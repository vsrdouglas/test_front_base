import 'dart:async';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:http/http.dart' as http;

import 'package:my_app/PopUps/projects_delete_warning.dart';
import 'package:my_app/PopUps/warning_popup.dart';
import 'package:my_app/Screens/info_dashboard.dart';
import '../Screens/add_project_screen.dart';
import '../Models/project_model_list.dart';
import '../Screens/project_detail_screen.dart';
import '../Screens/projects_screen.dart';
import '../app_constants.dart';

// ignore: must_be_immutable
class SearchBar extends StatefulWidget {
  late List<ProjectModel> convertedNames;
  late List<ProjectModel> projects;
  late List<ProjectModel> foundProjects;
  StreamController refreshController;

  SearchBar(projectList, this.refreshController, {Key? key}) : super(key: key) {
    convertedNames = SearchBarState().listconverter(projectList);
    projects = convertedNames;
    foundProjects = projects;
  }

  @override
  SearchBarState createState() => SearchBarState();
}

class SearchBarState extends State<SearchBar> {
  SearchBarState();

  Future<void> handleRefresh() async {
    await fetchData().then((res) {
      widget.refreshController.add(res);

      return null;
    });
  }

  void _openAddEntryDialog(ctx) {
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return AddEntryDialog(ctx, widget.refreshController, false);
        },
        fullscreenDialog: true));
  }

  Future<bool> openProjectDetail(ProjectModel projetos) async {
    await Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return ProjectDetailScreen(
              projetos.id, projetos.status, projetos.name);
        },
        fullscreenDialog: true));
    return true;
  }

  deleteProjects(String projectId) async {
    final response = await http.delete(
      Uri.parse(projectsUrl + projectId),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Project succesfully removed',
            style: TextStyle(fontFamily: 'mont'),
          ),
        ),
      );
    } else {
      return showDialog(
        context: context,
        builder: (BuildContext context) => Warning(context, response.body),
      );
    }
  }

  onSearch(String search) {
    setState(() {
      widget.foundProjects = widget.projects
          .where((projects) =>
              projects.name.toLowerCase().contains(search.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var ctx = context;
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxWidth <= 800) {
                return Container(
                  key: const Key('search-bar-project'),
                  // margin: EdgeInsets.symmetric(horizontal: 150),
                  padding: const EdgeInsets.only(
                      bottom: 30, top: 25, left: 20, right: 20),
                  width: double.infinity,
                  child: TextField(
                    onChanged: (value) => onSearch(value),
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
                );
              } else {
                return Container(
                  key: const Key('search-bar-project'),
                  margin: const EdgeInsets.symmetric(horizontal: 150),
                  padding: const EdgeInsets.only(
                      bottom: 30, top: 25, left: 20, right: 20),
                  width: double.infinity,
                  child: TextField(
                    onChanged: (value) => onSearch(value),
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
                );
              }
            }),
            widget.foundProjects.isNotEmpty
                ? Expanded(
                    child: RefreshIndicator(
                      onRefresh: handleRefresh,
                      child: ListView.builder(
                        primary: false,
                        padding: const EdgeInsets.only(
                            bottom: kFloatingActionButtonMargin + 70),
                        physics: const ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.foundProjects.length,
                        itemBuilder: (context, index) {
                          return LayoutBuilder(builder: (context, constraints) {
                            if (constraints.maxWidth <= 800) {
                              return projectComponent(
                                  projetos: widget.foundProjects[index]);
                            } else {
                              return projectComponentWeb(
                                  projetos: widget.foundProjects[index]);
                            }
                          });
                          //   return projectComponent(
                          //       projetos: widget.foundProjects[index]);
                        },
                      ),
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
      floatingActionButton: SizedBox(
        width: 60,
        height: 60,
        child: FittedBox(
          child: FloatingActionButton(
            heroTag: 'btn2',
            onPressed: () {
              _openAddEntryDialog(ctx);
            },
            elevation: 10,
            child: const Icon(Icons.add,
                key: Key('add-project-searchlist'), size: 35),
            backgroundColor: const Color(0xFF6CCFF7),
          ),
        ),
      ),
    );
  }

  projectComponent({required ProjectModel projetos}) {
    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Color(0xFF6CCFF7), width: 2),
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 3.0,
      shadowColor: Colors.grey[500],
      margin: const EdgeInsets.symmetric(
        vertical: 3,
        horizontal: 20,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 10,
        ),
        onTap: () {
          openProjectDetail(projetos).then((_) => handleRefresh());
        },
        leading: Image.asset(
          "images/projectIcon_projectlist.png",
          fit: BoxFit.contain,
          width: 60,
        ),
        title: AutoSizeText(
          projetos.name,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          minFontSize: 12,
          style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontFamily: 'mont',
              fontWeight: FontWeight.bold),
        ),
        subtitle: checkStatus(projetos),
        trailing: Container(
          margin: const EdgeInsets.only(right: 10),
          child: IconButton(
            icon: const Icon(Icons.close,
                key: Key('delete-project'), size: 30, color: Colors.grey),
            padding: EdgeInsets.zero,
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) =>
                    DeleteWarningProjects(context),
              ).then((value) async {
                if (value) {
                  await deleteProjects(projetos.id);
                  handleRefresh();
                  EInfoDashBoardState().handleRefresh1();
                  EInfoDashBoardState().handleRefresh2();
                  EInfoDashBoardState().handleRefresh3();
                }
              });
            },
          ),
        ),
      ),
    );
  }

  projectComponentWeb({required ProjectModel projetos}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 150),
      child: Card(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFF6CCFF7), width: 2),
          borderRadius: BorderRadius.circular(5.0),
        ),
        elevation: 3.0,
        shadowColor: Colors.grey[500],
        margin: const EdgeInsets.symmetric(
          vertical: 3,
          horizontal: 20,
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 10,
          ),
          onTap: () {
            openProjectDetail(projetos).then((_) => handleRefresh());
          },
          leading: Image.asset(
            "images/projectIcon_projectlist.png",
            fit: BoxFit.contain,
            width: 60,
          ),
          title: AutoSizeText(
            projetos.name,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            minFontSize: 12,
            style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontFamily: 'mont',
                fontWeight: FontWeight.bold),
          ),
          subtitle: checkStatus(projetos),
          trailing: Container(
            margin: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(Icons.close,
                  key: Key('delete-project'), size: 30, color: Colors.grey),
              padding: EdgeInsets.zero,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      DeleteWarningProjects(context),
                ).then((value) async {
                  if (value) {
                    await deleteProjects(projetos.id);
                    handleRefresh();
                    EInfoDashBoardState().handleRefresh1();
                    EInfoDashBoardState().handleRefresh2();
                    EInfoDashBoardState().handleRefresh3();
                  }
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  List<ProjectModel> listconverter(list) {
    List<ProjectModel> converted = [];
    for (var i = 0; i < list.length; i++) {
      converted.add(ProjectModel(list[i]['id'], list[i]['name'],
          list[i]['status'], list[i]['startDate']));
    }
    return converted;
  }
}

// ignore: body_might_complete_normally_nullable
AutoSizeText? checkStatus(ProjectModel projetos) {
  String status = projetos.status;
  switch (status) {
    case 'open':
      return const AutoSizeText(
        'Active',
        maxLines: 2,
        style: TextStyle(
          fontSize: 14,
          color: Colors.green,
          fontFamily: 'mont',
        ),
      );

    case 'closed':
      return const AutoSizeText(
        'Closed',
        maxLines: 2,
        style: TextStyle(
          fontSize: 14,
          color: Colors.red,
          fontFamily: 'mont',
        ),
      );

    case 'suspended':
      return AutoSizeText(
        'Suspended',
        maxLines: 2,
        style: TextStyle(
          fontSize: 14,
          color: Colors.yellow[800],
          fontFamily: 'mont',
        ),
      );
  }
}
