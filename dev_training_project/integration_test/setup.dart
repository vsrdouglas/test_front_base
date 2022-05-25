import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_app/main.dart' as app;

Future<void> takeScreenshot(
  WidgetTester tester,
  IntegrationTestWidgetsFlutterBinding binding,
) async {
  if (kIsWeb) {
    await binding.takeScreenshot('test-screenshot');
    return;
  } else if (Platform.isAndroid) {
    await binding.convertFlutterSurfaceToImage();
    await tester.pumpAndSettle();
  }
  await binding.takeScreenshot('test-screenshot');
}

Future<void> login(tester) async {
  app.main();
  await tester.pumpAndSettle();
  final Finder emailTextField = find.byKey(const Key('email-text-field'));
  final Finder passwordTextField = find.byKey(const Key('password-text-field'));
  final Finder signInButton = find.byKey(const Key('btn-sign-in'));
  await tester.pumpAndSettle();
  await tester.enterText(emailTextField, 'admin@admin.com');
  await tester.pumpAndSettle();
  await tester.enterText(passwordTextField, '123456');
  await tester.pumpAndSettle();
  await tester.tap(signInButton);
  await tester.pump();
  await waitFor(tester, find.byIcon(Icons.person_add_alt));
}

Future<void> navEquipment(tester) async {
  final equipmentButton = find.byKey(const Key('equipment-nav'));
  await tester.tap(equipmentButton);
  await tester.pumpAndSettle();
}

Future<void> navEmployee(tester) async {
  final employeeButton = find.byKey(const Key('app-employees-nav'));
  await tester.tap(employeeButton);
  await tester.pumpAndSettle();
}

Future<void> navProjects(tester) async {
  final projectsButton = find.byKey(const Key('app-projects-nav'));
  await tester.tap(projectsButton);
  await tester.pumpAndSettle();
}

Future<void> waitFor(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 30),
}) async {
  bool timerDone = false;
  final timer =
      Timer(timeout, () => throw TimeoutException("Pump until has timed out"));
  while (timerDone != true) {
    await tester.pumpAndSettle();
    final found = tester.any(finder);
    if (found) {
      timerDone = true;
    }
  }
  timer.cancel();
}

Future<void> waitForPump(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 30),
}) async {
  bool timerDone = false;
  final timer =
      Timer(timeout, () => throw TimeoutException("Pump until has timed out"));
  while (timerDone != true) {
    await tester.pumpAndSettle();
    final found = tester.any(finder);
    if (found) {
      timerDone = true;
    }
  }
  timer.cancel();
}

Future<void> waitForNot(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 30),
}) async {
  bool timerDone = false;
  final timer =
      Timer(timeout, () => throw TimeoutException("Pump until has timed out"));
  while (timerDone != true) {
    await tester.pumpAndSettle();
    final found = tester.any(finder);
    if (!found) {
      timerDone = true;
    }
  }
  timer.cancel();
}

