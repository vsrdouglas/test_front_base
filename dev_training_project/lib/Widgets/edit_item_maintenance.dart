import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class EditItemMaintenance extends StatelessWidget {
  final String title;
  final String value;
  final Function onPressed;
  final bool isDescription;
  final double? fontSizeTitle;
  final double? fontSizeValue;
  const EditItemMaintenance({
    Key? key,
    required this.title,
    required this.value,
    required this.onPressed,
    required this.isDescription,
    this.fontSizeTitle,
    this.fontSizeValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isDescription) {
      return Column(mainAxisSize: MainAxisSize.max, children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 1,
              child: AutoSizeText(
                title,
                style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontFamily: 'mont',
                    fontSize: fontSizeTitle ?? 16,
                    color: Colors.black),
              ),
            ),
            Expanded(
              child: AutoSizeText(
                value,
                maxFontSize: 14,
                minFontSize: 8,
                textAlign: TextAlign.end,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontFamily: 'mont',
                    letterSpacing: 0.8,
                    fontSize: fontSizeValue ?? 14,
                    color: Colors.grey),
              ),
            ),
            IconButton(
              onPressed: () => onPressed(),
              icon: const Icon(
                Icons.mode_edit,
                color: Colors.black87,
              ),
              iconSize: 20,
            )
          ],
        ),
        const Divider(height: 2, color: Colors.black45)
      ]);
    } else {
      return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        IntrinsicHeight(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisSize: MainAxisSize.min, children: [
                Text(
                  title,
                  style: TextStyle(
                      fontFamily: 'mont',
                      fontSize: fontSizeTitle ?? 18,
                      color: Colors.black),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => onPressed(),
                  icon: const Icon(
                    Icons.mode_edit,
                    color: Colors.black87,
                  ),
                  iconSize: 20,
                )
              ]),
              Text(
                value,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontFamily: 'mont',
                    letterSpacing: 0.8,
                    fontSize: fontSizeValue ?? 14,
                    color: Colors.grey),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        const Divider(height: 2, color: Colors.black45)
      ]);
    }
  }
}
