// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../app_constants.dart';

class WageHistoryPopup extends StatefulWidget {
  String userId;
  WageHistoryPopup(this.userId, {Key? key}) : super(key: key);
  @override
  WageHistoryPopupState createState() => WageHistoryPopupState();
}

class WageHistoryPopupState extends State<WageHistoryPopup> {
  late Future futureData;

  Future fetchData() async {
    final data = await http
        .get(Uri.parse(usersUrl + '/${widget.userId}/history'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    return jsonDecode(data.body);
  }

  @override
  void initState() {
    super.initState();

    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            dynamic wageHistory = snapshot.data['data'];
            if (wageHistory == null || wageHistory.isEmpty) {
              return AlertDialog(
                  title: const Text(
                    'Gone bad',
                    style: TextStyle(
                      fontFamily: 'montBold',
                      fontSize: 22,
                    ),
                  ),
                  content: const Text(
                    'Empty list.',
                    style: TextStyle(
                      fontFamily: 'mont',
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Okay',
                        style: TextStyle(
                          fontFamily: 'mont',
                          color: Color(0xFF213e4b),
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ]);
            }
            return AlertDialog(
              scrollable: true,
              title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Wage History',
                      style: TextStyle(fontFamily: "montBold", fontSize: 22),
                    ),
                    Text(
                      wageHistory.first['name'],
                      style: const TextStyle(
                          fontFamily: "mont", color: Colors.grey, fontSize: 18),
                    ),
                  ]),
              content: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: ListView.builder(
                    itemCount: wageHistory.length,
                    itemBuilder: (context, index) {
                      return wageHistoryComponent(wageHistory[index]);
                    },
                  )),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      fontFamily: 'mont',
                      color: Color(0xFF213e4b),
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF6CCFF7),
              ),
            );
          }
        });
  }

  wageHistoryComponent(dynamic wageHistory) {
    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.7)),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          'R\$' + wageHistory['monthlyWage'],
          maxLines: 1,
          style: const TextStyle(
            fontFamily: 'mont',
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
          Text(
            'Updated: ' + wageHistory['createdAt'].split('T')[0],
            maxLines: 1,
            style: const TextStyle(
              fontFamily: 'mont',
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          if (wageHistory['isActive'] == true) ...[
            const Text(
              'Active',
              maxLines: 1,
              style: TextStyle(
                fontFamily: 'mont',
                fontSize: 12,
                color: Colors.green,
              ),
            )
          ]
        ]),
      ]),
    );
  }
}
