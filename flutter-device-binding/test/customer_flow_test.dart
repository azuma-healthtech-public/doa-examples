import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:doa_device_binding_api/doa_device_binding_api.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_device_binding/src/core/device_bound_api.dart';
import 'package:flutter_device_binding/src/customer/customer_controller.dart';
import 'package:flutter_device_binding/src/customer/notice.dart';
import 'package:flutter_device_binding/src/customer/customer_session.dart';
import 'package:flutter_device_binding/src/customer/customer_storage.dart';
import 'package:flutter_device_binding/src/core/health_id.dart';
import 'package:flutter_device_binding/src/core/biometric_binding.dart';
import 'package:flutter_device_binding/src/core/device_binding.dart';
import 'package:flutter_device_binding/src/core/passkey_manager.dart';
import 'package:flutter_device_binding/src/core/play_integrity.dart';

Map<String, dynamic> login(
  DateTime now, {
  int seconds = 3600,
  List<String> actions = const [],
}) => {
  'accessToken':
      'header.${base64Url.encode(utf8.encode(jsonEncode({'sub': 'account-a', 'exp': now.add(Duration(seconds: seconds)).millisecondsSinceEpoch ~/ 1000})))}.signature',
  'expiresIn': seconds,
  'refreshToken': 'MUST-NOT-PERSIST',
  'postLoginActions': actions.map((a) => {'actionType': a}).toList(),
};

/// The body DOA returns when it decodes a Play Integrity verdict and rejects it.
DioException integrityRejection() => DioException(
  requestOptions: RequestOptions(),
  type: DioExceptionType.badResponse,
  response: Response(
    requestOptions: RequestOptions(),
    statusCode: 400,
    data: {'error': 'DeviceBindingInvalidIntegrity'},
  ),
);

class MemoryStore extends CustomerStorage {
  CustomerDevice? value;
  bool fail = false;
  MemoryStore(this.value);
  @override
  Future<CustomerDevice?> load() async {
    if (fail) throw StateError('storage inaccessible');
    return value;
  }

  @override
  Future<void> save(CustomerDevice device) async {
    if (fail) throw StateError('storage inaccessible');
    value = device;
  }

  @override
  Future<void> clearPending() async {
    value = null;
  }
}

class TestKeys extends DeviceBinding {
  final List<String> generated = [];
  @override
  Future<void> generateEcKeyPair({
    required String identifier,
    required String challenge,
    bool biometricGated = false,
  }) async {
    expect(
      generated,
      isNot(contains(identifier)),
      reason: 'Do not overwrite a device key',
    );
    generated.add(identifier);
  }

  @override
  Future<DeviceAttestationDto> getDeviceAttestationsKey(
    String identifier,
  ) async => DeviceAttestationDto(
    attestation: 'attestation',
    deviceOs: UserDeviceOs.android,
  );
}

class TestBiometrics extends BiometricBinding {
  bool available = true, cancelled = false;
  void Function()? onSign;
  @override
  Future<bool> canAuthenticate() async => available;
  @override
  Future<AttestedBiometricKey> generateAttestedBiometricKey({
    required String alias,
    required String challenge,
    BiometricAlgorithm algorithm = BiometricAlgorithm.ecP256,
  }) async => AttestedBiometricKey(
    publicKey: 'public-key',
    attestation: 'bio-attestation:$challenge',
  );
  @override
  Future<String> signChallenge({
    required String alias,
    required String challenge,
    String promptTitle = '',
    String promptSubtitle = '',
  }) async {
    if (cancelled) throw PlatformException(code: 'cancelled');
    onSign?.call();
    return 'signature';
  }
}

class TestPasskeys extends PasskeyManager {
  bool cancelled = false;
  Object? failure;
  @override
  Future<String> createCredential(String options) async {
    if (cancelled) throw PlatformException(code: 'cancelled');
    if (failure != null) throw failure!;
    return 'credential';
  }

  @override
  Future<String> getCredential(String options) async => 'assertion';
}

class TestHealth extends HealthId {
  static const provider = 'https://idp.example.org/insurer';
  final List<String> chosen = [];
  @override
  bool get configured => true;
  @override
  Future<List<HealthIdProvider>> providers() async => const [
    HealthIdProvider(
      issuer: provider,
      name: 'Example Insurer',
      privateInsurance: false,
    ),
  ];
  Object? failure;
  @override
  Future<String> authenticate(String provider) async {
    chosen.add(provider);
    if (failure != null) throw failure!;
    return 'provider-token';
  }
}

