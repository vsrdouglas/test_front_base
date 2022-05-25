import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DeleteWarningProjects extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables

  const DeleteWarningProjects(BuildContext context, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Delete Project?',
        maxLines: 1,
        style: TextStyle(
          color: Colors.black,
          fontFamily: "montBold",
          fontWeight: FontWeight.bold,
        ),
      ),
      content: const SizedBox(
        width: double.infinity,
        child: Text(
          'Are you sure you want to delete this project?',
          style: TextStyle(fontFamily: 'mont', fontSize: 14),
        ),
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
