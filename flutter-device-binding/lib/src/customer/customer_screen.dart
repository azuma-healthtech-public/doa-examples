import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_config.dart';
import '../theme/app_colors.dart';
import 'customer_controller.dart';
import 'devtools/dev_tools_screen.dart';
import 'widgets/widgets.dart';
import 'notice.dart';
import 'scenario.dart';
import 'views/account_view.dart';
import 'views/customer_view.dart';
import 'views/email_views.dart';
import 'views/entry_views.dart';
import 'views/gate_views.dart';
import 'views/phone_key_views.dart';
import 'views/safety_view.dart';
import 'views/transfer_views.dart';

/// The one screen. It owns the forms and the lifecycle (clear passwords and
/// hide the body when not in the foreground) and maps controller state to a
/// view - in this order, and nothing routes around it:
///
///   storage unreadable -> retry
///   session ended      -> 7 lock screen
///   no session         -> 1 / 2a / 2b / 2c / 3 / 4 / 5   (entry steps)
///   email unverified   -> 4
///   no biometric key   -> 6 mandatory setup
///   blocking action    -> maintenance message
///   password required  -> 9
///   otherwise          -> 8 account & security (9 as a sub-step)
///
/// Entry steps are a sub-state of "no session", not routes: the record decides
/// which are reachable (`normaliseStep`), and back moves between them.
class CustomerScreen extends ConsumerStatefulWidget {
  const CustomerScreen({super.key});
  @override
  ConsumerState<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends ConsumerState<CustomerScreen>
    with WidgetsBindingObserver {
  final forms = CustomerForms();
  EntryStep step = EntryStep.welcome;
  AccountStep accountStep = AccountStep.overview;
  bool hidden = false;
  bool _hadSession = false;
  Object? _profileRequestedFor;
  Notice? _shownSnack;
  CustomerController get c => ref.read(customerProvider);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // The "Account transfer" tile means the transfer, not the reference
    // journey with a link at the bottom: it opens on A1, which is the only way
    // in - the other flows never offer the transfer. Unconfigured, A1 says so
    // itself. A phone that already holds a binding still lands on sign-in,
    // because `normaliseStep` says so, and "Not now" on A1 leads to this flow's
    // own welcome screen.
    if (ref.read(activeScenarioProvider) == Scenario.transfer) {
      step = EntryStep.transferIntro;
    }
    Future.microtask(() => c.initialize());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    c.checkExpiry();
    if (mounted) setState(() => hidden = state != AppLifecycleState.resumed);
    if (hidden) forms.clearPasswords();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    forms.dispose();
    super.dispose();
  }

  void _goTo(EntryStep next) => setState(() {
    step = next;
    _leaveScreen();
    forms.name.clear();
  });

  void _goToAccount(AccountStep next) => setState(() {
    accountStep = next;
    _leaveScreen();
  });

  /// What every move between screens drops: the secrets typed into the screen
  /// being left, what was wrong with its fields, and the outcome of whatever
  /// happened there. A notice belongs to the screen that produced it - carrying
  /// "that didn't work" onto the next screen describes something the user is no
  /// longer looking at.
  void _leaveScreen() {
    forms.clearPasswords();
    forms.errors.clear();
    c.notice = null;
  }

