//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:dio/dio.dart';
import 'package:doa_device_binding_api/src/auth/api_key_auth.dart';
import 'package:doa_device_binding_api/src/auth/basic_auth.dart';
import 'package:doa_device_binding_api/src/auth/bearer_auth.dart';
import 'package:doa_device_binding_api/src/auth/oauth.dart';
import 'package:doa_device_binding_api/src/api/device_binding_account_api.dart';
import 'package:doa_device_binding_api/src/api/device_binding_account_biometrics_api.dart';
import 'package:doa_device_binding_api/src/api/device_binding_account_health_id_api.dart';
import 'package:doa_device_binding_api/src/api/device_binding_account_oidc_api.dart';
import 'package:doa_device_binding_api/src/api/device_binding_account_passkeys_api.dart';
import 'package:doa_device_binding_api/src/api/device_binding_audit_log_api.dart';
import 'package:doa_device_binding_api/src/api/device_binding_auth_api.dart';
import 'package:doa_device_binding_api/src/api/device_binding_auth_biometrics_api.dart';
import 'package:doa_device_binding_api/src/api/device_binding_auth_health_id_api.dart';
import 'package:doa_device_binding_api/src/api/device_binding_auth_oidc_api.dart';
import 'package:doa_device_binding_api/src/api/device_binding_auth_passkeys_api.dart';
import 'package:doa_device_binding_api/src/api/device_binding_challenge_api.dart';
import 'package:doa_device_binding_api/src/api/device_binding_device_api.dart';
import 'package:doa_device_binding_api/src/api/device_binding_device_health_id_api.dart';
import 'package:doa_device_binding_api/src/api/device_binding_device_passkeys_api.dart';
import 'package:doa_device_binding_api/src/api/device_binding_session_api.dart';

class DoaDeviceBindingApi {
  static const String basePath = r'https://pie.azuma-health.tech/api/organization';

  final Dio dio;
  DoaDeviceBindingApi({
    Dio? dio,
    String? basePathOverride,
    List<Interceptor>? interceptors,
  })  : 
        this.dio = dio ??
            Dio(BaseOptions(
              baseUrl: basePathOverride ?? basePath,
              connectTimeout: const Duration(milliseconds: 5000),
              receiveTimeout: const Duration(milliseconds: 3000),
            )) {
    if (interceptors == null) {
      this.dio.interceptors.addAll([
        OAuthInterceptor(),
        BasicAuthInterceptor(),
        BearerAuthInterceptor(),
        ApiKeyAuthInterceptor(),
      ]);
    } else {
      this.dio.interceptors.addAll(interceptors);
    }
  }

  void setOAuthToken(String name, String token) {
    if (this.dio.interceptors.any((i) => i is OAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is OAuthInterceptor) as OAuthInterceptor).tokens[name] = token;
    }
  }

  void setBearerAuth(String name, String token) {
    if (this.dio.interceptors.any((i) => i is BearerAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is BearerAuthInterceptor) as BearerAuthInterceptor).tokens[name] = token;
    }
  }

  void setBasicAuth(String name, String username, String password) {
    if (this.dio.interceptors.any((i) => i is BasicAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is BasicAuthInterceptor) as BasicAuthInterceptor).authInfo[name] = BasicAuthInfo(username, password);
    }
  }

  void setApiKey(String name, String apiKey) {
    if (this.dio.interceptors.any((i) => i is ApiKeyAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((element) => element is ApiKeyAuthInterceptor) as ApiKeyAuthInterceptor).apiKeys[name] = apiKey;
    }
  }

  /// Get DeviceBindingAccountApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  DeviceBindingAccountApi getDeviceBindingAccountApi() {
    return DeviceBindingAccountApi(dio);
  }

  /// Get DeviceBindingAccountBiometricsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  DeviceBindingAccountBiometricsApi getDeviceBindingAccountBiometricsApi() {
    return DeviceBindingAccountBiometricsApi(dio);
  }

  /// Get DeviceBindingAccountHealthIDApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  DeviceBindingAccountHealthIDApi getDeviceBindingAccountHealthIDApi() {
    return DeviceBindingAccountHealthIDApi(dio);
  }

  /// Get DeviceBindingAccountOIDCApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  DeviceBindingAccountOIDCApi getDeviceBindingAccountOIDCApi() {
    return DeviceBindingAccountOIDCApi(dio);
  }

  /// Get DeviceBindingAccountPasskeysApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  DeviceBindingAccountPasskeysApi getDeviceBindingAccountPasskeysApi() {
    return DeviceBindingAccountPasskeysApi(dio);
  }

  /// Get DeviceBindingAuditLogApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  DeviceBindingAuditLogApi getDeviceBindingAuditLogApi() {
    return DeviceBindingAuditLogApi(dio);
  }

  /// Get DeviceBindingAuthApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  DeviceBindingAuthApi getDeviceBindingAuthApi() {
    return DeviceBindingAuthApi(dio);
  }

  /// Get DeviceBindingAuthBiometricsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  DeviceBindingAuthBiometricsApi getDeviceBindingAuthBiometricsApi() {
    return DeviceBindingAuthBiometricsApi(dio);
  }

  /// Get DeviceBindingAuthHealthIDApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  DeviceBindingAuthHealthIDApi getDeviceBindingAuthHealthIDApi() {
    return DeviceBindingAuthHealthIDApi(dio);
  }

  /// Get DeviceBindingAuthOIDCApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  DeviceBindingAuthOIDCApi getDeviceBindingAuthOIDCApi() {
    return DeviceBindingAuthOIDCApi(dio);
  }

  /// Get DeviceBindingAuthPasskeysApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  DeviceBindingAuthPasskeysApi getDeviceBindingAuthPasskeysApi() {
    return DeviceBindingAuthPasskeysApi(dio);
  }

  /// Get DeviceBindingChallengeApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  DeviceBindingChallengeApi getDeviceBindingChallengeApi() {
    return DeviceBindingChallengeApi(dio);
  }

  /// Get DeviceBindingDeviceApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  DeviceBindingDeviceApi getDeviceBindingDeviceApi() {
    return DeviceBindingDeviceApi(dio);
  }

  /// Get DeviceBindingDeviceHealthIDApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  DeviceBindingDeviceHealthIDApi getDeviceBindingDeviceHealthIDApi() {
    return DeviceBindingDeviceHealthIDApi(dio);
  }

  /// Get DeviceBindingDevicePasskeysApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  DeviceBindingDevicePasskeysApi getDeviceBindingDevicePasskeysApi() {
    return DeviceBindingDevicePasskeysApi(dio);
  }

  /// Get DeviceBindingSessionApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  DeviceBindingSessionApi getDeviceBindingSessionApi() {
    return DeviceBindingSessionApi(dio);
  }
}
