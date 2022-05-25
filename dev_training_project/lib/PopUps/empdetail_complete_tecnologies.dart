// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CompleteTechnologies extends StatefulWidget {
  String technologies;
  CompleteTechnologies(this.technologies, {Key? key}) : super(key: key);
  @override
  CompleteTechnologiesState createState() => CompleteTechnologiesState();
}

class CompleteTechnologiesState extends State<CompleteTechnologies> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text(
        'All Technologies',
        style: TextStyle(fontFamily: "montBold", fontSize: 22),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.20,
        child: Text(
          widget.technologies.toString(),
          style: const TextStyle(fontFamily: "mont", fontSize: 18),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Close',
            style: TextStyle(
              fontFamily: 'mont',
              color: Color(0xFF213e4b),
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}
