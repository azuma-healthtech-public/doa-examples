import 'dart:convert';

import '../core/secure_store.dart';

/// Identifiers only. Private keys remain in AndroidKeyStore; tokens/passwords
/// never enter this store. A single JSON write commits an association together.
class CustomerDevice {
  const CustomerDevice({
    required this.alias,
    this.id,
    this.email,
    this.biometricAlias,
    this.verificationFlow,
    this.transferredFrom,
    this.transferredAt,
    this.username,
  });
  final String alias;
  final String? id, email, biometricAlias, verificationFlow;

  /// Variant A only: the provider this account was brought over from, and when.
  /// A label and a date for the account screen - never an identity, never a
  /// token, and nothing is decided from either.
  final String? transferredFrom;
  final DateTime? transferredAt;

  /// Variant C only: the username the account was created with. Shown on the
  /// account screen and asked for again when adding another phone; never a
  /// secret, and the password is never stored beside it.
  final String? username;
  Map<String, dynamic> toJson() => {
    'alias': alias,
    'id': id,
    'email': email,
    'biometricAlias': biometricAlias,
    'verificationFlow': verificationFlow,
    'transferredFrom': transferredFrom,
    'transferredAt': transferredAt?.toIso8601String(),
    'username': username,
  };
  factory CustomerDevice.fromJson(Map<String, dynamic> j) => CustomerDevice(
    alias: j['alias'] as String,
    id: j['id'] as String?,
    email: j['email'] as String?,
    biometricAlias: j['biometricAlias'] as String?,
    verificationFlow: j['verificationFlow'] as String?,
    transferredFrom: j['transferredFrom'] as String?,
    transferredAt: j['transferredAt'] is String
        ? DateTime.tryParse(j['transferredAt'] as String)
        : null,
    username: j['username'] as String?,
  );
  CustomerDevice copy({
    String? id,
    String? biometricAlias,
    String? verificationFlow,
    String? transferredFrom,
    DateTime? transferredAt,
    String? username,
    bool verified = false,
    bool resetBiometrics = false,
  }) => CustomerDevice(
    alias: alias,
    id: id ?? this.id,
    email: email,
    biometricAlias: resetBiometrics
        ? null
        : biometricAlias ?? this.biometricAlias,
    verificationFlow: verified
        ? null
        : verificationFlow ?? this.verificationFlow,
    transferredFrom: transferredFrom ?? this.transferredFrom,
    transferredAt: transferredAt ?? this.transferredAt,
    username: username ?? this.username,
  );
}

/// The one record a scenario persists, in the native secure store, under a
/// per-scenario slot (`customerDevice.v1.<slot>`) so the flows on the Start
/// screen behave like separate installs. A record that cannot be decrypted
/// surfaces as an error and is never deleted, so [load] fails closed rather
/// than reporting a fresh install.
class CustomerStorage {
  static const String _prefix = 'customerDevice.v1';

  /// The key the customer scenario used before slots existed; read once as a
  /// fallback so an installed phone keeps its record.
  static const String _legacyKey = _prefix;

  /// The first write on a fresh install can wait for the RSA-4096 wrapping key,
  /// which the TEE takes seconds to generate on some devices.
  static const writeTimeout = Duration(seconds: 60);
  static const readTimeout = Duration(seconds: 15);

  CustomerStorage({
    this.store = const NativeSecureStore(),
    this.slot = 'customer',
  });

  final NativeSecureStore store;
  final String slot;
  String get _key => '$_prefix.$slot';
  Future<void> _pendingWrite = Future<void>.value();

  Future<CustomerDevice?> load() async {
    await _pendingWrite.catchError((Object _) {}).timeout(writeTimeout);
    var raw = await store.read(_key).timeout(readTimeout);
    if (raw == null && slot == 'customer') {
      raw = await store.read(_legacyKey).timeout(readTimeout);
    }
    return raw == null
        ? null
        : CustomerDevice.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> _write(Future<void> Function() action) {
    // A timeout does not cancel a platform write. Keep the original future in
    // the queue so a retry/read cannot race its late completion.
    _pendingWrite = _pendingWrite
        .catchError((Object _) {})
        .then((_) => action());
    return _pendingWrite.timeout(writeTimeout);
  }

  Future<void> save(CustomerDevice device) =>
      _write(() => store.write(_key, jsonEncode(device.toJson())));
  Future<void> clearPending() => _write(() async {
    await store.delete(_key);
    if (slot == 'customer') await store.delete(_legacyKey);
  });
}
