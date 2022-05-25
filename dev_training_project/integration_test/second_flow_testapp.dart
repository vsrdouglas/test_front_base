import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'db.setup.dart';
import 'setup.dart';

void main() {
  group('Second Flow app, ', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('second flow app', (WidgetTester tester) async {
      await setupDB();
      await tester.runAsync(() async {
        await login(tester);
        await tester.tap(find.byIcon(Icons.person_add_alt));
        await addUser(tester);
        await tester.tap(find.text('List of Unallocated Employees'));
        await tester.pumpAndSettle();
        await waitForNot(tester, find.byType(SnackBar));
        await tester.ensureVisible(find.text('Employee Teste'));
        await tester.tap(find.text('Employee Teste'));
        await waitForPump(tester, find.byIcon(Icons.edit).first);
        expect(find.byIcon(Icons.edit).first, findsOneWidget);
      });
    });
  });
}
