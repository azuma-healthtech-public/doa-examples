import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
// The journey's methods are an extension on the controller, and an extension is
// only in scope where its library is imported directly.
import '../customer_controller.dart';
import '../widgets/widgets.dart';
import 'customer_view.dart';

/// Variant C - username once, then this phone is the key
/// (`examples/specifications/variants.md`, section C).

/// C1 · Choose a username. The password is not how the user signs in here: it
/// is what adds another phone later, and there is no e-mail to reset it with,
/// which is what the warning says.
List<Widget> usernameSetupView(CustomerView v) {
  final f = v.forms;

  Future<void> submit() async {
    final ok = v.valid((e) {
      if (f.name.text.trim().isEmpty) {
        e['name'] = 'Choose a username';
      }
      if (f.password.text.isEmpty) {
        e['password'] = 'Choose a password';
      } else if (f.password.text != f.confirmation.text) {
        e['confirmation'] = "The passwords don't match";
      }
    });
    if (!ok || !f.consent) return;
    await v.c.registerUsername(f.name.text, f.password.text);
  }

  return [
    v.notice(),
    v.headline('Choose a username'),
    v.body(
      'No e-mail, no code to wait for. Your phone becomes your key, and you '
      'unlock it with your fingerprint or face.',
      small: true,
    ),
    v.field('Username', f.name, errorKey: 'name', keyboard: TextInputType.name),
    v.field(
      'Password',
      f.password,
      secret: true,
      errorKey: 'password',
      onChanged: (_) => v.refresh(() {}),
    ),
    StrengthMeter(f.password.text),
    v.field(
      'Confirm password',
      f.confirmation,
      secret: true,
      errorKey: 'confirmation',
    ),
    const InfoBanner(
      'Keep this password. It is only needed to add another phone or to get '
      'back in if this one is lost - and because there is no e-mail on the '
      'account, it cannot be reset for you.',
      kind: BannerKind.warning,
    ),
    _Consent(v: v),
    const SizedBox(height: 8),
    v.button('Create account', submit, hero: true),
  ];
}

/// C2 · Protect this phone. Not a second key: the device key itself is the one
/// the fingerprint unlocks, which is why there is no "enable" step to skip.
List<Widget> protectPhoneView(CustomerView v) => [
  const SizedBox(height: 40),
  const HeroCircle(Icons.fingerprint),
  const SizedBox(height: 8),
  v.headline('This phone is your key', align: TextAlign.center),
  v.body(
    'Unlock with the fingerprint or face enrolled on this phone. The key that '
    'signs you in lives in the phone’s secure hardware and will not sign '
    'anything without it.',
    align: TextAlign.center,
  ),
  const SizedBox(height: 8),
  const ProofLine('One unlock covers one 10-minute session'),
  const ProofLine('The phone refuses to sign without your fingerprint or face'),
  const ProofLine(
    'Change the fingerprints or face on this phone and the key is destroyed; '
    'sign in again with your username and password',
  ),
  const SizedBox(height: 24),
  v.notice(),
  const SizedBox(height: 8),
  v.button('Unlock', v.c.loginById, icon: Icons.fingerprint, hero: true),
  v.note("This step can't be skipped.", align: TextAlign.center),
];

/// 8-lite · Account. What this profile has: a username, one phone, a password
/// for adding another, and a passkey as the way out of "only this phone".
List<Widget> phoneKeyAccountView(CustomerView v, BuildContext context) {
  final c = v.c;
  final username = c.device?.username;
  return [
    v.notice(),
    const SectionLabel('Account'),
    ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: const Icon(Icons.person_outline, color: AppColors.primary700),
      title: const Text('Username'),
      subtitle: Text(username ?? 'Not recorded on this phone'),
    ),
    const ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 8),
      leading: Icon(Icons.fingerprint, color: AppColors.primary700),
      title: Text('This phone is your key'),
      subtitle: Text('Unlocked with your fingerprint or face'),
    ),
    const InfoBanner(
      'Add a passkey to use another phone without typing your password there, '
      'and to keep a way in if this phone is lost.',
    ),
    const SectionLabel('Security'),
    ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: const Icon(Icons.key_outlined, color: AppColors.primary700),
      title: const Text('Add a passkey'),
      trailing: TextButton(
        onPressed: c.busy ? null : () => v.act(c.addPasskey),
        child: const Text('Add'),
      ),
    ),
    ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: const Icon(Icons.lock_outline, color: AppColors.primary700),
      title: const Text('Change password'),
      onTap: () => v.goToAccount(AccountStep.changePassword),
      trailing: const Icon(Icons.chevron_right, color: AppColors.neutral400),
    ),
    ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: const Icon(Icons.shield_outlined, color: AppColors.primary700),
      title: const Text('Keep your phone safe'),
      subtitle: const Text('What keeps your protection intact'),
      onTap: () => v.goToAccount(AccountStep.safety),
      trailing: const Icon(Icons.chevron_right, color: AppColors.neutral400),
    ),
    const Divider(),
    ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: const Icon(Icons.logout, color: AppColors.errorText),
      title: const Text(
        'Sign out',
        style: TextStyle(color: AppColors.errorText, fontWeight: FontWeight.w600),
      ),
      onTap: v.signOut,
    ),
  ];
}

/// The consent this profile takes on C1 (O.Purp_3), unchecked by default and
/// cleared with the passwords so it is never carried into another form.
class _Consent extends StatefulWidget {
  const _Consent({required this.v});

  final CustomerView v;

  @override
  State<_Consent> createState() => _ConsentState();
}

class _ConsentState extends State<_Consent> {
  @override
  Widget build(BuildContext context) {
    final v = widget.v;
    return CheckboxListTile(
      value: v.forms.consent,
      onChanged: v.c.busy
          ? null
          : (value) => setState(() => v.forms.consent = value ?? false),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      title: const Text(
        'azuma may create and secure my account on this phone.',
        style: TextStyle(
          fontSize: 14,
          height: 20 / 14,
          color: AppColors.neutral700,
        ),
      ),
    );
  }
}
