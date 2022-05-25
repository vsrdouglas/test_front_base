// ignore_for_file: non_constant_identifier_names, body_might_complete_normally_nullable

import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/app_constants.dart';
import 'info_dashboard.dart';
import 'projects_screen.dart';

import '../PopUps/warning_popup.dart';

// ignore: must_be_immutable
class AddEntryDialog extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  var parentCtx;
  StreamController refreshController;
  bool flag;

  AddEntryDialog(this.parentCtx, this.refreshController, this.flag, {Key? key})
      : super(key: key);
  @override
  AddEntryDialogState createState() => AddEntryDialogState();
}

class AddEntryDialogState extends State<AddEntryDialog> {
  late DateTime _dateTime = DateTime.now();
  final _form = GlobalKey<FormState>();

  late String projectName = '';
  late double projectBudget = 0;
  int? sprintLenght;
  int? aux;
  String text = 'Start Date';

  Future handleRefresh() async {
    if (widget.flag) {
      await infoEmployeesU().then((res) {
        widget.refreshController.add(res);

        return null;
      });
    } else {
      await fetchData().then((res) {
        widget.refreshController.add(res);

        return null;
      });
    }
  }

  createProject(List<dynamic> dadosTextFild) async {
    final response = await http.post(
      Uri.parse(projectsUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'name': dadosTextFild[0],
        'status': 'open',
        'budget': dadosTextFild[1],
        'paymentType': 'sprint',
        'sprintLength': dadosTextFild[3],
        'startDate': dadosTextFild[4],
      }),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(widget.parentCtx).showSnackBar(
        const SnackBar(
          content: Text(
            'Project succesfully added',
            style: TextStyle(fontFamily: 'mont'),
          ),
        ),
      );
      // return ProjectData.fromJson(jsonDecode(response.body));
    } else {
      showDialog(
        context: widget.parentCtx,
        builder: (BuildContext context) => Warning(context, response.body),
      );
    }
  }

  ResponsiveContainer(context, double sizeLarge) {
    return Container(
      margin: EdgeInsets.only(top: 50, right: sizeLarge, left: sizeLarge),
      child: Form(
        key: _form,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
              child: TextFormField(
                key: const Key('add-project-name'),
                style: const TextStyle(fontFamily: "mont", fontSize: 14),
                maxLines: 1,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF6CCFF7), width: 2),
                  ),
                  border: OutlineInputBorder(),
                  labelText: 'Name: ',
                  labelStyle: TextStyle(
                      color: Colors.grey, fontFamily: "mont", fontSize: 14),
                ),
                keyboardType: TextInputType.name,
                // autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.split('')[0] == " ") {
                    return 'Please enter a valid Name';
                  }
                  return null;
                },
                onChanged: (value) => setState(() => projectName = value),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
              child: TextFormField(
                key: const Key('add-project-budget'),
                style: const TextStyle(fontFamily: "mont", fontSize: 14),
                maxLines: 1,
                decoration: const InputDecoration(
                  prefixText: 'R\$',
                  hintText: '0000.00',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF6CCFF7), width: 2),
                  ),
                  border: OutlineInputBorder(),
                  labelText: 'Budget: ',
                  labelStyle: TextStyle(
                      color: Colors.grey, fontFamily: "mont", fontSize: 14),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter(',',
                      allow: false, replacementString: '.'),
                  FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}")),
                ],
                // autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a budget';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid budget.';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please enter a budget greater than zero.';
                  }
                  return null;
                },
                onChanged: (value) =>
                    setState(() => projectBudget = double.parse(value)),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
              child: TextFormField(
                  key: const Key('add-project-sprint'),
                  style: const TextStyle(fontFamily: "mont", fontSize: 14),
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF6CCFF7), width: 2),
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'Sprint-Lenght (Business Days)',
                    labelStyle: TextStyle(
                        color: Colors.grey, fontFamily: "mont", fontSize: 14),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r"^\d+")),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a sprint lenght.';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number.';
                    }
                    if (int.parse(value) <= 0) {
                      return 'Please enter a number greater than zero.';
                    }
                  },
                  onChanged: (value) {
                    setState(() => sprintLenght = int.parse(value));
                  }),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
              child: TextFormField(
                key: const Key('add-project-startDate'),
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF6CCFF7), width: 2),
                  ),
                  border: const OutlineInputBorder(),
                  labelText: text,
                  labelStyle: const TextStyle(
                      color: Colors.grey, fontFamily: "mont", fontSize: 14),
                  suffixIcon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey[600],
                  ),
                ),
                validator: (value) {
                  if (text == 'Start Date') {
                    return 'Please enter a date.';
                  }
                },
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1980),
                          lastDate: DateTime(2050))
                      .then(
                    (date) {
                      setState(
                        () {
                          _dateTime = date!;
                          text = DateFormat("yyyy-MM-dd").format(_dateTime);
                        },
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              key: const Key('add-project-button'),
              borderRadius: BorderRadius.circular(20),
              onTap: () async {
                List<dynamic> dados = [
                  projectName,
                  projectBudget,
                  'sprint',
                  sprintLenght,
                  text.toString()
                ];

                if (_form.currentState!.validate()) {
                  Navigator.of(context).pop();
                  _form.currentState!.save();
                  await createProject(dados);
                  handleRefresh();
                  EInfoDashBoardState().handleRefresh1();
                  EInfoDashBoardState().handleRefresh2();
                  EInfoDashBoardState().handleRefresh3();
                }
              },
              child: Container(
                height: 40,
                width: 300,
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                      offset: Offset(1, 1),
                      blurRadius: 1.5,
                      spreadRadius: 1,
                    )
                  ],
                  color: const Color(0xFF6CCFF7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: AutoSizeText(
                    'Add Project',
                    maxLines: 1,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "montBold",
                        fontSize: 20),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          borderRadius: BorderRadius.circular(500),
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            padding: const EdgeInsets.only(left: 20),
            height: double.infinity,
            width: double.infinity,
            child: Container(
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 5,
                    spreadRadius: 2,
                    offset: Offset(2, 2),
                  )
                ],
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.black,
                size: 30,
              ),
            ),
          ),
        ),
        leadingWidth: 70,
        toolbarHeight: 80,
        backgroundColor: const Color(0xFF6CCFF7),
        title: Container(
          padding: const EdgeInsets.only(right: 80),
          width: double.infinity,
          child: const AutoSizeText(
            'Add Project',
            maxLines: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'montBold',
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth <= 600) {
          return ResponsiveContainer(context, 5.0);
        } else if (constraints.maxWidth > 600 && constraints.maxWidth <= 1000) {
          return ResponsiveContainer(context, 200.0);
        } else if (constraints.maxWidth > 1000 &&
            constraints.maxWidth <= 1200) {
          return ResponsiveContainer(context, 350.0);
        } else if (constraints.maxWidth > 1200 && constraints.maxWidth < 1500) {
          return ResponsiveContainer(context, 450.0);
        } else {
          return ResponsiveContainer(context, 550.0);
        }
      }),
    );
  }
}
