part of '../customer_controller.dart';

/// Add this fresh installation to an existing account. Only a passkey or
/// Health-ID can do that; email and a biometric key on another device cannot.
/// Both return a token, so the user lands in mandatory biometric setup.
/// See docs/journeys/second-device.md.
extension SecondDeviceJourney on CustomerController {
  Future<void> _enrolWithPasskey() async {
    await _newDevice();
    final options = await api.post(
      'device',
      'register/passkeys/generate-options',
      {},
    );
    final assertion = await passkeys.getCredential(
      options['options'] as String,
    );
    final challenge = await api.challenge('additionalDevice');
    final result = await api.post('device', 'register/passkeys/verify', {
      'assertion': assertion,
      'scope': '',
      'requestChallenge': challenge,
      ...await _deviceProof(device!.alias, challenge),
    });
    await _complete(Map<String, dynamic>.from(result['token'] as Map));
  }

  Future<void> _enrolWithHealthId(String provider) async {
    await _newDevice();
    final token = await healthId.authenticate(provider);
    final challenge = await api.challenge('additionalDevice');
    await _complete(
      await api.post('device', 'register/healthId', {
        'identityToken': token,
        'scope': '',
        'requestChallenge': challenge,
        ...await _deviceProof(device!.alias, challenge),
      }),
    );
  }
}
