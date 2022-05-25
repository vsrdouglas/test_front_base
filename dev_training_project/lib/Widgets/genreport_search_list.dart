import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:my_app/Screens/report_screen.dart';

import '../Models/project_model_report.dart';

// ignore: must_be_immutable
class SearchBar extends StatefulWidget {
  late List<ProjectModelReport> convertedNames;

  SearchBar(projectList, {Key? key}) : super(key: key) {
    convertedNames = SearchBarState().listconverter(projectList);
  }

  @override
  SearchBarState createState() => SearchBarState();
}

class SearchBarState extends State<SearchBar> {
  late List<ProjectModelReport> _projects;
  late List<ProjectModelReport> _foundProjects = [];
  String nomeSplit = "";
  SearchBarState();

  onSearch(String search) {
    setState(() {
      _foundProjects = _projects
          .where((projects) =>
              projects.name.toLowerCase().contains(search.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      _projects = widget.convertedNames;
      _foundProjects = _projects;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxWidth <= 800) {
                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 10, left: 20),
                      child: Text(
                        'Select a project',
                        style: TextStyle(
                          fontFamily: 'montBold',
                          color: Colors.grey[800],
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          bottom: 20, top: 5, left: 20, right: 20),
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
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 150),
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 10, left: 20),
                      child: Text(
                        'Select a project',
                        style: TextStyle(
                          fontFamily: 'montBold',
                          color: Colors.grey[800],
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 150),
                      padding: const EdgeInsets.only(
                          bottom: 20, top: 5, left: 20, right: 20),
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
                    ),
                  ],
                );
              }
            }),
            _foundProjects.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _foundProjects.length,
                        itemBuilder: (context, index) {
                          return LayoutBuilder(builder: (context, constraints) {
                            if (constraints.maxWidth <= 800) {
                              return projectComponent(
                                  projetos: _foundProjects[index]);
                            } else {
                              return projectComponentWeb(
                                  projetos: _foundProjects[index]);
                            }
                          });
                          // return projectComponent(
                          //     projetos: _foundProjects[index]);
                        }))
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
  }

  projectComponent({required projetos}) {
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReportScreen(projetos.id),
            ),
          );
        },
        leading: Image.asset(
          "images/projectIcon_projectlist.png",
          fit: BoxFit.contain,
          width: 60,
        ),
        title: SizedBox(
          width: double.infinity,
          child: AutoSizeText(
            projetos.name,
            overflow: TextOverflow.ellipsis,
            minFontSize: 12,
            maxLines: 2,
            style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontFamily: 'mont',
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  projectComponentWeb({required projetos}) {
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReportScreen(projetos.id),
                ),
              );
            },
            leading: Image.asset(
              "images/projectIcon_projectlist.png",
              fit: BoxFit.contain,
              width: 60,
            ),
            title: SizedBox(
              width: double.infinity,
              child: AutoSizeText(
                projetos.name,
                overflow: TextOverflow.ellipsis,
                minFontSize: 12,
                maxLines: 2,
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontFamily: 'mont',
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ));
  }

  List<ProjectModelReport> listconverter(list) {
    List<ProjectModelReport> converted = [];
    for (var i = 0; i < list.length; i++) {
      converted.add(ProjectModelReport(
          list[i]['id'], list[i]['name'], list[i]['startDate']));
    }
    return converted;
  }
}
