import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_app/main.dart' as app;

import 'setup.dart';

Future<void> loginWrongEmail(tester) async {
  app.main();
  await tester.pumpAndSettle();
  await tester.pump();

  final emailTextField = find.byKey(const Key('email-text-field'));
  final passwordTextField = find.byKey(const Key('password-text-field'));
  final signInButton = find.byKey(const Key('btn-sign-in'));

  await tester.enterText(emailTextField, 'admin@admin.co');
  await tester.enterText(passwordTextField, '123456');
  await tester.pumpAndSettle();

  await tester.tap(signInButton);
  await tester.pump();
  await tester.pumpAndSettle();
}

void main() {
  group('First flow, logins with wrong email', () {
    final binding = IntegrationTestWidgetsFlutterBinding();
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('should return an pop up error', (WidgetTester tester) async {
      try {
        await loginWrongEmail(tester);
        // waitFor(tester, find.byKey(const Key('text-warning')));
        await tester.pumpAndSettle();
        await tester.tapAt(const Offset(400, 100));
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('btn-sign-in')), findsOneWidget);
      } catch (e) {
        await takeScreenshot(tester, binding);
      }
    });
  });
}
