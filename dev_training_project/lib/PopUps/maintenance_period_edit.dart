// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../app_constants.dart';
import 'warning_popup.dart';

// ignore: must_be_immutable
class EditMaintenancePeriod extends StatefulWidget {
  var ctx;
  late String maintenanceId;
  late String startDate;
  late String endDate;
  EditMaintenancePeriod(
      this.ctx, this.maintenanceId, this.startDate, this.endDate,
      {Key? key})
      : super(key: key);

  @override
  EditMaintenancePeriodState createState() => EditMaintenancePeriodState();
}

class EditMaintenancePeriodState extends State<EditMaintenancePeriod> {
  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  saveField() async {
    _form.currentState!.save();
    Navigator.of(context).pop();
    await sendEdit();
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
        "startDate": widget.startDate,
        "endDate": widget.endDate == 'Active' ? null : widget.endDate,
      }),
    );
    if (response.statusCode == 200) {
      // ScaffoldMessenger.of(widget.ctx).showSnackBar(
      //   const SnackBar(
      //     content: Text(
      //       'Period succesfully edited',
      //       style: TextStyle(fontFamily: 'mont'),
      //     ),
      //   ),
      // );
    } else {
      showDialog(
        context: widget.ctx,
        builder: (BuildContext context) => Warning(context, response.body),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Edit Period',
        style: TextStyle(
          fontFamily: 'montBold',
          fontSize: 22,
        ),
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 232, maxHeight: 132),
        child: Form(
          key: _form,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: TextFormField(
                  key: Key(widget.startDate),
                  style: const TextStyle(fontFamily: "mont", fontSize: 14),
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF6CCFF7), width: 2),
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'From: ',
                    labelStyle: TextStyle(
                        color: Colors.grey, fontFamily: "mont", fontSize: 14),
                  ),
                  initialValue: widget.startDate,
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2010),
                            lastDate: DateTime(2050))
                        .then(
                      (date) {
                        setState(
                          () {
                            widget.startDate =
                                DateFormat("yyyy-MM-dd").format(date!);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: TextFormField(
                  key: Key(widget.endDate),
                  style: const TextStyle(fontFamily: "mont", fontSize: 14),
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF6CCFF7), width: 2),
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'To: ',
                    labelStyle: TextStyle(
                        color: Colors.grey, fontFamily: "mont", fontSize: 14),
                  ),
                  initialValue: widget.endDate,
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    showDatePicker(
                            context: context,
                            initialDate: DateFormat("yyyy-MM-dd")
                                .parse(widget.startDate),
                            firstDate: DateFormat("yyyy-MM-dd")
                                .parse(widget.startDate),
                            lastDate: DateTime(2050))
                        .then(
                      (date) {
                        setState(
                          () {
                            widget.endDate =
                                DateFormat("yyyy-MM-dd").format(date!);
                          },
                        );
                      },
                    );
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
