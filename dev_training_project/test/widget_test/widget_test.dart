import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/Models/equipments_detail_model.dart';
import 'package:my_app/Screens/employees_screen.dart';
import 'package:my_app/Screens/equipments/equipments_search_list.dart';
import 'package:my_app/Screens/first_acess.dart';
import 'package:my_app/Screens/history_equipment/widgets/history_equipment_data.dart';
import 'package:my_app/Screens/history_equipment/widgets/history_user_equipment_card.dart';
import 'package:my_app/Screens/login_screen.dart';
import 'package:my_app/Screens/projects_screen.dart';
import 'package:my_app/Screens/recovery_password.dart';
import 'package:my_app/Screens/reset_password.dart';
import 'package:my_app/Widgets/allocation_employee.dart';
import 'package:my_app/Widgets/allocation_employee_app.dart';
import 'package:my_app/Widgets/employee_statistics.dart';
import 'package:my_app/Widgets/employee_statistics_app.dart';
import 'package:my_app/Widgets/employees_search_list.dart'
    // ignore: library_prefixes
    as employeesSearchList;
// ignore: library_prefixes
import 'package:my_app/Widgets/genreport_search_list.dart' as reportSearchList;
import 'package:my_app/Widgets/project_statistics.dart';
import 'package:my_app/Widgets/project_statistics_app.dart';
// ignore: library_prefixes
import 'package:my_app/Widgets/projects_search_list.dart' as projectSearchList;

