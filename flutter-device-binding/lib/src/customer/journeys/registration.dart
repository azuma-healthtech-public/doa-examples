part of '../customer_controller.dart';

/// Create an account: email, passkey or Health-ID. All three bind this
/// installation as the account's first device and end in mandatory biometric
/// setup. See docs/journeys/registration.md.
extension RegistrationJourney on CustomerController {
  Future<void> registerEmail(String email, String password) => run(() async {
    await _newDevice(email: email.trim());
    final challenge = await api.challenge('registration');
    final proof = await _deviceProof(device!.alias, challenge);
    final result = await api.post('account', 'register/email', {
      'email': email.trim(),
      'password': password,
      'language': 'en',
      'initiateEmailVerification': true,
      'requestChallenge': challenge,
      ...proof,
    });
    await _save(
      device!.copy(
        id: result['id'] as String?,
        verificationFlow: result['verificationFlow'] as String?,
      ),
    );
    notice = const Notice.success(
      'We sent a 6-digit code to your address. Enter it here to verify your email.',
      title: 'Account created',
    );
  });

  Future<void> resendVerification() => run(() async {
    final result = await _bound('account', 'verify/email/initiate', {
      'email': device!.email,
    });
    await _save(
      device!.copy(verificationFlow: result['verificationFlow'] as String?),
    );
    notice = const Notice.success('A new code is on its way to your inbox.');
  });

  Future<void> verifyEmail(String code) => run(() async {
    await _bound('account', 'verify/email/confirm', {
      'email': device!.email,
      'verificationFlow': device!.verificationFlow,
      'verificationCode': code.trim(),
    });
    await _save(device!.copy(verified: true));
    notice = const Notice.success(
      'Sign in to set up biometrics on this phone.',
      title: 'Email verified',
    );
  });

  /// Passkey creation and the device binding in one verify call; it returns a
  /// token, so registering also signs in.
  Future<void> registerPasskey(String name) => run(() async {
    if (name.trim().isEmpty) {
      throw const CustomerIssue('Enter an account name for your passkey.');
    }
    await _newDevice();
    final options = await api.post(
      'account',
      'register/passkeys/generate-options',
      {'identifier': name.trim()},
    );
    final attestation = await passkeys.createCredential(
      options['options'] as String,
    );
    final challenge = await api.challenge('registration');
    final result = await api.post('account', 'register/passkeys/verify', {
      'identifier': name.trim(),
      'passkeyAttestation': attestation,
      ...await _deviceProof(device!.alias, challenge),
      'requestChallenge': challenge,
      'loginScope': '',
      'language': 'en',
    });
    await _save(device!.copy(id: result['id'] as String?));
    await _complete(Map<String, dynamic>.from(result['token'] as Map));
  });

  /// Only an explicit "Create account" reaches this; a Health-ID sign-in on a
  /// fresh install adds a device to an existing account instead.
  Future<void> registerHealthId(String provider) => run(() async {
    _requireHealthId();
    await _newDevice();
    final token = await healthId.authenticate(provider);
    if (kDebugMode) debugPrint('health-id: registering the account with DOA');
    final challenge = await api.challenge('registration');
    final r = await api.post('account', 'register/healthId', {
      'identityToken': token,
      'requestChallenge': challenge,
      'language': 'en',
      ...await _deviceProof(device!.alias, challenge),
    });
    await _save(device!.copy(id: r['id'] as String?));
    notice = const Notice.success(
      'Sign in with Health-ID to set up biometrics on this phone.',
      title: 'Account created',
    );
  });

  void _requireHealthId() {
    if (!healthId.configured) {
      throw const CustomerIssue(
        'Health-ID is not configured for this build yet.',
      );
    }
  }
}
