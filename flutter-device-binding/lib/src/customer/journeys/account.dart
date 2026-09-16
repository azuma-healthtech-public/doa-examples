part of '../customer_controller.dart';

/// Account & security: profile, linking, password change - and the unlink
/// operations the customer UI does not surface (DevTools does).
/// See docs/journeys/account.md.
extension AccountJourney on CustomerController {
  Future<void> loadProfile() => run(_loadProfile);

  Future<void> _loadProfile() async {
    profile = null;
    profile = await _account('userInfo', {});
  }

  Future<void> linkHealthId(String provider) => run(() async {
    _requireHealthId();
    _requireSession();
    final token = await healthId.authenticate(provider);
    await _account('link/healthId', {'healthIdIdentityToken': token});
    await _loadProfile();
    notice = const Notice.snack('Health-ID connected');
  });

  Future<void> addPasskey() => run(() async {
    final options = await _account('link/passkeys/generate-options', {});
    final attestation = await passkeys.createCredential(
      options['options'] as String,
    );
    await _account('link/passkeys/verify', {'passkeyAttestation': attestation});
    await _loadProfile();
    notice = const Notice.snack('Passkey added');
  });

  /// Only for an account this installation registered with an email: nothing
  /// else has a password, and the profile does not say whether one exists.
  Future<void> changePassword(String oldPassword, String newPassword) =>
      run(() async {
    if (newPassword.isEmpty) {
      throw const CustomerIssue('Enter a new password.');
    }
    // Variant C has no e-mail: its identifier is the username it registered
    // with, and that is what DOA expects here.
    final account = device!.email ?? device!.username;
    if (account == null || account.isEmpty) {
      throw const CustomerIssue(
        'This account has no password. It was created with a passkey or '
        'Health-ID, which is what signs you in.',
        tone: NoticeTone.info,
        title: 'No password to change',
      );
    }
    await _account('changePassword', {
      'identifier': account,
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    });
    session = null;
    profile = null;
    notice = const Notice.success(
      'Sign in with biometrics to continue.',
      title: 'Password changed',
    );
  });

  // ---- not in the customer UI; surfaced by DevTools -------------------------

  Future<void> unlinkPasskey(String passkeyId) => run(() async {
    await _account('unlink/passkeys', {'passkeyId': passkeyId});
    await _loadProfile();
  });

  /// Unlinking this device's own biometric key leaves the local alias behind;
  /// "Repair biometric setup" on the entry screen clears it.
  Future<void> unlinkBiometric(String biometricsId) => run(() async {
    await _account('unlink/biometrics', {'biometricsId': biometricsId});
    await _loadProfile();
  });

  Future<void> unlinkHealthId() => run(() async {
    await _account('unlink/healthId', {});
    await _loadProfile();
  });
}
