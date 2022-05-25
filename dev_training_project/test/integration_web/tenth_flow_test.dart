import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../utils/db.setup.dart';
import 'setup.dart';
import 'fourth_flow.dart';

void main() {
  group('Tenth Flow', () {
    final binding = IntegrationTestWidgetsFlutterBinding();
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('Tenth flow', (WidgetTester tester) async {
      try {
        await setupDB();

        await login(tester);

        expect(find.byKey(const Key('info-dashboard')), findsOneWidget);

        await navProjects(tester);

        await tester.tap(find.byIcon(Icons.add));

        await waitFor(tester, find.byKey(const Key('add-project-button')));

        await addProject(tester);

        await waitFor(tester, find.byType(ListView));

        expect(find.byType(ListView), findsOneWidget);

        await navReport(tester);

        final project = find.text('Project Teste');

        await tester.tap(project);

        await waitFor(tester, find.text('Report of: Project Teste'));

        expect(find.text('Report of: Project Teste'), findsOneWidget);

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

        await waitFor(tester, find.text('Cancel'));

        expect(find.text('Cancel'), findsOneWidget);

        final cancelForecastButton = find.text('Cancel');

        await tester.tap(cancelForecastButton);

        await tester.pumpAndSettle();

        final iconBack = find.byIcon(Icons.keyboard_backspace_rounded);

        await tester.tap(iconBack);

        await waitFor(tester, find.byType(ListView));

        expect(find.byType(ListView), findsOneWidget);
      } catch (e) {
        await takeScreenshot(tester, binding);
      }
    });
  });
}
