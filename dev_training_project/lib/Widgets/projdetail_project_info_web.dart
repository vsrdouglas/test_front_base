import 'package:flutter/material.dart';
import 'projdetail_text_line_web.dart';
import 'package:dotted_line/dotted_line.dart';

class ProjectInfoWeb extends StatelessWidget {
  final dynamic projectDetails;
  const ProjectInfoWeb(this.projectDetails, {Key? key}) : super(key: key);
  line() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
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
    return Container(
      alignment: Alignment.centerLeft,
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        // TextLine('Client: ', 'xxxxxxx'),
        TextLineWeb('Status: ', projectDetails['status']),
        line(),
        TextLineWeb('Start Date: ', projectDetails['startDate']),
        line(),
        if (projectDetails['status'] == 'closed' &&
            projectDetails['endDate'] != null) ...[
          TextLineWeb('End Date: ', projectDetails['endDate']),
          line(),
        ],
        TextLineWeb('Budget Type: ', projectDetails['paymentType']),
        line(),
        TextLineWeb('Sprint length: ',
            projectDetails['sprintLength'].toString() + ' days'),
        line(),
        TextLineWeb('Budget (per Sprint): ', 'R\$' + projectDetails['budget']),
        line(),
      ]),
    );
  }
}
