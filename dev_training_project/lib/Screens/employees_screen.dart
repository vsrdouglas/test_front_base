import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../app_constants.dart';
import '../Widgets/employees_search_list.dart';

class EmployeesBodyFinal extends StatefulWidget {
  const EmployeesBodyFinal({Key? key}) : super(key: key);

  @override
  EmployeesBodyFinalState createState() => EmployeesBodyFinalState();
}

class EmployeesBodyFinalState extends State<EmployeesBodyFinal> {
  late StreamController refreshController;

  loadData() async {
    fetchData().then((res) async {
      refreshController.add(res);
      return res;
    });
  }

  Future handleRefresh() async {
    await fetchData().then((res) {
      refreshController.add(res);
      return null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    refreshController.close();
  }

  @override
  void initState() {
    refreshController = StreamController();
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<dynamic>(
      stream: refreshController.stream,
      key: const Key('stream-builder-employees'),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var employeeJson = snapshot.data['data'];
          return SearchBar(employeeJson, refreshController);
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
}

Future fetchData() async {
  final data = await http.get(Uri.parse(allUsers), headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  });
  if (data.statusCode == 200) {
    return jsonDecode(data.body);
  } else {
    throw Exception('Failed to finish request');
  }
}
