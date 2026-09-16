part of '../customer_controller.dart';

/// Variant A: bring an account over from a previous identity provider. The user
/// signs in there once (A1 explains it and takes consent, the hand-off runs,
/// A2 confirms who came back), DOA creates the account for that identity and
/// binds this phone, and from then on the journey is the customer app's.
///
/// The previous provider is a registration-time identity. After the transfer
/// the account needs a DOA-native way in - the e-mail the provider supplied, or
/// a passkey added on the account screen - which is what screen 8's banner is
/// for. See `examples/specifications/variants.md`, section A.
extension TransferJourney on CustomerController {
  /// A1 -> the hand-off. Consent is taken on the screen before this runs,
  /// because the hand-off itself already sends data to the provider.
  ///
  /// In demo mode the in-app sheet hands the identity in as [demo]. A demo
  /// identity is refused unless the build is in demo mode and the identity says
  /// it is one, so nothing typed into a demo can reach a real hand-off.
  Future<void> startTransfer({TransferIdentity? demo}) => run(() async {
    _requireTransfer();
    if (device != null) {
      throw const CustomerIssue(
        'This installation already has an account or pending setup. Sign in to continue it.',
      );
    }
    handoffProvider = transfer.name;
    if (demo != null) {
      if (!transfer.demoMode || !demo.demo) {
        throw const CustomerIssue(
          'A demo identity is only accepted in demo mode.',
        );
      }
      pendingTransfer = demo;
      return;
    }
    try {
      pendingTransfer = await transfer.authenticate();
    } catch (_) {
      pendingTransfer = null;
      rethrow;
    }
  });

  /// A2 · "Create my account". Nothing exists until here: the identity has been
  /// held in memory only, and this is the first call that creates anything.
  Future<void> confirmTransfer() => run(() async {
    final identity = pendingTransfer;
    if (identity == null) {
      throw const CustomerIssue(
        'Start the transfer again; nothing was carried over.',
      );
    }
    if (identity.demo) {
      // The demo ends here, and says so. DOA validates provider tokens against
      // the provider's own signing keys, so nothing minted in the app could be
      // accepted; and a record with no account behind it would only break the
      // next sign-in. So: no request, no record, one honest notice.
      pendingTransfer = null;
      notice = Notice.info(
        'This is where azuma would create your account for '
        '${identity.label ?? 'this identity'} and bind this phone. Demo mode '
        'contacted no provider and created nothing.',
        title: 'Demo finished',
      );
      return;
    }
    await _newDevice(email: identity.email);
    final challenge = await api.challenge('registration');
    final proof = await _deviceProof(device!.alias, challenge);
    final result = await api.post(
      'account',
      'register/${TransferProvider.doaProvider}',
      {
        'identityToken': identity.token,
        'requestChallenge': challenge,
        'language': 'en',
        ...proof,
      },
    );
    await _save(
      device!.copy(
        id: result['id'] as String?,
        transferredFrom: transfer.name,
        transferredAt: now(),
      ),
    );
    pendingTransfer = null;
    // DOA may hand back a session with the registration, as passkey
    // registration does. When it does not, the account exists and the user
    // signs in once more to reach the mandatory biometric setup - the same
    // shape as Health-ID registration. Which of the two DOA does is a tenant
    // and backend question the spec leaves open, so both are handled.
    final token = result['token'];
    if (token is Map) {
      await _complete(Map<String, dynamic>.from(token));
      return;
    }
    notice = Notice.success(
      'Sign in with ${transfer.name} to set up biometrics on this phone.',
      title: 'Account created',
    );
  });

  /// A2 · "This isn't me". Nothing was created, so nothing is undone.
  void abandonTransfer() {
    pendingTransfer = null;
    handoffProvider = null;
    notice = const Notice.info(
      'Nothing was created. You can start again, or create an account here instead.',
    );
    _emit();
  }

  /// Sign in with the previous provider on a phone that already holds the
  /// binding: the identity is still accepted until the account has a DOA-native
  /// method, which is what the account screen keeps asking for.
  Future<void> loginTransfer() => run(() async {
    _requireTransfer();
    if (transfer.demoMode) {
      // Demo mode has no provider to sign in at, and there is no account to
      // sign in to - the demo never created one.
      throw const CustomerIssue(
        'Demo mode shows the transfer screens only; there is no sign-in behind it.',
        tone: NoticeTone.info,
        title: 'Demo mode',
      );
    }
    if (device == null) {
      throw const CustomerIssue(
        'Add this phone with a passkey or Health-ID first.',
      );
    }
    handoffProvider = transfer.name;
    final identity = await transfer.authenticate();
    final challenge = await api.challenge('login');
    await _complete(
      await _bound('auth', 'login/${TransferProvider.doaProvider}', {
        'identityToken': identity.token,
        'scope': '',
        'requestChallenge': challenge,
        'deviceBoundIntegrityVerificationData': await _loginIntegrity(
          challenge,
        ),
      }),
    );
  });

  void _requireTransfer() {
    if (!transfer.configured) {
      throw const CustomerIssue(
        'Account transfer is not configured for this build yet.',
      );
    }
  }
}
