import 'package:flutter/material.dart';
import 'package:my_app/Screens/report_screen.dart';
import 'projdetail_text_line.dart';

class ProjectInfo extends StatelessWidget {
  final dynamic projectDetails;
  const ProjectInfo(this.projectDetails, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Expanded(
        flex: 1,
        child: Container(
          alignment: Alignment.centerLeft,
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            // TextLine('Client: ', 'xxxxxxx'),
            TextLine('Status: ', projectDetails['status']),
            TextLine('Start Date: ', projectDetails['startDate']),
            if (projectDetails['status'] == 'closed' &&
                projectDetails['endDate'] != null) ...[
              TextLine('End Date: ', projectDetails['endDate'])
            ],
            TextLine('Budget Type: ', projectDetails['paymentType']),
            TextLine('Sprint length: ',
                projectDetails['sprintLength'].toString() + ' days'),
            TextLine('Budget (per Sprint): ', 'R\$' + projectDetails['budget']),
          ]),
        ),
      ),
      ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReportScreen(projectDetails['id']),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(
            side: BorderSide.none,
          ),
          fixedSize: const Size(70, 70),
          shadowColor: Colors.black,
          elevation: 10.0,
        ),
        child: Image.asset(
          "images/report_detail.png",
          fit: BoxFit.contain,
          width: 50,
        ),
      )
    ]);
  }
}
