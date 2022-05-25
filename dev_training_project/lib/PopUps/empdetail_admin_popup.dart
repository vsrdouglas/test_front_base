// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RevokeAcess extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables

  RevokeAcess(BuildContext context, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Revoke Access',
        style: TextStyle(
          color: Colors.black,
          fontFamily: "montBold",
          fontWeight: FontWeight.bold,
        ),
      ),
      content: const Text(
        'Are you sure you want to revoke his access?',
        style: TextStyle(fontFamily: 'mont', fontSize: 14),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text(
            'No',
            style: TextStyle(
              fontFamily: 'montBold',
              color: Color(0xFF213e4b),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xFF6CCFF7),
          ),
          child: const Text(
            'Yes',
            style: TextStyle(
              fontFamily: 'montBold',
              color: Color(0xFF213e4b),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
