import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_device_binding/src/app_config.dart';
import 'package:flutter_device_binding/src/core/device_bound_api.dart';
import 'package:flutter_device_binding/src/customer/customer_controller.dart';
import 'package:flutter_device_binding/src/customer/customer_storage.dart';

// The launcher harness, the session helper and the button finder.
import 'widget_test.dart' hide main;

/// Where sign-out, a password change and a cancelled transfer end up. The rule
/// is one rule: the root - the launcher here, since no PROFILE is pinned under
/// test - and a password change gets one screen of its own on the way there.

/// A backend that accepts everything, so a password change can succeed without
/// a device key to sign with or a network to reach.
class AcceptingApi extends DeviceBoundApi {
  @override
  Future<String> challenge(String kind) async => 'challenge';

  @override
  Future<Map<String, dynamic>> post(
    String area,
    String action,
    Map<String, dynamic> payload, {
    String? alias,
    void Function()? authorize,
  }) async {
    authorize?.call();
    return {};
  }
}

const bound = CustomerDevice(
  alias: 'device',
  id: 'account',
  email: 'maria.berger@example.org',
  biometricAlias: 'bio',
);

const emptyProfile = {
  'passkeyCredentials': <Object>[],
  'linkedAuthenticationMethods': <String>[],
};

void main() {
  testWidgets('signing out returns to the launcher', (tester) async {
    final controller = await pumpCustomerApp(
      tester,
      using: CustomerController(api: AcceptingApi(), storage: EmptyStore()),
    );
    controller.device = bound;
    controller.profile = emptyProfile;
    controller.session = session(DateTime.now(), valid: true);
    await controller.run(() async {});
    await tester.pumpAndSettle();
    expect(find.text('Account & security'), findsOneWidget);

    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();
    expect(find.text('DOA example flows'), findsOneWidget);
    expect(find.text('Account & security'), findsNothing);
    controller.dispose();
  });

  testWidgets('a changed password gets its own screen, then the welcome screen', (
    tester,
  ) async {
    final controller = await pumpCustomerApp(
      tester,
      using: CustomerController(api: AcceptingApi(), storage: EmptyStore()),
    );
    controller.device = bound;
    controller.profile = emptyProfile;
    controller.session = session(DateTime.now(), valid: true);
    await controller.run(() async {});
    await tester.pumpAndSettle();

    await tester.tap(find.text('Change password'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Current password'),
      'old-password',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'New password'),
      'new-password',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Confirm new password'),
      'new-password',
    );
    await tester.tap(filled('Save password'));
    await tester.pumpAndSettle();

    // 9b, not the sign-in screen with a banner on it.
    expect(find.text('Password changed'), findsOneWidget);
    expect(controller.signedIn, false);
    expect(find.text('Welcome back'), findsNothing);

    await tester.tap(filled('Continue'));
    await tester.pumpAndSettle();
    // The welcome screen of a bound phone is "Welcome back".
    expect(find.text('Welcome back'), findsOneWidget);
    controller.dispose();
  });

  testWidgets('leaving the transfer returns to the launcher', (tester) async {
    final controller = await pumpCustomerApp(tester);
    // Back to the launcher, then into the transfer's own tile.
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Account transfer'));
    await tester.pumpAndSettle();
    // The tile opens on A1, even unconfigured (A1 says so itself).
    expect(find.textContaining('Transfer your account from'), findsOneWidget);

    await tester.tap(find.text('Not now'));
    await tester.pumpAndSettle();
    expect(find.text('DOA example flows'), findsOneWidget);

    // And back from A1 does the same.
    await tester.tap(find.text('Account transfer'));
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('DOA example flows'), findsOneWidget);
    controller.dispose();
  });

  testWidgets('the safety guidance is one tap from the welcome screen, and back', (
    tester,
  ) async {
    final controller = await pumpCustomerApp(tester);
    expect(find.text('Your health data, secured by this phone'), findsOneWidget);

    await tester.tap(find.text('Keep your phone safe'));
    await tester.pumpAndSettle();
    expect(find.text('Keep your phone safe'), findsWidgets);
    expect(find.textContaining('Keep a screen lock'), findsOneWidget);

    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();
    expect(find.text('Your health data, secured by this phone'), findsOneWidget);
    controller.dispose();
  });

  testWidgets('a build that names no tenant stops before the flow', (tester) async {
    final controller = await pumpCustomerApp(
      tester,
      config: const RuntimeConfig(baseUrl: '', applicationId: ''),
    );
    expect(find.text('This build is not configured'), findsOneWidget);
    expect(find.text('Your health data, secured by this phone'), findsNothing);
    controller.dispose();
  });
}
