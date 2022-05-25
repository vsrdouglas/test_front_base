// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../app_constants.dart';
import 'warning_popup.dart';

class EquipmentsAddMemory extends StatefulWidget {
  dynamic parentCtx;
  Map<String, dynamic>? parameters;
  Function refresh;
  EquipmentsAddMemory({
    required this.parentCtx,
    required this.refresh,
    this.parameters,
    Key? key,
  }) : super(key: key);
  @override
  EquipmentsAddMemoryState createState() => EquipmentsAddMemoryState();
}

class EquipmentsAddMemoryState extends State<EquipmentsAddMemory> {
  final _form = GlobalKey<FormState>();
  late String valueSize, dropdownValue;

  saveField() async {
    if (_form.currentState!.validate() == true) {
      _form.currentState!.save();
      Navigator.of(context).pop();
      if (widget.parameters == null) {
        await sendAdd();
      } else {
        await sendEdit();
      }
      widget.refresh();
    }
  }

  sendEdit() async {
    final response = await http.put(
      Uri.parse(equipments + '/memory/' + widget.parameters!['id']),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        "size": valueSize,
        "unit": dropdownValue,
      }),
    );
    if (response.statusCode == 200) {
      return ScaffoldMessenger.of(widget.parentCtx).showSnackBar(
        const SnackBar(
          content: Text(
            'Memory Size succesfully edited',
            style: TextStyle(fontFamily: 'mont'),
          ),
        ),
      );
    } else {
      return showDialog(
        context: widget.parentCtx,
        builder: (BuildContext context) => Warning(context, response.body),
      );
    }
  }

  sendAdd() async {
    final response = await http.post(
      Uri.parse(equipments + '/memory'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        "size": valueSize,
        "unit": dropdownValue,
      }),
    );
    if (response.statusCode == 200) {
      return ScaffoldMessenger.of(widget.parentCtx).showSnackBar(
        const SnackBar(
          content: Text(
            'Memory Size succesfully add',
            style: TextStyle(fontFamily: 'mont'),
          ),
        ),
      );
    } else {
      return showDialog(
        context: widget.parentCtx,
        builder: (BuildContext context) => Warning(context, response.body),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Add Memory',
        style: TextStyle(
          fontFamily: 'montBold',
          fontSize: 22,
        ),
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 232),
        child: Form(
          key: _form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: TextFormField(
                  key: const Key('add-size-memory'),
                  style: const TextStyle(fontFamily: "mont", fontSize: 14),
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF6CCFF7), width: 2),
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'Size Number*',
                    labelStyle: TextStyle(
                        color: Colors.grey, fontFamily: "mont", fontSize: 14),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r"^\d+")),
                  ],
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value == " " ||
                        value == "  " ||
                        value == "   ") {
                      return 'Please enter a memory size!';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    valueSize = newValue!;
                  },
                  initialValue: widget.parameters?['size'],
                ),
              ),
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: DropdownButtonFormField<String>(
                    key: const Key('add-unit-memory'),
                    value: widget.parameters?['unit'],
                    onSaved: (value) {
                      dropdownValue = value!;
                    },
                    validator: (value) {
                      if (value == null || value == '') {
                        return 'Enter a memory unit';
                      }
                      return null;
                    },
                    icon: const Icon(Icons.keyboard_arrow_down),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontFamily: 'mont',
                        fontSize: 14),
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF6CCFF7), width: 2),
                      ),
                      border: OutlineInputBorder(),
                      labelText: 'Memory Unit*',
                      labelStyle: TextStyle(
                          color: Colors.grey, fontFamily: "mont", fontSize: 14),
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                    items: <String>[
                      'GB',
                      'TB',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 14)),
                      );
                    }).toList(),
                  )),
            ],
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