class TestIntegrity extends PlayIntegrity {
  final List<String> requested = [];
  bool unavailable = false;
  void Function()? onRequest;
  @override
  Future<String> requestToken(String challenge) async {
    onRequest?.call();
    if (unavailable) throw const IntegrityUnavailable();
    requested.add(challenge);
    return 'integrity:$challenge';
  }
}

class TestApi extends DeviceBoundApi {
  TestApi() : super(keys: TestKeys());
  final List<({String route, Map<String, dynamic> payload, String? alias})>
  requests = [];
  Map<String, dynamic> response = {};
  void Function()? beforeAuthorize;
  Object? failure;
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
    beforeAuthorize?.call();
    authorize?.call();
    requests.add((route: '$area/$action', payload: payload, alias: alias));
    if (failure != null) throw failure!;
    if (action.endsWith('generate-options')) return {'options': '{}'};
    if (action == 'register/email') {
      return {'id': 'account-a', 'verificationFlow': 'flow'};
    }
    if (area == 'device' && action.endsWith('passkeys/verify') ||
        area == 'account' && action == 'register/passkeys/verify') {
      return {'id': 'account-a', 'token': response};
    }
    if (action == 'register/healthId' && area == 'account') {
      return {'id': 'account-a'};
    }
    return response;
  }
}

