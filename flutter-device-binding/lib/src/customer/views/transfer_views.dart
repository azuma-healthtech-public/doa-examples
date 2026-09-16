import 'package:flutter/material.dart';

import '../../core/transfer_provider.dart';
import '../../theme/app_colors.dart';
// The journey's methods are an extension on the controller, and an extension is
// only in scope where its library is imported directly.
import '../customer_controller.dart';
import '../widgets/widgets.dart';
import 'customer_view.dart';

/// Screens A1 and A2 - variant A, account transfer from a previous identity
/// provider (`examples/specifications/variants.md`).
///
/// Demo mode (`TransferProvider.demoMode`, debuggable builds only) keeps these
/// screens exactly as they are and replaces only the hand-off: an in-app sheet
/// that accepts whatever is typed, so the screens can be walked without a
/// provider. It ends before DOA, and every screen says so.
///
/// Every way of stopping - "Not now", "This isn't me", cancelling the sheet -
/// returns to the root: the transfer is entered from its own tile, so leaving
/// it goes back to where that tile is.

/// A1 · Transfer intro. What moves, what does not, what happens next, and the
/// consent that must be given *before* the hand-off, because the hand-off
/// itself already sends data to the provider.
List<Widget> transferIntroView(CustomerView v) {
  final name = v.c.transfer.name;
  return [
    v.notice(),
    v.headline('Transfer your account from $name'),
    v.body(
      'You sign in at $name once. azuma then creates your account for that '
      'identity and binds it to this phone. After that you use azuma, not '
      '$name.',
    ),
    const SizedBox(height: 8),
    ProofLine('Your identity moves, and your email if $name supplies it'),
    ProofLine('Data held by $name does not move'),
    const ProofLine('Next: set up biometrics on this phone. This is required.'),
    const SizedBox(height: 8),
    const InfoBanner(
      'Once transferred, add a passkey or use your email so you can still get '
      'in if the old sign-in stops working.',
    ),
    if (v.c.transfer.demoMode)
      const InfoBanner(
        'Demo mode: no previous provider is contacted. Any details work on '
        'the next screen, and no account is created at the end.',
        kind: BannerKind.warning,
      ),
    if (!v.c.transfer.configured)
      v.note('Account transfer is awaiting configuration for this build.'),
    const SizedBox(height: 8),
    TransferConsent(v: v),
    v.link('Not now', v.toRoot),
  ];
}

/// The consent checkbox and the action it gates. A widget rather than two
/// entries in the list because the checkbox owns state the screen does not.
class TransferConsent extends StatefulWidget {
  const TransferConsent({super.key, required this.v});

  final CustomerView v;

  @override
  State<TransferConsent> createState() => _TransferConsentState();
}

class _TransferConsentState extends State<TransferConsent> {
  /// Unchecked, always: consent is given here, never carried in.
  bool agreed = false;

  Future<void> _continue() async {
    final v = widget.v;
    if (v.c.transfer.demoMode) {
      // The sheet stands in for the provider's sign-in page. Whatever comes
      // back is marked as a demo identity, which the journey refuses to send
      // anywhere. Cancelling the sheet cancels the transfer.
      final identity = await demoSignIn(context, v.c.transfer.name);
      if (!mounted) return;
      if (identity == null) {
        v.toRoot();
        return;
      }
      await v.c.startTransfer(demo: identity);
    } else {
      await v.c.startTransfer();
    }
    if (v.mounted() && v.c.pendingTransfer != null) {
      v.goTo(EntryStep.transferConfirm);
    }
  }

  @override
  Widget build(BuildContext context) {
    final v = widget.v;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CheckboxListTile(
          value: agreed,
          onChanged: v.c.busy
              ? null
              : (value) => setState(() => agreed = value ?? false),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          title: Text(
            'azuma may process the identity ${v.c.transfer.name} returns, to '
            'create and secure my account.',
            style: const TextStyle(
              fontSize: 14,
              height: 20 / 14,
              color: AppColors.neutral700,
            ),
          ),
        ),
        v.button(
          'Continue to ${v.c.transfer.name}',
          _continue,
          hero: true,
          enabled: agreed && v.c.transfer.configured,
        ),
      ],
    );
  }
}

