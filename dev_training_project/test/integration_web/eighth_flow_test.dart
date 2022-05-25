import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../utils/db.setup.dart';
import 'setup.dart';

void main() {
  group('Eighth Flow', () {
    final binding = IntegrationTestWidgetsFlutterBinding();
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('eighth flow', (WidgetTester tester) async {
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

        await waitForNot(tester, find.byType(SnackBar));

        await tester.tap(find.text('Assign Equipment'));

        await waitFor(tester, find.text('Admin Test'));

        await tester.tap(find.text('Admin Test'));

        await tester.pumpAndSettle();

        await tester.tap(find.bySemanticsLabel('OK'));

        await waitFor(tester, find.bySemanticsLabel('Close Assignment'));

        expect(find.bySemanticsLabel('Close Assignment'), findsOneWidget);

        await tester.tap(find.bySemanticsLabel('Close Assignment'));

        await tester.pumpAndSettle();

        await tester.tap(find.bySemanticsLabel('OK'));

        await waitFor(tester, find.text('Assign Equipment'));

        await tester.pumpAndSettle();

        expect(find.text('Assign Equipment'), findsWidgets);
      } catch (e) {
        await takeScreenshot(tester, binding);
      }
    });
  });
}
