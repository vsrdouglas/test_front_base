import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'db.setup.dart';
import 'fourth_flow_app.dart';
import 'setup.dart';

Future<void> editProject(tester) async {
  await tester.tap(find.byIcon(Icons.mode_edit));
  await waitFor(tester, find.text('Edit Project'));
  final textFieldName = find.byKey(const Key('edit-name-project'));
  await tester.tap(textFieldName);
  await tester.pump();
  await tester.enterText(textFieldName, 'Project Teste Edited');
  await tester.pumpAndSettle();
  await tester.tap(find.text('Confirm'));
  await waitFor(tester, find.text('Project Teste Edited'));
}

void main() {
  group('Fifth Flow', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('fifth flow', (WidgetTester tester) async {
      await setupDB();
      await tester.runAsync(() async {
        await login(tester);

        await waitFor(tester, find.byIcon(Icons.post_add_sharp));

        await tester.tap(find.byKey(const Key('app-projects-nav')));

        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.add));

        await tester.pumpAndSettle();

        await addProject(tester);

        await waitFor(tester, find.text('Project Teste'));

        await tester.tap(find.text('Project Teste'));

        await tester.pumpAndSettle();

        await waitFor(tester, find.byIcon(Icons.mode_edit));

        await editProject(tester);

        expect(find.text('Project Teste Edited'), findsOneWidget);
      });
    });
  });
}
