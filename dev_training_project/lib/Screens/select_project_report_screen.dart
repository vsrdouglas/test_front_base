import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Widgets/genreport_search_list.dart';
import '../app_constants.dart';

class ProjectsList extends StatefulWidget {
  const ProjectsList({Key? key}) : super(key: key);

  @override
  _ProjectsListState createState() => _ProjectsListState();
}

class _ProjectsListState extends State<ProjectsList> {
  late Future<Data> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Data>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var projectInfo = snapshot.data!.projects;
          return SearchBar(projectInfo);
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

Future<Data> fetchData() async {
  final data = await http.get(Uri.parse(projectsUrl), headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  });
  if (data.statusCode == 200) {
    return Data.fromJson(jsonDecode(data.body));
  } else {
    throw Exception('Failed to load Report');
  }
}

class Data {
  // ignore: prefer_typing_uninitialized_variables
  final projects;

  Data({
    required this.projects,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      projects: json['data'],
    );
  }
}
