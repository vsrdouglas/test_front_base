import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/Widgets/report_text_line.dart';

void main() {
  group('text line color report app', () {
    test('text line app report', () async {
      Color textLineColorGreenApp =
          const TextLine('Period Result: ', 'R\$10').checkColorResult();
      expect(textLineColorGreenApp, Colors.green);

      Color textLineColorRedApp =
          const TextLine('Period Result: ', 'R\$-1').checkColorResult();
      expect(textLineColorRedApp, Colors.red);

      Color textLineColorBlackApp =
          const TextLine('Sprint: ', '10').checkColorResult();
      expect(textLineColorBlackApp, Colors.black);
    });
  });
}
