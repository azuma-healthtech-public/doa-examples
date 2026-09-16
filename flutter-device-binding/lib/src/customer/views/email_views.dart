import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../customer_controller.dart';
import '../notice.dart';
import '../widgets/widgets.dart';
import 'customer_view.dart';

/// Screens 3, 4, 5 - the email path.

/// 3 · Email registration: consent gates the primary action; the strength
/// meter is derived on the fly and never stored.
List<Widget> emailRegisterView(CustomerView v) {
  final f = v.forms;
  Future<void> submit() async {
    final email = f.email.text.trim();
    final ok = v.valid((e) {
      if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
        e['email'] = 'Enter an address like name@example.org';
      }
      if (f.password.text.isEmpty) {
        e['password'] = 'Choose a password';
      } else if (f.password.text != f.confirmation.text) {
        e['confirmation'] = "The passwords don't match";
      }
    });
    if (ok) await v.c.registerEmail(email, f.password.text);
  }

  return [
    v.notice(),
    v.field(
      'Email address',
      f.email,
      keyboard: TextInputType.emailAddress,
      errorKey: 'email',
    ),
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
    ConsentRow(
      value: f.consent,
      onChanged: (value) => v.refresh(() => f.consent = value),
    ),
    const SizedBox(height: 16),
    v.button('Create account', submit, enabled: f.consent),
  ];
}

/// 4 · Verify email: the code from the mail, resend.
List<Widget> verifyEmailView(CustomerView v) {
  final c = v.c;
  final email = c.device?.email ?? '';
  return [
    v.notice(),
    const SizedBox(height: 16),
    const HeroCircle(Icons.mail_outline, size: 96),
    const SizedBox(height: 8),
    v.headline('Check your inbox', align: TextAlign.center),
    Text.rich(
      TextSpan(
        text: 'We sent a 6-digit code to\n',
        children: [
          TextSpan(
            text: email,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.neutral900,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
      style: v.text.bodyLarge,
    ),
    const SizedBox(height: 16),
    TextField(
      controller: v.forms.code,
      enabled: !c.busy,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      maxLength: 6,
      autocorrect: false,
      enableSuggestions: false,
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: 12,
        color: AppColors.neutral900,
      ),
      onChanged: (_) {
        if (v.forms.errors.remove('code') != null) v.refresh(() {});
      },
      decoration: InputDecoration(
        counterText: '',
        hintText: '••••••',
        errorText: v.forms.errors['code'],
      ),
    ),
    v.link('Resend code', () => v.act(c.resendVerification),
        color: AppColors.neutral500),
    const SizedBox(height: 24),
    v.button('Verify', () async {
      final code = v.forms.code.text.trim();
      if (!v.valid((e) {
        if (!RegExp(r'^\d{6}$').hasMatch(code)) {
          e['code'] = 'Enter the 6 digits from the email';
        }
      })) {
        return;
      }
      await c.verifyEmail(code);
      v.forms.code.clear();
    }),
  ];
}

/// 5 · Email sign-in on a linked phone: the address is the record's.
List<Widget> emailSignInView(CustomerView v) {
  final f = v.forms;
  f.email.text = v.c.device?.email ?? '';
  return [
    v.notice(),
    v.field(
      'Email address',
      f.email,
      readOnly: true,
      helper: 'This phone is linked to this account.',
    ),
    v.field('Password', f.password, secret: true, errorKey: 'password'),
    v.link(
      'Forgot password?',
      () => v.refresh(
        () => v.c.notice = const Notice.info(
          'Password reset is not available in this example yet.',
        ),
      ),
      alignment: Alignment.centerLeft,
    ),
    const SizedBox(height: 24),
    v.button('Sign in', () async {
      if (!v.valid((e) {
        if (f.password.text.isEmpty) e['password'] = 'Enter your password';
      })) {
        return;
      }
      await v.c.loginEmail(f.password.text);
    }),
  ];
}
