import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../app_constants.dart';
import '../Widgets/projects_search_list.dart';

class ProjectsBody extends StatefulWidget {
  const ProjectsBody({Key? key}) : super(key: key);

  @override
  _ProjectsBodyState createState() => _ProjectsBodyState();
}

class _ProjectsBodyState extends State<ProjectsBody> {
  late StreamController refreshController;

  _ProjectsBodyState();

  loadData() async {
    fetchData().then((res) async {
      refreshController.add(res);
      return res;
    });
  }

  @override
  void initState() {
    refreshController = StreamController();
    loadData();
    super.initState();
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
      key: const Key('stream-builder-project'),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var projectJson = snapshot.data['data'];

          return SearchBar(projectJson, refreshController);
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
  final data = await http.get(Uri.parse(projectsUrl), headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  });
  if (data.statusCode == 200) {
    return jsonDecode(data.body);
  } else {
    throw Exception('Failed to load Report');
  }
}

// class Data {
//   final projects;

//   Data({
//     required this.projects,
//   });

//   factory Data.fromJson(Map<String, dynamic> json) {
//     return Data(
//       projects: json['data'],
//     );
//   }
// }
