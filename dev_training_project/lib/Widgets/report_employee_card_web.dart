// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:my_app/PopUps/history_employee.dart';

import '../app_constants.dart';
import '../helpers.dart';

// ignore: must_be_immutable
class EmployeeCardWeb extends StatelessWidget {
  final String id, employeeName;
  var employeeCost;
  var employeeTotal;
  var employeeImageThumb;
  final String projectId;
  String startDate, endDate;

  EmployeeCardWeb(
      {required this.id,
      required this.employeeName,
      this.employeeCost,
      this.employeeTotal,
      this.employeeImageThumb,
      required this.projectId,
      required this.startDate,
      required this.endDate,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .15,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) =>
                HistoryEmployee(id, projectId, startDate, endDate),
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Color(0xFF6CCFF7), width: 2),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Row(children: [
            const SizedBox(width: 20.0),
            ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: CachedNetworkImage(
                width: 50,
                imageUrl: employeeImageThumb,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    Image.network(defaultImageThumb),
              ),
            ),
            const SizedBox(width: 20.0),
            AutoSizeText(nameSpliter(employeeName),
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontFamily: 'mont',
                )),
            const SizedBox(width: 40.0),
            Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.40),
              padding: const EdgeInsets.only(left: 40, top: 8, bottom: 8),
              decoration: const BoxDecoration(
                  border: Border(
                      left: BorderSide(color: Color(0xFFCECECE), width: 0.7))),
              child: SingleChildScrollView(
                reverse: true,
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AutoSizeText(
                      "Current Cost per Month: R\$${employeeCost.toString()}",
                      maxLines: 1,
                      minFontSize: 10,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'mont',
                      ),
                    ),
                    AutoSizeText(
                      'Project Total Cost: R\$${employeeTotal.toString()}',
                      maxLines: 1,
                      minFontSize: 10,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'mont',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
