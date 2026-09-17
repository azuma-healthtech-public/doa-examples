import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Configuration belongs to the integrator's Health-ID broker registration.
/// No Mimoto demo client IDs, embedded secrets, or pasted identity tokens.
class HealthId {
  static const authorization = String.fromEnvironment(
    'HEALTH_ID_AUTHORIZATION_URL',
    defaultValue: 'https://mimoto-ref.pie.azuma-health.tech/connect/auth',
  );
  static const tokenEndpoint = String.fromEnvironment(
    'HEALTH_ID_TOKEN_URL',
    defaultValue: 'https://mimoto-ref.pie.azuma-health.tech/connect/token',
  );
  static const exchangeEndpoint = String.fromEnvironment(
    'HEALTH_ID_EXCHANGE_URL',
    defaultValue:
        'https://mimoto-ref.pie.azuma-health.tech/oidcf/exchange/mobile',
  );
  static const clientId = String.fromEnvironment(
    'HEALTH_ID_CLIENT_ID',
    defaultValue: 'd0fe4fb5-ab2a-4ff4-bba4-91853071c3ce',
  );

  /// The broker's directory of identity providers, and the relying party whose
  /// list to ask for. The user picks one; there is no provider pinned into the
  /// build, because which insurer a person belongs to is not a build decision.
  static const idpListUrl = String.fromEnvironment(
    'HEALTH_ID_IDP_LIST_URL',
    defaultValue: 'https://mimoto-ref.pie.azuma-health.tech/api/v1/idps',
  );
  static const relyingPartyId = String.fromEnvironment(
    'HEALTH_ID_RELYING_PARTY_ID',
    defaultValue: 'c36eb4fa-0f55-46f2-8e69-e52ff6013022',
  );
  static const redirect = String.fromEnvironment(
    'HEALTH_ID_REDIRECT_URI',
    defaultValue: 'https://mimoto-example-app.azuma-health.tech/rn-ce/code/ce',
  );
  static const launchScheme = String.fromEnvironment(
    'HEALTH_ID_AUTHENTICATOR_SCHEME',
    defaultValue: 'https',
  );
  static const exchangeViaRedirect = bool.fromEnvironment(
    'HEALTH_ID_EXCHANGE_VIA_REDIRECT',
    defaultValue: true,
  );
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
  bool get configured =>
      [
        authorization,
        tokenEndpoint,
        exchangeEndpoint,
        redirect,
        idpListUrl,
      ].every(
        (s) =>
            Uri.tryParse(s)?.scheme == 'https' && Uri.parse(s).host.isNotEmpty,
      ) &&
      clientId.isNotEmpty &&
      relyingPartyId.isNotEmpty;

  /// The providers this relying party may use. Read-only and public: no
  /// challenge, no token, nothing about the user leaves the phone. Fetched when
  /// the picker opens, not at start-up, and never cached to disk - the list
  /// changes on the broker's side and a stale entry sends the user to an
  /// identity provider that no longer federates.
  Future<List<HealthIdProvider>> providers() async {
    if (!configured) throw StateError('Health-ID configuration missing');
    final response = await _dio.get<dynamic>(
      idpListUrl,
      queryParameters: {'relayingPartyId': relyingPartyId},
      options: Options(responseType: ResponseType.json),
    );
    final entries = response.data;
    if (entries is! List) throw StateError('Unexpected provider list');
    final list = <HealthIdProvider>[];
    for (final entry in entries) {
      if (entry is! Map) continue;
      final issuer = '${entry['issuer'] ?? ''}';
      final name = '${entry['organizationName'] ?? ''}';
      // A provider the phone cannot reach over https, or one with no name to
      // show, is not offered rather than shown as a broken row.
      if (Uri.tryParse(issuer)?.scheme != 'https' || name.isEmpty) continue;
      list.add(
        HealthIdProvider(
          issuer: issuer,
          name: name,
          privateInsurance: entry['pkv'] == true,
        ),
      );
    }
    list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return list;
  }

  Future<String> authenticate(String provider) async {
    if (active) throw StateError('Authentication already running');
    if (Uri.tryParse(provider)?.scheme != 'https') {
      throw StateError('Provider must be an https issuer');
    }
    final cancellation = CancelToken();
    _activeCancellation = cancellation;
    try {
      return await _authenticate(provider, cancellation);
    } finally {
      _activeCancellation = null;
    }
  }

  /// Names the step that is about to run, in debug builds only. No value ever
  /// reaches it - not the provider, not a token, not a callback - so it says
  /// where a flow stopped without saying anything about the person using it.
  /// Release builds fold this away with `kDebugMode`.
  static void _step(String name) {
    if (kDebugMode) debugPrint('health-id: $name');
  }

  /// PKCE verifier and challenge, `state` and `nonce`, all from the platform's
  /// CSPRNG.
  ///
  /// `invokeMapMethod` rather than `invokeMethod<Map<String, dynamic>>`: a
  /// channel hands a map back as `Map<Object?, Object?>` whatever the platform
  /// wrote, so asking for a typed map throws on every real device while the
  /// journey tests, which replace this class wholesale, never notice.
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

