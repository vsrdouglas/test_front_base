import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../utils/db.setup.dart';
import 'fourth_flow.dart';
import 'setup.dart';

Future<void> editProject(tester) async {
  await tester.tap(find.byIcon(Icons.mode_edit));
  await tester.pumpAndSettle();
  final textFieldName = find.byKey(const Key('edit-name-project'));
  await tester.enterText(textFieldName, 'Project Teste Edited');
  await tester.tap(find.text('Confirm'));
  await waitFor(tester, find.text('Project Teste Edited'));
}

void main() {
  group('Fifth Flow', () {
    final binding = IntegrationTestWidgetsFlutterBinding();
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('fifth flow', (WidgetTester tester) async {
      try {
        await setupDB();

        await login(tester);

        expect(find.byKey(const Key('info-dashboard')), findsOneWidget);

        await navProjects(tester);

        await tester.tap(find.byIcon(Icons.add));

        await tester.pumpAndSettle();

        await addProject(tester);

        await waitFor(tester, find.text('Project Teste'));

        await tester.tap(find.text('Project Teste'));

        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.mode_edit), findsOneWidget);

        await editProject(tester);

        expect(find.text('Project Teste Edited'), findsOneWidget);
      } catch (e) {
        await takeScreenshot(tester, binding);
      }
    });
  });
}
