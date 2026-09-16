import 'dart:convert';

import 'package:doa_device_binding_api/doa_device_binding_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_device_binding/src/core/biometric_binding.dart';
import 'package:flutter_device_binding/src/core/device_binding.dart';
import 'package:flutter_device_binding/src/core/device_bound_api.dart';
import 'package:flutter_device_binding/src/core/play_integrity.dart';
import 'package:flutter_device_binding/src/customer/customer_controller.dart';
import 'package:flutter_device_binding/src/customer/customer_storage.dart';
import 'package:flutter_device_binding/src/customer/notice.dart';

/// Variant C, the phone-key profile. The gating itself is the AndroidKeyStore's
/// to enforce; what a test can hold to account is that the app asks for a gated
/// key, that every login is the device-bound `login/id`, and that no password
/// or identity token is sent with it.

Map<String, dynamic> session(DateTime now) => {
  'accessToken':
      'header.${base64Url.encode(utf8.encode(jsonEncode({'sub': 'account-a', 'exp': now.add(const Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000})))}.signature',
  'expiresIn': 3600,
  'postLoginActions': <Map<String, dynamic>>[],
};

class MemoryStore extends CustomerStorage {
  MemoryStore([this.value]);
  CustomerDevice? value;
  @override
  Future<CustomerDevice?> load() async => value;
  @override
  Future<void> save(CustomerDevice device) async => value = device;
  @override
  Future<void> clearPending() async => value = null;
}

class TestKeys extends DeviceBinding {
  final List<bool> gated = [];

  /// Every session start must ask, whatever the keystore's window says.
  int unlocks = 0;
  @override
  Future<void> unlock() async {
    unlocks++;
  }
  @override
  Future<void> generateEcKeyPair({
    required String identifier,
    required String challenge,
    bool biometricGated = false,
  }) async {
    gated.add(biometricGated);
  }

  @override
  Future<DeviceAttestationDto> getDeviceAttestationsKey(String identifier) async =>
      DeviceAttestationDto(
        attestation: 'attestation',
        deviceOs: UserDeviceOs.android,
      );
}

class TestBiometrics extends BiometricBinding {
  @override
  Future<bool> canAuthenticate() async => true;
}

class TestIntegrity extends PlayIntegrity {
  @override
  Future<String> requestToken(String challenge) async => 'integrity:$challenge';
}

class TestApi extends DeviceBoundApi {
  TestApi(this.testKeys) : super(keys: testKeys);
  final TestKeys testKeys;
  final List<({String route, Map<String, dynamic> payload, String? alias})>
  requests = [];
  Map<String, dynamic> registration = {'id': 'account-a'};
  Map<String, dynamic> loginResponse = {};

  @override
  Future<String> challenge(String kind) async => 'challenge-$kind';

  @override
  Future<Map<String, dynamic>> post(
    String area,
    String action,
    Map<String, dynamic> payload, {
    String? alias,
    void Function()? authorize,
  }) async {
    authorize?.call();
    requests.add((route: '$area/$action', payload: payload, alias: alias));
    if (area == 'account' && action.startsWith('register/')) return registration;
    return loginResponse;
  }
}

