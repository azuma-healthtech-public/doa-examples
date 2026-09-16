import 'dart:convert';

import 'package:doa_device_binding_api/doa_device_binding_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_device_binding/src/core/biometric_binding.dart';
import 'package:flutter_device_binding/src/core/device_binding.dart';
import 'package:flutter_device_binding/src/core/device_bound_api.dart';
import 'package:flutter_device_binding/src/core/play_integrity.dart';
import 'package:flutter_device_binding/src/core/transfer_provider.dart';
import 'package:flutter_device_binding/src/customer/customer_controller.dart';
import 'package:flutter_device_binding/src/customer/customer_storage.dart';
import 'package:flutter_device_binding/src/customer/notice.dart';

/// Variant A, the account transfer journey. The provider itself is replaced
/// wholesale, exactly as the Health-ID tests do: what is under test is what the
/// app does with an identity, not the OIDC hand-off that produced it.

Map<String, dynamic> session(DateTime now) => {
  'accessToken':
      'header.${base64Url.encode(utf8.encode(jsonEncode({'sub': 'account-a', 'exp': now.add(const Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000})))}.signature',
  'expiresIn': 3600,
  'postLoginActions': <Map<String, dynamic>>[],
};

class MemoryStore extends CustomerStorage {
  MemoryStore([this.value]);
  CustomerDevice? value;
  @override
  Future<CustomerDevice?> load() async => value;
  @override
  Future<void> save(CustomerDevice device) async => value = device;
  @override
  Future<void> clearPending() async => value = null;
}

class TestKeys extends DeviceBinding {
  @override
  Future<void> generateEcKeyPair({
    required String identifier,
    required String challenge,
    bool biometricGated = false,
  }) async {}
  @override
  Future<DeviceAttestationDto> getDeviceAttestationsKey(String identifier) async =>
      DeviceAttestationDto(
        attestation: 'attestation',
        deviceOs: UserDeviceOs.android,
      );
}

class TestBiometrics extends BiometricBinding {
  @override
  Future<bool> canAuthenticate() async => true;
}

class TestIntegrity extends PlayIntegrity {
  @override
  Future<String> requestToken(String challenge) async => 'integrity:$challenge';
}

class TestApi extends DeviceBoundApi {
  TestApi() : super(keys: TestKeys());
  final List<({String route, Map<String, dynamic> payload, String? alias})>
  requests = [];

  /// What `register/<provider>` answers. Without a token DOA has created the
  /// account but not a session, which is the case the journey has to handle.
  Map<String, dynamic> registration = {'id': 'account-a'};
  Map<String, dynamic> loginResponse = {};

  @override
  Future<String> challenge(String kind) async => 'challenge-$kind';

  @override
  Future<Map<String, dynamic>> post(
    String area,
    String action,
    Map<String, dynamic> payload, {
    String? alias,
    void Function()? authorize,
  }) async {
    authorize?.call();
    requests.add((route: '$area/$action', payload: payload, alias: alias));
    if (action.startsWith('register/')) return registration;
    return loginResponse;
  }
}

class TestTransfer extends TransferProvider {
  TestTransfer({this.ready = true});
  bool ready;

  /// Flips the demo path on for a test; the real flag is a compile-time
  /// constant that `flutter test` never sets.
  bool demo = false;
  @override
  bool get demoMode => demo;
  int handoffs = 0;
  Object? failure;
  TransferIdentity identity = const TransferIdentity(
    token: 'provider-token',
    email: 'maria@previous.example',
  );

  @override
  bool get configured => ready;
  @override
  String get name => 'Previous App';
  @override
  Future<TransferIdentity> authenticate() async {
    handoffs++;
    if (failure != null) throw failure!;
    return identity;
  }
}

