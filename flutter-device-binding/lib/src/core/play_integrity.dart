import 'package:flutter/services.dart';

import '../app_config.dart';
import 'platform_channel.dart';

/// Play Integrity could not produce a token: Play services missing or out of
/// date, no network, or the Cloud project not configured. It carries no detail
/// because the device cannot interpret the verdict - only the backend can.
class IntegrityUnavailable implements Exception {
  const IntegrityUnavailable();
}

/// Dart face of `IntegrityChannel.kt`, a Play Integrity *standard* request.
///
/// [requestToken] takes the server-issued challenge of the request the token
/// accompanies: DOA checks the token's request hash against exactly that value.
class PlayIntegrity {
  const PlayIntegrity();

  /// Must match `IntegrityChannel.CHANNEL` in
  /// `android/app/src/main/kotlin/com/doa/example/devicebinding/flutter/IntegrityChannel.kt`.
  static const MethodChannel _channel = MethodChannel(
    'com.doa.example.devicebinding.flutter/integrity',
  );

  Future<String> requestToken(String challenge) async {
    try {
      final token = await _channel
          .invokeMethod<String>('requestToken', {
            'requestHash': challenge,
            'cloudProjectNumber': AppConfig.playIntegrityCloudProjectNumber,
          })
          .bounded('requestToken', kChannelTimeout);
      if (token == null || token.isEmpty) throw const IntegrityUnavailable();
      return token;
    } on PlatformException {
      throw const IntegrityUnavailable();
    } on ChannelTimeoutException {
      throw const IntegrityUnavailable();
    }
  }
}