  /// Back from A2 (variant A). The identity the provider returned is held in
  /// memory only; leaving the screen drops it, so nothing waits behind the user
  /// to be confirmed later.
  void _backFromTransfer() {
    c.abandonTransfer();
    _goTo(EntryStep.transferIntro);
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: ref.watch(customerProvider),
    builder: (context, _) {
      if (_hadSession && !c.signedIn) forms.clearPasswords();
      _hadSession = c.signedIn;
      final v = CustomerView(
        c: c,
        forms: forms,
        mounted: () => mounted,
        refresh: setState,
        goTo: _goTo,
        goToAccount: _goToAccount,
        toRoot: _toRoot,
      )..textThemeOf = Theme.of(context).textTheme;

      if (hidden) {
        return const Scaffold(
          body: Center(child: Icon(Icons.lock_outline, size: 48)),
        );
      }
      if (c.ready && !c.signedIn && c.reauthenticationRequired) {
        // 7-lite: variant C has no second key to renew a session with, so the
        // unlock is the device key's own prompt behind `login/id`, and there is
        // no biometric setup to repair.
        return c.phoneKey
            ? LockedScreen(
                c: c,
                act: v.act,
                onSignOut: v.signOut,
                unlock: c.loginById,
                unlockLabel: 'Unlock',
                showRepair: false,
              )
            : LockedScreen(c: c, act: v.act, onSignOut: v.signOut);
      }

      final (appBar, content, resolvedBack) = _resolve(v, context);
      final back = resolvedBack ?? _toLauncher();
      _showSnack(context);
      return PopScope(
        canPop: back == null,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) back?.call();
        },
        child: Scaffold(
          appBar: appBar,
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  children: [
                    // Views place the notice where the design says; a view
                    // that did not gets it at the top, never at the bottom.
                    if (!v.noticePlaced) v.notice(),
                    ...content,
                    if (c.busy)
                      const Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: LinearProgressIndicator(),
                      ),
                    if (c.busy && c.healthId.active) ...[
                      InfoBanner(
                        c.handoffProvider == null
                            ? 'Your insurer is taking over to confirm who you '
                                  'are. You will come back here when they are done.'
                            : '${c.handoffProvider} is taking over to confirm '
                                  'who you are. You will come back here when '
                                  'they are done.',
                      ),
                      TextButton(
                        onPressed: () async {
                          try {
                            await c.healthId.cancel();
                          } catch (_) {
                            /* The flow also has a bounded timeout. */
                          }
                        },
                        child: const Text('Cancel Health-ID sign-in'),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          "The insurer's page or app opens on top of this "
                          'screen. Nothing is saved until you come back.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            height: 18 / 13,
                            color: AppColors.neutral400,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );

  /// The gate. Returns the app bar (null for hero screens), the content, and
  /// what back does (null: system default).
  (PreferredSizeWidget?, List<Widget>, VoidCallback?) _resolve(
    CustomerView v,
    BuildContext context,
  ) {
    // A build that names no tenant stops here, before anything can leave for
    // nowhere. Config is compile-time (or the debug override), never typed in.
    if (!ref.read(runtimeConfigProvider).configured) {
      return (null, notConfiguredView(v), null);
    }
    if (!c.ready) return (null, storageView(v), null);
    if (c.deviceCheck != null) return (null, deviceCheckView(v), null);

    // Variant C is a different gate: there is no separate biometric key to set
    // up, so screen 6 never appears, and what signs the user in is the device
    // key the phone unlocks (variants.md, section C).
    if (c.phoneKey) {
      if (!c.signedIn) {
        return c.device == null
            ? (_bar('Create account'), usernameSetupView(v), null)
            : (null, protectPhoneView(v), null);
      }
      if (c.blockingActions.isNotEmpty) return (null, blockedView(v), null);
      if (accountStep == AccountStep.changePassword) {
        return (
          _bar('Change password', back: () => _goToAccount(AccountStep.overview)),
          changePasswordView(v),
          () => _goToAccount(AccountStep.overview),
        );
      }
      if (accountStep == AccountStep.safety) {
        return (
          _bar('Keep your phone safe', back: () => _goToAccount(AccountStep.overview)),
          safetyView(v, back: () => _goToAccount(AccountStep.overview)),
          () => _goToAccount(AccountStep.overview),
        );
      }
      _autoLoadProfile();
      return (
        _bar('Account', countdown: true),
        phoneKeyAccountView(v, context),
        null,
      );
    }

    if (!c.signedIn) {
      // Verification pending on a bound record comes before any sign-in.
      if (c.device?.verificationFlow != null) {
        return (_bar('Verify your email'), verifyEmailView(v), null);
      }
      step = normaliseStep(c, step);
      return switch (step) {
        EntryStep.welcome => (
          null,
          welcomeView(
            v,
            transferEntry:
                ref.read(activeScenarioProvider) == Scenario.transfer,
          ),
          null,
        ),
        EntryStep.createAccount => (
          _bar('Create account', back: () => _goTo(EntryStep.welcome)),
          createAccountView(v, context),
          () => _goTo(EntryStep.welcome),
        ),
        EntryStep.signIn when c.device == null => (
          _bar('Sign in', back: () => _goTo(EntryStep.welcome)),
          signInNewDeviceView(v, context),
          () => _goTo(EntryStep.welcome),
        ),
        EntryStep.signIn => (null, signInBoundView(v, context), null),
        EntryStep.emailRegister => (
          _bar('Create account with email', back: () => _goTo(EntryStep.createAccount)),
          emailRegisterView(v),
          () => _goTo(EntryStep.createAccount),
        ),
        EntryStep.emailSignIn => (
          _bar('Sign in with email', back: () => _goTo(EntryStep.signIn)),
          emailSignInView(v),
          () => _goTo(EntryStep.signIn),
        ),
        EntryStep.passkeyName => (
          _bar('Create account with passkey', back: () => _goTo(EntryStep.createAccount)),
          passkeyNameView(v),
          () => _goTo(EntryStep.createAccount),
        ),
        // A1 explains and takes consent; A2 confirms the identity that came
        // back. Back from A2 returns to A1 and drops the pending identity, so
        // leaving the screen never leaves an identity waiting to be confirmed.
        // A1 is the transfer's first screen, entered from its own tile, so
        // leaving it - back, "Not now" - returns to where that tile is.
        EntryStep.transferIntro => (
          _bar('Transfer your account', back: _toRoot),
          transferIntroView(v),
          _toRoot,
        ),
        EntryStep.transferConfirm => (
          _bar('Confirm transfer', back: _backFromTransfer),
          transferConfirmView(v),
          _backFromTransfer,
        ),
        // 9b: read the outcome, then Continue to the welcome screen. Back does
        // the same, because there is nothing behind it to return to.
        EntryStep.passwordChanged => (
          null,
          passwordChangedView(v),
          () => _goTo(EntryStep.welcome),
        ),
        // S3 from the welcome screen; back returns there.
        EntryStep.safety => (
          _bar('Keep your phone safe', back: () => _goTo(EntryStep.welcome)),
          safetyView(v, back: () => _goTo(EntryStep.welcome)),
          () => _goTo(EntryStep.welcome),
        ),
      };
    }

    if (c.needsVerification) return (_bar('Verify your email'), verifyEmailView(v), null);
    if (c.needsBiometrics) return (null, biometricsSetupView(v), null);
    if (c.blockingActions.isNotEmpty) return (null, blockedView(v), null);
    if (c.needsPassword) return (_bar('Change password'), changePasswordView(v), null);

    _autoLoadProfile();
    if (accountStep == AccountStep.changePassword) {
      return (
        _bar('Change password', back: () => _goToAccount(AccountStep.overview)),
        changePasswordView(v),
        () => _goToAccount(AccountStep.overview),
      );
    }
    // S3 from the account screen; back returns there.
    if (accountStep == AccountStep.safety) {
      return (
        _bar('Keep your phone safe', back: () => _goToAccount(AccountStep.overview)),
        safetyView(v, back: () => _goToAccount(AccountStep.overview)),
        () => _goToAccount(AccountStep.overview),
      );
    }
    return (_bar('Account & security', countdown: true), accountView(v, context), null);
  }

  /// Where back goes when the flow itself has nowhere left to go.
  ///
  /// An unpinned build entered this flow from the launcher (screen 0), which is
  /// a swapped home widget and not a route, so there is nothing for the system
  /// back to pop: without this it leaves the app from the first screen of a
  /// flow instead of returning to the list. `AppConfig.isPinned` is a
  /// compile-time constant, so a pinned build folds this away entirely. Once
  /// signed in, back behaves as it does on any home screen and leaves the app.
  VoidCallback? _toLauncher() {
    if (AppConfig.isPinned || c.signedIn) return null;
    if (ref.read(activeScenarioProvider) == null) return null;
    return () => ref.read(activeScenarioProvider.notifier).clear();
  }

  /// The root of the flow: the launcher when the build has one and a flow is
  /// active, otherwise the flow's own welcome screen. Where sign-out and every
  /// cancel end up, so nobody is left on a screen belonging to what they just
  /// stopped. Clearing the scenario replaces this screen with the launcher;
  /// the pinned build has no launcher and goes to welcome instead.
  void _toRoot() {
    if (!AppConfig.isPinned && ref.read(activeScenarioProvider) != null) {
      ref.read(activeScenarioProvider.notifier).clear();
      return;
    }
    _goTo(EntryStep.welcome);
  }

  /// A snack-tone notice is a four-second snackbar, shown once.
  void _showSnack(BuildContext context) {
    final n = c.notice;
    if (n == null || n.tone != NoticeTone.snack || identical(n, _shownSnack)) {
      return;
    }
    _shownSnack = n;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_outline, size: 20, color: AppColors.white),
                const SizedBox(width: 12),
                Expanded(child: Text(n.body)),
              ],
            ),
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
          ),
        );
    });
  }

  /// Screen 8 shows the profile without a manual load; once per session.
  void _autoLoadProfile() {
    final session = c.session;
    if (session == null || c.profile != null || c.busy) return;
    if (identical(_profileRequestedFor, session)) return;
    _profileRequestedFor = session;
    Future.microtask(c.loadProfile);
  }

  AppBar _bar(String title, {VoidCallback? back, bool countdown = false}) => AppBar(
    title: Text(title),
    leading: back == null
        ? null
        : IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: c.busy ? null : back,
          ),
    automaticallyImplyLeading: false,
    actions: [
      if (countdown && c.secondsRemaining != null)
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: _CountdownChip(seconds: c.secondsRemaining!),
        ),
      // Compile-time constant: the release build has neither the button nor
      // the screen behind it.
      if (kDebugMode)
        IconButton(
          tooltip: 'DevTools',
          icon: const Icon(Icons.bug_report_outlined),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const DevToolsScreen()),
          ),
        ),
      if (!AppConfig.isPinned && !c.signedIn)
        IconButton(
          tooltip: 'Example flows',
          icon: const Icon(Icons.apps_outlined),
          onPressed: () => ref.read(activeScenarioProvider.notifier).clear(),
        ),
    ],
  );
}

class _CountdownChip extends StatelessWidget {
  const _CountdownChip({required this.seconds});
  final int seconds;

  @override
  Widget build(BuildContext context) {
    final s = seconds < 0 ? 0 : seconds;
    final text = '${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.neutral200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.schedule, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              fontFeatures: [FontFeature.tabularFigures()],
              color: AppColors.neutral700,
            ),
          ),
        ],
      ),
    );
  }
}
