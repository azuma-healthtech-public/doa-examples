import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_device_binding/src/app.dart';
import 'package:flutter_device_binding/src/app_config.dart';
import 'package:flutter_device_binding/src/customer/customer_controller.dart';
import 'package:flutter_device_binding/src/customer/customer_session.dart';
import 'package:flutter_device_binding/src/customer/customer_storage.dart';
import 'package:flutter_device_binding/src/customer/notice.dart';
import 'package:flutter_device_binding/src/customer/views/provider_picker.dart';
import 'package:flutter_device_binding/src/core/biometric_binding.dart';
import 'package:flutter_device_binding/src/core/health_id.dart';
import 'package:flutter_device_binding/src/theme/app_theme.dart';
import 'package:flutter_device_binding/src/customer/scenario.dart';
import 'package:flutter_device_binding/src/customer/widgets/widgets.dart';

/// The broker directory, as three entries: one private insurer, two statutory.
/// `hold` keeps `authenticate` pending so a test can look at the hand-off.
class FakeHealth extends HealthId {
  FakeHealth({this.failFirstLoad = false});
  bool failFirstLoad;
  bool _active = false;
  final hold = Completer<void>();

  @override
  bool get configured => true;
  @override
  bool get active => _active;

  @override
  Future<List<HealthIdProvider>> providers() async {
    if (failFirstLoad) {
      failFirstLoad = false;
      throw StateError('directory unreachable');
    }
    return const [
      HealthIdProvider(
        issuer: 'https://idp.example.org/allianz',
        name: 'Allianz Private Krankenversicherung',
        privateInsurance: true,
      ),
      HealthIdProvider(
        issuer: 'https://idp.example.org/axa',
        name: 'AXA',
        privateInsurance: false,
      ),
      HealthIdProvider(
        issuer: 'https://idp.example.org/barmer',
        name: 'BARMER',
        privateInsurance: false,
      ),
    ];
  }

  @override
  Future<String> authenticate(String provider) async {
    _active = true;
    await hold.future;
    _active = false;
    return 'token';
  }
}

class AlwaysCapableBiometrics extends BiometricBinding {
  @override
  Future<bool> canAuthenticate() async => true;
}

class EmptyStore extends CustomerStorage {
  EmptyStore() : super(slot: 'test');
  @override
  Future<CustomerDevice?> load() async => null;
  @override
  Future<void> save(CustomerDevice device) async {}
}

CustomerSession session(DateTime now, {required bool valid}) => CustomerSession(
  token: 'token',
  id: 'account',
  deadline: valid
      ? now.add(const Duration(minutes: 10))
      : now.subtract(const Duration(seconds: 1)),
  started: Duration.zero,
  actions: [],
);

/// Pumps the app, and - since no PROFILE is pinned under test - opens the
/// customer flow from the Start launcher, which is itself under test here.
Future<CustomerController> pumpCustomerApp(
  WidgetTester tester, {
  CustomerController? using,
  // A test build has no defines, and the gate refuses to run a build that
  // names no tenant; the screens under test are the ones behind that gate.
  RuntimeConfig config = const RuntimeConfig(
    baseUrl: 'https://doa.example.test/api/organization',
    applicationId: 'application-under-test',
  ),
}) async {
  // A tall phone, so the hero screens' primary actions are laid out.
  tester.view.physicalSize = const Size(430, 1400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final controller = using ?? CustomerController(storage: EmptyStore());
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        customerProvider.overrideWithValue(controller),
        runtimeConfigProvider.overrideWithValue(config),
      ],
      child: const DeviceBindingApp(),
    ),
  );
  await tester.pumpAndSettle();
  expect(find.text('DOA example flows'), findsOneWidget);
  expect(find.text('Account transfer'), findsOneWidget);
  await tester.tap(find.text(Scenario.customer.title));
  await tester.pumpAndSettle();
  return controller;
}

/// `FilledButton.icon` builds a private subclass, so match by `is`.
Finder filled(String label) => find.ancestor(
  of: find.text(label),
  matching: find.byWidgetPredicate((w) => w is FilledButton),
);

