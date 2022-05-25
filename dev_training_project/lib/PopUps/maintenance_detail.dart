// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_app/Widgets/edit_item_maintenance.dart';
import 'package:my_app/app_constants.dart';
import 'package:http/http.dart' as http;

import 'maintenance_edit.dart';
import 'maintenance_period_edit.dart';

class MaintenanceDetails extends StatefulWidget {
  BuildContext ctx;
  dynamic detailInfo;
  MaintenanceDetails(this.ctx, this.detailInfo, {Key? key}) : super(key: key);

  @override
  MaintenanceDetailsState createState() => MaintenanceDetailsState();
}

class MaintenanceDetailsState extends State<MaintenanceDetails> {
  late StreamController refreshDetail;
  addEquipments() async {}

  Future<void> handleRefresh() async {
    await fetchDataMaintenanceDetail().then((res) {
      refreshDetail.add(res);

      return null;
    });
  }

  Future<void> loadData() async {
    await fetchDataMaintenanceDetail().then((res) {
      refreshDetail.add(res);

      return res;
    });
  }

  @override
  void initState() {
    refreshDetail = StreamController();
    handleRefresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: refreshDetail.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            dynamic infoDetail = snapshot.data;
            return AlertDialog(
              scrollable: true,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    Expanded(
                      child: Text(
                        infoDetail['name'],
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'montBold',
                          fontSize: 18,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => EditMaintenance(
                                widget.ctx,
                                infoDetail['id'],
                                'Name',
                                infoDetail['name'],
                                loadData));
                      },
                      icon: const Icon(
                        Icons.mode_edit,
                        key: Key('edit-maintenance'),
                        color: Colors.black,
                      ),
                      iconSize: 30,
                    )
                  ]),
                  Padding(
                    padding: const EdgeInsets.only(left: 3),
                    child: Text(
                      'Type: ${infoDetail['type']}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontFamily: 'mont',
                          fontSize: 14,
                          color: Colors.black),
                    ),
                  ),
                ],
              ),
              content: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                width: MediaQuery.of(context).size.width * 0.35,
                height: MediaQuery.of(context).size.height * 0.3,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EditItemMaintenance(
                        title: 'Cost',
                        value: 'R\$${infoDetail['cost'] ?? '00,00'}',
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  EditMaintenance(widget.ctx, infoDetail['id'],
                                      'Cost', infoDetail['cost'], loadData));
                        },
                        isDescription: false,
                      ),
                      const SizedBox(height: 5),
                      EditItemMaintenance(
                        title: 'Status',
                        value: infoDetail['status'],
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  EditMaintenance(
                                      widget.ctx,
                                      infoDetail['id'],
                                      'Status',
                                      infoDetail['status'],
                                      loadData));
                        },
                        isDescription: false,
                      ),
                      const SizedBox(height: 5),
                      EditItemMaintenance(
                        title: 'Period',
                        value: infoDetail['endDate'] != null
                            ? 'From: ${infoDetail['startDate']}\nTo: ${infoDetail['endDate']}'
                            : 'From: ${infoDetail['startDate']}\nTo: Active',
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  EditMaintenancePeriod(
                                    widget.ctx,
                                    infoDetail['id'],
                                    infoDetail['startDate'],
                                    infoDetail['endDate'] ?? 'Active',
                                  )).then((_) => loadData());
                        },
                        isDescription: false,
                      ),
                      const SizedBox(height: 5),
                      EditItemMaintenance(
                        title: 'Description',
                        value: infoDetail['description'] ?? ' ',
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  EditMaintenance(
                                      widget.ctx,
                                      infoDetail['id'],
                                      'Description',
                                      infoDetail['description'],
                                      loadData));
                        },
                        isDescription: true,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancel',
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

  fetchDataMaintenanceDetail() async {
    final data = await http.get(
        Uri.parse(
            equipments + '/maintenance/details/${widget.detailInfo['id']}'),
        headers: {
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
}