void main() {
  setUpAll(() {
    HttpOverrides.global = null; //is required to avoid HTTP error 400
  });
  testWidgets('Login screen widget', (WidgetTester tester) async {
    final emailTextField = find.byKey(const ValueKey('email-text-field'));
    final passwordTextField = find.byKey(const ValueKey('password-text-field'));

    await tester.pumpWidget(const MaterialApp(home: Login()));
    await tester.enterText(emailTextField, "admin@admin.com");
    await tester.enterText(passwordTextField, "123456");
    expect(find.text('Sign In'), findsOneWidget);
  });

  testWidgets('report body widget', (WidgetTester tester) async {
    dynamic list = [
      {
        'id': '01FZAZZJWBGMDPS361ZKTRB8K9',
        'name': 'Alfa Project',
        'startDate': '2022-03-21'
      }
    ];
    await tester
        .pumpWidget(MaterialApp(home: reportSearchList.SearchBar(list)));
    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('Alfa Project'), findsOneWidget);
  });

  testWidgets('project body widget', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ProjectsBody()));
    expect(
        find.byKey(const ValueKey('stream-builder-project')), findsOneWidget);
    dynamic list = [
      {
        'id': '01FZAZZJWBGMDPS361ZKTRB8K9',
        'name': 'Alfa Project',
        'status': 'open',
        'startDate': '2022-03-21'
      }
    ];
    await tester.pumpWidget(MaterialApp(
        home: projectSearchList.SearchBar(list, StreamController())));
    expect(find.byKey(const ValueKey('search-bar-project')), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.byIcon(Icons.close), findsOneWidget);
    expect(find.text('Alfa Project'), findsOneWidget);
  });

  testWidgets('employees body widget', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: EmployeesBodyFinal()));
    expect(
        find.byKey(const ValueKey('stream-builder-employees')), findsOneWidget);
    dynamic list = [
      {
        'id': '01FZAZZJWBGMDPS361ZKTRB8K9',
        'name': 'Employee Teste Um',
        'email': 'employee@um.com',
        'monthlyWage': '10',
        'imageUri': 'imageUri',
        'imageTumb': 'imageThumb',
        'tecnologies': 'C',
        'allocation': '0'
      }
    ];
    await tester.pumpWidget(MaterialApp(
        home: employeesSearchList.SearchBar(list, StreamController())));
    expect(find.byKey(const ValueKey('employee-search-list')), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.byIcon(Icons.close), findsOneWidget);
    expect(find.text('Employee Teste Um'), findsOneWidget);
  });

  testWidgets('equipment body list widget', (WidgetTester tester) async {
    dynamic list = [
      {
        'id': '01FZAZZJWBGMDPS361ZKTRB8K9',
        'model': 'Dell Dois',
        'status': 'Working',
        'memory': {'unit': 'GB', 'size': '32'},
        'processor': {'model': 'Intel I7 Gen 8'},
        'monthlyWage': '10',
        'serial': 'dsadaskdsoa',
        'storage': {'type': 'HD', 'size': '500', 'unit': 'GB'},
        'equipmentsUserModel': null
      }
    ];
    await tester.pumpWidget(
        MaterialApp(home: SearchBarEquipments(list, StreamController())));
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.byIcon(Icons.filter_list_rounded), findsOneWidget);
    expect(find.byIcon(Icons.download), findsOneWidget);
    expect(find.byIcon(Icons.close), findsOneWidget);
    expect(find.text('Dell Dois'), findsOneWidget);
  });

  testWidgets('first access widget', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: FirstAcess('DJSAILDAJSDSDA')));
    expect(find.text('Change your password'), findsOneWidget);
    await tester.enterText(
        find.byKey(const ValueKey('first-new-password')), "123456");
    await tester.enterText(
        find.byKey(const ValueKey('first-confirm-password')), "123456");
    expect(find.text("Confirm"), findsOneWidget);
  });

  testWidgets('recovery password widget', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: RecoveryPassword()));
    await tester.enterText(
        find.byKey(const ValueKey('recovery-email')), "admin@admin.com");
    expect(find.text("admin@admin.com"), findsOneWidget);
  });

  testWidgets('reset password widget', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: ResetPasswordScreen('admin@admin.com', 'tokenkeytest')));
    expect(find.text('Change your password'), findsOneWidget);
    await tester.enterText(
        find.byKey(const ValueKey('reset-new-password')), "123456");
    await tester.enterText(
        find.byKey(const ValueKey('reset-confirm-password')), "123456");
    await tester.tap(find.byIcon(Icons.visibility_off).first);
    expect(find.text('Confirm'), findsOneWidget);
  });

  testWidgets('history equipment data widget', (WidgetTester tester) async {
    EquipmentHistory equipmentHistory = EquipmentHistory(
        equipmentInfo: Equipments(
            id: 'PROJECTID',
            model: 'Dell Dois',
            serial: 'dsaiodadnsa',
            processor: 'Intel I7 Gen 8',
            processorId: 'PROCESSORID',
            memory: '32 GB',
            memoryId: 'MEMORYID',
            storage: 'HD 500 GB',
            storageSize: '500 GB',
            storageType: 'HD',
            purchaseDate: '2022-02-02',
            warranty: '2023-02-02',
            status: 'Working',
            company: 'AOA',
            note: 'ja tem usuario',
            cost: '10000',
            billingNumber: 'DSADSADSADSA'));
    await tester.pumpWidget(MaterialApp(
        home: HistoryEquipmentData(equipamentHistory: equipmentHistory)));
    expect(find.text('Processor'), findsOneWidget);
    expect(find.text('Intel I7 Gen 8'), findsOneWidget);
    expect(find.text('Working'), findsOneWidget);
    expect(find.text('AOA'), findsOneWidget);
    expect(find.text('HD 500 GB'), findsOneWidget);
    expect(find.text('32 GB'), findsOneWidget);
    expect(find.text('dsaiodadnsa'), findsOneWidget);
  });

  testWidgets('history user equipment card widget',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
        home: HistoryUserEquipmentCard(
      name: 'Employee Um',
      startDate: '2021-02-03',
      employeeImageThumb: 'csads',
      endDate: '2022-02-05',
    )));
    expect(find.text('Employee Um'), findsOneWidget);
    expect(find.text('2021-02-03 - 2022-02-05'), findsOneWidget);
  });

  testWidgets('statistics employee app widget', (WidgetTester tester) async {
    dynamic infoEmployee = {
      'numberOfUsers': 29,
      'allocated': 19,
      'unallocated': 10
    };
    await tester.pumpWidget(MaterialApp(
        home: StatisticsEmployeeApp(StreamController(), infoEmployee)));
    expect(find.text('Employees'), findsOneWidget);
    expect(find.byIcon(Icons.person_add_alt), findsOneWidget);
  });

  testWidgets('statistics project app widget', (WidgetTester tester) async {
    dynamic infoProjects = {
      'total': 19,
      'open': 9,
      'suspended': 5,
      'closed': 5
    };
    await tester.pumpWidget(MaterialApp(
        home: StatisticsProjectApp(StreamController(), infoProjects)));
    expect(find.text('Projects'), findsOneWidget);
    expect(find.byIcon(Icons.post_add_sharp), findsOneWidget);
  });

  testWidgets('statistics allocation employee app widget',
      (WidgetTester tester) async {
    List infoEmployeeList = [
      {
        'id': 'EMPLOYEEIDID',
        'imageTumb': 'imagethumb',
        'name': 'Employee Um',
        'tecnologies': 'C',
        'allocation': 0
      }
    ];
    await tester.pumpWidget(MaterialApp(
        home: AllocationEmployeeApp(StreamController(), infoEmployeeList)));
    expect(find.text('List of Unallocated Employees'), findsOneWidget);
  });

  testWidgets('statistics employee web widget', (WidgetTester tester) async {
    dynamic infoEmployee = {
      'numberOfUsers': 29,
      'allocated': 19,
      'unallocated': 10
    };
    await tester.pumpWidget(MaterialApp(
        home: StatisticsEmployee(StreamController(), infoEmployee)));
    expect(find.text('Employees'), findsOneWidget);
    expect(find.byIcon(Icons.person_add_alt), findsOneWidget);
    expect(find.text('29'), findsOneWidget);
    expect(find.text('Allocated: 19'), findsOneWidget);
    expect(find.text('Unallocated: 10'), findsOneWidget);
  });

  testWidgets('statistics project web widget', (WidgetTester tester) async {
    dynamic infoProjects = {
      'total': 19,
      'open': 9,
      'suspended': 5,
      'closed': 5
    };
    await tester.pumpWidget(
        MaterialApp(home: StatisticsProject(StreamController(), infoProjects)));
    expect(find.text('Projects'), findsOneWidget);
    expect(find.byIcon(Icons.post_add_sharp), findsOneWidget);
    expect(find.text('19'), findsOneWidget);
    expect(find.text('Open: 9'), findsOneWidget);
    expect(find.text('Suspended: 5'), findsOneWidget);
    expect(find.text('Closed: 5'), findsOneWidget);
  });

  testWidgets('statistics allocation employee web widget',
      (WidgetTester tester) async {
    List infoEmployeeList = [
      {
        'id': 'EMPLOYEEIDID',
        'imageTumb': 'imagethumb',
        'name': 'Employee Um',
        'tecnologies': 'C',
        'allocation': '0'
      }
    ];
    await tester.pumpWidget(MaterialApp(
        home: AllocationEmployee(StreamController(), infoEmployeeList)));
    expect(find.text('List of Unallocated Employees'), findsOneWidget);
  });
}