void main() {
  late DateTime now;
  late TestApi api;
  late MemoryStore store;
  late TestBiometrics bio;
  late TestPasskeys passkeys;
  late TestIntegrity integrity;
  late CustomerController c;
  setUp(() {
    now = DateTime.utc(2026, 9, 11, 12);
    api = TestApi()..response = login(now);
    store = MemoryStore(
      const CustomerDevice(
        alias: 'existing-key',
        id: 'account-a',
        email: 'a@example.org',
      ),
    );
    bio = TestBiometrics();
    passkeys = TestPasskeys();
    integrity = TestIntegrity();
    c = CustomerController(
      api: api,
      storage: store,
      biometrics: bio,
      passkeys: passkeys,
      integrity: integrity,
      healthId: TestHealth(),
      now: () => now,
    );
  });
  tearDown(() => c.dispose());
  test('mandatory setup, cancellation, backend biometric login and no persisted secrets', () async {
    await c.initialize();
    await c.loginEmail('secret');
    expect(c.signedIn, true);
    expect(c.canEnter, false);
    expect(c.needsBiometrics, true);
    bio.cancelled = true;
    await c.enableBiometrics();
    expect(c.needsBiometrics, true);
    expect(store.value!.biometricAlias, isNull);
    bio.cancelled = false;
    await c.enableBiometrics();
    expect(c.canEnter, true);
    expect(store.value!.biometricAlias, isNotNull);
    expect(api.requests.last.route, 'auth/login/biometrics');
    expect(jsonEncode(store.value!.toJson()), isNot(contains('secret')));
    expect(
      jsonEncode(store.value!.toJson()),
      isNot(contains('MUST-NOT-PERSIST')),
    );
    expect(
      api.requests.where((r) => r.payload['scope'] == 'offline_access'),
      isEmpty,
    );
  });
  test(
    'fixed deadline locks; cancelled login stays locked; biometrics renews',
    () async {
      store.value = store.value!.copy(biometricAlias: 'bio');
      await c.initialize();
      await c.loginEmail('secret');
      now = now.add(const Duration(minutes: 10));
      c.checkExpiry();
      expect(c.session, isNull);
      expect(c.reauthenticationRequired, true);
      final count = api.requests.length;
      await c.loadProfile();
      expect(api.requests.length, count);
      bio.cancelled = true;
      await c.loginBiometrics();
      expect(c.signedIn, false);
      api.response = login(now);
      await c.loginEmail('secret');
      expect(c.signedIn, false);
      bio.cancelled = false;
      await c.loginBiometrics();
      expect(c.canEnter, true);
      expect(api.requests.any((r) => r.route.contains('refresh')), false);
    },
  );
  test('expiry during signing prevents sending a protected request', () async {
    store.value = store.value!.copy(biometricAlias: 'bio');
    await c.initialize();
    await c.loginEmail('secret');
    api.beforeAuthorize = () {
      now = now.add(const Duration(minutes: 10));
    };
    final count = api.requests.length;
    await c.loadProfile();
    expect(api.requests.length, count);
    expect(c.profile, isNull);
  });
  test('restart retains associations but no authenticated session', () async {
    await c.initialize();
    await c.loginEmail('secret');
    await c.enableBiometrics();
    final restarted = CustomerController(
      api: TestApi(),
      storage: store,
      now: () => now,
    );
    await restarted.initialize();
    expect(restarted.signedIn, false);
    expect(restarted.device!.biometricAlias, isNotNull);
    restarted.dispose();
  });
  test('device B can use passkey, never email enrollment', () async {
    store.value = null;
    await c.initialize();
    await c.loginEmail('secret');
    expect(api.requests, isEmpty);
    await c.loginPasskey();
    expect(c.device!.id, 'account-a');
    expect(c.needsBiometrics, true);
    expect(
      api.requests.map((r) => r.route),
      contains('device/register/passkeys/verify'),
    );
    expect(api.requests.any((r) => r.route == 'device/register/email'), false);
  });
  test('device B Health-ID enrollment requires local biometrics', () async {
    store.value = null;
    await c.initialize();
    await c.loginHealthId(TestHealth.provider);
    expect(api.requests.last.route, 'device/register/healthId');
    expect(c.needsBiometrics, true);
    expect(c.device!.id, 'account-a');
  });
  test(
    'email registration persists verification and never saves password',
    () async {
      store.value = null;
      await c.initialize();
      await c.registerEmail('a@example.org', 'secret');
      expect(store.value!.verificationFlow, 'flow');
      expect(c.canEnter, false);
      expect(jsonEncode(store.value!.toJson()), isNot(contains('secret')));
      await c.verifyEmail('123456');
      expect(store.value!.verificationFlow, isNull);
      expect(api.requests.last.payload['verificationCode'], '123456');
    },
  );
  test(
    'passkey registration and Health-ID linking preserve account identity',
    () async {
      store.value = null;
      await c.initialize();
      await c.registerPasskey('Alice');
      expect(c.device!.id, 'account-a');
      expect(c.needsBiometrics, true);
      await c.enableBiometrics();
      await c.linkHealthId(TestHealth.provider);
      expect(api.requests.any((r) => r.route == 'account/link/healthId'), true);
      expect(c.device!.id, 'account-a');
    },
  );
  test('cancelled passkey creation permits retry', () async {
    store.value = null;
    await c.initialize();
    passkeys.cancelled = true;
    await c.registerPasskey('Alice');
    expect(c.device, isNull);
    expect(store.value, isNull);
    passkeys.cancelled = false;
    await c.registerPasskey('Alice');
    expect(c.needsBiometrics, true);
  });
  test('a provider the broker refuses says so instead of blaming the user', () async {
    store.value = null;
    await c.initialize();
    final health = c.healthId as TestHealth;
    health.failure = const HealthIdProviderUnavailable();
    await c.registerHealthId(TestHealth.provider);
    expect(c.notice!.title, 'Try another insurer');
    expect(c.signedIn, false);
    expect(store.value, isNull);
  });
  test('the provider the user picked is the one used for the hand-off', () async {
    store.value = null;
    await c.initialize();
    final health = c.healthId as TestHealth;
    expect((await health.providers()).single.name, 'Example Insurer');
    await c.registerHealthId(TestHealth.provider);
    expect(health.chosen, [TestHealth.provider]);
    expect(api.requests.last.route, 'account/register/healthId');
  });
  test('a dismissed platform prompt is an info notice, a failed one offers retry', () async {
    store.value = null;
    await c.initialize();
    passkeys.cancelled = true;
    await c.registerPasskey('Alice');
    expect(c.notice!.tone, NoticeTone.info);
    expect(c.notice!.retry, false);
    passkeys.cancelled = false;
    passkeys.failure = PlatformException(code: 'passkey_error');
    await c.registerPasskey('Alice');
    expect(c.notice!.tone, NoticeTone.error);
    expect(c.notice!.retry, true);
    expect(c.device, isNull);
    passkeys.failure = null;
    await c.retry();
    expect(c.needsBiometrics, true);
    expect(c.notice, isNull);
  });
  test('no answer from the backend is a retryable error, a rejection is not', () async {
    await c.initialize();
    api.failure = DioException(
      requestOptions: RequestOptions(),
      type: DioExceptionType.connectionError,
    );
    await c.loginEmail('secret');
    expect(c.notice!.tone, NoticeTone.error);
    expect(c.notice!.retry, true);
    api.failure = DioException(
      requestOptions: RequestOptions(),
      type: DioExceptionType.badResponse,
      response: Response(requestOptions: RequestOptions(), statusCode: 400),
    );
    await c.loginEmail('secret');
    expect(c.notice!.tone, NoticeTone.error);
    expect(c.notice!.retry, false);
  });
  test('a rejected device check is a full-screen state until checked again', () async {
    await c.initialize();
    api.failure = integrityRejection();
    await c.loginEmail('secret');
    expect(c.deviceCheck, DeviceCheckFailure.rejected);
    api.failure = null;
    c.clearDeviceCheck();
    expect(c.deviceCheck, isNull);
    expect(c.notice, isNull);
    await c.retry();
    expect(c.signedIn, true);
  });
  test('confirmations nobody has to read are snackbars', () async {
    await c.initialize();
    await c.loginEmail('secret');
    await c.signOut();
    expect(c.notice!.tone, NoticeTone.snack);
  });
  test('ambiguous registration keeps the submitted key and refuses to overwrite it', () async {
    store.value = null;
    await c.initialize();
    api.failure = DioException(
      requestOptions: RequestOptions(),
      type: DioExceptionType.receiveTimeout,
    );
    await c.registerEmail('a@example.org', 'secret');
    final alias = store.value!.alias;
    await c.registerEmail('a@example.org', 'secret');
    expect(store.value!.alias, alias);
    expect((api.keys as TestKeys).generated, [alias]);
  });
  test(
    'unreadable storage and unavailable biometrics block registration',
    () async {
      store.fail = true;
      await c.initialize();
      expect(c.ready, false);
      await c.registerEmail('a@example.org', 'secret');
      expect(api.requests, isEmpty);
      store.fail = false;
      store.value = null;
      await c.initialize();
      bio.available = false;
      await c.registerEmail('a@example.org', 'secret');
      expect(api.requests, isEmpty);
    },
  );
  test(
    'required password action gates entry; change returns to login',
    () async {
      store.value = store.value!.copy(biometricAlias: 'bio');
      api.response = login(now, actions: ['PasswordChangeRequired']);
      await c.initialize();
      await c.loginBiometrics();
      expect(c.canEnter, false);
      expect(c.needsPassword, true);
      await c.changePassword('old', 'new');
      expect(c.signedIn, false);
      expect(api.requests.last.route, 'account/changePassword');
    },
  );
  test('early token expiry and monotonic cap survive wall-clock rollback', () {
    final early = CustomerSession.fromResponse(
      login(now, seconds: 30),
      now,
      Duration.zero,
    );
    expect(
      early.valid(
        now.add(const Duration(seconds: 30)),
        const Duration(seconds: 30),
      ),
      false,
    );
    final full = CustomerSession.fromResponse(login(now), now, Duration.zero);
    expect(
      full.valid(
        now.subtract(const Duration(hours: 1)),
        const Duration(minutes: 10),
      ),
      false,
    );
  });
  test(
    'Health-ID rejects wrong state, duplicate code and foreign callback',
    () {
      final expected = Uri.parse('https://app.example.org/health-id/callback');
      validateHealthCallback(
        Uri.parse('$expected?code=abc&state=expected'),
        expected,
        'expected',
      );
      for (final value in [
        '$expected?code=abc&state=wrong',
        '$expected?code=abc&code=def&state=expected',
        'https://evil.example/health-id/callback?code=abc&state=expected',
        '$expected?code=abc&state=expected#fragment',
      ]) {
        expect(
          () => validateHealthCallback(Uri.parse(value), expected, 'expected'),
          throwsStateError,
        );
      }
    },
  );
  test(
    'every registration carries a Play Integrity token over its attestation challenge',
    () async {
      store.value = null;
      await c.initialize();
      await c.registerEmail('a@example.org', 'secret');
      final registration = api.requests.single;
      expect(registration.route, 'account/register/email');
      expect(registration.payload['requestChallenge'], 'challenge-registration');
      expect(
        registration.payload['androidIntegrityToken'],
        'integrity:challenge-registration',
      );
      expect(registration.payload['deviceAttestation'], isNotNull);
      expect(
        jsonEncode(store.value!.toJson()),
        isNot(contains('integrity:')),
      );

      store.value = null;
      await c.initialize();
      await c.loginPasskey();
      final additional = api.requests.last;
      expect(additional.route, 'device/register/passkeys/verify');
      expect(
        additional.payload['androidIntegrityToken'],
        'integrity:${additional.payload['requestChallenge']}',
      );
    },
  );
  test(
    'device-bound logins carry integrity data over the signed login challenge',
    () async {
      store.value = store.value!.copy(biometricAlias: 'bio');
      await c.initialize();
      await c.loginEmail('secret');
      await c.loginBiometrics();
      await c.loginPasskey();
      await c.loginHealthId(TestHealth.provider);
      for (final route in [
        'auth/login/email',
        'auth/login/biometrics',
        'auth/login/passkeys/verify',
        'auth/login/healthId',
      ]) {
        final request = api.requests.lastWhere((r) => r.route == route);
        expect(request.alias, 'existing-key', reason: route);
        expect(request.payload['requestChallenge'], 'challenge-login');
        expect(request.payload['deviceBoundIntegrityVerificationData'], {
          'challenge': 'challenge-login',
          'androidIntegrityToken': 'integrity:challenge-login',
        }, reason: route);
      }
    },
  );
  test(
    'unavailable Play Integrity stops registration before a key or binding exists',
    () async {
      store.value = null;
      await c.initialize();
      integrity.unavailable = true;
      await c.registerEmail('a@example.org', 'secret');
      expect(api.requests, isEmpty);
      expect((api.keys as TestKeys).generated, isEmpty);
      expect(store.value, isNull);
      expect(c.device, isNull);
      expect(c.message, CustomerController.integrityUnavailableMessage);
      integrity.unavailable = false;
      await c.registerEmail('a@example.org', 'secret');
      expect(store.value!.verificationFlow, 'flow');
    },
  );
  test(
    'biometric login requests its integrity token after the prompt, and stops without one',
    () async {
      store.value = store.value!.copy(biometricAlias: 'bio');
      await c.initialize();
      final order = <String>[];
      bio.onSign = () => order.add('prompt');
      integrity.onRequest = () => order.add('token');
      await c.loginBiometrics();
      expect(c.canEnter, true);
      expect(order, ['prompt', 'token']);
      now = now.add(const Duration(minutes: 10));
      c.checkExpiry();
      integrity.unavailable = true;
      final count = api.requests.length;
      await c.loginBiometrics();
      expect(c.signedIn, false);
      expect(api.requests.length, count);
      expect(c.message, CustomerController.integrityUnavailableMessage);
    },
  );
  test('a rejected integrity verdict explains the risk and grants no session', () async {
    await c.initialize();
    api.failure = integrityRejection();
    await c.loginEmail('secret');
    expect(c.signedIn, false);
    expect(c.message, CustomerController.integrityRejectedMessage);
  });
  test('an integrity-rejected registration leaves nothing pending', () async {
    store.value = null;
    await c.initialize();
    api.failure = integrityRejection();
    await c.registerEmail('a@example.org', 'secret');
    expect(c.message, CustomerController.integrityRejectedMessage);
    expect(store.value, isNull);
    expect(c.device, isNull);
  });
  test(
    'biometric link sends the key attestation over the linking challenge',
    () async {
      await c.initialize();
      await c.loginEmail('secret');
      await c.enableBiometrics();
      final link = api.requests.singleWhere(
        (r) => r.route == 'account/link/biometrics',
      );
      expect(link.alias, 'existing-key');
      expect(link.payload['requestChallenge'], 'challenge-linking');
      expect(link.payload['publicKey'], 'public-key');
      final attestation = link.payload['keyAttestation'] as Map;
      expect(attestation['attestation'], 'bio-attestation:challenge-linking');
      expect(attestation['deviceOs'], 'Android');
      expect(
        jsonEncode(store.value!.toJson()),
        isNot(contains('bio-attestation')),
      );
    },
  );
}
