import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'db.setup.dart';
import 'setup.dart';

Future<void> editEquipment(tester) async {
  final editIcon = find.byIcon(Icons.mode_edit);
  final textFieldModelEdit = find.byKey(const Key('model-edit'));
  final buttonConfirm = find.text('Confirm');

  await tester.tap(editIcon);
  await tester.pumpAndSettle();
  await tester.tap(textFieldModelEdit);
  await tester.pump();
  await tester.enterText(textFieldModelEdit, 'Dell Teste Edited');
  await tester.tap(buttonConfirm);
  await waitFor(tester, find.text('Dell Teste Edited'));
}

void main() {
  group('Sixth Flow', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('sixth flow', (WidgetTester tester) async {
      // try {
      await setupDB();
      await tester.runAsync(() async {
        await login(tester);

        await waitFor(tester, find.byIcon(Icons.post_add_sharp));

        await tester.tap(find.byKey(const Key('app-equipment-nav')));

        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.add));

        await tester.pumpAndSettle();

        await addEquipment(tester);

        await waitFor(tester, find.text('Dell Teste'));

        await tester.tap(find.text('Dell Teste'));

        await waitFor(tester, find.byIcon(Icons.mode_edit));

        expect(find.byIcon(Icons.mode_edit), findsOneWidget);

        await editEquipment(tester);

        expect(find.text('Dell Teste Edited'), findsOneWidget);
      });
      // } catch (e) {
      //   await takeScreenshot(tester, binding);
      // }
    });
  });
}
