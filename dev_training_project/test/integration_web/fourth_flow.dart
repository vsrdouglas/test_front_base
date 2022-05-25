import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../utils/db.setup.dart';
import 'setup.dart';

Future<void> addProject(tester) async {
  await tester.pumpAndSettle();
  final textFieldName = find.byKey(const Key('add-project-name'));
  final textFieldBudget = find.byKey(const Key('add-project-budget'));
  final textFieldSprint = find.byKey(const Key('add-project-sprint'));
  final datePicker = find.byKey(const Key('add-project-startDate'));
  final datePickerConfirm = find.bySemanticsLabel('OK');
  final buttonConfirm = find.byKey(const Key('add-project-button'));

  await tester.enterText(textFieldName, 'Project Teste');
  await tester.enterText(textFieldBudget, '1000');
  await tester.enterText(textFieldSprint, '10');
  await tester.tap(datePicker);
  await tester.pumpAndSettle(const Duration(seconds: 1));
  await tester.tap(datePickerConfirm);
  await tester.pumpAndSettle(const Duration(seconds: 1));
  await tester.tap(buttonConfirm);
}

void main() {
  group('Fourth Flow', () {
    final binding = IntegrationTestWidgetsFlutterBinding();
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('fourth flow', (WidgetTester tester) async {
      try {
        await setupDB();

        await login(tester);

        expect(find.byKey(const Key('info-dashboard')), findsOneWidget);

        await tester.tap(find.byIcon(Icons.post_add_sharp));

        await tester.pumpAndSettle();

        await addProject(tester);

        await tester.pumpAndSettle();

        await navProjects(tester);

        await tester.pumpAndSettle();

        await tester.tap(find.text('Project Teste'));

        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.mode_edit), findsOneWidget);
      } catch (e) {
        await takeScreenshot(tester, binding);
      }
    });
  });
}
