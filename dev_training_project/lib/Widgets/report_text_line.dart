import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class TextLine extends StatelessWidget {
  final String firstText, secondText;

  const TextLine(this.firstText, this.secondText, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 4, left: 20, right: 15),
      decoration: const BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Color(0xFFCECECE), width: 0.7))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: AutoSizeText(
              firstText,
              maxLines: 1,
              minFontSize: 5,
              style: TextStyle(
                fontFamily:
                    firstText == 'Period Result: ' ? 'montBold' : 'mont',
                fontSize: 18,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Flexible(
            child: AutoSizeText(
              secondText.toString(),
              maxLines: 1,
              minFontSize: 5,
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'mont',
                color: checkColorResult(),
              ),
              textAlign: TextAlign.right,
            ),
          )
        ],
      ),
    );
  }

  checkColorResult() {
    if (firstText == 'Period Result: ') {
      if (double.parse(secondText.split('\$')[1]) >= 0) {
        return Colors.green;
      } else {
        return Colors.red;
      }
    } else {
      return Colors.black;
    }
  }
}