void main() {
  late DateTime now;
  late TestKeys keys;
  late TestApi api;
  late MemoryStore store;
  late CustomerController c;

  CustomerController build({CustomerDevice? device}) {
    store = MemoryStore(device);
    return CustomerController(
      api: api,
      storage: store,
      biometrics: TestBiometrics(),
      integrity: TestIntegrity(),
      phoneKey: true,
      now: () => now,
    );
  }

  setUp(() {
    now = DateTime.utc(2026, 9, 16, 12);
    keys = TestKeys();
    api = TestApi(keys)..loginResponse = session(now);
    c = build();
  });
  tearDown(() => c.dispose());

  test('registration asks for a biometric-gated device key', () async {
    await c.initialize();
    await c.registerUsername('maria', 'chosen-password');
    expect(
      keys.gated,
      [true],
      reason: 'the device key is the biometric factor in this profile',
    );
  });

  test('registration sends the username and keeps it, without signing in', () async {
    await c.initialize();
    await c.registerUsername('  maria  ', 'chosen-password');

    final register = api.requests.single;
    expect(register.route, 'account/register/username');
    expect(register.payload['username'], 'maria', reason: 'trimmed');
    expect(register.payload['password'], 'chosen-password');
    expect(register.payload['androidIntegrityToken'], 'integrity:challenge-registration');
    expect(store.value?.id, 'account-a');
    expect(store.value?.username, 'maria');
    expect(store.value?.email, isNull, reason: 'there is no e-mail on this account');
    expect(c.signedIn, false, reason: 'C2 unlocks the key before the first session');
    expect(c.notice?.tone, NoticeTone.success);
  });

  test('a password is never persisted', () async {
    await c.initialize();
    await c.registerUsername('maria', 'chosen-password');
    expect(jsonEncode(store.value!.toJson()), isNot(contains('chosen-password')));
  });

  test('every login is the device-bound login/id, with no secret in it', () async {
    c.dispose();
    c = build(
      device: const CustomerDevice(
        alias: 'existing-key',
        id: 'account-a',
        username: 'maria',
      ),
    );
    await c.initialize();
    await c.loginById();

    final login = api.requests.single;
    expect(login.route, 'auth/login/id');
    expect(login.alias, 'existing-key', reason: 'signed by the device key');
    expect(login.payload['id'], 'account-a');
    expect(login.payload.containsKey('password'), false);
    expect(login.payload.containsKey('identityToken'), false);
    expect(
      (login.payload['deviceBoundIntegrityVerificationData'] as Map)['challenge'],
      'challenge-login',
    );
    expect(c.signedIn, true);
  });

  test('the unlock renews a session that ended', () async {
    c.dispose();
    c = build(
      device: const CustomerDevice(
        alias: 'existing-key',
        id: 'account-a',
        username: 'maria',
      ),
    );
    await c.initialize();
    await c.loginById();
    c.expireSessionNow();
    expect(c.signedIn, false);
    await c.loginById();
    expect(c.signedIn, true, reason: 'the gated key is the factor that renews');
  });

  test('every session start asks, and the account gate wants no second key', () async {
    c.dispose();
    c = build(
      device: const CustomerDevice(
        alias: 'existing-key',
        id: 'account-a',
        username: 'maria',
      ),
    );
    await c.initialize();
    await c.loginById();
    // The prompt runs whatever the keystore's window says: a window opened by
    // unlocking the phone must not let a sign-in through without asking.
    expect(keys.unlocks, 1);
    expect(c.signedIn, true);
    // The device key is the biometric factor here; there is no second key to
    // set up, so the account screen must open rather than demand one.
    expect(c.needsBiometrics, false);
    expect(c.canEnter, true);

    c.expireSessionNow();
    await c.loginById();
    expect(keys.unlocks, 2, reason: 'one prompt per session, every session');
    expect(c.canEnter, true);
  });

  test('another phone is added with the username and password', () async {
    await c.initialize();
    await c.addPhoneWithUsername('maria', 'chosen-password');
    final add = api.requests.single;
    expect(add.route, 'device/register/username');
    expect(add.payload['username'], 'maria');
    expect(add.payload['requestChallenge'], 'challenge-additionalDevice');
    expect(keys.gated, [true], reason: 'the new phone gets a gated key too');
    expect(c.signedIn, true);
  });

  test('the username survives a restart', () async {
    await c.initialize();
    await c.registerUsername('maria', 'chosen-password');
    expect(CustomerDevice.fromJson(store.value!.toJson()).username, 'maria');
  });

  test('empty details are refused before anything is created', () async {
    await c.initialize();
    await c.registerUsername('   ', 'chosen-password');
    expect(api.requests, isEmpty);
    expect(store.value, isNull);
    expect(c.notice?.tone, NoticeTone.error);
  });
}
