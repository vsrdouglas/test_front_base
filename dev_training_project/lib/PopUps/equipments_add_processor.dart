// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../app_constants.dart';
import 'warning_popup.dart';

class EquipmentsAddProcessor extends StatefulWidget {
  var parentCtx;
  Map<String, dynamic>? parameters;
  Function refresh;
  EquipmentsAddProcessor(
      {required this.parentCtx,
      required this.refresh,
      this.parameters,
      Key? key})
      : super(key: key);
  @override
  EquipmentsAddProcessorState createState() => EquipmentsAddProcessorState();
}

class EquipmentsAddProcessorState extends State<EquipmentsAddProcessor> {
  final _form = GlobalKey<FormState>();
  late String valueBrand, valueModel, valueGeneration;

  saveField() async {
    if (_form.currentState!.validate() == true) {
      _form.currentState!.save();
      Navigator.of(context).pop();
      if (widget.parameters == null) {
        await sendAdd();
      } else {
        await sendEdit();
      }
    }
    widget.refresh();
  }

  sendEdit() async {
    final response = await http.put(
      Uri.parse(equipments + '/processor/' + widget.parameters!['id']),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{"model": valueModel}),
    );
    if (response.statusCode == 200) {
      return ScaffoldMessenger.of(widget.parentCtx).showSnackBar(
        const SnackBar(
          content: Text(
            'Processor succesfully edit',
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
      Uri.parse(equipments + '/processor'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{"model": valueModel}),
    );
    if (response.statusCode == 200) {
      return ScaffoldMessenger.of(widget.parentCtx).showSnackBar(
        const SnackBar(
          content: Text(
            'Processor succesfully add',
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
        'Add Processor',
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
                  key: const Key('add-processor'),
                  style: const TextStyle(fontFamily: "mont", fontSize: 14),
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF6CCFF7), width: 2),
                    ),
                    hintText: 'Intel i7 Gen 10',
                    border: OutlineInputBorder(),
                    labelText: 'Model*',
                    labelStyle: TextStyle(
                        color: Colors.grey, fontFamily: "mont", fontSize: 14),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value == " " ||
                        value == "  " ||
                        value == "   ") {
                      return 'Please enter a model!';
                    }
                    return null;
                  },
                  initialValue: widget.parameters?['model'],
                  onSaved: (newValue) {
                    valueModel = newValue!;
                  },
                ),
              ),
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
