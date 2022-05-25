// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../app_constants.dart';

class EditProjectPopup extends StatefulWidget {
  final projectsId;
  String status;
  String name;
  // StreamController refreshController;
  var ctx;
  final usersProject;
  EditProjectPopup(
      this.ctx, this.projectsId, this.status, this.name, this.usersProject,
      {Key? key})
      : super(key: key);
  @override
  EditProjectPopupState createState() => EditProjectPopupState();
}

class EditProjectPopupState extends State<EditProjectPopup> {
  final _form = GlobalKey<FormState>();

  Future fetchDataDetails() async {
    final data =
        await http.get(Uri.parse(usersUrl + '/${widget.projectsId}'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    return jsonDecode(data.body);
  }

  saveField() {
    if (_form.currentState!.validate() == true) {
      _form.currentState!.save();
      Navigator.of(context).pop([widget.name, widget.status]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text(
        'Edit Project',
        style: TextStyle(
          fontFamily: 'montBold',
          fontSize: 22,
        ),
      ),
      content: Form(
        key: _form,
        child: Column(children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: TextFormField(
              key: const Key('edit-name-project'),
              style: const TextStyle(fontFamily: "mont", fontSize: 14),
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6CCFF7), width: 2),
                ),
                border: OutlineInputBorder(),
                labelText: 'Name',
                labelStyle: TextStyle(
                    color: Colors.grey, fontFamily: "mont", fontSize: 14),
              ),
              keyboardType: TextInputType.name,
              initialValue: widget.name,
              onChanged: (String? newValue) {
                setState(() {
                  widget.name = newValue!;
                });
              },
            ),
          ),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: DropdownButtonFormField<String>(
                key: const Key('edit-status-project'),
                value: widget.status,
                icon: const Icon(Icons.keyboard_arrow_down),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(
                    color: Colors.grey[600], fontFamily: 'mont', fontSize: 14),
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF6CCFF7), width: 2),
                  ),
                  border: OutlineInputBorder(),
                  labelText: 'Status',
                  labelStyle: TextStyle(
                      color: Colors.grey, fontFamily: "mont", fontSize: 14),
                ),
                // ignore: body_might_complete_normally_nullable
                validator: (value) {
                  if (widget.usersProject.length > 0 && value == "closed") {
                    return "Please remove the assigments first";
                  }
                  if (widget.usersProject.length > 0 && value == "suspended") {
                    return "Please remove the assigments first";
                  }
                },
                onChanged: (String? newValue) {
                  setState(() {
                    widget.status = newValue!;
                  });
                },
                items: <String>['open', 'suspended', 'closed']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 14)),
                  );
                }).toList(),
              )),
        ]),
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
          key: const Key('confirm-edit-project'),
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
