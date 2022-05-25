import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class TextLine extends StatelessWidget {
  final String firstText, secondText;

  // ignore: use_key_in_widget_constructors
  const TextLine(this.firstText, this.secondText);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 4, left: 20, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Flexible(
            child: AutoSizeText(
              firstText,
              maxLines: 1,
              minFontSize: 5,
              style: TextStyle(
                fontFamily: 'mont',
                fontSize: 18,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Flexible(
            child: AutoSizeText(
              secondText,
              maxLines: 1,
              minFontSize: 5,
              style: const TextStyle(
                fontSize: 18,
                fontFamily: 'mont',
              ),
              textAlign: TextAlign.right,
            ),
          )
        ],
      ),
    );
  }
}
