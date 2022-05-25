// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:my_app/PopUps/project_detail_delete_member.dart';
import 'package:my_app/Screens/employee_details_screen.dart';
import 'package:my_app/Widgets/projdetail_project_info.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:my_app/Widgets/projdetail_project_info_web.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'employee_details_screen.dart';
import '../app_constants.dart';
import '../Widgets/details_backbutton.dart';
import '../Widgets/projdetail_title_line.dart';
import 'available_members_list_screen.dart';
import '../PopUps/warning_popup.dart';
import 'info_dashboard.dart';
import 'report_screen.dart';
// import '../Provider/stream_controller.dart';

class ProjectDetailScreen extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final projectId;
  String name;
  String status;
  ProjectDetailScreen(this.projectId, this.status, this.name, {Key? key})
      : super(key: key);

  @override
  ProjectDetailScreenState createState() => ProjectDetailScreenState();
}

class ProjectDetailScreenState extends State<ProjectDetailScreen> {
  late StreamController refreshController;
  ProjectDetailScreenState();
  late DateTime _dateTime = DateTime.now();
  String text = 'End Date';

  void _openAddMemberDialog(ctx, projectId, projectStartDate) {
    Navigator.of(context)
        .push(MaterialPageRoute(
      builder: (BuildContext context) {
        return AddMember(ctx, projectId, projectStartDate);
      },
      fullscreenDialog: true,
    ))
        .then((value) async {
      if (value) {
        await fetchData();
        handleRefresh();
        EInfoDashBoardState().handleRefresh1();
        EInfoDashBoardState().handleRefresh2();
        EInfoDashBoardState().handleRefresh3();
      }
    });
  }

