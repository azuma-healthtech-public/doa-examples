part of '../customer_controller.dart';

/// Sign in on a bound device. Every request here is signed by the device key
/// and carries integrity data over its own login challenge. On a fresh install
/// the passkey and Health-ID entries hand over to the second-device journey.
/// See docs/journeys/login.md.
extension LoginJourney on CustomerController {
  Future<void> loginEmail(String password) => run(() async {
    if (device?.email == null) {
      throw const CustomerIssue(
        'Email login requires this account to be bound to this device.',
      );
    }
    final challenge = await api.challenge('login');
    final r = await _bound('auth', 'login/email', {
      'email': device!.email,
      'password': password,
      'scope': '',
      'requestChallenge': challenge,
      'deviceBoundIntegrityVerificationData': await _loginIntegrity(challenge),
    });
    await _complete(r);
  });

  Future<void> loginPasskey() => run(() async {
    if (device == null) {
      await _enrolWithPasskey();
      return;
    }
    final options = await _bound('auth', 'login/passkeys/generate-options', {
      if (device!.id != null) 'identifier': device!.id,
    });
    final assertion = await passkeys.getCredential(
      options['options'] as String,
    );
    final challenge = await api.challenge('login');
    await _complete(
      await _bound('auth', 'login/passkeys/verify', {
        if (device!.id != null) 'identifier': device!.id,
        'assertion': assertion,
        'scope': '',
        'requestChallenge': challenge,
        'deviceBoundIntegrityVerificationData': await _loginIntegrity(
          challenge,
        ),
      }),
    );
  });

  Future<void> loginHealthId(String provider) => run(() async {
    _requireHealthId();
    if (device == null) {
      await _enrolWithHealthId(provider);
      return;
    }
    final token = await healthId.authenticate(provider);
    final challenge = await api.challenge('login');
    await _complete(
      await _bound('auth', 'login/healthId', {
        'identityToken': token,
        'scope': '',
        'requestChallenge': challenge,
        'deviceBoundIntegrityVerificationData': await _loginIntegrity(
          challenge,
        ),
      }),
    );
  });
}
