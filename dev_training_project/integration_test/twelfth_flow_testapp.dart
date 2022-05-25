import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'db.setup.dart';
import 'setup.dart';

Future<void> memoryFlow(tester) async {
  await tester.tap(find.byIcon(Icons.close));

  await waitFor(tester, find.text('Yes'));

  await tester.tap(find.text('Yes'));

  await waitFor(tester, find.byKey(const Key('add-button')));

  final buttonAdd = find.byKey(const Key('add-button'));

  await tester.tap(buttonAdd);

  await waitFor(tester, find.byKey(const Key('add-size-memory')));

  final enterTextSize = find.byKey(const Key('add-size-memory'));

  await tester.enterText(enterTextSize, '64');

  await waitFor(tester, find.byKey(const Key('add-unit-memory')));

  await tester.tap(find.byKey(const Key('add-unit-memory')));

  await waitFor(tester, find.bySemanticsLabel('TB'));

  await tester.tap(find.bySemanticsLabel('TB'));

  await waitFor(tester, find.text('Confirm'));

  final confirmButton = find.text('Confirm');

  await tester.tap(confirmButton);

  await waitFor(tester, find.byIcon(Icons.edit));

  await tester.tap(find.byIcon(Icons.edit));

  await waitFor(tester, enterTextSize);

  await tester.enterText(enterTextSize, '16');

  await waitFor(tester, find.byKey(const Key('add-unit-memory')));

  await tester.tap(find.byKey(const Key('add-unit-memory')));

  await waitFor(tester, find.bySemanticsLabel('GB'));

  await tester.tap(find.bySemanticsLabel('GB'));

  await waitFor(tester, find.text('Confirm'));

  await tester.tap(find.text('Confirm'));
}

void main() {
  group('Twelfth Flow', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('twelfth flow', (WidgetTester tester) async {
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

        await waitFor(tester, find.bySemanticsLabel('Memory'));

        await tester.tap(find.bySemanticsLabel('Memory'));

        await waitFor(tester, find.byType(ListView));

        await memoryFlow(tester);

        await waitFor(tester, find.text('16 GB'));

        expect(find.text('16 GB'), findsOneWidget);
      });
    });
  });
}
