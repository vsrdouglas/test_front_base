import 'package:flutter/material.dart';
import 'package:my_app/Models/report_request_model.dart';
import 'report_text_line.dart';

// ignore: must_be_immutable
class Report extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  var report;
  late List<ReportRequest> listReport;
  late int sprintStart;
  late int sprintEnd;
  Report(this.report, this.listReport, this.sprintStart, this.sprintEnd,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          TextLine('Project Start Date: ', report['startDate']),
          if (report['endDate'] != null) ...[
            TextLine('End Date: ', report['endDate']),
          ],
          TextLine('Number Of Sprints: ',
              report['numberOfClosedSprints'].toString()),
          TextLine('Budget (per Sprint): ', 'R\$${report['budget']}'),
          TextLine('Sprint Length: ', report['sprintLength'].toString()),
          TextLine('Period Cost: ', costSprint(1)),
          TextLine('Total Budget: ', costSprint(2)),
          TextLine('Period Result: ', costSprint(3)),
        ],
      ),
    );
  }

  String costSprint(int flag) {
    double cost = 0;
    double result = 0;
    late double totalBudget;
    for (int i = 0; i < listReport.length; i++) {
      cost += double.parse(listReport[i].sprintCost);
      result += double.parse(listReport[i].sprintResult);
    }
    if (flag == 1) {
      return 'R\$' + cost.toStringAsFixed(2);
    } else if (flag == 2) {
      if (report['numberOfClosedSprints'] == 0) {
        totalBudget = 0;
      } else {
        totalBudget =
            (double.parse(report['budget']) * (sprintEnd - sprintStart + 1));
      }
      return 'R\$' + totalBudget.toStringAsFixed(2);
    } else {
      return 'R\$' + result.toStringAsFixed(2);
    }
  }
}
