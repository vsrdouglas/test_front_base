// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable, body_might_complete_normally_nullable

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../app_constants.dart';
import 'warning_popup.dart';

class EditEmployeePopup extends StatefulWidget {
  var parentCtx;
  StreamController refreshController;
  String userId;
  String editingField;
  String currentValue;
  late String suport;
  EditEmployeePopup(BuildContext context, this.parentCtx,
      this.refreshController, this.userId, this.editingField, this.currentValue,
      {Key? key})
      : super(key: key);
  @override
  EditEmployeePopupState createState() => EditEmployeePopupState();
}

class EditEmployeePopupState extends State<EditEmployeePopup> {
  final _form = GlobalKey<FormState>();
  late String? editedValue = widget.currentValue;

  Future fetchDataDetails() async {
    final data =
        await http.get(Uri.parse(usersUrl + '/${widget.userId}'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    return jsonDecode(data.body);
  }

  Future<void> handleRefresh() async {
    await fetchDataDetails().then((res) {
      widget.refreshController.add(res);
      return null;
    });
  }

  String? checkSuffix(field) {
    if (field == 'Cost') {
      return 'R\$';
    } else {
      return '';
    }
  }

  TextInputType? checkFieldInput(field) {
    switch (field) {
      case 'Name':
        widget.suport = 'name';
        return TextInputType.name;
      case 'Email':
        widget.suport = 'email';
        return TextInputType.emailAddress;
      case 'Cost':
        widget.suport = 'monthlyWage';
        return TextInputType.number;
      case 'Technologies':
        widget.suport = 'tecnologies';
        return TextInputType.text;
    }
  }

  checkValidationType(field) {
    switch (field) {
      case 'Name':
        return (value) {
          if (value == null ||
              value.isEmpty ||
              value == " " ||
              value == "  " ||
              value == "   ") {
            return 'Please enter a Name!';
          }
          return null;
        };
      case 'Email':
        return (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter an Email!';
          }
          if (!RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(value)) {
            return 'Enter a valid Email format';
          }
          return null;
        };
      case 'Cost':
        return (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a Cost!';
          }
          if (double.tryParse(value) == null) {
            return 'Please enter a valid number';
          }
          if (double.parse(value) <= 0) {
            return 'Enter a number greater than 0';
          }

          return null;
        };
    }
  }

  saveField() async {
    if (_form.currentState!.validate() == true) {
      _form.currentState!.save();
      Navigator.of(context).pop();
      await sendEdit();
      handleRefresh();
    }
  }

  sendEdit() async {
    final response = await http.put(
      Uri.parse(usersUrl + '/' + widget.userId),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        widget.suport: editedValue,
      }),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(widget.parentCtx).showSnackBar(
        SnackBar(
          content: Text(
            widget.editingField + ' succesfully edited',
            style: const TextStyle(fontFamily: 'mont'),
          ),
        ),
      );
    } else {
      showDialog(
        context: widget.parentCtx,
        builder: (BuildContext context) => Warning(context, response.body),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Edit ' + widget.editingField,
        style: const TextStyle(
          fontFamily: 'montBold',
          fontSize: 22,
        ),
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 232),
        child: Form(
          key: _form,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: TextFormField(
              key: const Key('fieldEdit'),
              style: const TextStyle(fontFamily: "mont", fontSize: 14),
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6CCFF7), width: 2),
                ),
                hintText: widget.currentValue,
                border: const OutlineInputBorder(),
                prefixText: checkSuffix(widget.editingField),
                labelText: widget.editingField,
                labelStyle: const TextStyle(
                    color: Colors.grey, fontFamily: "mont", fontSize: 14),
              ),
              inputFormatters: widget.editingField == 'Cost'
                  ? [
                      FilteringTextInputFormatter(',',
                          allow: false, replacementString: '.'),
                      FilteringTextInputFormatter.allow(
                          RegExp(r"^\d+\.?\d{0,2}")),
                    ]
                  : [],
              keyboardType: checkFieldInput(widget.editingField),
              validator: checkValidationType(widget.editingField),
              onSaved: (newValue) {
                editedValue = newValue;
              },
              initialValue: widget.editingField == 'Technologies'
                  ? widget.currentValue
                  : null,
              maxLines: widget.editingField == 'Technologies' ||
                      widget.editingField == 'Email'
                  ? null
                  : 1,
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Cancel',
            style: TextStyle(
              fontFamily: 'mont',
              color: Color(0xFF213e4b),
              fontSize: 15,
            ),
          ),
        ),
        TextButton(
          key: const Key('confirmEditEmployee'),
          onPressed: () {
            saveField();
          },
          child: Container(
            color: const Color(0xFF6CCFF7),
            padding: const EdgeInsets.all(6),
            child: const Text(
              'Confirm',
              style: TextStyle(
                fontFamily: 'montBold',
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
