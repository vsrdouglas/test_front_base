import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'db.setup.dart';
import 'setup.dart';

Future<void> processorFlow(tester) async {
  await tester.tap(find.byIcon(Icons.close));

  await waitFor(tester, find.text('Yes'));

  await tester.tap(find.text('Yes'));

  await waitFor(tester, find.byKey(const Key('add-button')));

  final buttonAdd = find.byKey(const Key('add-button'));

  await tester.tap(buttonAdd);

  await waitFor(tester, find.byKey(const Key('add-processor')));

  final enterTextModel = find.byKey(const Key('add-processor'));

  await tester.enterText(enterTextModel, 'Inteste I9');

  await waitFor(tester, find.text('Confirm'));

  final confirmButton = find.text('Confirm');

  await tester.tap(confirmButton);

  await waitFor(tester, find.byIcon(Icons.edit));

  await tester.tap(find.byIcon(Icons.edit));

  await waitFor(tester, enterTextModel);

  await tester.tap(enterTextModel);

  await tester.pump();

  await tester.enterText(enterTextModel, 'edit');

  await waitFor(tester, find.text('Confirm'));

  await tester.tap(find.text('Confirm'));
}

void main() {
  group('Eleventh Flow', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('eleventh flow', (WidgetTester tester) async {
      await setupDB();

      await tester.runAsync(() async {
        await login(tester);

        // await waitFor(tester, find.byKey(const Key('drawer-app')));
        await waitFor(tester, find.byIcon(Icons.menu));

        final menuButton = find.byIcon(Icons.menu);

        await tester.tap(menuButton);

        await waitFor(tester, find.text('Equipments Parameters'));

        await tester.tap(find.text('Equipments Parameters'));

        await waitFor(tester, find.byType(ListView));

        await processorFlow(tester);

        await waitFor(tester, find.text('edit'));

        expect(find.text('edit'), findsOneWidget);
      });
    });
  });
}
