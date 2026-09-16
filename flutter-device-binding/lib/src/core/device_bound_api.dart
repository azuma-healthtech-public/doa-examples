import 'dart:convert';

import 'package:dio/dio.dart';

import '../app_config.dart';
import 'device_binding.dart';
import 'device_os.dart';

/// The DOA Device Binding API transport: URL shape and the device-bound
/// envelope. Payloads follow the checked-in Swagger; raw maps rather than the
/// generated models, so a field the client has not been regenerated for can
/// still be sent.
///
/// No logging interceptors: bodies carry credentials and provider tokens.
class DeviceBoundApi {
  DeviceBoundApi({
    Dio? dio,
    this.keys = const DeviceBinding(),
    this.config = RuntimeConfig.defaults,
  }) : dio =
           dio ??
           Dio(
             BaseOptions(
               baseUrl: config.baseUrl,
               connectTimeout: const Duration(seconds: 15),
               receiveTimeout: const Duration(seconds: 30),
               sendTimeout: const Duration(seconds: 30),
               followRedirects: false,
             ),
           );

  final Dio dio;
  final DeviceBinding keys;
  final RuntimeConfig config;

  String path(String area, String action) =>
      '/deviceBinding/$area/v1/mobile/${config.applicationId}/$action';

  /// `GET challenge/<kind>`; server-issued, single-use.
  Future<String> challenge(String kind) async =>
      ((await dio.get<dynamic>(path('challenge', kind))).data
              as Map)['challenge']
          as String;

  /// `POST <area>/<action>`. With [alias], the payload is JSON-encoded once,
  /// signed by that device key, and sent as `{payload, signature, deviceOs}` -
  /// the string that is signed is the string that is sent. [authorize] runs
  /// after signing and before the network, so a session that ended during a
  /// biometric prompt never sends a protected request.
  Future<Map<String, dynamic>> post(
    String area,
    String action,
    Map<String, dynamic> payload, {
    String? alias,
    void Function()? authorize,
  }) async {
    Object data = payload;
    if (alias != null) {
      final json = jsonEncode(payload);
      data = {
        'payload': json,
        'signature': await keys.sign(json, alias),
        'deviceOs': DeviceOs.wireName,
      };
    }
    authorize?.call();
    final response = await dio.post<dynamic>(path(area, action), data: data);
    return Map<String, dynamic>.from(response.data as Map);
  }
}
