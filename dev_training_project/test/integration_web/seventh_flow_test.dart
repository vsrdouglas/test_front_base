import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_driver/flutter_driver.dart' as d;

import '../utils/db.setup.dart';
import 'setup.dart';
import 'fourth_flow.dart';

Future<void> assigmentUser(tester) async {
  await waitFor(tester, find.byKey(const Key('addMember-role')));
  await tester.enterText(find.byKey(const Key('addMember-role')), 'Dev Master');
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('start-date')));
  await tester.pumpAndSettle();
  await tester.tap(find.bySemanticsLabel('OK'));
  await tester.pumpAndSettle();
  await tester.tap(find.bySemanticsLabel('Confirm'));
}

void main() {
  group('Seventh Flow, ', () {
    final binding = IntegrationTestWidgetsFlutterBinding();
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('login teste a', (WidgetTester tester) async {
      try {
        await setupDB();

        await login(tester);
        await waitFor(tester, find.byIcon(Icons.person_add_alt));

        await tester.tap(find.byIcon(Icons.person_add_alt));

        await addUser(tester);

        await waitFor(tester, find.text('Employee Teste'));

        await tester.tap(find.byIcon(Icons.post_add_sharp));

        await tester.pumpAndSettle();

        await addProject(tester);

        await tester.pumpAndSettle();

        await tester.tap(find.text('Employee Teste'));

        await waitFor(tester, find.byKey(const Key('assigment-user')));

        await tester.tap(find.byKey(const Key('assigment-user')));

        await waitFor(tester, find.bySemanticsLabel('Project Teste'));

        await tester.tap(find.bySemanticsLabel('Project Teste'));

        await assigmentUser(tester);

        await waitFor(tester, find.text('Project Teste'));

        expect(find.text('Project Teste'), findsOneWidget);
      } catch (e) {
        await takeScreenshot(tester, binding);
      }
    });
  });
}
