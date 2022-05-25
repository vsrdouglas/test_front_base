// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:my_app/Models/report_generate_pdf.dart';
import 'package:my_app/Models/report_request_model.dart';

import 'report_pdf_model.dart';
import 'report_user_model.dart';

generateData(reportInfo, List<ReportRequest> listReport,
    Map<String, ReportUserModel> userInfo) async {
  // await fetchData(dados);
  Invoice invoice = Invoice();
  var endDate;
  int sprintLength;
  if (reportInfo['endDate'] == null) {
    endDate = 'This Project is Open';
  } else {
    endDate = reportInfo['endDate'];
  }

  if (reportInfo['sprintLength'] == null) {
    sprintLength = 0;
  } else {
    sprintLength = reportInfo['sprintLength'];
  }

  double periodBudget = double.parse(reportInfo['budget']) * listReport.length;

  double periodCost = 0;
  double periodResult = 0;
  for (int i = 0; i < listReport.length; i++) {
    periodCost += double.parse(listReport[i].sprintCost);
    periodResult += double.parse(listReport[i].sprintResult);
  }

  invoice.report = Report(
      reportInfo['name'],
      listReport.first.startDate,
      listReport.last.endDate,
      reportInfo['startDate'],
      endDate,
      reportInfo['paymentType'],
      sprintLength,
      reportInfo['budget'],
      periodBudget.toString(),
      periodCost.toString(),
      periodResult.toStringAsFixed(2));

  List<Member> membersData = [];

  if (userInfo.isNotEmpty) {
    userInfo.entries.map((value) {
      membersData.add(Member(value.value.name, value.value.monthlyWage,
          value.value.costAtSprint.toStringAsFixed(2)));
    }).toList();
  } else {
    membersData = [];
  }
  invoice.members = membersData;
  GeneratePDF generatePdf = GeneratePDF(invoice: invoice);
  generatePdf.generatePDFInvoice();
}
