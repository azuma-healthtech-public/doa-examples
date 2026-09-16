import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:doa_device_binding_api/doa_device_binding_api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_config.dart';
import '../core/biometric_binding.dart';
import '../core/device_bound_api.dart';
import '../core/device_os.dart';
import '../core/health_id.dart';
import '../core/passkey_manager.dart';
import '../core/play_integrity.dart';
import '../core/transfer_provider.dart';
import 'customer_session.dart';
import 'customer_storage.dart';
import 'notice.dart';
import 'scenario.dart';

// One library, one file per journey. Parts share this library's private
// members, so the journeys use `_save`, `_account`, `_complete` and friends
// without those becoming public API. Read them in this order:
part 'journeys/registration.dart';
part 'journeys/login.dart';
part 'journeys/biometrics.dart';
part 'journeys/second_device.dart';
part 'journeys/account.dart';
part 'journeys/transfer.dart';
part 'journeys/phone_key.dart';

final customerProvider = Provider<CustomerController>((ref) {
  final scenario = ref.watch(activeScenarioProvider) ?? Scenario.customer;
  final c = CustomerController(
    api: DeviceBoundApi(config: ref.watch(runtimeConfigProvider)),
    storage: CustomerStorage(slot: scenario.slot),
    // Variant C decides how the device key is generated, so it is fixed when
    // the flow starts rather than read per call.
    phoneKey: scenario == Scenario.phoneKey,
  );
  ref.onDispose(c.dispose);
  return c;
});