void main() {
  testWidgets('the launcher lists every scenario and opens the one that is tapped', (
    tester,
  ) async {
    final controller = await pumpCustomerApp(tester);
    expect(find.text('Your health data, secured by this phone'), findsOneWidget);
    expect(filled('Create account'), findsOneWidget);
    expect(find.widgetWithText(OutlinedButton, 'Sign in'), findsOneWidget);
    controller.dispose();
  });

  testWidgets('a fresh install can only add itself with passkey or Health-ID', (
    tester,
  ) async {
    final controller = await pumpCustomerApp(tester);
    await tester.tap(find.widgetWithText(OutlinedButton, 'Sign in'));
    await tester.pumpAndSettle();
    expect(find.text('Add this phone to your account'), findsOneWidget);
    expect(find.text('Passkey'), findsOneWidget);
    expect(find.text('Health-ID'), findsOneWidget);
    expect(find.text('Email and password'), findsNothing);
    expect(find.text('Sign in with biometrics'), findsNothing);
    controller.dispose();
  });

  testWidgets('create account offers three methods and email needs consent', (
    tester,
  ) async {
    final controller = await pumpCustomerApp(tester);
    await tester.tap(filled('Create account'));
    await tester.pumpAndSettle();
    expect(find.text('How do you want to sign in?'), findsOneWidget);
    expect(find.text('Email and password'), findsOneWidget);
    expect(find.text('Passkey'), findsOneWidget);
    expect(find.text('Health-ID'), findsOneWidget);
    await tester.tap(find.text('Email and password'));
    await tester.pumpAndSettle();
    final create = filled('Create account');
    expect(tester.widget<FilledButton>(create).onPressed, isNull);
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    expect(tester.widget<FilledButton>(create).onPressed, isNotNull);
    controller.dispose();
  });

  testWidgets(
    'mandatory biometrics gate the account, and an ended session locks the app',
    (tester) async {
      final now = DateTime.now();
      final controller = await pumpCustomerApp(tester);
      controller.device = const CustomerDevice(
        alias: 'device',
        id: 'account',
        email: 'a@example.org',
      );
      controller.session = session(now, valid: true);
      await controller.run(() async {});
      await tester.pumpAndSettle();
      expect(find.text('Set up biometric sign-in'), findsOneWidget);
      expect(filled('Enable biometrics'), findsOneWidget);
      expect(find.text("This step can't be skipped."), findsOneWidget);
      expect(find.text('Account & security'), findsNothing);

      controller.session = session(now, valid: false);
      controller.checkExpiry();
      await tester.pumpAndSettle();
      expect(find.text('Session ended'), findsOneWidget);
      expect(find.text('Unlock with biometrics'), findsOneWidget);
      expect(find.text('Email and password'), findsNothing);
      expect(find.text('Account & security'), findsNothing);
      controller.dispose();
    },
  );

  testWidgets('a linked phone leads with biometrics and shows the countdown once in', (
    tester,
  ) async {
    final now = DateTime.now();
    final controller = await pumpCustomerApp(tester);
    controller.device = const CustomerDevice(
      alias: 'device',
      id: 'account',
      email: 'maria.berger@example.org',
      biometricAlias: 'bio',
    );
    await controller.run(() async {});
    await tester.pumpAndSettle();
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('m•••••@example.org'), findsOneWidget);
    expect(find.text('Sign in with biometrics'), findsOneWidget);
    expect(find.text('Email and password'), findsOneWidget);

    // A loaded profile keeps the screen from fetching one over the network.
    controller.profile = {
      'passkeyCredentials': <Object>[],
      'linkedAuthenticationMethods': <String>[],
    };
    controller.session = session(now, valid: true);
    await controller.run(() async {});
    await tester.pump();
    expect(find.text('Account & security'), findsOneWidget);
    expect(find.text('Change password'), findsOneWidget);
    expect(find.textContaining(':'), findsWidgets);
    expect(find.text('Sign out'), findsOneWidget);
    controller.dispose();
  });

  testWidgets('an action outcome is a banner at the top, above what the user tried', (
    tester,
  ) async {
    final controller = await pumpCustomerApp(tester);
    await tester.tap(filled('Create account'));
    await tester.pumpAndSettle();
    await controller.run(() async {
      controller.notice = const Notice.error(
        'Nothing was saved.',
        title: "Couldn't finish on this phone",
        retry: true,
      );
    });
    await tester.pumpAndSettle();
    final banner = find.text("Couldn't finish on this phone");
    expect(banner, findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
    expect(
      tester.getTopLeft(banner).dy,
      lessThan(tester.getTopLeft(find.text('How do you want to sign in?')).dy),
    );
    controller.dispose();
  });

  testWidgets('passkey registration asks for the account name on its own screen', (
    tester,
  ) async {
    final controller = await pumpCustomerApp(tester);
    await tester.tap(filled('Create account'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Passkey'));
    await tester.pumpAndSettle();
    expect(find.text('Name your account'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
    await tester.tap(filled('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Enter a name for your account'), findsOneWidget);
    expect(controller.device, isNull);
    controller.dispose();
  });

  testWidgets('a notice does not follow the user to the next screen', (
    tester,
  ) async {
    final controller = await pumpCustomerApp(tester);
    await tester.tap(filled('Create account'));
    await tester.pumpAndSettle();
    await controller.run(() async {
      controller.notice = const Notice.error(
        'Nothing was saved.',
        title: "Couldn't finish on this phone",
      );
    });
    await tester.pumpAndSettle();
    expect(find.text("Couldn't finish on this phone"), findsOneWidget);

    // Back to the welcome screen: the failure belonged to the screen behind us.
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Your health data, secured by this phone'), findsOneWidget);
    expect(find.text("Couldn't finish on this phone"), findsNothing);
    expect(controller.notice, isNull);
    controller.dispose();
  });

  testWidgets('validation is a field error, never a banner', (tester) async {
    final controller = await pumpCustomerApp(tester);
    await tester.tap(filled('Create account'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Email and password'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextField, 'Email address'), 'maria@example');
    await tester.enterText(find.widgetWithText(TextField, 'Password'), 'correct horse');
    await tester.enterText(find.widgetWithText(TextField, 'Confirm password'), 'correct hors');
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    await tester.tap(filled('Create account'));
    await tester.pumpAndSettle();
    expect(find.text('Enter an address like name@example.org'), findsOneWidget);
    expect(find.text("The passwords don't match"), findsOneWidget);
    expect(find.byType(NoticeBanner), findsNothing);
    expect(controller.notice, isNull);
    controller.dispose();
  });

  testWidgets('an account without a password is offered no password change', (
    tester,
  ) async {
    final now = DateTime.now();
    final controller = await pumpCustomerApp(tester);
    // Registered with a passkey: this installation knows no email, so there is
    // no password behind the account.
    controller.device = const CustomerDevice(
      alias: 'device',
      id: 'account',
      biometricAlias: 'bio',
    );
    controller.profile = {
      'passkeyCredentials': <Object>[],
      'linkedAuthenticationMethods': <String>[],
    };
    controller.session = session(now, valid: true);
    await controller.run(() async {});
    await tester.pumpAndSettle();

    expect(find.text('Account & security'), findsOneWidget);
    expect(find.text('Change password'), findsNothing);
    expect(find.text('Sign out'), findsOneWidget);
    controller.dispose();
  });

  testWidgets('back from a flow returns to the launcher rather than leaving the app', (
    tester,
  ) async {
    final controller = await pumpCustomerApp(tester);
    expect(find.text('Your health data, secured by this phone'), findsOneWidget);

    // Deeper in first: back walks the entry steps before it leaves the flow.
    await tester.tap(filled('Create account'));
    await tester.pumpAndSettle();
    expect(find.text('How do you want to sign in?'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Your health data, secured by this phone'), findsOneWidget);

    // And from the first screen of the flow, back to the list of flows.
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('DOA example flows'), findsOneWidget);
    controller.dispose();
  });

  testWidgets('the insurer picker lists the directory, filters it and returns a choice', (
    tester,
  ) async {
    HealthIdProvider? picked;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () async {
                picked = await pickHealthIdProvider(context, FakeHealth());
              },
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Choose your insurer'), findsOneWidget);
    expect(find.text('BARMER'), findsOneWidget);
    // Only the private insurer carries the marking.
    expect(find.text('Private health insurance'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextField, 'Search'), 'barm');
    await tester.pumpAndSettle();
    expect(find.text('BARMER'), findsOneWidget);
    expect(find.text('AXA'), findsNothing);

    await tester.tap(find.text('BARMER'));
    await tester.pumpAndSettle();
    expect(picked!.issuer, 'https://idp.example.org/barmer');
    expect(find.text('Choose your insurer'), findsNothing);
  });

  testWidgets('an unreachable directory offers a retry rather than an empty list', (
    tester,
  ) async {
    final health = FakeHealth(failFirstLoad: true);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => pickHealthIdProvider(context, health),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text("Couldn't reach the directory"), findsOneWidget);
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.text('BARMER'), findsOneWidget);
  });

  testWidgets('the hand-off names the insurer and can always be cancelled', (
    tester,
  ) async {
    final health = FakeHealth();
    final controller = CustomerController(
      storage: EmptyStore(),
      healthId: health,
      biometrics: AlwaysCapableBiometrics(),
    );
    await pumpCustomerApp(tester, using: controller);
    await tester.tap(filled('Create account'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Health-ID'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('BARMER'));
    // Not pumpAndSettle: the hand-off runs an indeterminate progress bar, so
    // the tree never settles while the insurer has the foreground.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // The browser is in front; this is the screen behind it.
    expect(find.textContaining('BARMER is taking over'), findsOneWidget);
    expect(find.text('Cancel Health-ID sign-in'), findsOneWidget);
    expect(
      find.textContaining('Nothing is saved until you come back'),
      findsOneWidget,
    );
    // The method tile carries the insurer while the hand-off runs.
    expect(find.text('BARMER'), findsOneWidget);

    // Left pending on purpose: completing it would carry on into the network,
    // and the state under test is the one the user sees while waiting.
    controller.dispose();
  });
}