  Future<String> _authenticate(
    String provider,
    CancelToken cancellation,
  ) async {
    if (!configured) throw StateError('Health-ID configuration missing');
    _step('creating proof');
    final proof = await createProof();
    final auth = Uri.parse(authorization).replace(
      queryParameters: {
        ...Uri.parse(authorization).queryParameters,
        'client_id': clientId,
        'redirect_uri': redirect,
        'response_type': 'code',
        // Only the insured-person scope: it carries the KVNR claim DOA reads.
        // The email scope is deliberately not requested - nothing consumes it.
        'scope': 'openid urn:telematik:versicherter',
        'provider': provider,
        'state': proof['state'] as String,
        'nonce': proof['nonce'] as String,
        'code_challenge': proof['challenge'] as String,
        'code_challenge_method': 'S256',
        'response_format': 'json',
      },
    );
    // The broker answers for the chosen provider, and providers differ: one
    // federated through gematik refuses a relying party whose registration the
    // federation has not picked up, while a directly registered one accepts it.
    // That is about the provider, not about the user's input, so it gets its
    // own failure and the caller can say "try another insurer".
    final Response<dynamic> response;
    _step('asking the broker for an authorization url');
    try {
      response = await _dio.getUri<dynamic>(auth, cancelToken: cancellation);
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) rethrow;
      _step('the broker refused this provider (${e.response?.statusCode})');
      throw const HealthIdProviderUnavailable();
    }
    final data = response.data;
    if (data is! Map || data['url'] is! String) {
      throw const HealthIdProviderUnavailable();
    }
    final launch = Uri.parse(data['url'] as String);
    if (launch.scheme != launchScheme ||
        launch.userInfo.isNotEmpty ||
        !['https', launchScheme].contains(launch.scheme) ||
        [
          'http',
          'intent',
          'file',
          'javascript',
          'content',
        ].contains(launch.scheme)) {
      throw StateError('Unexpected authenticator URL');
    }
    String? callback;
    try {
      callback = await _channel
          .invokeMethod<String>('authorize', {
            'url': launch.toString(),
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
    final expected = Uri.parse(redirect);
    if (received.scheme != expected.scheme ||
        received.host != expected.host ||
        received.port != expected.port ||
        received.path != expected.path ||
        received.fragment.isNotEmpty) {
      _step('the callback does not match the redirect we registered');
      throw StateError('Unexpected callback');
    }
    _step('exchanging the callback');
    final exchange = await _dio.post<dynamic>(
      exchangeEndpoint,
      cancelToken: cancellation,
      data: {
        'clientId': clientId,
        if (exchangeViaRedirect)
          'redirectUrl': received.toString()
        else ...{
          'code': received.queryParameters['code'],
          'state': received.queryParameters['state'],
        },
      },
    );
    final result = Uri.parse((exchange.data as Map)['redirectUrl'] as String);
    // Validate the broker's final OAuth response, not just its outer deep link.
    validateHealthCallback(result, expected, proof['state'] as String);
    _step('requesting the token');
    final tokens = await _dio.post<dynamic>(
      tokenEndpoint,
      cancelToken: cancellation,
      options: Options(contentType: Headers.formUrlEncodedContentType),
      data: {
        'grant_type': 'authorization_code',
        'client_id': clientId,
        'redirect_uri': redirect,
        'code': result.queryParameters['code'],
        'code_verifier': proof['verifier'],
      },
    );
    final token = (tokens.data as Map)['id_token'];
    if (token is! String || token.isEmpty) {
      throw StateError('No identity token');
    }
    final claims = jsonDecode(
      utf8.decode(base64Url.decode(base64Url.normalize(token.split('.')[1]))),
    ) as Map<String, dynamic>;
    if (claims['nonce'] != proof['nonce']) {
      _step('the token carries a different nonce');
      throw StateError('Invalid authorization nonce');
    }
    _step('identity token in hand');
    // DOA is the validating relying party for this token. The app never treats
    // unverified claims as an authenticated account.
    return token;
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

void validateHealthCallback(Uri result, Uri expected, String state) {
  if (result.scheme != expected.scheme ||
      result.host != expected.host ||
      result.port != expected.port ||
      result.path != expected.path ||
      result.userInfo.isNotEmpty ||
      result.fragment.isNotEmpty ||
      result.queryParametersAll['state']?.length != 1 ||
      result.queryParameters['state'] != state ||
      result.queryParameters.containsKey('error') ||
      result.queryParametersAll['code']?.length != 1 ||
      result.queryParameters['code']!.isEmpty) {
    throw StateError('Invalid authorization response');
  }
}

/// One identity provider from the broker's directory: the insurer the user
/// picks before the hand-off.
class HealthIdProvider {
  const HealthIdProvider({
    required this.issuer,
    required this.name,
    required this.privateInsurance,
  });

  /// The value sent as `provider` in the authorization request.
  final String issuer;
  final String name;
  final bool privateInsurance;
}

/// The broker would not start a sign-in with the chosen provider. Everything
/// else about the configuration can be right: a provider federated through
/// gematik resolves the relying party through the federation, so it refuses one
/// whose redirect URI the federation has not published yet.
class HealthIdProviderUnavailable implements Exception {
  const HealthIdProviderUnavailable();
}
