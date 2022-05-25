import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:my_app/Models/report_user_model.dart';

import 'report_employee_card.dart';

// ignore: must_be_immutable
class Members extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  late Map<String, ReportUserModel> userInfo;
  final String dadoId;
  String startDate, endDate;
  Members(this.userInfo, this.dadoId, this.startDate, this.endDate, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 30),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(left: 20),
            child: const Text(
              'Members: ',
              style: TextStyle(
                fontFamily: 'montBold',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Column(
            children: checkEmployees(userInfo),
          ),
        ],
      ),
    );
  }

  checkEmployees(Map<String, ReportUserModel> userInfo) {
    if (userInfo.isNotEmpty) {
      return employeeList(userInfo);
    } else {
      return [
        Container(
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          alignment: Alignment.center,
          child: const AutoSizeText(
            'No Assignments found for the selected period!',
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              fontFamily: 'montBold',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ];
    }
  }

  List<Widget> employeeList(Map<String, ReportUserModel> userInfo) {
    List<Widget> list = userInfo.entries
        .map((value) => EmployeeCard(
            value.key,
            value.value.name,
            value.value.monthlyWage,
            value.value.costAtSprint.toStringAsFixed(2),
            value.value.imageThumb,
            dadoId,
            startDate,
            endDate))
        .toList();
    return list;
  }
}
