// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SelectLevel extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables

  SelectLevel(BuildContext context, {Key? key}) : super(key: key);

  @override
  State<SelectLevel> createState() => _SelectLevelState();
}

class _SelectLevelState extends State<SelectLevel> {
  late String dropdownvalue;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Select a level of access',
        style: TextStyle(
          color: Colors.black,
          fontFamily: "montBold",
          fontWeight: FontWeight.bold,
        ),
      ),
      content: DropdownButtonFormField<String>(
        key: const Key('select-level-dropdown'),
        validator: (value) {
          if (value == null || value == '') {
            return 'Please Enter a level';
          }
          return null;
        },
        onChanged: (String? newValue) {
          setState(() {
            dropdownvalue = newValue!;
          });
        },
        icon: const Icon(Icons.keyboard_arrow_down),
        iconSize: 24,
        elevation: 16,
        style: const TextStyle(
            color: Colors.black, fontFamily: 'mont', fontSize: 14),
        decoration: const InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF6CCFF7), width: 2),
          ),
          border: OutlineInputBorder(),
          labelText: 'Level*',
          labelStyle:
              TextStyle(color: Colors.grey, fontFamily: "mont", fontSize: 14),
        ),
        items: <String>['Support', 'RH', 'Admin']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value,
                style: const TextStyle(color: Colors.grey, fontSize: 14)),
          );
        }).toList(),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop([
              false,
            ]);
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
            Navigator.of(context).pop([true, dropdownvalue]);
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
