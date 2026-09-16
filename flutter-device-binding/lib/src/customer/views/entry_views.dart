import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../customer_controller.dart';
import '../widgets/widgets.dart';
import 'customer_view.dart';
import 'provider_picker.dart';

/// Screens 1, 2a, 2b, 2c - the "no session" state of the gate.

/// 1 · Welcome. Fresh install, nothing chosen yet.
/// [transferEntry] is true only inside the Account transfer flow: the transfer
/// is reachable from its tile alone, and this link exists so "Not now" on A1
/// has a way back in. The other flows never show it.
List<Widget> welcomeView(CustomerView v, {bool transferEntry = false}) => [
  const SizedBox(height: 48),
  Image.asset('assets/icon/icon.png', width: 64, height: 64),
  const SizedBox(height: 16),
  v.headline('Your health data, secured by this phone', large: true),
  v.body(
    'Sign in with your fingerprint or face. Your keys are created inside this '
    'device and never leave it.',
  ),
  const SizedBox(height: 8),
  const ProofLine('Hardware-backed device binding'),
  const ProofLine('Biometrics required, sessions end after 10 minutes'),
  const ProofLine('Email, passkey or Health-ID to get started'),
  const SizedBox(height: 24),
  v.notice(),
  const SizedBox(height: 8),
  v.button('Create account', () async => v.goTo(EntryStep.createAccount)),
  v.outlined('Sign in', () => v.goTo(EntryStep.signIn)),
  // Variant A: only inside its own flow, and only where a previous provider
  // is configured for this build.
  if (transferEntry && v.c.transfer.configured)
    v.link(
      'Already using ${v.c.transfer.name}? Transfer your account',
      () => v.goTo(EntryStep.transferIntro),
    ),
  Wrap(
    alignment: WrapAlignment.center,
    spacing: 16,
    children: [
      v.link(
        'Keep your phone safe',
        () => v.goTo(EntryStep.safety),
        color: AppColors.neutral500,
      ),
      v.link('Privacy notice', () {}, color: AppColors.neutral500),
      v.link('Imprint', () {}, color: AppColors.neutral500),
    ],
  ),
];

/// 2a · Create account: the method picker.
List<Widget> createAccountView(CustomerView v, BuildContext context) => [
  v.headline('How do you want to sign in?'),
  v.body('You can add the other methods later.', small: true),
  MethodTile(
    icon: Icons.mail_outline,
    title: 'Email and password',
    subtitle: "We'll email you a code",
    onTap: () => v.goTo(EntryStep.emailRegister),
  ),
  MethodTile(
    icon: Icons.key_outlined,
    title: 'Passkey',
    subtitle: 'No password to remember',
    onTap: () => v.goTo(EntryStep.passkeyName),
  ),
  MethodTile(
    icon: Icons.badge_outlined,
    title: 'Health-ID',
    subtitle: v.c.handoffProvider ?? "Your health insurer's digital ID",
    emphasised: v.c.handoffProvider != null,
    enabled: v.c.healthId.configured,
    onTap: () => withHealthIdProvider(v, context, v.c.registerHealthId),
  ),
  if (!v.c.healthId.configured)
    v.note('Health-ID is awaiting configuration for this build.'),
  Container(
    margin: const EdgeInsets.symmetric(vertical: 8),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      border: Border.all(color: AppColors.neutral100),
      borderRadius: BorderRadius.circular(12),
    ),
    child: const Column(
      children: [
        _Step(1, 'Create your account with one of the methods above'),
        _Step(2, 'Set up biometrics on this phone. This is required.'),
        _Step(3, 'Confirm with your fingerprint or face every 10 minutes'),
      ],
    ),
  ),
  const SizedBox(height: 8),
  _footer(v, 'Already have an account?', 'Sign in', EntryStep.signIn),
];

/// 2b · Sign in on a phone with no record: only what can add a device.
List<Widget> signInNewDeviceView(CustomerView v, BuildContext context) => [
  v.headline('Add this phone to your account'),
  const InfoBanner(
    "This phone isn't linked to your account yet. A passkey or your Health-ID "
    "can add it. Email and password alone can't add a new phone.",
  ),
  MethodTile(
    icon: Icons.key_outlined,
    title: 'Passkey',
    subtitle: 'Saved on this or another device',
    onTap: () => v.act(v.c.loginPasskey),
  ),
  MethodTile(
    icon: Icons.badge_outlined,
    title: 'Health-ID',
    subtitle: v.c.handoffProvider ?? "Your health insurer's digital ID",
    emphasised: v.c.handoffProvider != null,
    enabled: v.c.healthId.configured,
    onTap: () => withHealthIdProvider(v, context, v.c.loginHealthId),
  ),
  if (!v.c.healthId.configured)
    v.note('Health-ID is awaiting configuration for this build.'),
  v.body("After signing in you'll set up biometrics on this phone.", small: true),
  const SizedBox(height: 8),
  _footer(v, 'New to azuma?', 'Create account', EntryStep.createAccount),
];

