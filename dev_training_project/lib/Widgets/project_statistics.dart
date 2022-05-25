// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:my_app/Screens/add_project_screen.dart';

import '../Screens/info_dashboard.dart';

class StatisticsProject extends StatefulWidget {
  StreamController refreshControllerP;
  var infoProjects;
  StatisticsProject(this.refreshControllerP, this.infoProjects, {Key? key})
      : super(key: key);

  @override
  StatisticsProjectState createState() => StatisticsProjectState();
}

class StatisticsProjectState extends State<StatisticsProject> {
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
    return Material(
      child: Container(
        height: 230,
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFF6CCFF7),
            width: 1,
          ),
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(3)),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.5),
              offset: Offset(1, 1),
              blurRadius: 0.5,
              spreadRadius: 1,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const AutoSizeText(
                  'Projects',
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: "mont",
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                IconButton(
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
                      handleRefresh();
                      EInfoDashBoardState().loadData2();
                      EInfoDashBoardState().handleRefresh2();
                    });
                  },
                ),
              ],
            ),
            AutoSizeText(
              widget.infoProjects['total'].toString(),
              maxLines: 1,
              style: const TextStyle(
                fontFamily: "montBold",
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 20.0,
              runSpacing: 7.0,
              children: [
                AutoSizeText(
                  'Open: ' + widget.infoProjects['open'].toString(),
                  maxLines: 1,
                  style: const TextStyle(
                    fontFamily: "montBold",
                    color: Colors.green,
                    fontSize: 12,
                  ),
                ),
                AutoSizeText(
                  'Suspended: ' + widget.infoProjects['suspended'].toString(),
                  maxLines: 1,
                  style: const TextStyle(
                    color: Colors.amber,
                    fontFamily: "montBold",
                    fontSize: 12,
                  ),
                ),
                AutoSizeText(
                  'Closed: ' + widget.infoProjects['closed'].toString(),
                  maxLines: 1,
                  style: const TextStyle(
                    color: Colors.red,
                    fontFamily: "montBold",
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
