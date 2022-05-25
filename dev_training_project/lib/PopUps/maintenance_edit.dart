// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../app_constants.dart';
import 'warning_popup.dart';

class EditMaintenance extends StatefulWidget {
  var parentCtx;
  String maintenanceId;
  String editingField;
  String? currentValue;
  final VoidCallback loadData;
  EditMaintenance(this.parentCtx, this.maintenanceId, this.editingField,
      this.currentValue, this.loadData,
      {Key? key})
      : super(key: key);
  @override
  EditMaintenanceState createState() => EditMaintenanceState();
}

class EditMaintenanceState extends State<EditMaintenance> {
  final _form = GlobalKey<FormState>();
  late String? editedValue = widget.currentValue;

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
        return TextInputType.name;
      case 'Cost':
        return TextInputType.number;
      case 'Description':
        return TextInputType.text;
    }
    return null;
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
      case 'Description':
        return (value) {};
    }
  }

  saveField() async {
    if (_form.currentState!.validate() == true) {
      _form.currentState!.save();
      Navigator.of(context).pop();
      await sendEdit();
    }
  }

  sendEdit() async {
    final response = await http.put(
      Uri.parse(equipments + '/maintenance/details/${widget.maintenanceId}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        widget.editingField.toLowerCase(): editedValue,
      }),
    );
    if (response.statusCode == 200) {
      widget.loadData();
      // ScaffoldMessenger.of(widget.parentCtx).showSnackBar(
      //   SnackBar(
      //     content: Text(
      //       widget.editingField + ' succesfully edited',
      //       style: const TextStyle(fontFamily: 'mont'),
      //     ),
      //   ),
      // );
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
              child: widget.editingField != 'Status'
                  ? TextFormField(
                      key: const Key('edit-field-maintenance'),
                      style: const TextStyle(fontFamily: "mont", fontSize: 14),
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFF6CCFF7), width: 2),
                        ),
                        hintText: widget.currentValue,
                        border: const OutlineInputBorder(),
                        prefixText: checkSuffix(widget.editingField),
                        labelText: widget.editingField,
                        labelStyle: const TextStyle(
                            color: Colors.grey,
                            fontFamily: "mont",
                            fontSize: 14),
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
                      initialValue: widget.currentValue,
                      maxLines: widget.editingField == 'Description' ? 2 : 1,
                    )
                  : DropdownButtonFormField<String>(
                      value: widget.currentValue,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontFamily: 'mont',
                          fontSize: 14),
                      onSaved: (value) {
                        widget.currentValue = value!;
                      },
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFF6CCFF7), width: 2),
                        ),
                        border: OutlineInputBorder(),
                        labelText: 'Company',
                        labelStyle: TextStyle(
                            color: Colors.grey,
                            fontFamily: "mont",
                            fontSize: 14),
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          widget.currentValue = newValue!;
                        });
                      },
                      items: <String>[
                        'Complete',
                        'In progress',
                        'Out of service'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 14)),
                        );
                      }).toList(),
                    )),
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
          key: const Key('edit-maintenance-name'),
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
