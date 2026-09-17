import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_device_binding/src/app_config.dart';
import 'package:flutter_device_binding/src/core/health_id.dart';
import 'package:flutter_device_binding/src/core/transfer_provider.dart';

/// `config.example.json` is the template an integrator copies, and the code's
/// `defaultValue`s are what a bare `flutter run` and a store build use. The
/// two are the same tenant on purpose; this test is what keeps them equal in
/// both directions - a key changed in one place fails here until the other
/// follows, and a key present in only one of them fails too.
void main() {
  test('the built-in defaults are config.example.json, key for key', () {
    // No --dart-define reaches the test binary, so every constant below is
    // its defaultValue.
    const builtIn = <String, Object>{
      'DOA_BASE_URL': AppConfig.baseUrl,
      'DOA_APPLICATION_ID': AppConfig.applicationId,
      'PLAY_INTEGRITY_CLOUD_PROJECT_NUMBER':
          AppConfig.playIntegrityCloudProjectNumber,
      'HEALTH_ID_AUTHORIZATION_URL': HealthId.authorization,
      'HEALTH_ID_TOKEN_URL': HealthId.tokenEndpoint,
      'HEALTH_ID_EXCHANGE_URL': HealthId.exchangeEndpoint,
      'HEALTH_ID_IDP_LIST_URL': HealthId.idpListUrl,
      'HEALTH_ID_CLIENT_ID': HealthId.clientId,
      'HEALTH_ID_RELYING_PARTY_ID': HealthId.relyingPartyId,
      'HEALTH_ID_REDIRECT_URI': HealthId.redirect,
      'HEALTH_ID_AUTHENTICATOR_SCHEME': HealthId.launchScheme,
      'HEALTH_ID_EXCHANGE_VIA_REDIRECT': HealthId.exchangeViaRedirect,
      'TRANSFER_PROVIDER_NAME': TransferProvider.providerName,
      'TRANSFER_AUTHORIZATION_URL': TransferProvider.authorization,
      'TRANSFER_TOKEN_URL': TransferProvider.tokenEndpoint,
      'TRANSFER_CLIENT_ID': TransferProvider.clientId,
      'TRANSFER_REDIRECT_URI': TransferProvider.redirect,
      'TRANSFER_SCOPE': TransferProvider.scope,
      'TRANSFER_DOA_PROVIDER': TransferProvider.doaProvider,
      'TRANSFER_DEMO': TransferProvider.demo,
    };

    final file = File('config.example.json');
    expect(file.existsSync(), isTrue, reason: 'run from the package root');
    final example = (jsonDecode(file.readAsStringSync()) as Map<String, dynamic>)
      ..removeWhere((key, _) => key.startsWith('_')); // the comments

    expect(
      example.keys.toSet(),
      builtIn.keys.toSet(),
      reason: 'every key in config.example.json has a built-in default, and '
          'every built-in default is in config.example.json',
    );
    for (final entry in example.entries) {
      expect(
        builtIn[entry.key],
        entry.value,
        reason: '${entry.key}: the code default and config.example.json differ',
      );
    }
  });
}