  Future fetchData() async {
    final data = await http
        .get(Uri.parse(projectsUrl + '/${widget.projectId}'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    return jsonDecode(data.body);
  }

  Future deleteMember(String id, String endDate) async {
    ///projects/assignments/:id/close
    final res = await http.put(
      Uri.parse(projectsUrl + 'assignments/$id/close'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'endDate': endDate,
      }),
    );
    if (res.statusCode == 200) {
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Member assignment succesfully removed',
            style: TextStyle(fontFamily: 'mont'),
          ),
        ),
      );
      // return ProjectData.fromJson(jsonDecode(response.body));
    } else {
      return showDialog(
        context: context,
        builder: (BuildContext context) => Warning(context, res.body),
      );
    }
  }

  loadData() async {
    fetchData().then((res) async {
      refreshController.add(res);
      return res;
    });
  }

  Future<void> handleRefresh() async {
    await fetchData().then((res) {
      refreshController.add(res);

      return null;
    });
  }

  @override
  void initState() {
    super.initState();
    refreshController = StreamController();
    loadData();
  }

  void _openUserDetail(userInfo) {
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return EmployeeDetailScreen(employee: userInfo['id']);
        },
        fullscreenDialog: true));
  }

  @override
  void dispose() {
    super.dispose();
    refreshController.close();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<dynamic>(
        stream: refreshController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            dynamic projectDetails = snapshot.data['data'];
            return LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxWidth <= 800) {
                return BodyProjectApp(projectDetails);
              } else {
                return BodyProjectWeb(projectDetails);
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
        });
  }

  BodyProjectApp(projectDetails) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButtonWhite(),
        leadingWidth: 70,
        toolbarHeight: 80,
        backgroundColor: const Color(0xFF6CCFF7),
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 70),
          child: TitleLine(
              context,
              projectDetails['name'],
              widget.projectId,
              widget.status,
              widget.name,
              refreshController,
              projectDetails['users'],
              projectDetails['startDate'],
              false),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            color: Colors.white,
            width: double.infinity,
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.all(15),
            child: ProjectInfo(projectDetails),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: 5,
            width: double.infinity,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey,
                  width: 0.7,
                ),
              ),
            ),
          ),
          Card(
            elevation: 0.0,
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: ListTile(
                title: Container(
                  margin: const EdgeInsets.only(top: 25, bottom: 25),
                  child: const AutoSizeText(
                    'Active Members: ',
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'montBold',
                      fontSize: 20,
                    ),
                  ),
                ),
                trailing: ElevatedButton(
                  onPressed: projectDetails['status'] != 'open'
                      ? null
                      : () {
                          _openAddMemberDialog(context, projectDetails['id'],
                              projectDetails['startDate']);
                        },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(
                      side: BorderSide.none,
                    ),
                    fixedSize: const Size(70, 70),
                    shadowColor: Colors.black,
                    elevation: 10.0,
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 30,
                    color: Colors.black,
                  ),
                )),
          ),
          projectDetails['users'].isNotEmpty
              ? ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: projectDetails['users'].length,
                  itemBuilder: (context, index) {
                    return usersComponent(projectDetails['users'][index],
                        context, projectDetails['startDate']);
                  },
                )
              : Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: const Text(
                      "No active members",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'mont',
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
        ]),
      ),
    );
  }

  BodyProjectWeb(projectDetails) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButtonWhite(),
        leadingWidth: 70,
        toolbarHeight: 80,
        backgroundColor: const Color(0xFF6CCFF7),
      ),
      body: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.25,
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey, width: 0.7)),
            boxShadow: [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 4,
                offset: Offset(2, 4),
              ),
            ],
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                  const SizedBox(
                    height: 50,
                  ),
                  TitleLine(
                      context,
                      projectDetails['name'],
                      widget.projectId,
                      widget.status,
                      widget.name,
                      refreshController,
                      projectDetails['users'],
                      projectDetails['startDate'],
                      true),
                  Container(
                    color: Colors.white,
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.all(15),
                    child: ProjectInfoWeb(projectDetails),
                  ),
                ]),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Card(
                    elevation: 10.0,
                    color: const Color(0xFF6CCFF7),
                    shadowColor: Colors.grey,
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                      side:
                          const BorderSide(color: Color(0xFF6CCFF7), width: 1),
                    ),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ReportScreen(projectDetails['id']),
                          ),
                        );
                      },
                      subtitle: Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 10),
                        child: const AutoSizeText(
                          'Generate Report ',
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.black87,
                            fontFamily: 'montBold',
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
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
                    'Active Members:',
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'montBold',
                      fontSize: 17,
                    ),
                  ),
                ),
                trailing: ElevatedButton(
                  onPressed: projectDetails['status'] != 'open'
                      ? null
                      : () {
                          _openAddMemberDialog(context, projectDetails['id'],
                              projectDetails['startDate']);
                        },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(
                      side: BorderSide.none,
                    ),
                    primary: const Color(0xFF6CCFF7),
                    fixedSize: const Size(70, 70),
                    shadowColor: Colors.black,
                    elevation: 10.0,
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 30,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: projectDetails['users'].isNotEmpty
                      ? ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: projectDetails['users'].length,
                          itemBuilder: (context, index) {
                            return usersComponentWeb(
                                projectDetails['users'][index],
                                context,
                                projectDetails['startDate']);
                          },
                        )
                      : Center(
                          child: Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: const Text(
                              "No active members",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'mont',
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ]),
          ),
        ),
      ]),
    );
  }

  usersComponent(dynamic userInfo, ctx, startDate) {
    return Column(children: [
      for (var i = 0; i < userInfo['projectHasUsers'].length; i++) ...[
        Card(
          elevation: 0.0,
          margin: const EdgeInsets.only(left: 10, right: 10),
          child: ListTile(
            onTap: () {
              _openUserDetail(userInfo);
            },
            leading: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: CachedNetworkImage(
                  imageUrl: userInfo['imageTumb'],
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      Image.network(defaultImageThumb),
                ),
              ),
            ),
            title: AutoSizeText(
              userInfo['name'],
              maxLines: 1,
              style: const TextStyle(
                fontFamily: 'mont',
                fontSize: 17,
                color: Colors.black,
              ),
            ),
            subtitle: AutoSizeText(
              userInfo['projectHasUsers'][i]['teamRole'] +
                  ' - Started: ' +
                  userInfo['projectHasUsers'][i]['startDate'],
              maxLines: 1,
              style: const TextStyle(
                fontFamily: 'mont',
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
            trailing: Container(
              margin: const EdgeInsets.only(right: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 5, right: 10),
                    child: Text(
                      'Allocation:',
                      style: TextStyle(fontFamily: 'mont', fontSize: 12),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, right: 20),
                    child: CircularPercentIndicator(
                      radius: 15.0,
                      lineWidth: 3.0,
                      percent: double.parse(
                          userInfo['projectHasUsers'][i]['allocation']),
                      center: Text(
                        "${((double.parse(userInfo['projectHasUsers'][i]['allocation'])) * 100).toStringAsFixed(0)}%",
                        style: const TextStyle(fontSize: 8),
                      ),
                      progressColor: Colors.green,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      size: 30,
                    ),
                    onPressed: () {
                      showDialog(
                        context: ctx,
                        builder: (BuildContext ctx) => DeleteWarningMember(ctx),
                      ).then((value) async {
                        if (value) {
                          await showDatePicker(
                                  helpText: 'Select the last day he worked',
                                  context: context,
                                  initialDate: DateFormat('yyyy-MM-dd').parse(
                                      userInfo['projectHasUsers'][i]
                                          ['startDate']),
                                  firstDate: DateFormat('yyyy-MM-dd').parse(
                                      userInfo['projectHasUsers'][i]
                                          ['startDate']),
                                  lastDate: DateTime(2050))
                              .then(
                            (date) {
                              setState(
                                () {
                                  _dateTime = date!;
                                  text = DateFormat("yyyy-MM-dd")
                                      .format(_dateTime);
                                },
                              );
                            },
                          );
                          await deleteMember(
                              userInfo['projectHasUsers'][i]['id'], text);
                          handleRefresh();
                          EInfoDashBoardState().handleRefresh1();
                          EInfoDashBoardState().handleRefresh2();
                          EInfoDashBoardState().handleRefresh3();
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        )
      ]
    ]);
  }

  usersComponentWeb(dynamic userInfo, ctx, startDate) {
    return Column(children: [
      for (var i = 0; i < userInfo['projectHasUsers'].length; i++) ...[
        Card(
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Color(0xFF6CCFF7), width: 2),
            borderRadius: BorderRadius.circular(5.0),
          ),
          margin: const EdgeInsets.symmetric(
            vertical: 3.0,
            horizontal: 20,
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 10,
            ),
            onTap: () {
              _openUserDetail(userInfo);
            },
            leading: Container(
              margin: const EdgeInsets.only(left: 15, right: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: CachedNetworkImage(
                  filterQuality: FilterQuality.low,
                  fit: BoxFit.cover,
                  imageUrl: userInfo['imageTumb'],
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      Image.network(defaultImageThumb),
                  height: 40,
                  width: 40,
                ),
              ),
            ),
            title: AutoSizeText(
              userInfo['name'],
              maxLines: 1,
              style: const TextStyle(
                fontFamily: 'mont',
                fontSize: 17,
                color: Colors.black,
              ),
            ),
            subtitle: AutoSizeText(
              userInfo['projectHasUsers'][i]['teamRole'] +
                  ' - Started: ' +
                  userInfo['projectHasUsers'][i]['startDate'],
              maxLines: 1,
              style: const TextStyle(
                fontFamily: 'mont',
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
            trailing: Container(
              margin: const EdgeInsets.only(right: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 5, right: 10),
                    child: Text(
                      'Allocation:',
                      style: TextStyle(fontFamily: 'mont', fontSize: 12),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, right: 20),
                    child: CircularPercentIndicator(
                      radius: 15.0,
                      lineWidth: 3.0,
                      percent: double.parse(
                          userInfo['projectHasUsers'][i]['allocation']),
                      center: Text(
                        "${((double.parse(userInfo['projectHasUsers'][i]['allocation'])) * 100).toStringAsFixed(0)}%",
                        style: const TextStyle(fontSize: 8),
                      ),
                      progressColor: Colors.green,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      size: 30,
                    ),
                    onPressed: () {
                      showDialog(
                        context: ctx,
                        builder: (BuildContext ctx) => DeleteWarningMember(ctx),
                      ).then((value) async {
                        if (value) {
                          await showDatePicker(
                                  helpText: 'Select the last day he worked',
                                  context: context,
                                  initialDate: DateFormat('yyyy-MM-dd').parse(
                                      userInfo['projectHasUsers'][i]
                                          ['startDate']),
                                  firstDate: DateFormat('yyyy-MM-dd').parse(
                                      userInfo['projectHasUsers'][i]
                                          ['startDate']),
                                  lastDate: DateTime(2050))
                              .then(
                            (date) {
                              setState(
                                () {
                                  _dateTime = date!;
                                  text = DateFormat("yyyy-MM-dd")
                                      .format(_dateTime);
                                },
                              );
                            },
                          );
                          await deleteMember(
                              userInfo['projectHasUsers'][i]['id'], text);
                          handleRefresh();
                          EInfoDashBoardState().handleRefresh1();
                          EInfoDashBoardState().handleRefresh2();
                          EInfoDashBoardState().handleRefresh3();
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ]
    ]);
  }
}
