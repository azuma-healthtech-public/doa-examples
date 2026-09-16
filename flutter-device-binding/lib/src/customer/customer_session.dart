import 'dart:convert';

/// Local upper bound in addition to backend expiration. Never a sliding timer.
class CustomerSession {
  CustomerSession({
    required this.token,
    required this.id,
    required this.deadline,
    required this.started,
    required this.actions,
  });
  final String token, id;
  final DateTime deadline;
  final Duration started;
  final List<String> actions;
  bool valid(DateTime now, Duration elapsed) =>
      now.isBefore(deadline) && elapsed - started < const Duration(minutes: 10);

  factory CustomerSession.fromResponse(
    Map<String, dynamic> response,
    DateTime now,
    Duration elapsed,
  ) {
    final token = response['accessToken'] as String;
    final claims = jsonDecode(
      utf8.decode(base64Url.decode(base64Url.normalize(token.split('.')[1]))),
    ) as Map<String, dynamic>;
    final id = claims['sub'] as String;
    final exp = DateTime.fromMillisecondsSinceEpoch(
      (claims['exp'] as num).toInt() * 1000,
    );
    var deadline = now.add(const Duration(minutes: 10));
    if (exp.isBefore(deadline)) deadline = exp;
    final expiresIn = response['expiresIn'];
    if (expiresIn is num) {
      final advertised = now.add(Duration(seconds: expiresIn.toInt()));
      if (advertised.isBefore(deadline)) deadline = advertised;
    }
    if (!deadline.isAfter(now) || id.isEmpty) {
      throw StateError('Expired login response');
    }
    // Claims set a conservative local deadline, not a trust decision. DOA
    // validates the token and device signature on every authenticated request.
    return CustomerSession(
      token: token,
      id: id,
      deadline: deadline,
      started: elapsed,
      actions: [
        for (final a in response['postLoginActions'] as List? ?? [])
          ((a as Map)['actionType'] as String?) ?? 'Unknown',
      ],
    );
  }
}
