import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_config.dart';
import '../core/transfer_provider.dart';

/// The flows the example can start (spec: `variants.md`, "Profiles").
///
/// Each keeps its own storage slot, so switching flows on one phone behaves
/// like separate installs: four accounts, four device keys, four sessions.
///
/// The variants run the customer journey until their own deltas are built;
/// what already differs between them is the record they use, which is what
/// makes them useful for testing more than one account from one phone.
enum Scenario {
  customer(
    slot: 'customer',
    title: 'Email · passkey · Health-ID',
    subtitle: 'Mandatory biometrics, 10-minute sessions. The reference.',
  ),
  transfer(
    slot: 'transfer',
    title: 'Account transfer',
    subtitle: 'Sign in at a previous provider once, then DOA-native',
  ),
  // Variant B (OIDC + biometrics) had a tile here. It is specified but not
  // built, and a tile that opens the reference journey under another name
  // promises something the app does not do - so the spec keeps the design and
  // the launcher offers only what exists. See variants.md, section B.
  phoneKey(
    slot: 'phone-key',
    title: 'Phone key',
    subtitle: 'Username once, then login by id with a biometric-gated key',
  );

  const Scenario({
    required this.slot,
    required this.title,
    required this.subtitle,
  });

  final String slot;
  final String title;
  final String subtitle;

  /// What the launcher shows. The transfer tile says when it is a demo: a tile
  /// that reads like the real journey while contacting no provider would
  /// promise something the build does not do. A configured build keeps the
  /// plain title, and a release build cannot be in demo mode at all.
  String get displayTitle => this == Scenario.transfer && TransferProvider.demo
      ? '$title (Demo)'
      : title;

  /// The scenario a `PROFILE` define names, or null when unpinned.
  static Scenario? byName(String name) {
    for (final s in Scenario.values) {
      if (s.name == name || s.slot == name) return s;
    }
    return null;
  }
}

/// Which scenario the app is running. A pinned build never changes it; an
/// unpinned build sets it from the Start screen and clears it to go back.
class ActiveScenario extends Notifier<Scenario?> {
  @override
  Scenario? build() => AppConfig.pinnedScenario;

  void select(Scenario scenario) => state = scenario;

  void clear() {
    if (AppConfig.isPinned) return;
    state = null;
  }
}

final activeScenarioProvider = NotifierProvider<ActiveScenario, Scenario?>(
  ActiveScenario.new,
);