void main() {
  late DateTime now;
  late TestApi api;
  late MemoryStore store;
  late TestTransfer transfer;
  late CustomerController c;

  CustomerController build({CustomerDevice? device}) {
    store = MemoryStore(device);
    return CustomerController(
      api: api,
      storage: store,
      biometrics: TestBiometrics(),
      integrity: TestIntegrity(),
      transfer: transfer,
      now: () => now,
    );
  }

  setUp(() {
    now = DateTime.utc(2026, 9, 16, 12);
    api = TestApi()..loginResponse = session(now);
    transfer = TestTransfer();
    c = build();
  });
  tearDown(() => c.dispose());

  test('the hand-off alone creates nothing, on the phone or at DOA', () async {
    await c.initialize();
    await c.startTransfer();
    expect(transfer.handoffs, 1);
    expect(c.pendingTransfer?.email, 'maria@previous.example');
    expect(api.requests, isEmpty, reason: 'nothing is sent before A2');
    expect(store.value, isNull, reason: 'nothing is persisted before A2');
    expect(c.device, isNull);
  });

  test('"this isn\'t me" leaves no trace', () async {
    await c.initialize();
    await c.startTransfer();
    c.abandonTransfer();
    expect(c.pendingTransfer, isNull);
    expect(api.requests, isEmpty);
    expect(store.value, isNull);
  });

  test('confirming registers the identity and records where it came from', () async {
    await c.initialize();
    await c.startTransfer();
    await c.confirmTransfer();

    final register = api.requests.single;
    expect(register.route, 'account/register/google');
    expect(register.payload['identityToken'], 'provider-token');
    expect(register.payload['requestChallenge'], 'challenge-registration');
    expect(register.payload['deviceAttestation'], isNotNull);
    expect(register.payload['androidIntegrityToken'], 'integrity:challenge-registration');

    expect(store.value?.id, 'account-a');
    expect(store.value?.email, 'maria@previous.example');
    expect(store.value?.transferredFrom, 'Previous App');
    expect(store.value?.transferredAt, now);
    expect(c.pendingTransfer, isNull, reason: 'the identity is used once');
    // No session came back, so the journey says what happens next instead of
    // pretending the user is signed in.
    expect(c.signedIn, false);
    expect(c.notice?.tone, NoticeTone.success);
    expect(c.notice?.body, contains('Previous App'));
  });

  test('a registration that returns a session signs the user straight in', () async {
    api.registration = {'id': 'account-a', 'token': session(now)};
    await c.initialize();
    await c.startTransfer();
    await c.confirmTransfer();
    expect(c.signedIn, true);
    expect(c.needsBiometrics, true, reason: 'biometric setup is still mandatory');
  });

  test('the record survives a restart with its transfer details', () async {
    await c.initialize();
    await c.startTransfer();
    await c.confirmTransfer();
    final reloaded = CustomerDevice.fromJson(store.value!.toJson());
    expect(reloaded.transferredFrom, 'Previous App');
    expect(reloaded.transferredAt, now);
  });

  test('signing in later goes through the provider route, device-bound', () async {
    c.dispose();
    c = build(
      device: const CustomerDevice(alias: 'existing-key', id: 'account-a'),
    );
    await c.initialize();
    await c.loginTransfer();
    final login = api.requests.single;
    expect(login.route, 'auth/login/google');
    expect(login.alias, 'existing-key', reason: 'signed by the device key');
    expect(login.payload['identityToken'], 'provider-token');
    expect(
      (login.payload['deviceBoundIntegrityVerificationData']
          as Map)['challenge'],
      'challenge-login',
    );
    expect(c.signedIn, true);
  });

  test('demo mode holds an identity from the sheet without a provider', () async {
    transfer.demo = true;
    await c.initialize();
    await c.startTransfer(
      demo: const TransferIdentity(
        token: 'demo',
        email: 'anyone@typed.example',
        demo: true,
      ),
    );
    expect(transfer.handoffs, 0, reason: 'no provider is contacted');
    expect(c.pendingTransfer?.email, 'anyone@typed.example');
    expect(api.requests, isEmpty);
    expect(store.value, isNull);
  });

  test('demo mode ends before DOA: no request, no record, an honest notice', () async {
    transfer.demo = true;
    await c.initialize();
    await c.startTransfer(
      demo: const TransferIdentity(
        token: 'demo',
        email: 'anyone@typed.example',
        demo: true,
      ),
    );
    await c.confirmTransfer();
    expect(api.requests, isEmpty, reason: 'a token minted here would be refused by DOA');
    expect(store.value, isNull, reason: 'no account, so no record');
    expect(c.device, isNull);
    expect(c.pendingTransfer, isNull, reason: 'the demo identity is used once');
    expect(c.signedIn, false);
    expect(c.notice?.tone, NoticeTone.info);
    expect(c.notice?.title, 'Demo finished');
  });

  test('a demo identity is refused outside demo mode', () async {
    await c.initialize();
    await c.startTransfer(
      demo: const TransferIdentity(token: 'demo', email: 'x@y.example', demo: true),
    );
    expect(c.pendingTransfer, isNull);
    expect(c.notice?.tone, NoticeTone.error);
    expect(api.requests, isEmpty);
  });

  test('demo mode has no sign-in behind it', () async {
    transfer.demo = true;
    c.dispose();
    c = build(
      device: const CustomerDevice(alias: 'existing-key', id: 'account-a'),
    );
    await c.initialize();
    await c.loginTransfer();
    expect(transfer.handoffs, 0);
    expect(api.requests, isEmpty);
    expect(c.notice?.tone, NoticeTone.info);
    expect(c.signedIn, false);
  });

  test('an unconfigured build says so and does nothing', () async {
    transfer.ready = false;
    await c.initialize();
    await c.startTransfer();
    expect(transfer.handoffs, 0);
    expect(c.notice?.tone, NoticeTone.error);
    expect(c.notice?.body, contains('not configured'));
    expect(store.value, isNull);
  });

  test('a phone that already has a binding refuses a transfer', () async {
    c.dispose();
    c = build(
      device: const CustomerDevice(alias: 'existing-key', id: 'account-a'),
    );
    await c.initialize();
    await c.startTransfer();
    expect(transfer.handoffs, 0);
    expect(c.notice?.tone, NoticeTone.error);
    expect(api.requests, isEmpty);
  });
}
