import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../utils/db.setup.dart';
import 'setup.dart';

Future<void> storageFlow(tester) async {
  await tester.tap(find.byIcon(Icons.close));

  await waitFor(tester, find.text('Yes'));

  await tester.tap(find.text('Yes'));
  await waitForNot(tester, find.byType(SnackBar));
  await waitForNot(tester, find.byType(SnackBar));

  await waitFor(tester, find.byKey(const Key('add-button')));

  final buttonAdd = find.byKey(const Key('add-button'));

  await tester.tap(buttonAdd);

  await waitFor(tester, find.byKey(const Key('storage-type')));

  final enterTextType = find.byKey(const Key('storage-type'));

  final enterTextSize = find.byKey(const Key('storage-size'));

  final enterTextUnit = find.byKey(const Key('storage-unit'));

  await tester.tap(enterTextType);

  await waitFor(tester, find.bySemanticsLabel('HD'));

  await tester.tap(find.bySemanticsLabel('HD'));

  await waitFor(tester, enterTextSize);

  await tester.enterText(enterTextSize, '500');

  await waitFor(tester, enterTextUnit);

  await tester.tap(enterTextUnit);

  await waitFor(tester, find.bySemanticsLabel('TB'));

  await tester.tap(find.bySemanticsLabel('TB'));

  await waitFor(tester, find.text('Confirm'));

  final confirmButton = find.text('Confirm');

  await tester.tap(confirmButton);
  await waitForNot(tester, find.byType(SnackBar));

  await waitFor(tester, find.byIcon(Icons.edit));

  await tester.tap(find.byIcon(Icons.edit));

  await waitFor(tester, enterTextSize);

  await tester.enterText(enterTextSize, '1');

  await waitFor(tester, find.text('Confirm'));

  await tester.tap(find.text('Confirm'));
  await waitForNot(tester, find.byType(SnackBar));
}

void main() {
  group('Thirteenth Flow', () {
    final binding = IntegrationTestWidgetsFlutterBinding();
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('thirteenth flow', (WidgetTester tester) async {
      try {
        await setupDB();

        await login(tester);

        await waitFor(tester, find.byIcon(Icons.person_add_alt));

        final menuButton = find.byKey(const Key('dropdown-menu-button'));

        await tester.tap(menuButton);

        await waitFor(tester, find.byKey(const Key('equipments-parameters')));

        await tester.tap(find.byKey(const Key('equipments-parameters')));

        await waitFor(tester, find.byIcon(Icons.keyboard_arrow_down));

        await tester.tap(find.byIcon(Icons.keyboard_arrow_down));

        await waitFor(tester, find.bySemanticsLabel('Storage'));

        await tester.tap(find.bySemanticsLabel('Storage'));

        await waitFor(tester, find.byType(ListView));

        await storageFlow(tester);

        await waitFor(tester, find.text('1 TB'));
        expect(find.text('1 TB'), findsOneWidget);
      } catch (e) {
        await takeScreenshot(tester, binding);
      }
    });
  });
}
