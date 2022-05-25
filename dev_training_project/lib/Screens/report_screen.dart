// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Models/custom/custom_forecast_thumb_slider.dart';
import '../Models/custom/custom_forecast_track_slider.dart';
import '../Models/report_request_model.dart';
import '../PopUps/forecast_sprints.dart';
import '../PopUps/warning_popup.dart';
import '../Widgets/details_backbutton.dart';
import '../Widgets/report_data_web.dart';
import '../Widgets/report_members_web.dart';
import '../Widgets/report_title_line.dart';
import '../Widgets/report_title_line_web.dart';
import '../Models/report_user_model.dart';
import '../app_constants.dart';
import '../Widgets/report_close_button.dart';
import '../Widgets/report_members.dart';
import '../Widgets/report_data.dart';

// ignore: must_be_immutable
class ReportScreen extends StatefulWidget {
  late String dadoId;

  ReportScreen(infoId, {Key? key}) : super(key: key) {
    dadoId = infoId;
  }

  @override
  ReportScreenState createState() => ReportScreenState();
}

class ReportScreenState extends State<ReportScreen> {
  late String dadoIdProject;
  late StreamController refreshController;
  var selectRanger = const RangeValues(1, 1);
  late List<ReportRequest> listReport;
  late Map<String, ReportUserModel> mapUsers;
  late dynamic reportSprints;
  int numbForecastSprints = 0;

  var tecnologies;

  Future fetchData() async {
    final data = await http
        .get(Uri.parse(projectsUrl + 'report/' + widget.dadoId), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (data.statusCode == 200) {
      reportSprints = jsonDecode(data.body)['sprints'];
      return jsonDecode(data.body);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => Warning(context, data.body),
      ).then((_) => Navigator.of(context).pop());
    }
  }

  loadDataReport() async {
    refreshController.add(null);
    await fetchData().then((res) async {
      refreshController.add(res);
      selectRanger = RangeValues(1, reportSprints.length.toDouble());
      return res;
    });
  }

  @override
  void dispose() {
    super.dispose();
    // refreshController.close();
  }

