// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:my_app/PopUps/employees_add_employee_popup.dart';

import '../Screens/info_dashboard.dart';

var infoEmployeeT;

class StatisticsEmployee extends StatefulWidget {
  StreamController refreshControllerE;
  var infoEmployee;
  StatisticsEmployee(this.refreshControllerE, this.infoEmployee, {Key? key})
      : super(key: key);

  @override
  StatisticsEmployeeState createState() => StatisticsEmployeeState();
}

class StatisticsEmployeeState extends State<StatisticsEmployee> {
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
    return Material(
      child: Container(
        height: 230,
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFF6CCFF7),
            width: 1,
          ),
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(3)),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.5),
              offset: Offset(1, 1),
              blurRadius: 0.5,
              spreadRadius: 1,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const AutoSizeText(
                'Employees',
                maxLines: 1,
                style: TextStyle(
                  fontFamily: "mont",
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.person_add_alt,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AddEmployeePopup(
                        context, ctx, widget.refreshControllerE, true),
                  ).then((value) async {
                    handleRefresh();
                    EInfoDashBoardState().loadData1();
                    EInfoDashBoardState().loadData3();
                    EInfoDashBoardState().handleRefresh1();
                    EInfoDashBoardState().handleRefresh3();
                  });
                },
              ),
            ]),
            AutoSizeText(
              widget.infoEmployee['numberOfUsers'].toString(),
              maxLines: 1,
              style: const TextStyle(
                fontFamily: "montBold",
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(spacing: 20.0, runSpacing: 7.0, children: [
              AutoSizeText(
                'Allocated: ' + widget.infoEmployee['allocated'].toString(),
                maxLines: 1,
                style: const TextStyle(
                  fontFamily: "montBold",
                  color: Colors.green,
                  fontSize: 12,
                ),
              ),
              AutoSizeText(
                'Unallocated: ' + widget.infoEmployee['unallocated'].toString(),
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
    );
  }
}
