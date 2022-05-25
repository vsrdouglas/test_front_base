import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../utils/db.setup.dart';
import 'setup.dart';

void main() {
  group('Second Flow, ', () {
    final binding = IntegrationTestWidgetsFlutterBinding();
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('second flow', (WidgetTester tester) async {
      try {
        await setupDB();
        await tester.runAsync(() async {
          await login(tester);
          await tester.tap(find.byIcon(Icons.person_add_alt));
          await addUser(tester);
          await waitFor(tester, find.text('Employee Teste'));
          await tester.tap(find.text('Employee Teste'), warnIfMissed: false);
          await tester.pumpAndSettle();
        });
        expect(find.bySemanticsLabel('Employee Teste'), findsOneWidget);
      } catch (e) {
        await takeScreenshot(tester, binding);
      }
    });
  });
}