  @override
  void initState() {
    refreshController = StreamController();
    loadDataReport();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: refreshController.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          dynamic report = snapshot.data;
          listReport = modelReport(report['sprints'],
              (selectRanger.start).round(), (selectRanger.end).round());
          mapUsers = usersReport(report['sprints'],
              (selectRanger.start).round(), (selectRanger.end).round());
          return LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth <= 1000) {
              return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  leading: const CloseButtonWhite(),
                  leadingWidth: 70,
                  toolbarHeight: 80,
                  backgroundColor: const Color(0xFF6CCFF7),
                  title: PreferredSize(
                    preferredSize: const Size(double.infinity, 70),
                    child:
                        TitleLine(report['name'], report, listReport, mapUsers),
                  ),
                ),
                body: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    Column(
                      children: <Widget>[
                        const SizedBox(height: 20),
                        Visibility(
                          visible: report['numberOfClosedSprints'] == 0,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              SizedBox(width: 3.0),
                              Icon(
                                Icons.info_outline_rounded,
                                color: Colors.red,
                              ),
                              SizedBox(width: 7.0),
                              Expanded(
                                child: Text(
                                  'This project hasn\'t started so it has no period result',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        const Text(
                          'Select period: ',
                          style: TextStyle(fontFamily: 'mont', fontSize: 16),
                        ),
                        Text(
                          listReport.first.startDate +
                              ' - ' +
                              listReport.last.endDate,
                          style:
                              const TextStyle(fontFamily: 'mont', fontSize: 16),
                        ),
                        sliderSprints(
                            (report['sprints'].length).toDouble(), constraints),
                        Report(report, listReport, selectRanger.start.toInt(),
                            selectRanger.end.toInt()),
                        const SizedBox(height: 20),
                        numbForecastSprints == 0
                            ? forecastButton(
                                2,
                                report['startDate'],
                                report['sprintLength'],
                                report['id'],
                                report['numberOfClosedSprints'])
                            : forecastCancelButton(),
                        Members(
                            mapUsers,
                            widget.dadoId,
                            listReport.first.startDate,
                            listReport.last.endDate),
                      ],
                    )
                  ],
                ),
              );
            } else {
              return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  leading: const BackButtonWhite(),
                  leadingWidth: 70,
                  toolbarHeight: 80,
                  backgroundColor: const Color(0xFF6CCFF7),
                ),
                body:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Container(
                    width: constraints.maxWidth * 0.25,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom: BorderSide(color: Colors.grey, width: 0.7)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 4,
                          offset: Offset(2, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      child: Column(
                        children: [
                          const SizedBox(height: 15.0),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            child: TitleLineWeb(
                                report['name'], report, listReport, mapUsers),
                          ),
                          const SizedBox(height: 20.0),
                          Visibility(
                            visible: report['numberOfClosedSprints'] == 0,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                SizedBox(width: 3.0),
                                Icon(
                                  Icons.info_outline_rounded,
                                  color: Colors.red,
                                ),
                                SizedBox(width: 7.0),
                                Expanded(
                                  child: Text(
                                    'This project hasn\'t started so it has no period result',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          const Text(
                            'Selected period: ',
                            style: TextStyle(fontFamily: 'mont', fontSize: 16),
                          ),
                          Text(
                            listReport.first.startDate +
                                ' - ' +
                                listReport.last.endDate,
                            style: const TextStyle(
                                fontFamily: 'mont', fontSize: 16),
                          ),
                          sliderSprints(report['sprints'].length, constraints),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Container(
                                color: Colors.white,
                                width: double.infinity,
                                alignment: Alignment.centerLeft,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: ReportWeb(
                                  report,
                                  listReport,
                                ),
                              ),
                            ),
                          ),
                          numbForecastSprints == 0
                              ? forecastButton(
                                  1,
                                  report['startDate'],
                                  report['sprintLength'],
                                  report['id'],
                                  report['numberOfClosedSprints'])
                              : forecastCancelButton(),
                          const SizedBox(height: 10.0),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 50),
                      child: Column(children: [
                        const SizedBox(
                          height: 50,
                        ),
                        ListTile(
                          title: Container(
                            padding: const EdgeInsets.only(left: 20),
                            width: double.infinity,
                            child: const AutoSizeText(
                              'Members:',
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: 'montBold',
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                              primary: false,
                              child: MembersWeb(
                                  mapUsers,
                                  widget.dadoId,
                                  listReport.first.startDate,
                                  listReport.last.endDate)),
                        ),
                      ]),
                    ),
                  ),
                ]),
              );
            }
          });
        } else {
          return Container(
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF6CCFF7),
              ),
            ),
          );
        }
      },
    );
  }

  sliderSprints(double max, BoxConstraints constraints) {
    if (max <= 1) {
      return const SizedBox(height: 15.0);
    }
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
          rangeTrackShape: ForecastRangeSliderTrackShape(
              current: max - numbForecastSprints,
              forecast: numbForecastSprints.toDouble()),
          rangeThumbShape: ForecastRangeSliderThumbShape(
              current: max - numbForecastSprints,
              forecast: numbForecastSprints.toDouble(),
              value: selectRanger)),
      child: RangeSlider(
          labels: RangeLabels(selectRanger.start.toStringAsFixed(0),
              selectRanger.end.toStringAsFixed(0)),
          values: selectRanger,
          onChanged: (newvalue) {
            setState(() {
              selectRanger = newvalue;
            });
          },
          divisions: max.toInt() - 1,
          max: max,
          min: 1),
    );
  }

  forecastButton(int option, String startDate, int sprintLength,
      String projectId, int numberSprints) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 210),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            key: const Key('forecast-button'),
            onTap: () {
              showDialog(
                      context: context,
                      builder: (BuildContext context) => ForecastSprints(
                          startDate, sprintLength, projectId, numberSprints))
                  .then((value) async {
                if (value != false) {
                  setState(() {
                    numbForecastSprints = value;
                  });
                  await loadDataForecast(numbForecastSprints, projectId);
                }
              });
            },
            child: Card(
              elevation: 10.0,
              color: option == 1 ? Colors.white : const Color(0xFF6CCFF7),
              shadowColor: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: const BorderSide(color: Color(0xFF6CCFF7), width: 1),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 50.0,
                  vertical: 7.0,
                ),
                child: const AutoSizeText(
                  'Forecast ',
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black87,
                    fontFamily: 'montBold',
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 7.0),
          Row(
            children: const [
              SizedBox(width: 3.0),
              Icon(Icons.info_outline_rounded),
              SizedBox(width: 7.0),
              Expanded(
                child: Text('Forecast future reports for this project'),
              ),
            ],
          )
        ],
      ),
    );
  }

  forecastCancelButton() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 210),
      child: GestureDetector(
        key: const Key('forecast-cancel-button'),
        onTap: () async {
          setState(() {
            numbForecastSprints = 0;
            selectRanger = const RangeValues(1, 1);
          });
          await loadDataReport();
        },
        child: Card(
          elevation: 10.0,
          color: const Color(0xFF6CCFF7),
          shadowColor: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(color: Color(0xFF6CCFF7), width: 1),
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 50.0,
              vertical: 7.0,
            ),
            child: const AutoSizeText(
              'Cancel',
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black87,
                fontFamily: 'montBold',
                fontSize: 17,
              ),
            ),
          ),
        ),
      ),
    );
  }

  fetchDataForecast(int futureSprints, String projectId) async {
    final data = await http.get(
        Uri.parse(projectsUrl + '/$projectId/forecast/$futureSprints'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
    if (data.statusCode == 200) {
      setState(() {
        reportSprints = jsonDecode(data.body)['sprints'];
      });
      return jsonDecode(data.body);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => Warning(context, data.body),
      );
    }
  }

  loadDataForecast(int futureSprints, String projectId) async {
    await fetchDataForecast(futureSprints, projectId).then((res) async {
      if (res != null || res.isNotEmpty) {
        refreshController.add(res);
        selectRanger = RangeValues(1, reportSprints.length.toDouble());
        setState(() {
          numbForecastSprints = futureSprints;
        });
        return res;
      }
    });
  }

  List<ReportRequest> modelReport(
      List<dynamic> reportMap, int startSprint, int endSprint) {
    Map sprints = reportMap.asMap();
    List<ReportRequest> listSprints = [];

    if (reportMap.isNotEmpty) {
      for (int i = startSprint - 1; i < endSprint; i++) {
        listSprints.add(ReportRequest(
          sprints[i]["sprintNumber"],
          sprints[i]["sprintStartDate"],
          sprints[i]["sprintEndDate"],
          sprints[i]["sprintCost"],
          sprints[i]["sprintResult"],
        ));
      }
    }

    return listSprints;
  }

  Map<String, ReportUserModel> usersReport(
      List<dynamic> reportMap, int startSprint, int endSprint) {
    Map sprints = reportMap.asMap();
    Map<String, ReportUserModel> mapUsersA = <String, ReportUserModel>{};

    if (sprints.isNotEmpty) {
      for (int i = startSprint - 1; i < endSprint; i++) {
        sprints[i]["users"].forEach((user) {
          mapUsersA.update(
              user["id"],
              (ReportUserModel value) =>
                  value..costAtSprint += double.parse(user["costAtSprint"]),
              ifAbsent: () => ReportUserModel(
                    name: user["name"],
                    imageThumb: user["imageTumb"],
                    monthlyWage: user["monthlyWage"],
                    costAtSprint: double.parse(user["costAtSprint"]),
                  ));
        });
      }
    }

    return mapUsersA;
  }
}
