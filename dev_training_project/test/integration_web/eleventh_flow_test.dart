import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../utils/db.setup.dart';
import 'setup.dart';

Future<void> processorFlow(tester) async {
  await tester.tap(find.byIcon(Icons.close));

  await waitFor(tester, find.text('Yes'));

  await tester.tap(find.text('Yes'));

  await waitForNot(tester, find.byType(SnackBar));

  await waitFor(tester, find.byKey(const Key('add-button')));

  final buttonAdd = find.byKey(const Key('add-button'));

  await tester.tap(buttonAdd);

  await waitFor(tester, find.byKey(const Key('add-processor')));

  final enterTextModel = find.byKey(const Key('add-processor'));

  await tester.enterText(enterTextModel, 'Inteste I9');

  await waitFor(tester, find.text('Confirm'));

  final confirmButton = find.text('Confirm');

  await tester.tap(confirmButton);

  await waitForNot(tester, find.byType(SnackBar));

  await waitFor(tester, find.byIcon(Icons.edit));

  await tester.tap(find.byIcon(Icons.edit));

  await waitFor(tester, enterTextModel);

  await tester.enterText(enterTextModel, 'Intel I9 teste');

  await waitFor(tester, find.text('Confirm'));

  await tester.tap(find.text('Confirm'));
  await waitForNot(tester, find.byType(SnackBar));

  await waitFor(tester, find.byType(ListView));
}

void main() {
  group('Eleventh Flow', () {
    final binding = IntegrationTestWidgetsFlutterBinding();
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('eleventh flow', (WidgetTester tester) async {
      try {
        await setupDB();

        await login(tester);

        await waitFor(tester, find.byIcon(Icons.person_add_alt));

        final menuButton = find.byKey(const Key('dropdown-menu-button'));

        await tester.tap(menuButton);

        await waitFor(tester, find.byKey(const Key('equipments-parameters')));

        await tester.tap(find.byKey(const Key('equipments-parameters')));

        await waitFor(tester, find.byType(ListView));

        await processorFlow(tester);

        expect(find.text('Intel I9 teste'), findsOneWidget);
      } catch (e) {
        await takeScreenshot(tester, binding);
      }
    });
  });
}
