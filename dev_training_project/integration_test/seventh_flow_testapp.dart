import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'db.setup.dart';
import 'setup.dart';
import 'fourth_flow_app.dart';

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
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('seventh app', (WidgetTester tester) async {
      await setupDB();

      await tester.runAsync(() async {
        await login(tester);

        await tester.tap(find.byIcon(Icons.person_add_alt));

        await addUser(tester);

        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.post_add_sharp));

        await tester.pumpAndSettle();

        await addProject(tester);

        await tester.pumpAndSettle();

        await tester.tap(find.text('List of Unallocated Employees'));

        await tester.pumpAndSettle();

        await waitForNot(tester, find.byType(SnackBar));

        await tester.ensureVisible(find.text('Employee Teste'));

        await tester.tap(find.text('Employee Teste'));

        await waitFor(tester, find.text('Employee Teste').first);

        final scrollableFinder = find.descendant(
          of: find.byType(ListView),
          matching: find.byType(Scrollable),
        );

        await tester.scrollUntilVisible(
            find.byKey(const Key('assigment-user')), 200.0,
            scrollable: scrollableFinder);

        await tester.pumpAndSettle();

        expect(find.byKey(const Key('assigment-user')), findsOneWidget);

        await tester.tap(find.byKey(const Key('assigment-user')));

        await waitFor(tester, find.bySemanticsLabel('Project Teste'));

        await tester.tap(find.bySemanticsLabel('Project Teste'));

        await assigmentUser(tester);

        await waitFor(tester, find.text('Project Teste'));

        expect(find.text('Project Teste'), findsOneWidget);
      });
    });
  });
}
