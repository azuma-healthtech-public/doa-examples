import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_device_binding/src/core/health_id.dart';

/// The PKCE proof crosses a platform channel, and a channel hands a map back as
/// `Map<Object?, Object?>` no matter what the platform wrote. Asking for a typed
/// map compiles, passes every journey test - those replace `HealthId` with a
/// fake and never cross the boundary - and then throws on the first real phone.
/// This test speaks the channel's own encoding so that cannot happen again.
void main() {
  const channel = MethodChannel(
    'com.doa.example.devicebinding.flutter/health_id',
  );
  TestWidgetsFlutterBinding.ensureInitialized();
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  tearDown(() => messenger.setMockMethodCallHandler(channel, null));

  test('the proof survives the map a platform channel actually returns', () async {
    messenger.setMockMethodCallHandler(channel, (call) async {
      expect(call.method, 'createProof');
      // Deliberately untyped, as the channel's codec delivers it.
      final Map<Object?, Object?> raw = {
        'verifier': 'v',
        'challenge': 'c',
        'state': 's',
        'nonce': 'n',
      };
      return raw;
    });

    final proof = await HealthId().createProof();
    expect(proof['verifier'], 'v');
    expect(proof['challenge'], 'c');
    expect(proof['state'], 's');
    expect(proof['nonce'], 'n');
  });

  test('a proof missing a field is refused rather than half used', () async {
    messenger.setMockMethodCallHandler(channel, (call) async {
      final Map<Object?, Object?> raw = {'verifier': 'v', 'challenge': 'c'};
      return raw;
    });

    await expectLater(HealthId().createProof(), throwsStateError);
  });
}
