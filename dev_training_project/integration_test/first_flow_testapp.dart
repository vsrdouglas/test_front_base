import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_app/main.dart' as app;

import 'setup.dart';

Future<void> loginWrongEmail(tester) async {
  app.main();
  await tester.pumpAndSettle();

  final emailTextField = find.byKey(const Key('email-text-field'));
  final passwordTextField = find.byKey(const Key('password-text-field'));
  final signInButton = find.byKey(const Key('btn-sign-in'));

  await tester.enterText(emailTextField, 'admin@admin.co');
  await tester.enterText(passwordTextField, '123456');
  await tester.pumpAndSettle();

  await tester.tap(signInButton);
  await waitFor(tester, find.byKey(const Key('warning-popup')));
}

Future<void> loginWrongPassword(tester) async {
  app.main();
  await tester.pumpAndSettle();

  final emailTextField = find.byKey(const Key('email-text-field'));
  final passwordTextField = find.byKey(const Key('password-text-field'));
  final signInButton = find.byKey(const Key('btn-sign-in'));

  await tester.enterText(emailTextField, 'admin@admin.com');
  await tester.enterText(passwordTextField, '12345');
  await tester.pumpAndSettle();

  await tester.tap(signInButton);
  await tester.pump();
  await tester.pumpAndSettle();
}

void main() {
  group('First flow, logins with wrong email', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('should return an pop up error', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await loginWrongEmail(tester);
        expect(find.byKey(const Key('warning-popup')), findsOneWidget);
      });
    });
  });

  // group('First flow, logins with wrong password', () {
  //   final binding = IntegrationTestWidgetsFlutterBinding();
  //   IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  //   testWidgets('should return an pop up error', (WidgetTester tester) async {
  //     try {
  //       await tester.runAsync(() async {
  //         await loginWrongPassword(tester);
  //       });
  //       expect(find.byKey(const Key('warning-popup')), findsOneWidget);
  //     } catch (e) {
  //       await takeScreenshot(tester, binding);
  //     }
  //   });
  // });
}
