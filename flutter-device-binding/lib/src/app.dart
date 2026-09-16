import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_config.dart';
import 'customer/customer_screen.dart';
import 'customer/scenario.dart';
import 'start/start_screen.dart';
import 'theme/app_theme.dart';

/// Set by `main()` when opening the AndroidKeyStore failed, so the app can
/// surface it as a SnackBar once the first screen is up.
final keystoreErrorProvider = Provider<String?>((ref) => null);

class DeviceBindingApp extends ConsumerStatefulWidget {
  const DeviceBindingApp({super.key});

  @override
  ConsumerState<DeviceBindingApp> createState() => _DeviceBindingAppState();
}

class _DeviceBindingAppState extends ConsumerState<DeviceBindingApp> {
  final GlobalKey<ScaffoldMessengerState> _messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    final error = ref.read(keystoreErrorProvider);
    if (error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _messengerKey.currentState?.showSnackBar(
          SnackBar(content: Text(error), duration: const Duration(seconds: 6)),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final active = ref.watch(activeScenarioProvider);
    return MaterialApp(
      title: 'azuma doa',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: _messengerKey,
      theme: AppTheme.light,
      // The design is a single light look; the lock screen is the one dark
      // surface and it is drawn as such regardless of the system setting.
      darkTheme: AppTheme.light,
      themeMode: ThemeMode.light,
      // `AppConfig.isPinned` is a compile-time constant: a pinned build folds
      // this to the customer screen and the launcher is not compiled in.
      home: AppConfig.isPinned || active != null
          ? CustomerScreen(key: ValueKey(active ?? Scenario.customer))
          : const StartScreen(),
    );
  }
}
