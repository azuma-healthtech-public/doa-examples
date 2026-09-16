import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_binding/src/customer/customer_storage.dart';
import 'package:flutter_device_binding/src/core/device_bound_api.dart';
import 'package:flutter_device_binding/src/core/device_binding.dart';

class SigningKey extends DeviceBinding {
  String? signed;
  void Function()? afterSigning;
  @override
  Future<String> sign(String data, String identifier) async {
    signed = data;
    afterSigning?.call();
    return 'test-signature';
  }
}

class CaptureHttp implements HttpClientAdapter {
  RequestOptions? request;
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    request = options;
    return ResponseBody.fromString(
      '{}',
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  testWidgets('timed-out secure writes remain serialized before retry', (
    tester,
  ) async {
    const channel = MethodChannel(
      'com.doa.example.devicebinding.flutter/secure_store',
    );
    final pending = Completer<void>();
    var calls = 0;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          if (call.method == 'write') {
            calls++;
            if (calls == 1) await pending.future;
          }
          return null;
        });
    final storage = CustomerStorage();
    var timedOut = false;
    final first = storage.save(const CustomerDevice(alias: 'first')).catchError(
      (Object _) {
        timedOut = true;
      },
    );
    await tester.pump();
    expect(calls, 1);
    await tester.pump(CustomerStorage.writeTimeout + const Duration(seconds: 1));
    expect(timedOut, true);
    final second = storage.save(const CustomerDevice(alias: 'second'));
    await tester.pump();
    expect(calls, 1);
    pending.complete();
    await tester.pump();
    await first;
    await second;
    expect(calls, 2);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });
  test(
    'device envelope transports the exact signed bytes and expected URL',
    () async {
      final http = CaptureHttp();
      final keys = SigningKey();
      final dio = Dio(
        BaseOptions(baseUrl: 'https://example.org/api/organization'),
      )..httpClientAdapter = http;
      final api = DeviceBoundApi(dio: dio, keys: keys);
      await api.post('auth', 'login/email', {
        'email': 'ä@example.org',
        'password': 'a\\b',
        'scope': '',
      }, alias: 'local-key');
      final envelope = http.request!.data as Map<String, dynamic>;
      expect(envelope['payload'], keys.signed);
      expect(envelope['signature'], 'test-signature');
      expect(envelope['deviceOs'], 'Android');
      expect(
        http.request!.uri.path,
        startsWith('/api/organization/deviceBinding/auth/'),
      );
      dio.close();
    },
  );
  test(
    'authorization is rechecked after asynchronous signing before network',
    () async {
      final http = CaptureHttp();
      var valid = true;
      final keys = SigningKey()
        ..afterSigning = () {
          valid = false;
        };
      final dio = Dio()..httpClientAdapter = http;
      final api = DeviceBoundApi(dio: dio, keys: keys);
      await expectLater(
        api.post(
          'account',
          'userInfo',
          {'accessToken': 'token'},
          alias: 'key',
          authorize: () {
            if (!valid) throw StateError('Expired');
          },
        ),
        throwsStateError,
      );
      expect(http.request, isNull);
      dio.close();
    },
  );
}
