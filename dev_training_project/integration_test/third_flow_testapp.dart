import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'db.setup.dart';
import 'setup.dart';

void main() {
  group('Third Flow App', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('third flow app', (WidgetTester tester) async {
      await setupDB();
      await tester.runAsync(() async {
        await login(tester);

        await navEmployee(tester);

        await waitFor(tester, find.byKey(const Key('add-user-button')));

        expect(find.byKey(const Key('add-user-button')), findsOneWidget);

        await tester.tap(find.byKey(const Key('add-user-button')));

        await addUser(tester);

        await waitForPump(tester, find.text('Employee Teste'));

        expect(find.text('Employee Teste'), findsOneWidget);

        await tester.tap(find.text('Employee Teste'));

        await waitFor(tester, find.byIcon(Icons.edit).first);

        await tester.tap(find.byIcon(Icons.edit).first);

        await tester.pumpAndSettle();

        await tester.enterText(
            find.byKey(const Key('fieldEdit')), 'Employee Teste Edited');

        await tester.tap(find.text('Confirm'));

        await waitFor(tester, find.bySemanticsLabel('Employee Teste Edited'));

        expect(find.bySemanticsLabel('Employee Teste Edited'), findsOneWidget);
      });
    });
  });
}
