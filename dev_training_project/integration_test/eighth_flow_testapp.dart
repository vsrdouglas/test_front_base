import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'db.setup.dart';
import 'setup.dart';

void main() {
  group('Eighth Flow', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('eighth flow', (WidgetTester tester) async {
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

        await tester.tap(find.bySemanticsLabel('Assign Equipment'));

        await waitFor(tester, find.text('Admin Test'));

        await tester.tap(find.text('Admin Test'));

        await tester.pumpAndSettle();

        await tester.tap(find.bySemanticsLabel('OK'));

        await tester.pump();

        await waitFor(tester, find.bySemanticsLabel('Close Assignment'));

        await waitFor(tester, find.byKey(const Key('history-equipment')));

        await tester.tap(find.byKey(const Key('history-equipment')));

        await waitFor(tester, find.text('Admin Test'));

        await tester.tap(find.bySemanticsLabel('Close Assignment'));

        await tester.pumpAndSettle();

        await tester.tap(find.bySemanticsLabel('OK'));

        await waitFor(tester, find.bySemanticsLabel('Assign Equipment'));

        expect(find.bySemanticsLabel('Assign Equipment'), findsWidgets);
      });
    });
  });
}
