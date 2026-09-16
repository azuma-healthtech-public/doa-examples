import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'health_id.dart' show validateHealthCallback;

/// The identity provider a user is leaving behind: variant A of
/// `examples/specifications/variants.md`. They sign in there once, DOA creates
/// an account for that identity, and the provider is never used again except as
/// a sign-in on this phone until a DOA-native method exists.
///
/// A plain OIDC authorization-code flow with PKCE, run in the system browser -
/// the same shape as the Health-ID hand-off and deliberately the same platform
/// channel, which is a generic "open this URL and give me the callback" service
/// rather than anything Health-ID specific.
///
/// **Which providers work today.** DOA validates tokens for `google` and
/// `apple` only (`account/register/{google,apple}`), against the tenant's
/// `GoogleOidcData` / `AppleOidcData`. A previous provider that is neither
/// needs generic per-tenant OIDC providers in DOA, with `registrationOnly` and
/// `AllowAddingNewDeviceOnlyOnRegistration` - a backend feature, and the reason
/// the spec calls the general case blocked. So `TRANSFER_DOA_PROVIDER` names
/// which DOA route accepts the token; the endpoints below are still read from
/// configuration, so a tenant that gains generic providers changes config only.
class TransferProvider {
  /// What the previous app is called, for the screens. Never a decision.
  static const providerName = String.fromEnvironment('TRANSFER_PROVIDER_NAME');
  static const authorization = String.fromEnvironment(
    'TRANSFER_AUTHORIZATION_URL',
  );
  static const tokenEndpoint = String.fromEnvironment('TRANSFER_TOKEN_URL');
  static const clientId = String.fromEnvironment('TRANSFER_CLIENT_ID');
  static const redirect = String.fromEnvironment('TRANSFER_REDIRECT_URI');

  /// `openid` is required; `email` is what lets the transferred account keep a
  /// DOA-native way in through the forgot-password flow. Nothing else is asked
  /// for - a scope the app does not consume is data it should not receive.
  static const scope = String.fromEnvironment(
    'TRANSFER_SCOPE',
    defaultValue: 'openid email',
  );

  /// The DOA route that validates the token: `google` or `apple` today.
  static const doaProvider = String.fromEnvironment(
    'TRANSFER_DOA_PROVIDER',
    defaultValue: 'google',
  );

