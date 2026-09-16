import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../customer_controller.dart';
import '../notice.dart';
import '../widgets/widgets.dart';

/// The text fields every view may use. Owned by the screen, not the views, so
/// clearing passwords on background and after every action happens in one
/// place regardless of which view is showing.
class CustomerForms {
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmation = TextEditingController();
  final code = TextEditingController();
  final name = TextEditingController();
  final oldPassword = TextEditingController();

  /// Explicit consent on registration (O.Purp_3). Unchecked by default; reset
  /// together with the passwords so it is never carried into another form.
  bool consent = false;

  /// Field-level validation messages by field key; shown under the field,
  /// cleared as soon as that field changes. Never carried into a banner.
  final errors = <String, String>{};

  void clearPasswords() {
    password.clear();
    confirmation.clear();
    oldPassword.clear();
    consent = false;
  }

  void dispose() {
    for (final f in [email, password, confirmation, code, name, oldPassword]) {
      f.dispose();
    }
  }
}

/// Where the user is within the "no session" state of the gate. Not routes:
/// the gate decides which steps are reachable from the device record.
enum EntryStep {
  welcome,
  createAccount,
  signIn,
  emailRegister,
  emailSignIn,
  passkeyName,
  // Variant A: what the transfer explains before the hand-off, and what it
  // asks after it (variants.md, screens A1 and A2).
  transferIntro,
  transferConfirm,
  // 9b: the confirmation after a password change, on the way back to sign-in.
  passwordChanged,
  // S3: keep your phone safe, from the welcome screen.
  safety,
}

/// Where the user is within the signed-in account state.
enum AccountStep {
  overview,
  changePassword,
  // S3, from the account screen.
  safety,
}

/// What a view gets: the controller, the forms, navigation between steps, and
/// the builders that encode the shared rules (disabled while busy, password
/// fields cleared after every action, no autocorrect on secrets).
class CustomerView {
  CustomerView({
    required this.c,
    required this.forms,
    required this.mounted,
    required this.refresh,
    required this.goTo,
    required this.goToAccount,
    required this.toRoot,
  });

  final CustomerController c;
  final CustomerForms forms;
  final bool Function() mounted;
  final void Function(VoidCallback) refresh;
  final void Function(EntryStep) goTo;
  final void Function(AccountStep) goToAccount;

  /// Leaves the flow for its root: the launcher in an unpinned build, the
  /// flow's own welcome screen in a pinned one. Where sign-out and every cancel
  /// end up, so the user is never left on a screen belonging to something they
  /// just stopped.
  final VoidCallback toRoot;

  /// Signing out always ends at the root - never on the account screen the
  /// user just left, and never on the lock screen.
  Future<void> signOut() async {
    await act(c.signOut);
    if (mounted()) toRoot();
  }

  TextTheme get text => textThemeOf;
  late final TextTheme textThemeOf;

  /// Set once a view has placed the notice; the screen prepends it otherwise.
  bool noticePlaced = false;

  /// The outcome of the last action, where the view puts it: at the top of the
  /// content under the app bar, or directly above the primary action on hero
  /// screens. Snackbar tones belong to the screen.
  Widget notice() {
    noticePlaced = true;
    final n = c.notice;
    if (n == null || n.tone == NoticeTone.snack) return const SizedBox.shrink();
    return NoticeBanner(n, onRetry: () => act(c.retry));
  }

  /// Runs [validate], which fills `forms.errors`; false when any is set.
  bool valid(void Function(Map<String, String> errors) validate) {
    forms.errors.clear();
    validate(forms.errors);
    if (forms.errors.isNotEmpty) refresh(() {});
    return forms.errors.isEmpty;
  }

  /// Runs [action], then clears secrets and repaints - the rule every button
  /// follows.
  Future<void> act(Future<void> Function() action) async {
    await action();
    if (mounted()) {
      forms.clearPasswords();
      refresh(() {});
    }
  }

