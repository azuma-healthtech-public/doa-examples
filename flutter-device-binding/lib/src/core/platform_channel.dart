import 'dart:async';

/// A platform call that never came back.
///
/// A `MethodChannel.Result` that is never completed leaves `invokeMethod`
/// pending forever — `invokeMethod` has no timeout of its own. Without a bound,
/// a channel that drops a call parks the calling controller on
/// `FlowState.busy`: spinner spinning, buttons disabled, no error and no way
/// out short of killing the app. The Kotlin example cannot show this, because
/// there the Activity owns both the crypto and the UI and they die together;
/// in Flutter the Dart side outlives the platform side.
class ChannelTimeoutException implements Exception {
  const ChannelTimeoutException(this.operation, this.limit);

  /// The channel method that did not answer, e.g. `sign`.
  final String operation;
  final Duration limit;

  String get message =>
      'The platform did not answer "$operation" within ${limit.inSeconds}s.';

  @override
  String toString() => message;
}

/// Bounds a platform call so a dropped result becomes a readable error.
extension ChannelCall<T> on Future<T> {
  Future<T> bounded(String operation, Duration limit) => timeout(
    limit,
    onTimeout: () => throw ChannelTimeoutException(operation, limit),
  );
}

/// Calls that run to completion without the user in the loop. Generous enough
/// that a cold keystore or a slow attestation never trips it.
const Duration kChannelTimeout = Duration(seconds: 30);

/// Calls that block on the user: a biometric prompt, or the Credential Manager
/// sheet. The bound exists only to catch an abandoned result, so it is far
/// longer than any real interaction — a user who walks away still gets a clean
/// error rather than a permanently stuck screen.
const Duration kInteractiveChannelTimeout = Duration(minutes: 3);
