import 'package:flutter/services.dart';

/// Dart face of `SecureStoreChannel.kt`: string values sealed with AES-256-GCM
/// under an RSA-4096 AndroidKeyStore wrapping key that never leaves the TEE.
///
/// A value that cannot be decrypted comes back as a `PlatformException` and is
/// never deleted by the channel, so callers can fail closed instead of
/// mistaking a broken store for a fresh install.
class NativeSecureStore {
  const NativeSecureStore();

  /// Must match `SecureStoreChannel.CHANNEL` in
  /// `android/app/src/main/kotlin/com/doa/example/devicebinding/flutter/SecureStoreChannel.kt`.
  static const MethodChannel _channel = MethodChannel(
    'com.doa.example.devicebinding.flutter/secure_store',
  );

  Future<String?> read(String key) =>
      _channel.invokeMethod<String>('read', {'key': key});
  Future<void> write(String key, String value) =>
      _channel.invokeMethod<void>('write', {'key': key, 'value': value});
  Future<void> delete(String key) =>
      _channel.invokeMethod<void>('delete', {'key': key});
}
