import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_app/Models/employee_model.dart';
import 'package:my_app/Widgets/projdetail_title_line.dart';

mixin DiagnosticableToStringMixin on Object {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

class MockEmployeeSearchBar extends Mock
    with DiagnosticableToStringMixin
    implements TitleLine {}

void main() {
  late TitleLine sut;

  setUp(() {
    sut = MockEmployeeSearchBar();
  });

  test('test test', () async {
    dynamic list = [
      {
        'id': '01FZAZZJWBGMDPS361ZKTRB8K9',
        'name': 'Employee Teste Um',
        'email': 'employee@um.com',
        'monthlyWage': '10',
        'imageUri': 'imageUri',
        'imageTumb': 'imageThumb',
        'tecnologies': 'C',
        'allocation': 0
      }
    ];
    when(() => sut.checkResponse(list)).thenReturn([
      EmployeeModel('01FZAZZJWBGMDPS361ZKTRB8K9', 'Employee Teste Um',
          'employee@um.com', '10', 'imageUri', 'imageThumb', 'C', 0)
    ]);
    List<EmployeeModel> result = sut.checkResponse(list);
    expect(result[0].email, 'employee@um.com');
    verify(() => sut.checkResponse(list)).called(1);
  });
}