/// 2c · Sign in on a linked phone: biometrics first, the rest beneath.
List<Widget> signInBoundView(CustomerView v, BuildContext context) {
  final c = v.c;
  final email = c.device?.email;
  return [
    const SizedBox(height: 32),
    Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.primary100,
          child: Text(
            (email ?? 'a')[0].toUpperCase(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.primary700,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome back', style: v.text.headlineSmall),
              if (email != null)
                Text(maskEmail(email), style: v.text.bodyMedium),
            ],
          ),
        ),
      ],
    ),
    const SizedBox(height: 16),
    v.notice(),
    const SizedBox(height: 8),
    if (c.device?.biometricAlias != null)
      v.button(
        'Sign in with biometrics',
        c.loginBiometrics,
        icon: Icons.fingerprint,
        hero: true,
      )
    else
      const InfoBanner('Sign in to enable biometrics on this phone.'),
    if (c.device?.biometricAlias != null) const _OrDivider(),
    if (email != null)
      MethodTile(
        icon: Icons.mail_outline,
        title: 'Email and password',
        onTap: () => v.goTo(EntryStep.emailSignIn),
      ),
    MethodTile(
      icon: Icons.key_outlined,
      title: 'Passkey',
      onTap: () => v.act(c.loginPasskey),
    ),
    MethodTile(
      icon: Icons.badge_outlined,
      title: 'Health-ID',
      subtitle: c.handoffProvider,
      emphasised: c.handoffProvider != null,
      enabled: c.healthId.configured,
      onTap: () => withHealthIdProvider(v, context, c.loginHealthId),
    ),
    const SizedBox(height: 16),
    if (c.device?.biometricAlias != null)
      v.link('Repair biometric setup', () => v.act(c.repairBiometrics),
          color: AppColors.neutral500),
    v.link(
      'Not you? Remove this account from the phone',
      () => _confirmRemove(v, context),
      color: AppColors.neutral500,
    ),
  ];
}

Future<void> _confirmRemove(CustomerView v, BuildContext context) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Remove this account from the phone?'),
      content: const Text(
        'The account stays on the server. This phone forgets it and becomes a '
        'new device; to use it again, add it with a passkey or Health-ID.',
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
        FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Remove')),
      ],
    ),
  );
  if (ok == true) await v.act(v.c.resetLocalState);
}

/// 3p · Name the account before the passkey is created. The server needs an
/// identifier for the account; the phone shows it next to the passkey.
List<Widget> passkeyNameView(CustomerView v) {
  final f = v.forms;
  Future<void> submit() async {
    final name = f.name.text.trim();
    final ok = v.valid((e) {
      if (name.isEmpty) {
        e['name'] = 'Enter a name for your account';
      } else if (name.length > 64) {
        e['name'] = 'Use at most 64 characters';
      }
    });
    if (ok) await v.c.registerPasskey(name);
  }

  return [
    v.notice(),
    v.headline('Name your account'),
    v.body(
      'The name is shown next to your passkey on this phone and is how azuma '
      'refers to your account. It is not a secret and not a password.',
      small: true,
    ),
    v.field(
      'Account name',
      f.name,
      errorKey: 'name',
      helper: 'For example your name or "Maria\'s health account"',
      keyboard: TextInputType.name,
    ),
    const InfoBanner(
      'Next, your phone asks you to confirm with your fingerprint or face and '
      'saves the passkey in your password manager. No password to remember.',
    ),
    const SizedBox(height: 16),
    v.button('Continue', submit, hero: true),
  ];
}

/// "Already have an account? Sign in" - wraps rather than overflows on narrow
/// phones and long translations.
Widget _footer(CustomerView v, String text, String action, EntryStep step) =>
    Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(text, style: v.text.bodyMedium),
        v.link(action, () => v.goTo(step)),
      ],
    );

class _Step extends StatelessWidget {
  const _Step(this.n, this.text);
  final int n;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.primary700,
            shape: BoxShape.circle,
          ),
          child: Text(
            '$n',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              height: 20 / 14,
              color: AppColors.neutral700,
            ),
          ),
        ),
      ],
    ),
  );
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(vertical: 12),
    child: Row(
      children: [
        Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'OR',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.96,
              color: AppColors.neutral400,
            ),
          ),
        ),
        Expanded(child: Divider()),
      ],
    ),
  );
}

/// Whether the entry step is reachable for the current record; the gate
/// falls back to the step that is.
EntryStep normaliseStep(CustomerController c, EntryStep step) {
  if (c.device == null) {
    return step == EntryStep.emailSignIn ? EntryStep.welcome : step;
  }
  // A bound phone only signs in; the registration steps are unreachable. The
  // one other screen it may show is the confirmation after a password change,
  // which is on the way back to sign-in anyway.
  return step == EntryStep.emailSignIn || step == EntryStep.passwordChanged
      ? step
      : EntryStep.signIn;
}
