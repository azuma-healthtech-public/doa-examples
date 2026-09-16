import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/app.dart';
import 'src/app_config.dart';
import 'src/core/device_binding.dart';
import 'src/customer/devtools/dev_config.dart';

/// Opens the AndroidKeyStore once and starts the customer app. Customer
/// identifiers load later, behind the UI's fail-closed storage gate.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String? keystoreError;
  try {
    await const DeviceBinding().initializeKeyStore();
  } catch (e) {
    keystoreError =
        'Secure device storage is unavailable. Restart the app to retry.';
  }

  // Debug builds may carry a DevTools override of the backend. `kDebugMode`
  // is a compile-time constant, so a release build contains neither this
  // branch nor DevConfig.
  var config = RuntimeConfig.defaults;
  if (kDebugMode) config = await DevConfig.load();

  runApp(
    ProviderScope(
      overrides: [
        keystoreErrorProvider.overrideWithValue(keystoreError),
        runtimeConfigProvider.overrideWithValue(config),
      ],
      child: const DeviceBindingApp(),
    ),
  );
}