Future<void> addEquipment(tester) async {
  await tester.pumpAndSettle();
  final textFieldModel = find.byKey(const Key('model-add'));
  final textFieldSerial = find.byKey(const Key('serial-add'));
  final textFieldProcessor = find.byKey(const Key('add-processor-equipment'));
  final textFieldMemory = find.byKey(const Key('add-memory-equipment'));
  final textFieldStorageType =
      find.byKey(const Key('add-storageType-equipment'));
  final textFieldStorageSize =
      find.byKey(const Key('add-storageSize-equipment'));
  final buttonConfirm = find.byKey(const Key('confirm-add-equipment'));
  await tester.enterText(textFieldModel, 'Dell Teste');
  await tester.pump();
  await tester.enterText(textFieldSerial, 'dsa5d46sa5da');
  await tester.pump();
  await tester.ensureVisible(textFieldProcessor);
  await tester.pump();

  late Finder processor;
  do {
    await tester.tap(textFieldProcessor);
    await tester.pumpAndSettle(const Duration(seconds: 1));
    processor = find.bySemanticsLabel('Intel I9 teste');
  } while (processor.evaluate().isEmpty);

  await waitFor(tester, find.bySemanticsLabel('Intel I9 teste'));
  await tester.tap(find.bySemanticsLabel('Intel I9 teste'));
  await tester.pumpAndSettle();
  await tester.ensureVisible(textFieldMemory);
  await tester.pump();
  await waitFor(tester, textFieldMemory);
  await tester.tap(textFieldMemory);
  await tester.pumpAndSettle();
  await waitFor(tester, find.bySemanticsLabel('16 GB'));
  await tester.tap(find.bySemanticsLabel('16 GB'));
  await tester.pumpAndSettle();
  await tester.ensureVisible(textFieldStorageType);
  await tester.pump();
  await waitFor(tester, textFieldStorageType);
  await tester.tap(textFieldStorageType);
  await tester.pumpAndSettle();
  await waitFor(tester, find.bySemanticsLabel('HD'));
  await tester.tap(find.bySemanticsLabel('HD'));
  await tester.pumpAndSettle();
  await tester.ensureVisible(textFieldStorageSize);
  await waitFor(tester, textFieldStorageSize);
  await tester.tap(textFieldStorageSize);
  await tester.pumpAndSettle();
  await tester.tap(find.bySemanticsLabel('1 TB'));
  await tester.pumpAndSettle();
  await tester.tap(buttonConfirm);
}

Future<void> addUser(tester) async {
  final gesture = await tester.startGesture(const Offset(0, 100));
  await tester.pumpAndSettle();
  final nameTextField = find.byKey(const Key('add-employee-name'));
  final emailTextField = find.byKey(const Key('add-employee-email'));
  final costTextField = find.byKey(const Key('add-employee-cost'));
  final accessTextField = find.byKey(const Key('add-employee-access'));
  final selectedAccess = find.bySemanticsLabel('Employee');
  final technologiesTextField =
      find.byKey(const Key('add-employee-technologies'));
  final buttonConfirm = find.byKey(const ValueKey('confirm-add-employee'));

  await tester.enterText(nameTextField, 'Employee Teste');
  await tester.pumpAndSettle();
  await tester.enterText(emailTextField, 'employee@teste.com');
  await tester.pumpAndSettle();
  await gesture.moveBy(const Offset(0, -100));
  await tester.pump();
  await tester.enterText(costTextField, '1000');
  await gesture.moveBy(const Offset(0, -100));
  await tester.pump();
  await tester.pumpAndSettle();
  await tester.tap(accessTextField);
  await tester.pumpAndSettle();
  await tester.pumpAndSettle();
  await tester.tap(selectedAccess, warnIfMissed: false);
  await tester.pumpAndSettle();
  await tester.pumpAndSettle();
  await gesture.moveBy(const Offset(0, -100));
  await tester.pump();
  await tester.enterText(technologiesTextField, 'C');
  await tester.pumpAndSettle();
  await tester.tap(buttonConfirm, warnIfMissed: false);
  await tester.pumpAndSettle();
}

Future<void> scrollScreen(tester) async {
  final gesture = await tester.startGesture(const Offset(0, 100));
  await gesture.moveBy(const Offset(0, -100));
  await tester.pump();
}

Future<void> slowDrag(WidgetTester tester, Offset start, Offset offset) async {
  final TestGesture gesture = await tester.startGesture(start);
  for (int index = 0; index < 10; index += 1) {
    await gesture.moveBy(offset);
    await tester.pump(const Duration(milliseconds: 20));
  }
  await gesture.up();
}

Future<void> scrollUntilFound(
  WidgetTester tester,
  Finder finder, {
  int attempts = 20,
}) async {
  for (int i = 1; i <= attempts; i++) {
    final gesture = await tester.startGesture(const Offset(0, 300));
    await gesture.moveBy(const Offset(0, -300));
    await tester.pump();

    try {
      expect(finder, findsOneWidget);
      await tester.pumpAndSettle();
      return;
    } catch (e) {
      if (i == attempts) {
        rethrow;
      }
    }
  }
}