/// The customer journey's state and the rules every journey shares: the
/// serialised `run` loop and its error mapping, session validity, persistence,
/// device proof, the signed account request and login completion. The
/// journeys themselves are the `part` files above.
class CustomerController extends ChangeNotifier {
  CustomerController({
    DeviceBoundApi? api,
    CustomerStorage? storage,
    this.biometrics = const BiometricBinding(),
    this.passkeys = const PasskeyManager(),
    this.integrity = const PlayIntegrity(),
    this.phoneKey = false,
    HealthId? healthId,
    TransferProvider? transfer,
    DateTime Function()? now,
  }) : api = api ?? DeviceBoundApi(),
       storage = storage ?? CustomerStorage(),
       healthId = healthId ?? HealthId(),
       transfer = transfer ?? TransferProvider(),
       now = now ?? DateTime.now {
    _clock.start();
    // Once a second: end the session when its time is up, and while it runs
    // repaint so the countdown chip on the account screen keeps time.
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      checkExpiry();
      if (signedIn) _emit();
    });
  }

  /// BSI TR-03161-1 O.Resi_2: when the device is not in the state its
  /// manufacturer intends, the user must be told what that puts at risk.
  static const integrityRejectedMessage =
      'Google Play could not confirm that this device and app are unmodified. '
      'On a rooted, unlocked or otherwise modified device, or with an app not '
      'installed from Google Play, other apps or attackers may be able to read '
      'or change your health data. Registration and sign-in are blocked on '
      'this device.';
  static const cancelledNotice = Notice.info(
    "Cancelled. Nothing changed. Try again whenever you're ready.",
  );
  static const integrityUnavailableMessage =
      'The device check with Google Play could not be completed. Make sure '
      'Google Play services are installed and up to date and that you are '
      'online, then retry.';

  final DeviceBoundApi api;
  final CustomerStorage storage;
  final BiometricBinding biometrics;
  final PasskeyManager passkeys;
  final PlayIntegrity integrity;
  final HealthId healthId;

  /// Variant A: the provider an account is being brought over from.
  final TransferProvider transfer;

  /// Variant C: this build runs the phone-key profile, so the device key is
  /// generated biometric-gated and `login/id` is the only sign-in. Fixed when
  /// the flow starts, because it decides how the key is created.
  final bool phoneKey;
  final DateTime Function() now;
  final Stopwatch _clock = Stopwatch();
  Timer? _timer;
  bool _disposed = false;
  bool ready = false, busy = false, storageFailed = false;
  bool reauthenticationRequired = false;
  bool _draft = false;
  bool _newBindingSubmitted = false;
  /// The outcome of the last action, for the screen to place (notice.dart).
  Notice? notice;

  /// The phone failed the integrity check; the gate shows a full-screen state
  /// until `clearDeviceCheck`.
  DeviceCheckFailure? deviceCheck;

  /// The insurer the user picked, while the Health-ID hand-off is running. The
  /// screen names it, so the user knows who is about to take over. Display only:
  /// nothing is decided from it.
  String? handoffProvider;

  /// Variant A: what the previous provider returned, between A1 and A2. Held in
  /// memory only - never persisted, never logged - and dropped as soon as the
  /// user confirms the transfer or says it is not them.
  TransferIdentity? pendingTransfer;
  Future<void> Function()? _lastAction;
  CustomerDevice? device;
  CustomerSession? session;
  Map<String, dynamic>? profile;

  // ---- state the gate reads -------------------------------------------------

  /// The notice text; what the tests and DevTools read.
  String? get message => notice?.body;

  /// Leaves the device-check state; the user then retries the action.
  void clearDeviceCheck() {
    deviceCheck = null;
    notice = null;
    _emit();
  }

  /// Re-runs the action behind a notice that offered "Try again".
  Future<void> retry() {
    final action = _lastAction;
    return action == null ? Future.value() : run(action);
  }

  /// A platform prompt the user dismissed: not an error, nothing changed.
  static bool isCancellation(PlatformException e) {
    final code = e.code.toUpperCase();
    return code.contains('CANCEL') ||
        // BiometricPrompt: USER_CANCELED (10), NEGATIVE_BUTTON (13), CANCELED (5).
        code == 'BIOMETRIC_ERROR_10' ||
        code == 'BIOMETRIC_ERROR_13' ||
        code == 'BIOMETRIC_ERROR_5';
  }

  bool get signedIn => session?.valid(now(), _clock.elapsed) ?? false;
  /// The phone-key profile has no separate biometric key - the device key is
  /// the biometric factor - so it never needs this setup, and the account gate
  /// must not demand it.
  bool get needsBiometrics =>
      signedIn && !phoneKey && device?.biometricAlias == null;
  bool get needsVerification => device?.verificationFlow != null;
  bool get needsPassword =>
      session?.actions.contains('PasswordChangeRequired') ?? false;
  List<String> get blockingActions =>
      session?.actions
          .where(
            (a) =>
                a != 'PasswordChangeRequired' &&
                a != 'DeviceBindingNearingExpiration',
          )
          .toList() ??
      [];
  bool get canEnter =>
      signedIn &&
      !needsVerification &&
      !needsBiometrics &&
      !needsPassword &&
      blockingActions.isEmpty;

  /// Seconds left in the current session, for the DevTools inspector.
  int? get secondsRemaining {
    final s = session;
    if (s == null || !signedIn) return null;
    final wall = s.deadline.difference(now()).inSeconds;
    final monotonic =
        const Duration(minutes: 10).inSeconds -
        (_clock.elapsed - s.started).inSeconds;
    return wall < monotonic ? wall : monotonic;
  }

  void _emit() {
    if (!_disposed) notifyListeners();
  }

  // ---- lifecycle ------------------------------------------------------------

  Future<void> initialize() => run(() async {
    try {
      device = await storage.load();
      storageFailed = false;
      ready = true;
    } catch (_) {
      storageFailed = true;
      rethrow;
    }
  });

  void checkExpiry() {
    if (session != null && !signedIn) {
      session = null;
      profile = null;
      reauthenticationRequired = true;
      notice = null;
      _emit();
    }
  }

  /// Ends the session locally as if the ten minutes had passed. DevTools only;
  /// the UI has no button for it.
  void expireSessionNow() {
    if (session == null) return;
    session = null;
    profile = null;
    reauthenticationRequired = true;
    notice = null;
    _emit();
  }

  /// Forgets this installation's association and session. The device key and
  /// biometric key stay in the keystore (a customer alias is never reused, so
  /// they are simply orphaned). DevTools only.
  Future<void> resetLocalState() => run(() async {
    await storage.clearPending();
    device = null;
    session = null;
    profile = null;
    reauthenticationRequired = false;
    notice = const Notice.info(
      'This phone forgot the account. It is a new device now; add it again with a passkey or Health-ID.',
    );
  });

  Future<void> signOut() => run(() async {
    final old = session;
    session = null;
    profile = null;
    reauthenticationRequired = false;
    _emit();
    if (old != null) {
      await _bound('auth', 'logout', {'id': old.id, 'accessToken': old.token});
    }
    notice = const Notice.snack('Signed out');
  });

  @override
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    api.dio.close();
    healthId.dispose();
    transfer.dispose();
    super.dispose();
  }

  // ---- the run loop ---------------------------------------------------------

  Future<void> run(Future<void> Function() action) async {
    if (busy || _disposed) return;
    busy = true;
    notice = null;
    _lastAction = action;
    _newBindingSubmitted = false;
    _emit();
    try {
      await action();
    } on DioException catch (e) {
      // A definitive rejection of this new binding permits another attempt.
      // Timeouts/5xx are ambiguous: retain its key and association for login.
      if (_newBindingSubmitted &&
          device?.id == null &&
          [400, 403, 409, 422].contains(e.response?.statusCode)) {
        try {
          await storage.clearPending();
          device = null;
        } catch (_) {
          storageFailed = true;
          ready = false;
        }
      }
      // Never echo backend messages: they may contain submitted credentials.
      final data = e.response?.data;
      final code = data is Map ? '${data['error'] ?? ''}' : '';
      // The code only, never the message: DOA's text can quote what was
      // submitted. Codes are a fixed catalogue, and in a debug build they are
      // the difference between "that didn't work" and knowing which rule the
      // tenant failed. Never printed in a release build.
      if (kDebugMode) {
        debugPrint('doa rejected: ${e.response?.statusCode} ${code.isEmpty ? e.type.name : code}');
      }
      if (e.type == DioExceptionType.cancel) {
        notice = cancelledNotice;
      } else if (code.contains('DeviceBindingInvalidIntegrity') ||
          code.contains('AuthLoginIntegrityDataMissing')) {
        deviceCheck = DeviceCheckFailure.rejected;
        notice = const Notice.error(integrityRejectedMessage);
      } else if (code.contains('ChangePasswordLoginRequired')) {
        notice = const Notice.error(
          'Sign in again with biometrics, then change your password.',
          title: 'A recent sign-in is required',
        );
        session = null;
        profile = null;
        reauthenticationRequired = true;
      } else if (e.response?.statusCode == 401) {
        if (session != null) reauthenticationRequired = true;
        session = null;
        profile = null;
        notice = const Notice.error(
          'Your sign-in is no longer valid. Sign in again to continue.',
          title: 'Sign in again',
        );
      } else if (e.response == null) {
        notice = const Notice.error(
          'Check your connection and try again. Nothing was changed.',
          title: "Couldn't reach azuma",
          retry: true,
        );
      } else {
        notice = const Notice.error(
          'azuma rejected the request. Check your details and try again.',
          title: "That didn't work",
        );
      }
    } on HealthIdProviderUnavailable catch (_) {
      notice = const Notice.error(
        'This insurer could not start the sign-in. Choose another one, or use '
        'email or a passkey instead.',
        title: 'Try another insurer',
      );
    } on IntegrityUnavailable catch (_) {
      deviceCheck = DeviceCheckFailure.unavailable;
      notice = const Notice.error(integrityUnavailableMessage);
    } on PlatformException catch (e) {
      notice = isCancellation(e)
          ? cancelledNotice
          : e.code == 'passkey_rp_mismatch'
          ? const Notice.error(
              'This build of the app is not registered with the passkey '
              'domain, so the phone refuses to create or use one. Use email '
              'or Health-ID, or install a registered build.',
              title: "Passkeys aren't available in this build",
            )
          : e.code == 'passkey_no_credential'
          ? const Notice.info(
              'There is no passkey for azuma on this phone. Sign in another '
              'way, or add this phone with Health-ID.',
              title: 'No passkey found',
            )
          : const Notice.error(
              "Your phone didn't finish the request, so nothing was saved. "
              'Try again, or choose another way to sign in.',
              title: "Couldn't finish on this phone",
              retry: true,
            );
    } on CustomerIssue catch (e) {
      notice = Notice(e.tone, e.message, title: e.title);
    } catch (_) {
      notice = const Notice.error(
        'Something went wrong on this phone. Nothing was changed. Try again.',
        title: "That didn't work",
        retry: true,
      );
    } finally {
      // What the user is about to be told, in debug builds. The titles and
      // bodies are a fixed catalogue, so this says how an action ended without
      // saying anything about the person or what they typed.
      if (kDebugMode && notice != null) {
        debugPrint('outcome: ${notice!.tone.name} - ${notice!.title ?? notice!.body}');
      }
      // Before submission there is nothing to resume, e.g. Credential Manager
      // cancellation. Once attestation is persisted, keep the pending binding.
      if (_draft) {
        device = null;
        _draft = false;
      }
      busy = false;
      _emit();
    }
  }

  // ---- shared building blocks -----------------------------------------------

  Future<void> _save(CustomerDevice value) async {
    if (_disposed) {
      throw const CustomerIssue('The app was closed. Please sign in again.');
    }
    try {
      await storage.save(value);
    } catch (_) {
      ready = false;
      storageFailed = true;
      session = null;
      profile = null;
      rethrow;
    }
    if (_disposed) {
      throw const CustomerIssue('The app was closed. Please sign in again.');
    }
    device = value;
  }

  String _alias(String kind) =>
      'customer.$kind.${List.generate(24, (_) => Random.secure().nextInt(256).toRadixString(16).padLeft(2, '0')).join()}';

  Future<void> _capability() async {
    if (!await biometrics.canAuthenticate()) {
      throw const CustomerIssue(
        'This app requires strong biometrics. Enroll a fingerprint or supported face unlock in device settings, then retry.',
      );
    }
  }

  /// Device key attestation and a Play Integrity token, both over the same
  /// server challenge - the backend checks each against it. The token comes
  /// first: a device Play cannot vouch for is turned away before a key exists
  /// or a pending binding is persisted.
  Future<Map<String, dynamic>> _deviceProof(
    String alias,
    String challenge,
  ) async {
    // Android asks Play Integrity before a key exists, so a modified device is
    // turned away before anything is persisted. iOS has no equivalent call: its
    // attestation object carries that evidence, so there is nothing to fetch.
    final integrityToken = DeviceOs.isIos
        ? null
        : await integrity.requestToken(challenge);
    await api.keys.generateEcKeyPair(
      identifier: alias,
      challenge: challenge,
      // Variant C: the device key is the biometric factor, so the hardware
      // itself refuses to sign without a fresh authentication.
      biometricGated: phoneKey,
    );
    await _save(device!);
    _draft = false;
    _newBindingSubmitted = true;
    final hardwareKeyId = await api.keys.hardwareKeyId(alias);
    return {
      'deviceAttestation': (await api.keys.getDeviceAttestationsKey(
        alias,
      )).toJson(),
      'androidIntegrityToken': ?integrityToken,
      'iosHardwareKey': ?hardwareKeyId,
    };
  }

  /// Integrity data for a device-bound login, over that login's own challenge.
  /// It travels inside the payload, so the device key signs it too.
  /// The device-integrity evidence for a login. On iOS the request's own
  /// assertion is that evidence - DOA reads it from the envelope - so only the
  /// challenge it was made over travels here.
  Future<Map<String, dynamic>> _loginIntegrity(String challenge) async => {
    'challenge': challenge,
    if (!DeviceOs.isIos)
      'androidIntegrityToken': await integrity.requestToken(challenge),
  };

  /// Starts a new device association in memory. Nothing is persisted until
  /// `_deviceProof` has a key to record; until then a failure leaves no trace.
  Future<void> _newDevice({String? email, String? username}) async {
    if (!ready || storageFailed) {
      throw const CustomerIssue('Load device storage before continuing.');
    }
    if (device != null) {
      if (kDebugMode) {
        debugPrint('device: refusing a new binding, this phone already has one');
      }
      throw const CustomerIssue(
        'This installation already has an account or pending setup. Sign in to continue it.',
      );
    }
    await _capability();
    device = CustomerDevice(
      alias: _alias('device'),
      email: email,
      username: username,
    );
    _draft = true;
  }

  /// A request signed by this installation's device key.
  Future<Map<String, dynamic>> _bound(
    String area,
    String action,
    Map<String, dynamic> p,
  ) {
    if (device == null) {
      throw const CustomerIssue(
        'Sign in with Health-ID or passkey to add this device.',
      );
    }
    return api.post(area, action, p, alias: device!.alias);
  }

  CustomerSession _requireSession() {
    checkExpiry();
    if (!signedIn) throw const CustomerIssue('Please sign in with biometrics.');
    return session!;
  }

  /// A signed account request with `id` and `accessToken`, allowed only while
  /// the session that started it is still the current, valid one - checked
  /// before signing, after signing, and after the response.
  Future<Map<String, dynamic>> _account(
    String action,
    Map<String, dynamic> p,
  ) async {
    final current = _requireSession();
    final setupAction = action == 'link/biometrics' && !needsVerification;
    final passwordAction =
        action == 'changePassword' &&
        !needsBiometrics &&
        !needsVerification &&
        blockingActions.isEmpty;
    if (!canEnter && !setupAction && !passwordAction) {
      throw const CustomerIssue(
        'Complete the required account setup before continuing.',
      );
    }
    final result = await api.post(
      'account',
      action,
      {
        ...p,
        if (action != 'changePassword') 'id': current.id,
        'accessToken': current.token,
      },
      alias: device!.alias,
      authorize: () {
        if (!identical(session, current) || !signedIn || _disposed) {
          throw const CustomerIssue(
            'Your session ended. Please sign in again.',
          );
        }
      },
    );
    if (!identical(session, current) || !signedIn) {
      throw const CustomerIssue('Your session ended. Please sign in again.');
    }
    return result;
  }

  /// Every login and token-returning registration ends here.
  Future<void> _complete(
    Map<String, dynamic> response, {
    bool biometric = false,
  }) async {
    if (reauthenticationRequired && !biometric) {
      throw const CustomerIssue('Use biometrics to renew this session.');
    }
    final next = CustomerSession.fromResponse(response, now(), _clock.elapsed);
    if (device!.id != null && device!.id != next.id) {
      throw const CustomerIssue('This device belongs to a different account.');
    }
    await _save(device!.copy(id: next.id));
    // Never retain response.refreshToken, even if the server returns one.
    session = next;
    profile = null;
    reauthenticationRequired = false;
  }
}

/// A journey-specific outcome with fixed text; error tone unless said otherwise.
class CustomerIssue implements Exception {
  const CustomerIssue(this.message, {this.tone = NoticeTone.error, this.title});
  final String message;
  final NoticeTone tone;
  final String? title;
}
