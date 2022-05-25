// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:my_app/PopUps/employees_add_employee_popup.dart';

import '../Screens/info_dashboard.dart';

var infoEmployeeT;

class StatisticsEmployeeApp extends StatefulWidget {
  StreamController refreshControllerE;
  var infoEmployee;
  StatisticsEmployeeApp(this.refreshControllerE, this.infoEmployee, {Key? key})
      : super(key: key);

  @override
  StatisticsEmployeeAppState createState() => StatisticsEmployeeAppState();
}

class StatisticsEmployeeAppState extends State<StatisticsEmployeeApp> {
  Future handleRefresh() async {
    await infoEmployeesU().then((res) {
      widget.refreshControllerE.add(res);
      return null;
    });
  }

  @override
  void initState() {
    super.initState();
    // handleRefresh();
  }

  @override
  Widget build(BuildContext context) {
    var ctx = context;
    return Card(
      elevation: 10,
      shadowColor: Colors.grey,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3),
        side: const BorderSide(color: Color(0xFF6CCFF7), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 30, bottom: 30, left: 20),
        child: Theme(
          data: ThemeData().copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.only(right: 20),
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(
                    child: AutoSizeText(
                      'Employees',
                      maxLines: 1,
                      style: TextStyle(
                        fontFamily: "mont",
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 20),
                    child: IconButton(
                      key: const Key('add-employee-dashboard'),
                      icon: const Icon(
                        Icons.person_add_alt,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AddEmployeePopup(
                              context, ctx, widget.refreshControllerE, true),
                        ).then((value) async {
                          // loadData();
                          // handleRefresh();
                        });
                      },
                    ),
                  ),
                ]),
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 25),
                width: double.infinity,
                child: AutoSizeText(
                  widget.infoEmployee['numberOfUsers'].toString(),
                  maxLines: 1,
                  style: const TextStyle(
                    fontFamily: "montBold",
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(children: [
                AutoSizeText(
                  'Allocated: ' + widget.infoEmployee['allocated'].toString(),
                  maxLines: 1,
                  style: const TextStyle(
                    fontFamily: "montBold",
                    color: Colors.green,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 20),
                AutoSizeText(
                  'Unallocated: ' +
                      widget.infoEmployee['unallocated'].toString(),
                  maxLines: 1,
                  style: const TextStyle(
                    color: Colors.red,
                    fontFamily: "montBold",
                    fontSize: 12,
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
