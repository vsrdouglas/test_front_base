// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../app_constants.dart';

class HistoryEmployee extends StatefulWidget {
  final String idUser, projectId;
  String startDate, endDate;
  HistoryEmployee(this.idUser, this.projectId, this.startDate, this.endDate,
      {Key? key})
      : super(key: key);
  @override
  HistoryEmployeeState createState() => HistoryEmployeeState();
}

class HistoryEmployeeState extends State<HistoryEmployee> {
  late Future futureData;

  fetchDataReport() async {
    final data = await http.get(
        Uri.parse(historyUser +
            '/${widget.idUser}/report?projectId=${widget.projectId}&startDate=${widget.startDate}&endDate=${widget.endDate}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
    return jsonDecode(data.body);
  }

  @override
  void initState() {
    super.initState();
    futureData = fetchDataReport();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            dynamic wageHistory = snapshot.data;
            return AlertDialog(
              scrollable: true,
              title: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: CachedNetworkImage(
                        imageUrl: wageHistory['imageThumb'],
                        fit: BoxFit.cover,
                        height: 80,
                        width: 80,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            Image.network(defaultImage),
                      ),
                    ),
                    Text(
                      wageHistory['name'],
                      style:
                          const TextStyle(fontFamily: "montBold", fontSize: 18),
                    ),
                  ]),
              content: Column(
                children: wageHistory['assigments']
                    .map<Widget>((user) => SizedBox(
                          // constraints: const BoxConstraints(maxHeight: 550,maxWidth: 350),
                          width: 500,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(15),
                            title: Text(
                              user['role'],
                              maxLines: 1,
                              style: const TextStyle(
                                fontFamily: 'mont',
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            subtitle: Text(
                              "${user['startDate']} - ${user['endDate'] ?? 'Active'}",
                              maxLines: 1,
                              style: const TextStyle(
                                fontFamily: 'mont',
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                            trailing: Padding(
                              padding: const EdgeInsets.only(top: 7),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Cost of this period :  ${user['costAtPeriod']}',
                                      style: const TextStyle(
                                        fontFamily: 'mont',
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      'Allocation: ${(double.parse(user['allocation']) * 100).toStringAsFixed(2)}%',
                                      style: const TextStyle(
                                        fontFamily: 'mont',
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ))
                    .toList(),
              ),
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
}
