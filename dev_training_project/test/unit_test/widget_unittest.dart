// ignore_for_file: library_prefixes

import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/Models/employee_model.dart';
import 'package:my_app/Models/project_model_list.dart';
import 'package:my_app/Models/project_model_report.dart';
import 'package:my_app/Widgets/employees_search_list.dart' as emploList;
import 'package:my_app/Widgets/genreport_search_list.dart' as genReport;
import 'package:my_app/Widgets/projects_search_list.dart' as projectList;

void main() {
  group('widget unit test', () {
    test('employee search list list converted', () async {
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
      List<EmployeeModel> result =
          emploList.SearchBarState().listconverter(list);
      expect(result[0].email, 'employee@um.com');
    });

    test('report search list converted', () async {
      dynamic list = [
        {
          'id': '01FZAZZJWBGMDPS361ZKTRB8K9',
          'name': 'Alfa Project',
          'status': 'open',
          'startDate': '2022-03-21'
        }
      ];
      List<ProjectModelReport> result =
          genReport.SearchBarState().listconverter(list);
      expect(result[0].id, '01FZAZZJWBGMDPS361ZKTRB8K9');
    });

    test('project search list converted', () async {
      dynamic list = [
        {
          'id': '01FZAZZJWBGMDPS361ZKTRB8K9',
          'name': 'Alfa Project',
          'status': 'open',
          'startDate': '2022-03-21'
        }
      ];
      List<ProjectModel> result =
          projectList.SearchBarState().listconverter(list);
      expect(result[0].id, '01FZAZZJWBGMDPS361ZKTRB8K9');
    });
  });
}
