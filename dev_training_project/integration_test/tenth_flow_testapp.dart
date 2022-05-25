import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'db.setup.dart';
import 'setup.dart';
import 'fourth_flow_app.dart';

void main() {
  group('Tenth Flow', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('tenth flow', (WidgetTester tester) async {
      await setupDB();
      await tester.runAsync(() async {
        await login(tester);

        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('app-projects-nav')));

        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.add));

        await waitFor(tester, find.byKey(const Key('add-project-button')));

        await addProject(tester);

        await waitFor(tester, find.byType(ListView));

        expect(find.byType(ListView), findsOneWidget);

        await tester.tap(find.byKey(const Key('app-report-nav')));

        await tester.pumpAndSettle();

        final project = find.text('Project Teste');

        await tester.tap(project);

        await waitFor(tester, find.text('Project Teste'));

        expect(find.text('Project Teste'), findsOneWidget);

        final forecast = find.byKey(const Key('forecast-button'));

        await tester.tap(forecast);

        await waitFor(tester, find.text('Select the Number of Sprints'));

        expect(find.text('Select the Number of Sprints'), findsOneWidget);

        await waitFor(tester, find.byKey(const Key('sprints-quant')));

        final forecastSprints = find.byKey(const Key('sprints-quant'));

        await tester.enterText(forecastSprints, '5');

        await tester.pumpAndSettle();

        final confirmForecastButton = find.text('Confirm');

        await tester.tap(confirmForecastButton);

        await waitFor(tester, find.byKey(const Key('forecast-cancel-button')));

        expect(find.byKey(const Key('forecast-cancel-button')), findsOneWidget);

        final cancelForecastButton =
            find.byKey(const Key('forecast-cancel-button'));

        await tester.tap(cancelForecastButton);

        await tester.pumpAndSettle();

        final iconBack = find.byIcon(Icons.close);

        await tester.tap(iconBack);

        await waitFor(tester, find.byType(ListView));

        expect(find.byType(ListView), findsOneWidget);
      });
    });
  });
}
