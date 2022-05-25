import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../utils/db.setup.dart';
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
  await tester.enterText(find.bySemanticsLabel('Name'), 'Maintenance Editado');
  await tester.pumpAndSettle();
  await tester.tap(buttonConfirm);
}

void main() {
  group('Sixth Flow', () {
    final binding = IntegrationTestWidgetsFlutterBinding();
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('sixth flow', (WidgetTester tester) async {
      try {
        await setupDB();

        await login(tester);

        expect(find.byKey(const Key('info-dashboard')), findsOneWidget);

        await navEquipment(tester);

        await tester.tap(find.byIcon(Icons.add));

        await tester.pumpAndSettle();

        await addEquipment(tester);

        await waitFor(tester, find.text('Dell Teste'));

        await tester.tap(find.text('Dell Teste'));

        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.mode_edit), findsOneWidget);

        await addMaintenance(tester);

        expect(find.text('Tela quebrada teste'), findsOneWidget);

        await editMaintenance(tester);

        await waitFor(tester, find.text('Maintenance Editado'));

        expect(find.text('Maintenance Editado'), findsOneWidget);
      } catch (e) {
        await takeScreenshot(tester, binding);
      }
    });
  });
}
