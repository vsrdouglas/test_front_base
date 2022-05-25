import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:my_app/Models/report_request_model.dart';
import 'package:my_app/Widgets/projdetail_text_line_web.dart';

// ignore: must_be_immutable
class ReportWeb extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  var report;
  late List<ReportRequest> listReport;
  ReportWeb(this.report, this.listReport, {Key? key}) : super(key: key);
  line() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      child: const DottedLine(
        direction: Axis.horizontal,
        lineLength: double.infinity,
        lineThickness: 0.8,
        dashLength: 2,
        dashColor: Colors.black38,
        dashGapLength: 2.0,
        dashGapColor: Colors.transparent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextLineWeb('Project Start Date: ', report['startDate']),
        line(),
        if (report['endDate'] != null) ...[
          TextLineWeb('End Date: ', report['endDate']),
          line(),
        ],
        TextLineWeb(
            'Number of Sprints: ', report['numberOfClosedSprints'].toString()),
        line(),
        TextLineWeb('Budget (per Sprint):', 'R\$${report['budget']}'),
        line(),
        TextLineWeb('Sprint Length: ', report['sprintLength'].toString()),
        line(),
        TextLineWeb('Period Cost: ', costSprint(1)),
        line(),
        TextLineWeb('Total Budget: ', costSprint(2)),
        line(),
        Container(
          width: MediaQuery.of(context).size.width * .17,
          margin: const EdgeInsets.only(top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Flexible(
                child: AutoSizeText(
                  'Period Result: ',
                  maxLines: 1,
                  minFontSize: 8,
                  // presetFontSizes: [28, 14, 5],
                  style: TextStyle(
                    fontFamily: 'montBold',
                    fontSize: 20,
                  ),
                ),
              ),
              Flexible(
                  child: AutoSizeText(
                costSprint(3),
                maxLines: 1,
                minFontSize: 5,
                style: TextStyle(
                  color: double.parse(costSprint(3).split('\$')[1]) >= 0
                      ? Colors.green
                      : Colors.red,
                  fontFamily: 'montBold',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ))
            ],
          ),
        ),
        const SizedBox(height: 10.0)
      ],
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
        totalBudget = double.parse(report['budget']) * (listReport.length);
      }
      return 'R\$' + totalBudget.toStringAsFixed(2);
    } else {
      return 'R\$' + result.toStringAsFixed(2);
    }
  }
}
