import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../customer_controller.dart';
import '../widgets/widgets.dart';
import 'customer_view.dart';
import 'provider_picker.dart';

/// Screens 8 and 9 - signed in with everything in place.

/// 8 · Account & security.
List<Widget> accountView(CustomerView v, BuildContext context) {
  final c = v.c;
  final profile = c.profile;
  final health = (profile?['linkedAuthenticationMethods'] as List? ?? [])
      .contains('Mimoto');
  final passkeys = profile?['passkeyCredentials'] as List? ?? [];
  final email = c.device?.email;
  return [
    v.notice(),
    const SectionLabel('Sign-in methods'),
    _row(
      icon: Icons.fingerprint,
      title: 'Biometrics',
      subtitle: 'This phone',
      trailing: const _Ok('Enabled'),
    ),
    if (profile == null) ...[
      _row(
        icon: Icons.key_outlined,
        title: 'Passkeys',
        subtitle: c.busy ? 'Loading…' : 'Not loaded',
        trailing: c.busy
            ? null
            : TextButton(onPressed: () => v.act(c.loadProfile), child: const Text('Reload')),
      ),
    ] else ...[
      _row(
        icon: Icons.key_outlined,
        title: 'Passkeys',
        subtitle: passkeys.isEmpty ? 'None' : '${passkeys.length} passkey${passkeys.length == 1 ? '' : 's'}',
        trailing: TextButton(
          onPressed: c.busy ? null : () => v.act(c.addPasskey),
          child: Text(passkeys.isEmpty ? 'Add' : 'Add another'),
        ),
      ),
      _row(
        icon: Icons.badge_outlined,
        title: 'Health-ID',
        subtitle: health ? 'Connected' : 'Not connected',
        trailing: health
            ? const _Ok('Connected')
            : TextButton(
                onPressed: c.busy || !c.healthId.configured
                    ? null
                    : () => withHealthIdProvider(v, context, c.linkHealthId),
                child: const Text('Connect'),
              ),
      ),
    ],
    const InfoBanner(
      'To use another phone, connect Health-ID or add a passkey first. Email '
      "and password alone can't add a new phone.",
    ),
    const SectionLabel('Account'),
    // Only an account this installation registered with an email has a password
    // to change. One created with a passkey or Health-ID has none, and the
    // profile does not report whether a password exists, so the entry is absent
    // rather than present and certain to fail.
    if (email != null)
      _row(
        icon: Icons.lock_outline,
        title: 'Change password',
        onTap: () => v.goToAccount(AccountStep.changePassword),
      ),
    if (email != null)
      _row(icon: Icons.mail_outline, title: 'Email', subtitle: '$email · verified', chevron: false),
    _row(
      icon: Icons.shield_outlined,
      title: 'Keep your phone safe',
      subtitle: 'What keeps your protection intact',
      onTap: () => v.goToAccount(AccountStep.safety),
    ),
    const Divider(),
    _row(
      icon: Icons.logout,
      title: 'Sign out',
      color: AppColors.errorText,
      leadBackground: AppColors.error50,
      chevron: false,
      onTap: v.signOut,
    ),
  ];
}

/// 9 · Change password. Also the gate's screen when the backend requires it.
List<Widget> changePasswordView(CustomerView v) {
  final f = v.forms;
  return [
    v.notice(),
    v.body("You'll sign in again with biometrics after saving.", small: true),
    v.field('Current password', f.oldPassword, secret: true),
    v.field(
      'New password',
      f.password,
      secret: true,
      errorKey: 'password',
      onChanged: (_) => v.refresh(() {}),
    ),
    StrengthMeter(f.password.text),
    v.field(
      'Confirm new password',
      f.confirmation,
      secret: true,
      errorKey: 'confirmation',
    ),
    const SizedBox(height: 24),
    v.button('Save password', () async {
      final ok = v.valid((e) {
        if (f.password.text.isEmpty) {
          e['password'] = 'Choose a new password';
        } else if (f.password.text != f.confirmation.text) {
          e['confirmation'] = "The passwords don't match";
        }
      });
      if (!ok) return;
      await v.c.changePassword(f.oldPassword.text, f.password.text);
      // A successful change ends the session without asking for a renewal;
      // that is the one outcome that deserves its own screen rather than a
      // banner on the sign-in screen that replaces this one.
      if (v.mounted() && !v.c.signedIn && !v.c.reauthenticationRequired) {
        v.goTo(EntryStep.passwordChanged);
      }
    }),
  ];
}

/// 9b · Password changed. Shown between a password change and signing in
/// again, so the outcome is read before the sign-in screen replaces it.
/// Continue leads to the welcome screen - on a bound phone, "Welcome back".
List<Widget> passwordChangedView(CustomerView v) => [
  const SizedBox(height: 40),
  const HeroCircle(Icons.check_circle_outline),
  const SizedBox(height: 8),
  v.headline('Password changed', align: TextAlign.center),
  v.body(
    'Your new password is in place. Sign in again to continue.',
    align: TextAlign.center,
  ),
  const SizedBox(height: 24),
  v.button('Continue', () async => v.goTo(EntryStep.welcome), hero: true),
];

Widget _row({
  required IconData icon,
  required String title,
  String? subtitle,
  Widget? trailing,
  VoidCallback? onTap,
  Color? color,
  Color leadBackground = AppColors.neutral50,
  bool chevron = true,
}) => ListTile(
  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
  minVerticalPadding: 12,
  leading: Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(color: leadBackground, shape: BoxShape.circle),
    child: Icon(icon, size: 22, color: color ?? AppColors.primary700),
  ),
  title: Text(
    title,
    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color),
  ),
  subtitle: subtitle == null ? null : Text(subtitle),
  trailing: trailing ?? (chevron && onTap != null ? const Icon(Icons.chevron_right, color: AppColors.neutral400) : null),
  onTap: onTap,
);

class _Ok extends StatelessWidget {
  const _Ok(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Icon(Icons.check, size: 18, color: AppColors.successText),
      const SizedBox(width: 6),
      Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.successText,
        ),
      ),
    ],
  );
}
