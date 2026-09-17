import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'customer/scenario.dart';

/// Compile-time configuration. Every value reads from `--dart-define` (or
/// `--dart-define-from-file=config.json`). `String.fromEnvironment` is `const`,
/// so these are baked into the binary: a build cannot be repointed afterwards,
/// and each environment is its own build.
///
/// The defaults are azuma's demo tenant - the same values as
/// `config.example.json`, and `defaults_test.dart` keeps the two equal - so a
/// bare `flutter run` and a store build work as they are. A `config.json`
/// overrides them for another tenant; a build whose overrides name no tenant
/// opens on a screen that says it is not configured.
abstract final class AppConfig {
  /// Backend base URL. Must be `https`.
  static const String baseUrl = String.fromEnvironment(
    'DOA_BASE_URL',
    defaultValue: 'https://pie.azuma-health.tech/api/organization',
  );

  /// The tenant's application registration this app authenticates against.
  static const String applicationId = String.fromEnvironment(
    'DOA_APPLICATION_ID',
    defaultValue: '9647d187-0494-4874-9c9c-e403afb1b819',
  );

  /// Google Cloud project linked to this app in the Play Console, for the Play
  /// Integrity standard requests in `IntegrityChannel.kt`. Android needs it for
  /// every registration and login; iOS never reads it.
  static const String playIntegrityCloudProjectNumber = String.fromEnvironment(
    'PLAY_INTEGRITY_CLOUD_PROJECT_NUMBER',
    defaultValue: '350905203458',
  );

  /// `PROFILE=customer` pins the app to one scenario: it opens on that flow's
  /// welcome screen and the Start launcher is not compiled in. Unset, the app
  /// opens on the launcher. Compile-time constant, so the branch folds.
  static const String profileName = String.fromEnvironment('PROFILE');
  static const bool isPinned = profileName != '';
  static Scenario? get pinnedScenario =>
      isPinned ? Scenario.byName(profileName) : null;
}

/// The two values a running app talks to. In release this is always
/// [defaults]; in debug builds the DevTools screen can persist an override that
/// `main()` reads at startup (`devtools/dev_config.dart`).
class RuntimeConfig {
  const RuntimeConfig({required this.baseUrl, required this.applicationId});

  static const RuntimeConfig defaults = RuntimeConfig(
    baseUrl: AppConfig.baseUrl,
    applicationId: AppConfig.applicationId,
  );

  final String baseUrl;
  final String applicationId;

  bool get isOverride =>
      baseUrl != AppConfig.baseUrl || applicationId != AppConfig.applicationId;

  /// Whether this build (or override) names a tenant at all: an https base URL
  /// with a host, and an application id. Without both the gate shows S0's
  /// "not configured" state instead of letting a request leave.
  bool get configured {
    final url = Uri.tryParse(baseUrl);
    return url != null &&
        url.scheme == 'https' &&
        url.host.isNotEmpty &&
        applicationId.isNotEmpty;
  }
}

/// Overridden in `main()`; everything that builds a [DeviceBoundApi] reads it.
final runtimeConfigProvider = Provider<RuntimeConfig>(
  (_) => RuntimeConfig.defaults,
);
