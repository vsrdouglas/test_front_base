import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'db.setup.dart';
import 'setup.dart';

Future<void> addMaintenance(tester) async {
  final maintenancePainel = find.text('Maintenance');
  final addMaintenance = find.byIcon(Icons.add);
  final name = find.byKey(const Key('add-maintenance-name'));
  final type = find.byKey(const Key('add-maintenance-type'));
  final status = find.byKey(const Key('add-maintenance-status'));
  final buttonConfirm = find.byKey(const Key('add-maintenance-confirm'));

  await tester.tap(maintenancePainel);
  await tester.pumpAndSettle();
  await tester.tap(addMaintenance);
  await tester.pumpAndSettle();
  await tester.enterText(name, 'Tela quebrada teste');
  await tester.pumpAndSettle();
  await tester.tap(type);
  await tester.pumpAndSettle();
  await tester.pumpAndSettle();
  await tester.tap(find.bySemanticsLabel('Maintenance'));
  await tester.pumpAndSettle();
  await tester.pumpAndSettle();
  await tester.tap(status);
  await tester.pumpAndSettle();
  await tester.pumpAndSettle();
  await tester.tap(find.bySemanticsLabel('In progress'));
  await tester.pumpAndSettle();
  await tester.tap(buttonConfirm);
  await waitFor(tester, find.text('Tela quebrada teste'));
}

Future<void> editMaintenance(tester) async {
  final buttonConfirm = find.byKey(const Key('edit-maintenance-name'));
  await tester.tap(find.text('Tela quebrada teste'));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('edit-maintenance')));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('edit-field-maintenance')));
  await tester.pump();
  await tester.enterText(
      find.byKey(const Key('edit-field-maintenance')), 'Maintenance Editado');
  await tester.pumpAndSettle();
  await waitFor(tester, buttonConfirm);
  await tester.tap(buttonConfirm);
}

void main() {
  group('Nineth Flow', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('nineth flow', (WidgetTester tester) async {
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

        await waitFor(tester, find.bySemanticsLabel('Assign Equipment'));

        await addMaintenance(tester);

        expect(find.text('Tela quebrada teste'), findsOneWidget);

        await editMaintenance(tester);

        await waitFor(tester, find.text('Maintenance Editado'));

        expect(find.text('Maintenance Editado'), findsOneWidget);
      });
    });
  });
}
