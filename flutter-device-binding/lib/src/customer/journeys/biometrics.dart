part of '../customer_controller.dart';

/// Mandatory biometric setup, the ten-minute renewal, and repair when the key
/// stops working. See docs/journeys/biometrics.md.
extension BiometricsJourney on CustomerController {
  Future<void> enableBiometrics() => run(() async {
    final current = _requireSession();
    await _capability();
    final alias = _alias('biometric');
    final challenge = await api.challenge('linking');
    // The key is attested over the link challenge, so DOA can verify that it
    // lives in secure hardware and demands a biometric on every use (once DOA reads it).
    // DOA skips fields it does not know, so the link works before that lands.
    final key = await biometrics.generateAttestedBiometricKey(
      alias: alias,
      challenge: challenge,
    );
    final signature = await biometrics.signChallenge(
      alias: alias,
      challenge: challenge,
      promptTitle: 'Enable biometrics',
      promptSubtitle: 'Use biometrics to sign in every 10 minutes',
    );
    await _account('link/biometrics', {
      'publicKey': key.publicKey,
      // Android sends the chain DOA will check once it reads attestation chains. iOS has none, so
      // the field is left out rather than sent empty.
      'keyAttestation': ?key.attestation == null
          ? null
          : DeviceAttestationDto(
              attestation: key.attestation,
              deviceName: 'Mobile',
              deviceOs: DeviceOs.model,
            ).toJson(),
      'requestChallenge': challenge,
      'requestSignature': signature,
    });
    if (!identical(session, current)) {
      throw const CustomerIssue('Sign in again to finish setup.');
    }
    await _save(device!.copy(biometricAlias: alias));
    // Prove the newly linked credential works through the backend before entry.
    session = null;
    await _biometricLogin();
  });

  Future<void> loginBiometrics() => run(_biometricLogin);

  Future<void> _biometricLogin() async {
    if (device?.biometricAlias == null || device?.id == null) {
      throw const CustomerIssue(
        'Sign in with your account and enable biometrics first.',
      );
    }
    final challenge = await api.challenge('login');
    final signature = await biometrics.signChallenge(
      alias: device!.biometricAlias!,
      challenge: challenge,
      promptTitle: 'Sign in',
      promptSubtitle: 'Start a new 10-minute session',
    );
    // After the prompt, not before: DOA will bound the token's age (planned),
    // and a prompt can stay open for minutes. Requested here, the token is
    // milliseconds old when the request leaves.
    final integrityData = await _loginIntegrity(challenge);
    await _complete(
      await _bound('auth', 'login/biometrics', {
        'id': device!.id,
        'requestChallenge': challenge,
        'requestSignature': signature,
        'scope': '',
        'deviceBoundIntegrityVerificationData': integrityData,
      }),
      biometric: true,
    );
  }

  /// Explicit repair requires account authentication followed by mandatory
  /// enrollment again; it never grants access on a broken local credential.
  Future<void> repairBiometrics() => run(() async {
    session = null;
    profile = null;
    reauthenticationRequired = false;
    await _save(device!.copy(resetBiometrics: true));
    notice = const Notice.info(
      'Sign in with email, passkey or Health-ID, then set up biometrics again.',
      title: 'Biometric setup reset',
    );
  });
}
