// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:my_app/Models/report_request_model.dart';
import 'package:my_app/Models/report_user_model.dart';
import '../Models/report_estatic_pdf.dart';

class TitleLineWeb extends StatelessWidget {
  final String lineText;
  var dados;
  late List<ReportRequest> listReport;
  late Map<String, ReportUserModel> userInfo;

  TitleLineWeb(this.lineText, this.dados, this.listReport, this.userInfo,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: AutoSizeText(
            'Report of: $lineText',
            maxLines: 2,
            style: const TextStyle(
              fontFamily: 'montBold',
              fontSize: 20,
              color: Color(0xFF213E4B),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(width: 5.0),
        IconButton(
          onPressed: () => {generateData(dados, listReport, userInfo)},
          icon: const Icon(
            Icons.file_download_outlined,
            color: Color(0xFF213E4B),
          ),
          iconSize: 30,
        ),
      ],
    );
  }
}
