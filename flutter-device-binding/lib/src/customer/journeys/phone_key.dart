part of '../customer_controller.dart';

/// Variant C: the lightest account DOA supports. A username and a password
/// entered once at registration, and from then on this phone signs the user in:
/// `auth/login/id` takes the account id and is authenticated by the bound
/// device key alone.
///
/// What makes that honest is the key, not this file. In the phone-key profile
/// the **device key itself** is generated biometric-gated, invalidated when
/// enrolment changes, and valid for ten minutes after one authentication, so
/// the prompt is the secure hardware's condition for signing rather than a
/// check the app performs and could skip. The server sees one factor
/// (TR-03161-1 O.Auth_3 is not met by DOA today); once DOA reads the key's
/// user-auth tags, the same profile becomes server-verifiable without a
/// protocol change. See `examples/specifications/variants.md`, section C.
extension PhoneKeyJourney on CustomerController {
  /// C1 · Choose a username. The password is not a sign-in method here: it is
  /// what adds another phone later, and there is no e-mail to reset it with.
  Future<void> registerUsername(String username, String password) =>
      run(() async {
        _requirePhoneKey();
        final name = username.trim();
        if (name.isEmpty) {
          throw const CustomerIssue('Choose a username.');
        }
        if (password.isEmpty) {
          throw const CustomerIssue('Choose a password.');
        }
        await _newDevice(username: name);
        final challenge = await api.challenge('registration');
        final proof = await _deviceProof(device!.alias, challenge);
        final result = await api.post('account', 'register/username', {
          'username': name,
          'password': password,
          'language': 'en',
          'requestChallenge': challenge,
          ...proof,
        });
        await _save(device!.copy(id: result['id'] as String?));
        // C2 comes next: the phone explains that it is now the key, and the
        // first login proves the gated key works before anything depends on it.
        notice = const Notice.success(
          'Your account is ready. Unlock with your fingerprint or face to '
          'finish setting up this phone.',
          title: 'Account created',
        );
      });

  /// Every login, including the first: the device key signs the request, and
  /// the secure hardware asks for a biometric if its ten minutes have passed.
  /// Nothing else is sent - no password, no identity token.
  Future<void> loginById() => run(_idLogin);

  Future<void> _idLogin() async {
    _requirePhoneKey();
    if (device?.id == null) {
      throw const CustomerIssue(
        'Create an account on this phone, or add it with your username and password.',
      );
    }
    final challenge = await api.challenge('login');
    // The prompt, every session. A time-bound key counts any strong-biometric
    // authentication inside its window - unlocking the phone with a finger
    // included - so the hardware alone would ask only once the window had
    // lapsed. The key stays gated underneath; this is the session's promise.
    await api.keys.unlock();
    // After the prompt, not before: a prompt can stay open for minutes, and
    // DOA bounds the token's age.
    final integrityData = await _loginIntegrity(challenge);
    await _complete(
      await _bound('auth', 'login/id', {
        'id': device!.id,
        'scope': '',
        'requestChallenge': challenge,
        'deviceBoundIntegrityVerificationData': integrityData,
      }),
      // The prompt that unlocked the device key is the biometric factor here;
      // there is no second key to renew a session with.
      biometric: true,
    );
  }

  /// Another phone: the username and password are asked for exactly here, and
  /// the new phone gets its own gated key.
  Future<void> addPhoneWithUsername(String username, String password) =>
      run(() async {
        _requirePhoneKey();
        final name = username.trim();
        if (name.isEmpty || password.isEmpty) {
          throw const CustomerIssue(
            'Enter the username and password you chose when you created the account.',
          );
        }
        await _newDevice(username: name);
        final challenge = await api.challenge('additionalDevice');
        final proof = await _deviceProof(device!.alias, challenge);
        await _complete(
          await api.post('device', 'register/username', {
            'username': name,
            'password': password,
            'requestChallenge': challenge,
            ...proof,
          }),
        );
      });

  /// The profile needs a device key the hardware will only use after a
  /// biometric. On iOS the device key is an App Attest key, which cannot carry
  /// that requirement, and a software check in front of it would be the UI
  /// promise the spec forbids - so the profile refuses rather than pretends.
  void _requirePhoneKey() {
    if (DeviceOs.isIos) {
      throw const CustomerIssue(
        'This flow needs a device key that the phone itself locks behind your '
        'fingerprint or face. iOS does not offer that for its device key, so '
        'the flow is Android-only for now.',
        tone: NoticeTone.info,
        title: 'Not available on this phone',
      );
    }
  }
}
