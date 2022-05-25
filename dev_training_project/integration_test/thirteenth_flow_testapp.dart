import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'db.setup.dart';
import 'setup.dart';

Future<void> storageFlow(tester) async {
  await tester.tap(find.byIcon(Icons.close));

  await waitFor(tester, find.text('Yes'));

  await tester.tap(find.text('Yes'));

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

  await waitFor(tester, find.byIcon(Icons.edit));

  await tester.tap(find.byIcon(Icons.edit));

  await waitFor(tester, enterTextSize);

  await tester.enterText(enterTextSize, '1');

  await waitFor(tester, find.text('Confirm'));

  await tester.tap(find.text('Confirm'));
}

void main() {
  group('Thirteenth Flow', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('thirteenth flow', (WidgetTester tester) async {
      await setupDB();

      await tester.runAsync(() async {
        await login(tester);

        await waitFor(tester, find.byIcon(Icons.menu));

        final menuButton = find.byIcon(Icons.menu);

        await tester.tap(menuButton);

        await waitFor(tester, find.text('Equipments Parameters'));

        await tester.tap(find.text('Equipments Parameters'));

        await waitFor(tester, find.byIcon(Icons.keyboard_arrow_down));

        await tester.tap(find.byIcon(Icons.keyboard_arrow_down));

        await waitFor(tester, find.bySemanticsLabel('Storage'));

        await tester.tap(find.bySemanticsLabel('Storage'));

        await waitFor(tester, find.byType(ListView));

        await storageFlow(tester);

        await waitFor(tester, find.text('1 TB'));

        expect(find.text('1 TB'), findsOneWidget);
      });
    });
  });
}
