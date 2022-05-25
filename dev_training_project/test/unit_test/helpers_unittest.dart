import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/helpers.dart';

void main() {
  group('helpers test', () {
    test('checkPercent helper test', () async {
      Color textLineColorRedApp = checkPercent(0.7);
      expect(textLineColorRedApp, Colors.red);

      Color textLineColorGreenApp = checkPercent(0.1);
      expect(textLineColorGreenApp, Colors.green);

      Color textLineColorYellowApp = checkPercent(0.30);
      expect(textLineColorYellowApp, Colors.yellow);
    });

    test('checkAvailability helper test', () async {
      dynamic mapUser = {
        'id': '01FXTBES6Q3BS6ZZBTHTM02CK1',
        'projects': [
          {
            'id': '01G254WT43EN26Z4P42HA6RQZV',
            'projectHasUsers': [
              {'allocation': '0.41'},
              {'allocation': '0.21'},
            ]
          }
        ]
      };
      double allocation = checkAvailability(mapUser);
      expect(allocation, 0.62);
    });

    test('checkAllocation helper test', () async {
      dynamic mapUser = {
        'id': '01G254WT43EN26Z4P42HA6RQZV',
        'projectHasUsers': [
          {'allocation': '0.41'}
        ]
      };
      double allocation = checkAllocation(mapUser);
      expect(allocation, 0.41);
    });

    test('nameSpliter helper test', () async {
      String nameSplited = nameSpliter('Employee Teste Um');
      expect(nameSplited, 'Employee Um');

      String nameSplitedSecond = nameSpliter('Employee');
      expect(nameSplitedSecond, 'Employee');
    });
  });
}
