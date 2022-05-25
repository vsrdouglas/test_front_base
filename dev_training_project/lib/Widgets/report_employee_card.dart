// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:my_app/PopUps/history_employee.dart';

import '../app_constants.dart';
import '../helpers.dart';

// ignore: must_be_immutable
class EmployeeCard extends StatelessWidget {
  final String id, employeeName;
  var employeeCost;
  var employeeTotal;
  var employeeImageThumb;
  final String projectId;
  String startDate, endDate;

  EmployeeCard(
      this.id,
      this.employeeName,
      this.employeeCost,
      this.employeeTotal,
      this.employeeImageThumb,
      this.projectId,
      this.startDate,
      this.endDate,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      margin: const EdgeInsets.symmetric(
        vertical: 0,
        horizontal: 0,
      ),
      child: ListTile(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) =>
                HistoryEmployee(id, projectId, startDate, endDate),
          );
        },
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(50.0),
          child: CachedNetworkImage(
            imageUrl: employeeImageThumb,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) =>
                Image.network(defaultImageThumb),
          ),
        ),
        title: AutoSizeText(nameSpliter(employeeName),
            maxLines: 2,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontFamily: 'mont',
            )),
        trailing: Container(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.40),
          padding: const EdgeInsets.only(left: 7, top: 8),
          decoration: const BoxDecoration(
              border: Border(
                  left: BorderSide(color: Color(0xFFCECECE), width: 0.7))),
          child: SingleChildScrollView(
            reverse: true,
            scrollDirection: Axis.horizontal,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                AutoSizeText(
                  "Monthly Cost: R\$${employeeCost.toString()}",
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'mont',
                  ),
                ),
                AutoSizeText(
                  'Total: R\$${employeeTotal.toString()}',
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'mont',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
