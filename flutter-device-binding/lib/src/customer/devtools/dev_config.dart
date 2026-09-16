import '../../app_config.dart';
import '../../core/secure_store.dart';

/// Debug-only runtime override of the backend and application id, persisted in
/// the native secure store and read once by `main()` before the app starts.
///
/// Only ever referenced under `kDebugMode`, which is a compile-time constant:
/// the release build contains none of this. Release keeps the `const`
/// `AppConfig` values, so a shipped build still cannot be repointed.
abstract final class DevConfig {
  static const NativeSecureStore _store = NativeSecureStore();
  static const String _baseUrl = 'dev.baseUrl';
  static const String _applicationId = 'dev.applicationId';
  static const Duration _timeout = Duration(seconds: 5);

  /// The stored override, or the compile-time defaults when there is none or
  /// the store cannot be read - startup must not block on it.
  static Future<RuntimeConfig> load() async {
    try {
      final baseUrl = await _store.read(_baseUrl).timeout(_timeout);
      final applicationId = await _store.read(_applicationId).timeout(_timeout);
      return RuntimeConfig(
        baseUrl: _valid(baseUrl) ? baseUrl! : AppConfig.baseUrl,
        applicationId: (applicationId?.isNotEmpty ?? false)
            ? applicationId!
            : AppConfig.applicationId,
      );
    } catch (_) {
      return RuntimeConfig.defaults;
    }
  }

  static Future<void> save(RuntimeConfig config) async {
    if (!_valid(config.baseUrl)) {
      throw ArgumentError('Base URL must be an absolute http(s) URL');
    }
    await _store.write(_baseUrl, config.baseUrl).timeout(_timeout);
    await _store.write(_applicationId, config.applicationId).timeout(_timeout);
  }

  static Future<void> clear() async {
    await _store.delete(_baseUrl).timeout(_timeout);
    await _store.delete(_applicationId).timeout(_timeout);
  }

  static bool _valid(String? url) {
    if (url == null || url.isEmpty) return false;
    final u = Uri.tryParse(url);
    return u != null && u.hasScheme && u.host.isNotEmpty &&
        (u.scheme == 'https' || u.scheme == 'http');
  }
}
