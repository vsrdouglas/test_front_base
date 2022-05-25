// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:my_app/Screens/add_project_screen.dart';

import '../Screens/info_dashboard.dart';

class StatisticsProjectApp extends StatefulWidget {
  StreamController refreshControllerP;
  var infoProjects;
  StatisticsProjectApp(this.refreshControllerP, this.infoProjects, {Key? key})
      : super(key: key);

  @override
  _StatisticsProjectAppState createState() => _StatisticsProjectAppState();
}

class _StatisticsProjectAppState extends State<StatisticsProjectApp> {
  Future handleRefresh() async {
    await infoProjectU().then((res) {
      widget.refreshControllerP.add(res);
      return null;
    });
  }

  @override
  void initState() {
    super.initState();
    // handleRefresh();
  }

  @override
  Widget build(BuildContext context) {
    var ctx = context;

    return Card(
      elevation: 10,
      shadowColor: Colors.grey,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3),
        side: const BorderSide(color: Color(0xFF6CCFF7), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 30, bottom: 30, left: 20),
        child: Theme(
          data: ThemeData().copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.only(right: 20),
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AutoSizeText(
                    'Projects',
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: "mont",
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 20),
                    child: IconButton(
                      key: const Key('add-project-dashboard-app'),
                      icon: const Icon(
                        Icons.post_add_sharp,
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .push(
                          MaterialPageRoute<void>(
                              builder: (BuildContext context) {
                                return AddEntryDialog(
                                    ctx, widget.refreshControllerP, true);
                              },
                              fullscreenDialog: true),
                        )
                            .then((value) async {
                          // loadData();
                          // handleRefresh();
                        });
                      },
                    ),
                  ),
                ]),
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 25),
                width: double.infinity,
                child: AutoSizeText(
                  widget.infoProjects['total'].toString(),
                  maxLines: 1,
                  style: const TextStyle(
                    fontFamily: "montBold",
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Wrap(children: [
                AutoSizeText(
                  'Open: ' + widget.infoProjects['open'].toString(),
                  maxLines: 1,
                  style: const TextStyle(
                    fontFamily: "montBold",
                    color: Colors.green,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 20),
                AutoSizeText(
                  'Suspended: ' + widget.infoProjects['suspended'].toString(),
                  maxLines: 1,
                  style: const TextStyle(
                    color: Colors.amber,
                    fontFamily: "montBold",
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 20),
                AutoSizeText(
                  'Closed: ' + widget.infoProjects['closed'].toString(),
                  maxLines: 1,
                  style: const TextStyle(
                    color: Colors.red,
                    fontFamily: "montBold",
                    fontSize: 12,
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
