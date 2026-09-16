import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_config.dart';
import '../customer/devtools/dev_tools_screen.dart';
import '../customer/scenario.dart';
import '../customer/widgets/widgets.dart';
import '../theme/app_colors.dart';

/// Screen 0 - the example launcher. Lists every scenario, the approved one
/// first; tapping an available one starts that flow on its own welcome screen.
/// Only compiled into unpinned builds (see `AppConfig.isPinned`).
class StartScreen extends ConsumerWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(runtimeConfigProvider);
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              children: [
                Row(
                  children: [
                    Image.asset('assets/icon/icon.png', width: 40, height: 40),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'DOA example flows',
                        style: theme.textTheme.headlineMedium,
                      ),
                    ),
                    if (kDebugMode)
                      IconButton(
                        tooltip: 'DevTools',
                        icon: const Icon(Icons.bug_report_outlined),
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const DevToolsScreen(),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Pick a flow. Each starts on its own welcome screen and keeps '
                  'its own device record, so they behave like separate installs '
                  'on this phone. The variants run the customer journey until '
                  'their own steps are built.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SectionLabel('Customer app'),
                _ScenarioTile(Scenario.customer, primary: true),
                const SectionLabel('Variants'),
                for (final s in Scenario.values.where((s) => s != Scenario.customer))
                  _ScenarioTile(s),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.neutral200),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${Uri.parse(config.baseUrl).host} · '
                          '${_short(config.applicationId)} · '
                          '${kDebugMode ? 'debug' : 'release'}'
                          '${config.isOverride ? ' · override' : ''}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontFamily: 'monospace',
                            fontSize: 11,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _short(String id) =>
      id.length > 12 ? '${id.substring(0, 8)}…${id.substring(id.length - 4)}' : id;
}

class _ScenarioTile extends ConsumerWidget {
  const _ScenarioTile(this.scenario, {this.primary = false});
  final Scenario scenario;
  final bool primary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = scenario;
    return MethodTile(
      icon: switch (s) {
        Scenario.customer => Icons.verified_user_outlined,
        Scenario.transfer => Icons.swap_horiz,
        Scenario.phoneKey => Icons.smartphone,
      },
      title: s.displayTitle,
      subtitle: s.subtitle,
      emphasised: primary,
      onTap: () => ref.read(activeScenarioProvider.notifier).select(s),
    );
  }
}
