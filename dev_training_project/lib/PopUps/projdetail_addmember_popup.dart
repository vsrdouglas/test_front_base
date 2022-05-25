// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../app_constants.dart';
import '../Models/addmember_model.dart';
import 'warning_popup.dart';

class AddMemberPopup extends StatefulWidget {
  MemberModel employee;
  String projectId;
  String projectStartDate;
  var ctx;
  AddMemberPopup(this.ctx, this.employee, this.projectId, this.projectStartDate,
      {Key? key})
      : super(key: key);
  @override
  AddMemberPopupState createState() => AddMemberPopupState();
}

class AddMemberPopupState extends State<AddMemberPopup> {
  final _form = GlobalKey<FormState>();
  late DateTime _dateTime = DateTime.now();
  String text = 'Start-Date';
  late MemberCreation _addMember;
  late double rating;
  AddMemberPopupState();

  addMember(MemberCreation userData) async {
    final response = await http.post(
      Uri.parse(projectsUrl +
          '/${widget.projectId}' +
          '/add' +
          '/${widget.employee.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "teamRole": userData.teamRole,
        "allocation": userData.allocation,
        "startDate": userData.startDate,
      }),
    );

    if (response.statusCode == 200) {
      return ScaffoldMessenger.of(widget.ctx).showSnackBar(
        const SnackBar(
          content: Text(
            'Member succesfully added to the project',
            style: TextStyle(fontFamily: 'mont'),
          ),
        ),
      );
    } else {
      return showDialog(
        context: widget.ctx,
        builder: (BuildContext context) => Warning(context, response.body),
      );
    }
  }

  checkZero(allocation) {
    if (allocation == 0) {
      return 0.05;
    } else {
      return allocation;
    }
  }

  void _saveMember() async {
    if (_form.currentState!.validate() == true) {
      _form.currentState!.save();
      Navigator.of(context).pop(true);
      await addMember(_addMember);
    }
  }

  @override
  void initState() {
    super.initState();
    _addMember = MemberCreation('', widget.employee.allocation, '', '');
    rating = 5;
    _addMember.allocation = rating / 100;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text(
          'Add Member',
          style: TextStyle(fontFamily: "montBold", fontSize: 22),
        ),
        Text(
          widget.employee.name,
          style: const TextStyle(
              fontFamily: "mont", color: Colors.grey, fontSize: 18),
        ),
      ]),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.70,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _form,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: TextFormField(
                      key: const Key('addMember-role'),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                      ],
                      style: const TextStyle(fontFamily: "mont", fontSize: 14),
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFF6CCFF7), width: 2),
                        ),
                        border: OutlineInputBorder(),
                        labelText: 'Role: ',
                        labelStyle: TextStyle(
                            color: Colors.grey,
                            fontFamily: "mont",
                            fontSize: 14),
                      ),
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value == " " ||
                            value == "  " ||
                            value == "   ") {
                          return 'Please enter a team role!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _addMember.teamRole = value;
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: TextFormField(
                      key: const Key('start-date'),
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFF6CCFF7), width: 2),
                        ),
                        border: const OutlineInputBorder(),
                        labelText: text,
                        labelStyle: const TextStyle(
                            color: Colors.grey,
                            fontFamily: "mont",
                            fontSize: 14),
                        suffixIcon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey[600],
                        ),
                      ),
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateFormat('yyyy-MM-dd')
                                    .parse(widget.projectStartDate),
                                lastDate: DateTime(2050))
                            .then(
                          (date) {
                            setState(
                              () {
                                _dateTime = date!;
                                text =
                                    DateFormat("yyyy-MM-dd").format(_dateTime);
                                _addMember.startDate = text;
                              },
                            );
                          },
                        );
                      },
                      validator: (value) {
                        if (text == 'Start-Date') {
                          return 'Please enter a date.';
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 5, left: 3),
                            child: const Text(
                              'Availability: ',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'mont',
                                  fontSize: 14),
                            ),
                          ),
                          SliderTheme(
                            // ignore: prefer_const_constructors
                            data: SliderThemeData(
                              trackHeight: 1,
                              trackShape: const RoundedRectSliderTrackShape(),
                            ),
                            child: Slider(
                              label: rating.toStringAsFixed(0),
                              value: rating,
                              onChanged: (newvalue) {
                                setState(() {
                                  rating = newvalue.roundToDouble();
                                  _addMember.allocation = rating / 100;
                                });
                              },
                              divisions: (100 -
                                  (widget.employee.allocation! * 100).toInt()),
                              // (100 - (widget.employee.allocation * 100).toInt() ),
                              max: (100 - (widget.employee.allocation! * 100))
                                  .roundToDouble(),
                            ),
                          ),
                          Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    '0%',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: 'mont',
                                        fontSize: 12),
                                  ),
                                  Text(
                                    (100 - (widget.employee.allocation! * 100))
                                            .toStringAsFixed(0) +
                                        '%',
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontFamily: 'mont',
                                        fontSize: 12),
                                  ),
                                ],
                              )),
                        ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
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
            _saveMember();
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
