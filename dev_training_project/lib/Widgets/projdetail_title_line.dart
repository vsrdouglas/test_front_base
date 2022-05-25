// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../PopUps/projdetail_editproject.dart';
import '../app_constants.dart';
import '../PopUps/warning_popup.dart';

// ignore: must_be_immutable
class TitleLine extends StatelessWidget {
  final StreamController refreshController;
  final String lineText;
  String projectName;
  String projectStatus;
  final projectId;
  final usersProject;
  var ctx;
  late DateTime _dateTime = DateTime.now();
  String text = 'End Date';
  final projectStartDate;
  late bool isWeb;
  // ignore: use_key_in_widget_constructors
  TitleLine(
      this.ctx,
      this.lineText,
      this.projectId,
      this.projectStatus,
      this.projectName,
      this.refreshController,
      this.usersProject,
      this.projectStartDate,
      this.isWeb);

  sendEdit(name, status, textdate) async {
    if (status != "closed" || projectStatus == "closed") {
      final response = await http.put(
        Uri.parse(projectsUrl + '/' + projectId),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          "name": name,
          "status": status,
        }),
      );
      checkResponse(response);
    } else {
      final response = await http.put(
        Uri.parse(projectsUrl + '/' + projectId),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          "name": name,
          "status": status,
          "endDate": textdate,
        }),
      );
      checkResponse(response);
    }
  }

  checkResponse(response) {
    if (response.statusCode == 200) {
      return ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(
          content: Text(
            'Project succesfully edited',
            style: TextStyle(fontFamily: 'mont'),
          ),
        ),
      );
    } else {
      return showDialog(
        context: ctx,
        builder: (BuildContext context) => Warning(context, response.body),
      );
    }
  }

  Future fetchData() async {
    final data =
        await http.get(Uri.parse(projectsUrl + '/' + projectId), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    return jsonDecode(data.body);
  }

  Future<void> handleRefresh() async {
    await fetchData().then((res) {
      refreshController.add(res);

      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isWeb ? null : double.infinity,
      margin:
          isWeb ? null : const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      decoration: isWeb
          ? null
          : const BoxDecoration(
              // color: Colors.amber,
              border: Border(
                  bottom: BorderSide(color: Color(0xFF213E4B), width: 1))),
      child: Row(
        mainAxisAlignment: isWeb
            ? MainAxisAlignment.spaceAround
            : MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: AutoSizeText(
              lineText,
              maxLines: 2,
              style: TextStyle(
                fontFamily: 'montBold',
                fontSize: 22,
                color: isWeb ? Colors.black : const Color(0xFF213E4B),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => EditProjectPopup(
                    ctx, projectId, projectStatus, projectName, usersProject),
              ).then((value) async {
                if (projectStatus == "closed") {
                  await sendEdit(value[0], value[1], null);
                  handleRefresh();
                } else if (value[1] == "closed") {
                  await showDatePicker(
                          helpText: 'Select the last day of the project',
                          context: context,
                          initialDate:
                              DateFormat('yyyy-MM-dd').parse(projectStartDate),
                          firstDate:
                              DateFormat('yyyy-MM-dd').parse(projectStartDate),
                          lastDate: DateTime(2050))
                      .then(
                    (date) async {
                      _dateTime = date!;
                      text = DateFormat("yyyy-MM-dd").format(_dateTime);
                      await sendEdit(value[0], value[1], text);
                      handleRefresh();
                    },
                  );
                } else {
                  await sendEdit(value[0], value[1], null);
                  handleRefresh();
                }
              });
            },
            icon: Icon(
              Icons.mode_edit,
              key: const Key('edit-project'),
              color: isWeb ? Colors.black : const Color(0xFF213E4B),
            ),
            iconSize: 30,
          ),
        ],
      ),
    );
  }
}
