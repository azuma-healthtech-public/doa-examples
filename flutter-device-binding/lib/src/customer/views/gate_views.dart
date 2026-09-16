import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../customer_controller.dart';
import '../notice.dart';
import '../widgets/widgets.dart';
import 'customer_view.dart';

/// The states between entry and the account: storage failure, mandatory
/// biometric setup (6), a blocking post-login action, and the lock screen (7).

List<Widget> storageView(CustomerView v) => [
  const SizedBox(height: 48),
  const HeroCircle(Icons.lock_outline, size: 96),
  const SizedBox(height: 16),
  v.headline(
    v.c.storageFailed ? 'Secure storage could not be read' : 'Loading your device…',
    align: TextAlign.center,
  ),
  if (v.c.storageFailed) ...[
    v.body(
      'Retry before continuing. This app never treats an unreadable store as a '
      'fresh install.',
      align: TextAlign.center,
    ),
    const SizedBox(height: 16),
    v.button('Retry', v.c.initialize),
  ],
];

/// S0, the other reason nothing can start: this build names no tenant. Every
/// value is a compile-time define, so the remedy is a `config.json` and a
/// rebuild (or, in a debug build, the DevTools override) - nothing the user can
/// do here. The screen says so rather than letting a request leave for nowhere.
List<Widget> notConfiguredView(CustomerView v) => [
  const SizedBox(height: 48),
  const HeroCircle(Icons.settings_outlined, size: 96),
  const SizedBox(height: 16),
  v.headline('This build is not configured', align: TextAlign.center),
  v.body(
    'It names no backend. Copy config.example.json to config.json, fill in your '
    'tenant, and rebuild with --dart-define-from-file=config.json.',
    align: TextAlign.center,
  ),
  v.note(
    'In a debug build, DevTools can point this build at a tenant until the '
    'next start.',
    align: TextAlign.center,
  ),
];

/// 6 · Enable biometrics. No back, no skip.
List<Widget> biometricsSetupView(CustomerView v) => [
  const SizedBox(height: 40),
  const HeroCircle(Icons.fingerprint),
  const SizedBox(height: 8),
  v.headline('Set up biometric sign-in', align: TextAlign.center),
  v.body(
    "Required on this phone. You'll confirm with your fingerprint or face every "
    '10 minutes. Nothing else unlocks your data.',
    align: TextAlign.center,
  ),
  const SizedBox(height: 8),
  const ProofLine("A key is created inside this phone's secure hardware"),
  const ProofLine('Only the fingerprints or face enrolled on this phone can use it'),
  const ProofLine("If you change them, you'll set this up again after signing in"),
  const SizedBox(height: 24),
  v.notice(),
  const SizedBox(height: 8),
  v.button('Enable biometrics', v.c.enableBiometrics,
      icon: Icons.fingerprint, hero: true),
  v.note("This step can't be skipped.", align: TextAlign.center),
];

/// S2 · The integrity check did not pass. Replaces the journey until "Check
/// again"; the account and other phones are unaffected, and the copy says so.
List<Widget> deviceCheckView(CustomerView v) {
  final rejected = v.c.deviceCheck == DeviceCheckFailure.rejected;
  return [
    const SizedBox(height: 24),
    const HeroCircle(
      Icons.phonelink_erase_outlined,
      background: AppColors.error50,
      foreground: AppColors.errorText,
    ),
    const SizedBox(height: 8),
    v.headline(
      rejected ? "This phone can't be used" : 'The phone check did not complete',
      align: TextAlign.center,
    ),
    v.body(
      rejected
          ? "Google Play couldn't confirm that this phone and app are unmodified. "
                'On a rooted, unlocked or modified phone, other apps could read or '
                "change your health data, so azuma won't sign you in here."
          : 'Google Play could not check this phone. Make sure Google Play '
                'services are installed and up to date and that you are online.',
      align: TextAlign.center,
    ),
    const InfoBanner(
      'This check looks at the phone, not your account. Your account and your '
      'other phones are unaffected.',
    ),
    const SizedBox(height: 24),
    v.outlined('Check again', () => v.act(() async {
      v.c.clearDeviceCheck();
      await v.c.retry();
    })),
  ];
}

List<Widget> blockedView(CustomerView v) => [
  const SizedBox(height: 48),
  const HeroCircle(Icons.build_outlined, size: 96),
  const SizedBox(height: 16),
  v.headline('Account maintenance required', align: TextAlign.center),
  v.body(
    'Your device requires account maintenance before you can continue. '
    'Contact your service provider.',
    align: TextAlign.center,
  ),
  const SizedBox(height: 16),
  v.outlined('Sign out', v.signOut),
];

/// 7 · Session ended. The one dark screen: a state, not a page. Drawn as a
/// whole scaffold because it replaces the entire UI.
class LockedScreen extends StatelessWidget {
  const LockedScreen({
    super.key,
    required this.c,
    required this.act,
    this.onSignOut,
    this.unlock,
    this.unlockLabel = 'Unlock with biometrics',
    this.showRepair = true,
  });
  final CustomerController c;
  final Future<void> Function(Future<void> Function()) act;

  /// Sign-out from the lock screen. The screen hands in `CustomerView.signOut`,
  /// which ends at the root; without it the raw controller call is used.
  final Future<void> Function()? onSignOut;

  /// What the primary action runs. The customer profile renews with the
  /// biometric key; variant C has no second key, so it unlocks the device key
  /// itself through `login/id` (7-lite). Default keeps screen 7 as it was.
  final Future<void> Function()? unlock;
  final String unlockLabel;

  /// "Biometrics not working? Sign in another way" resets the biometric key.
  /// Variant C has none to reset, so it is hidden there.
  final bool showRepair;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.primary700,
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),
                const HeroCircle(
                  Icons.lock_outline,
                  background: AppColors.primary600,
                  foreground: AppColors.primary100,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Session ended',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    height: 36 / 28,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.56,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Sessions last 10 minutes to protect your health data. '
                  "Confirm it's you to continue where you left off.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    height: 26 / 16,
                    color: AppColors.primary200,
                  ),
                ),
                const Spacer(),
                if (c.busy)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: LinearProgressIndicator(
                      color: AppColors.white,
                      backgroundColor: AppColors.primary600,
                    ),
                  ),
                if (c.notice != null && c.notice!.tone != NoticeTone.snack)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: NoticeBanner(
                      c.notice!,
                      onRetry: () => act(c.retry),
                    ),
                  ),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.primary700,
                  ),
                  onPressed: c.busy
                      ? null
                      : () => act(unlock ?? c.loginBiometrics),
                  icon: const Icon(Icons.fingerprint),
                  label: Text(unlockLabel),
                ),
                if (showRepair)
                  TextButton(
                    style: TextButton.styleFrom(foregroundColor: AppColors.primary200),
                    onPressed: c.busy ? null : () => act(c.repairBiometrics),
                    child: const Text('Biometrics not working? Sign in another way'),
                  ),
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: AppColors.primary300),
                  onPressed: c.busy
                      ? null
                      : () => (onSignOut ?? () => act(c.signOut))(),
                  child: const Text('Sign out'),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