  Widget button(
    String label,
    Future<void> Function() action, {
    IconData? icon,
    bool hero = false,
    bool enabled = true,
  }) {
    final style = hero
        ? FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(AppTheme.heroButtonHeight),
          )
        : null;
    final onPressed = c.busy || !enabled ? null : () => act(action);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: icon == null
          ? FilledButton(style: style, onPressed: onPressed, child: Text(label))
          : FilledButton.icon(
              style: style,
              onPressed: onPressed,
              icon: Icon(icon, size: hero ? 24 : 20),
              label: Text(label),
            ),
    );
  }

  Widget outlined(String label, VoidCallback onPressed) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: OutlinedButton(
      onPressed: c.busy ? null : onPressed,
      child: Text(label),
    ),
  );

  Widget link(
    String label,
    VoidCallback onPressed, {
    Color? color,
    AlignmentGeometry alignment = Alignment.center,
  }) => Align(
    alignment: alignment,
    child: TextButton(
      onPressed: c.busy ? null : onPressed,
      style: color == null ? null : TextButton.styleFrom(foregroundColor: color),
      child: Text(label),
    ),
  );

  Widget field(
    String label,
    TextEditingController controller, {
    bool secret = false,
    bool readOnly = false,
    String? helper,
    String? errorKey,
    TextInputType? keyboard,
    ValueChanged<String>? onChanged,
    Widget? trailing,
  }) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: _SecretField(
      label: label,
      controller: controller,
      secret: secret,
      readOnly: readOnly,
      enabled: !c.busy,
      helper: helper,
      error: errorKey == null ? null : forms.errors[errorKey],
      keyboard: keyboard,
      onChanged: (value) {
        if (errorKey != null && forms.errors.remove(errorKey) != null) {
          refresh(() {});
        }
        onChanged?.call(value);
      },
      trailing: trailing,
    ),
  );

  Widget headline(String value, {bool large = false, TextAlign? align}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          value,
          textAlign: align,
          style: large ? textThemeOf.headlineLarge : textThemeOf.headlineMedium,
        ),
      );

  Widget body(String value, {TextAlign? align, bool small = false}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Text(
      value,
      textAlign: align,
      style: small ? textThemeOf.bodyMedium : textThemeOf.bodyLarge,
    ),
  );

  Widget note(String value, {TextAlign? align}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Text(
      value,
      textAlign: align,
      style: const TextStyle(
        fontSize: 13,
        height: 18 / 13,
        color: AppColors.neutral400,
      ),
    ),
  );
}

/// Outlined field with an optional show/hide toggle for secrets.
class _SecretField extends StatefulWidget {
  const _SecretField({
    required this.label,
    required this.controller,
    required this.secret,
    required this.readOnly,
    required this.enabled,
    this.helper,
    this.error,
    this.keyboard,
    this.onChanged,
    this.trailing,
  });
  final String label;
  final TextEditingController controller;
  final bool secret, readOnly, enabled;
  final String? helper, error;
  final TextInputType? keyboard;
  final ValueChanged<String>? onChanged;
  final Widget? trailing;

  @override
  State<_SecretField> createState() => _SecretFieldState();
}

class _SecretFieldState extends State<_SecretField> {
  bool _hidden = true;

  Widget? _suffix() {
    if (widget.error != null) {
      return const Icon(Icons.error_outline, size: 22, color: AppColors.errorText);
    }
    if (widget.secret) {
      return IconButton(
        tooltip: _hidden ? 'Show' : 'Hide',
        icon: Icon(
          _hidden ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: AppColors.neutral500,
        ),
        onPressed: () => setState(() => _hidden = !_hidden),
      );
    }
    if (widget.readOnly) {
      return const Icon(Icons.lock_outline, size: 20, color: AppColors.neutral500);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) => TextField(
    controller: widget.controller,
    obscureText: widget.secret && _hidden,
    readOnly: widget.readOnly,
    enabled: widget.enabled && !widget.readOnly,
    autocorrect: false,
    // O.Data_10: nothing typed into this app should train the keyboard - not
    // the secrets, and not the e-mail or account name either, which identify
    // the person just as well.
    enableSuggestions: false,
    keyboardType: widget.keyboard,
    onChanged: widget.onChanged,
    style: TextStyle(
      fontSize: 16,
      color: widget.readOnly ? AppColors.neutral900 : null,
    ),
    decoration: InputDecoration(
      labelText: widget.label,
      helperText: widget.helper,
      errorText: widget.error,
      filled: widget.readOnly,
      fillColor: AppColors.neutral50,
      suffixIcon: widget.trailing ?? _suffix(),
    ),
  );
}