/// A2 · Confirm transfer. The identity that came back, masked. Nothing has been
/// created yet: this screen is the first that can create anything, and "This
/// isn't me" leaves no trace. Once the identity is gone - the demo finished, or
/// the account was created - the screen shows the outcome and a way back.
List<Widget> transferConfirmView(CustomerView v) {
  final identity = v.c.pendingTransfer;
  if (identity == null) {
    return [
      v.notice(),
      const SizedBox(height: 8),
      v.outlined('Back to start', v.toRoot),
    ];
  }
  final label = identity.label;
  final shown = label == null
      ? null
      : label.contains('@')
      ? maskEmail(label)
      : label;
  return [
    v.notice(),
    v.headline('Is this you?'),
    Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.neutral100),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.badge_outlined, color: AppColors.primary700),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              shown ?? 'Signed in at ${v.c.transfer.name}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.neutral900,
              ),
            ),
          ),
        ],
      ),
    ),
    v.body(
      'This creates your azuma account for this identity on this phone.',
    ),
    if (identity.demo)
      const InfoBanner(
        'Demo: the button below ends the demo instead of creating an account. '
        'Nothing is sent to azuma.',
        kind: BannerKind.warning,
      ),
    if (shown == null)
      v.note(
        '${v.c.transfer.name} did not return an address or a name to show.',
      ),
    const SizedBox(height: 8),
    v.button(
      identity.demo ? 'Create my account (demo)' : 'Create my account',
      v.c.confirmTransfer,
      hero: true,
    ),
    v.outlined("This isn't me", () {
      v.c.abandonTransfer();
      v.toRoot();
    }),
  ];
}

/// Demo mode's stand-in for the provider's sign-in page: a sheet that takes an
/// e-mail and a password and accepts anything, including nothing. The password
/// is read by no one and goes nowhere; the e-mail only labels A2. Returns null
/// when the sheet is dismissed.
Future<TransferIdentity?> demoSignIn(BuildContext context, String provider) =>
    showModalBottomSheet<TransferIdentity>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _DemoSignInSheet(provider: provider),
    );

/// Owns its two controllers, so they are disposed with the sheet's own element
/// and not a moment earlier. Disposing them when the sheet's future completed
/// - which is the instant "Sign in" pops it - left the fields rebuilding
/// against dead controllers while the sheet animated out with the keyboard
/// closing, which the framework reports as a teardown assertion.
class _DemoSignInSheet extends StatefulWidget {
  const _DemoSignInSheet({required this.provider});

  final String provider;

  @override
  State<_DemoSignInSheet> createState() => _DemoSignInSheetState();
}

class _DemoSignInSheetState extends State<_DemoSignInSheet> {
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void _signIn() {
    final typed = email.text.trim();
    Navigator.pop(
      context,
      TransferIdentity(
        // Not a token: never sent, and refused by the journey if it ever were.
        token: 'demo',
        email: typed.isEmpty ? 'demo@previous.example' : typed,
        demo: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(
      24,
      16,
      24,
      24 + MediaQuery.viewInsetsOf(context).bottom,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Sign in at ${widget.provider}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 4),
        const Text(
          'Demo: any details work, and none of them leave this phone.',
          style: TextStyle(fontSize: 13, color: AppColors.neutral400),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: email,
          autocorrect: false,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: password,
          obscureText: true,
          autocorrect: false,
          enableSuggestions: false,
          onSubmitted: (_) => _signIn(),
          decoration: const InputDecoration(labelText: 'Password'),
        ),
        const SizedBox(height: 16),
        FilledButton(onPressed: _signIn, child: const Text('Sign in')),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    ),
  );
}
