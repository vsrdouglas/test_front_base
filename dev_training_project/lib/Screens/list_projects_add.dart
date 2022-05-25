// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:my_app/Models/project_model_list.dart';

import '../Models/addmember_model.dart';
import '../app_constants.dart';
import '../PopUps/projdetail_addmember_popup.dart';

// ignore: must_be_immutable
class ListProjects extends StatefulWidget {
  MemberModel user;
  var ctx;
  ListProjects(this.ctx, this.user, {Key? key}) : super(key: key);

  @override
  ListProjectsState createState() => ListProjectsState();
}

class ListProjectsState extends State<ListProjects> {
  late List<ProjectModel> projects;
  late List<ProjectModel> foundProjects;
  late Future futureData;

  Future fetchData() async {
    final data = await http.get(Uri.parse(projectsUrl), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (data.statusCode == 200) {
      projects = listconverter(jsonDecode(data.body)['data']);
      foundProjects = projects;
      return jsonDecode(data.body);
    } else {
      throw Exception('Failed to finish request');
    }
  }

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  onSearch(String search) {
    setState(() {
      foundProjects = projects
          .where((projects) =>
              projects.name.toLowerCase().contains(search.toLowerCase()))
          .toList();
    });
  }

  onStart() async {
    return futureData = await fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                leading: InkWell(
                  borderRadius: BorderRadius.circular(500),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 20),
                    height: double.infinity,
                    width: double.infinity,
                    child: Container(
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 5,
                            spreadRadius: 2,
                            offset: Offset(2, 2),
                          )
                        ],
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: const Icon(
                        Icons.keyboard_backspace_rounded,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                leadingWidth: 70,
                toolbarHeight: 80,
                backgroundColor: const Color(0xFF6CCFF7),
                // ignore: prefer_const_constructors
                title: SizedBox(
                  width: double.infinity,
                  child: const AutoSizeText(
                    'Add Employee to a Project',
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'montBold',
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              body: Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(
                          bottom: 30, top: 25, left: 20, right: 20),
                      width: double.infinity,
                      child: TextField(
                        onChanged: (value) {
                          onSearch(value);
                        },
                        // => onSearch(value),
                        decoration: InputDecoration(
                          filled: false,
                          contentPadding: const EdgeInsets.all(0),
                          suffixIcon:
                              Icon(Icons.search, color: Colors.grey.shade500),
                          label: const Text(
                            'Search...',
                            style: TextStyle(fontFamily: 'mont', fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                    foundProjects.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                              physics: const ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: foundProjects.length,
                              itemBuilder: (context, index) {
                                return projectComponent(
                                    foundProjects[index], context);
                              },
                            ),
                          )
                        : const Center(
                            child: Text(
                              "No projects found",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'montBold',
                                fontSize: 24,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            );
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

  Widget projectComponent(ProjectModel infoProject, context) {
    return Card(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      elevation: 0.0,
      child: ListTile(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => AddMemberPopup(
                widget.ctx, widget.user, infoProject.id, infoProject.startDate),
          ).then((value) {
            if (value) {
              Navigator.of(context).pop(true);
            }
          });
        },
        title: AutoSizeText(
          infoProject.name,
          maxLines: 1,
          style: const TextStyle(
            fontFamily: 'mont',
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

List<ProjectModel> listconverter(list) {
  List<ProjectModel> converted = [];
  for (var i = 0; i < list.length; i++) {
    if (list[i]['status'] == 'open') {
      converted.add(ProjectModel(list[i]['id'], list[i]['name'],
          list[i]['status'], list[i]['startDate']));
    }
  }
  return converted;
}