  /// The generic browser hand-off, shared with Health-ID: `createProof`,
  /// `authorize(url, redirect)`, `cancel`. The channel matches the callback
  /// against the redirect handed to `authorize`, so two flows cannot be
  /// confused - but the platform only delivers a callback for a URL the app
  /// claims (Android: the App Link filter in the manifest; iOS: the associated
  /// domain and its `apple-app-site-association`).
  static const _channel = MethodChannel(
    'com.doa.example.devicebinding.flutter/health_id',
  );

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      followRedirects: false,
    ),
  );

  CancelToken? _activeCancellation;
  bool get active => _activeCancellation != null;

  /// Demo mode: the screens without a provider. Only a debuggable build with
  /// `TRANSFER_DEMO=true` has it - both halves are compile-time constants, so a
  /// release build folds the whole path away whatever its defines say. The
  /// hand-off becomes an in-app sheet that accepts anything typed, and the
  /// journey stops before DOA: no token is minted, because DOA validates
  /// provider tokens against the provider's own keys and would refuse it, and
  /// no record is written, because there is no account behind it.
  static const demo = kDebugMode && bool.fromEnvironment('TRANSFER_DEMO');

  /// Instance view of [demo], so a test fake can turn the demo path on.
  bool get demoMode => demo;

  bool get configured =>
      demoMode ||
      [authorization, tokenEndpoint, redirect].every(
            (s) =>
                Uri.tryParse(s)?.scheme == 'https' &&
                Uri.parse(s).host.isNotEmpty,
          ) &&
          clientId.isNotEmpty &&
          ['google', 'apple'].contains(doaProvider);

  /// The name to show. Never empty: a screen that says "your previous app" is
  /// honest, one that says "" is broken.
  String get name => providerName.isNotEmpty
      ? providerName
      : demoMode
      ? 'Demo provider'
      : 'your previous app';

  static void _step(String name) {
    if (kDebugMode) debugPrint('transfer: $name');
  }

  Future<TransferIdentity> authenticate() async {
    if (active) throw StateError('A transfer is already running');
    final cancellation = CancelToken();
    _activeCancellation = cancellation;
    try {
      return await _authenticate(cancellation);
    } finally {
      _activeCancellation = null;
    }
  }

  Future<Map<String, dynamic>> createProof() async {
    final proof = await _channel
        .invokeMapMethod<String, dynamic>('createProof')
        .timeout(const Duration(seconds: 10));
    for (final key in ['verifier', 'challenge', 'state', 'nonce']) {
      if (proof?[key] is! String) {
        throw StateError('The proof is missing "$key"');
      }
    }
    return proof!;
  }

  Future<TransferIdentity> _authenticate(CancelToken cancellation) async {
    if (!configured) throw StateError('Transfer configuration missing');
    _step('creating proof');
    final proof = await createProof();
    final base = Uri.parse(authorization);
    final auth = base.replace(
      queryParameters: {
        ...base.queryParameters,
        'client_id': clientId,
        'redirect_uri': redirect,
        'response_type': 'code',
        'scope': scope,
        'state': proof['state'] as String,
        'nonce': proof['nonce'] as String,
        'code_challenge': proof['challenge'] as String,
        'code_challenge_method': 'S256',
      },
    );
    _step('handing off to the previous provider');
    String? callback;
    try {
      callback = await _channel
          .invokeMethod<String>('authorize', {
            'url': auth.toString(),
            'redirect': redirect,
          })
          .timeout(const Duration(minutes: 3));
    } finally {
      await _channel
          .invokeMethod<void>('cancel')
          .timeout(const Duration(seconds: 10));
    }
    _step('callback received');
    final received = Uri.parse(callback!);
    // Same validation as the Health-ID callback: the redirect we registered,
    // our own `state`, exactly one code, no error, no fragment.
    validateHealthCallback(
      received,
      Uri.parse(redirect),
      proof['state'] as String,
    );
    _step('requesting the token');
    final tokens = await _dio.post<dynamic>(
      tokenEndpoint,
      cancelToken: cancellation,
      options: Options(contentType: Headers.formUrlEncodedContentType),
      data: {
        'grant_type': 'authorization_code',
        'client_id': clientId,
        'redirect_uri': redirect,
        'code': received.queryParameters['code'],
        'code_verifier': proof['verifier'],
      },
    );
    final token = (tokens.data as Map)['id_token'];
    if (token is! String || token.isEmpty) {
      throw StateError('No identity token');
    }
    final claims = _claims(token);
    if (claims['nonce'] != proof['nonce']) {
      _step('the token carries a different nonce');
      throw StateError('Invalid authorization nonce');
    }
    _step('identity in hand');
    // The claims are read only to show the user who came back. DOA is the
    // validating relying party; the app never treats them as authenticated.
    return TransferIdentity(
      token: token,
      email: claims['email'] is String ? claims['email'] as String : null,
      displayName: claims['name'] is String ? claims['name'] as String : null,
    );
  }

  static Map<String, dynamic> _claims(String token) {
    final parts = token.split('.');
    if (parts.length < 2) throw StateError('Malformed identity token');
    return jsonDecode(
          utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
        )
        as Map<String, dynamic>;
  }

  Future<void> cancel() async {
    _activeCancellation?.cancel();
    await _channel
        .invokeMethod<void>('cancel')
        .timeout(const Duration(seconds: 10));
  }

  void dispose() {
    _activeCancellation?.cancel();
    _dio.close();
  }
}

/// What came back from the previous provider, held only until the user
/// confirms or abandons the transfer on A2. The token never reaches storage,
/// the log or the screen.
class TransferIdentity {
  const TransferIdentity({
    required this.token,
    this.email,
    this.displayName,
    this.demo = false,
  });

  final String token;
  final String? email;
  final String? displayName;

  /// Made by the demo sheet, not by a provider. The journey accepts one only in
  /// demo mode and never sends it anywhere: the token is not a token.
  final bool demo;

  /// What A2 shows so the user can recognise themselves: the e-mail if the
  /// provider supplied one, otherwise the display name, otherwise nothing -
  /// in which case the screen says so rather than inventing a label.
  String? get label => email ?? displayName;
}
