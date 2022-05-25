import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/Widgets/allocation_employee_app.dart';
import 'package:my_app/Widgets/employee_statistics.dart';
import 'package:my_app/Widgets/project_statistics.dart';
import 'package:my_app/Widgets/project_statistics_app.dart';
import 'dart:convert';

import '../app_constants.dart';
import '../Widgets/allocation_employee.dart';
import '../Widgets/employee_statistics_app.dart';

// ignore: prefer_typing_uninitialized_variables
var infoEmployee, infoProjects, infoUsersNAlocados;

class InfoDashBoard extends StatefulWidget {
  const InfoDashBoard({Key? key}) : super(key: key);

  @override
  EInfoDashBoardState createState() => EInfoDashBoardState();
}

class EInfoDashBoardState extends State<InfoDashBoard> {
  Widget loaderScreen = Container(
    color: Colors.white,
    child: const Center(
      child: CircularProgressIndicator(
        color: Color(0xFF6CCFF7),
      ),
    ),
  );

  Future handleRefresh1() async {
    await infoEmployeesU().then((res) {
      refreshController1.add(res);
      return null;
    });
  }

  loadData1() async {
    infoEmployeesU().then((res) async {
      refreshController1.add(res);
      return res;
    });
  }

  Future handleRefresh2() async {
    await infoProjectU().then((res) {
      refreshController2.add(res);
      return null;
    });
  }

  loadData2() async {
    infoProjectU().then((res) async {
      refreshController2.add(res);
      return res;
    });
  }

  Future handleRefresh3() async {
    await infoUserNU().then((res) {
      refreshController3.add(res);
      return null;
    });
  }

  loadData3() async {
    infoUserNU().then((res) async {
      refreshController3.add(res);
      return res;
    });
  }

  dashboardWeb(BoxConstraints constraints) {
    final horizontal = (constraints.maxWidth / 10) * 2;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: 50),
        child: Column(children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
                flex: 1,
                child: StatisticsEmployee(refreshController1, infoEmployee)),
            const SizedBox(width: 50.0),
            Expanded(
                flex: 1,
                child: StatisticsProject(refreshController2, infoProjects)),
          ]),
          const SizedBox(height: 50),
          AllocationEmployee(refreshController3, infoUsersNAlocados),
        ]),
      ),
    );
  }

  dashboardApp() {
    return ListView(key: const Key('info-dashboard-app'), children: [
      StatisticsEmployeeApp(refreshController1, infoEmployee),
      StatisticsProjectApp(refreshController2, infoProjects),
      AllocationEmployeeApp(refreshController3, infoUsersNAlocados),
    ]);
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   refreshController1.close();
  //   refreshController2.close();
  //   refreshController3.close();
  // }

  @override
  void initState() {
    updateStream();
    loadData1();
    loadData2();
    loadData3();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: refreshController1.stream,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return StreamBuilder(
                stream: refreshController2.stream,
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasData) {
                    return StreamBuilder(
                        stream: refreshController3.stream,
                        builder: (BuildContext context, snapshot) {
                          if (snapshot.hasData) {
                            return LayoutBuilder(
                                key: const Key('info-dashboard'),
                                builder: (context, constraints) {
                                  if (constraints.maxWidth <= 800) {
                                    return dashboardApp();
                                  } else {
                                    return dashboardWeb(constraints);
                                  }
                                });
                          } else {
                            return loaderScreen;
                          }
                        });
                  } else {
                    return loaderScreen;
                  }
                });
          } else {
            return loaderScreen;
          }
        });
  }
}

Future<dynamic> infoEmployeesU() async {
  final data = await http.get(Uri.parse(usersUrl + 'statistics'), headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  });
  infoEmployee = jsonDecode(data.body)['data'];
  return jsonDecode(data.body);
}

Future<dynamic> infoProjectU() async {
  final data = await http.get(Uri.parse(projectsUrl + 'statistics'), headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  });
  infoProjects = jsonDecode(data.body)['data'];
  return jsonDecode(data.body);
}

Future<dynamic> infoUserNU() async {
  final data = await http
      .get(Uri.parse(usersUrl + 'available?orderColumn=allocation'), headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  });
  infoUsersNAlocados = jsonDecode(data.body)['data'];
  return jsonDecode(data.body);
}
