import 'dart:async';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:my_app/PopUps/equipments_add_maintenance.dart';

import 'package:my_app/PopUps/maintenance_detail.dart';
import 'package:my_app/Screens/equipments/widget/equipment_caption.dart';
import 'package:my_app/Widgets/details_backbutton.dart';
import 'package:my_app/app_constants.dart';
import 'package:my_app/helpers.dart';
import 'package:http/http.dart' as http;

class MaintenanceHistory extends StatefulWidget {
  final String model;
  final String equipmentId;

  const MaintenanceHistory(
      {required this.model, Key? key, required this.equipmentId})
      : super(key: key);

  @override
  State<MaintenanceHistory> createState() => MaintenanceHistoryState();
}

class MaintenanceHistoryState extends State<MaintenanceHistory> {
  late StreamController refreshController;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: refreshController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            dynamic data = snapshot.data;
            return LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth <= 800) {
                  return maintenanceHistoryApp(data, context);
                } else {
                  return maintenanceHistoryWeb(data, context);
                }
              },
            );
          }
          return Container(
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF6CCFF7),
              ),
            ),
          );
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
    refreshController.close();
    super.dispose();
  }

  loadData() async {
    await fetchDataMaintenance().then((res) {
      refreshController.add(res);

      return res;
    });
  }

  handleRefresh() async {
    await fetchDataMaintenance().then((res) {
      refreshController.add(res);

      return null;
    });
  }

  Future fetchDataMaintenance() async {
    final data = await http.get(
        Uri.parse(equipments + '/maintenance/${widget.equipmentId}'),
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

  maintenanceHistoryWeb(dynamic data, ctx) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: SizedBox(
        width: 60,
        height: 60,
        child: FittedBox(
          child: FloatingActionButton(
            heroTag: 'btn4',
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) =>
                    AddEquipmentsMaintenancePopup(
                  ctx: ctx,
                  equipmentId: widget.equipmentId,
                  handleRefresh: loadData,
                ),
              );
            },
            elevation: 10,
            child: const Icon(Icons.add, size: 35),
            backgroundColor: const Color(0xFF6CCFF7),
          ),
        ),
      ),
      appBar: AppBar(
        leading: const BackButtonWhite(),
        leadingWidth: 70,
        toolbarHeight: 80,
        backgroundColor: const Color(0xFF6CCFF7),
        title: Row(
          children: [
            const Spacer(),
            Text(
              'Maintenance Panel of ${widget.model}',
              style: const TextStyle(
                  fontSize: 25.0, fontFamily: 'montBold', color: Colors.black),
            ),
          ],
        ),
      ),
      body: data == null || data.isEmpty
          ? Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              alignment: Alignment.center,
              child: const AutoSizeText(
                'No Maintenance History found for the Equipment!',
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'montBold',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100.0),
              child: Column(children: [
                const SizedBox(height: 50.0),
                Row(
                  children: const [
                    Text(
                      'Maintenance History',
                      style: TextStyle(
                        fontFamily: 'montBold',
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    EquipmentCaption(
                        greenCaption: 'Complete',
                        yellowCaption: 'In progress',
                        redCaption: 'Out of service')
                  ],
                ),
                const SizedBox(height: 50.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (_, i) => Card(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Color(0xFF6CCFF7),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 10,
                        ),
                        onTap: () {
                          showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      MaintenanceDetails(ctx, data[i]))
                              .then((_) => loadData());
                        },
                        leading: statusColor(data[i]["status"]),
                        title: AutoSizeText(
                          data[i]["name"],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          minFontSize: 12,
                          style: const TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                            fontFamily: 'mont',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ]),
            ),
    );
  }

  maintenanceHistoryApp(dynamic data, ctx) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: SizedBox(
        width: 60,
        height: 60,
        child: FittedBox(
          child: FloatingActionButton(
            heroTag: 'btn5',
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) =>
                    AddEquipmentsMaintenancePopup(
                  ctx: ctx,
                  equipmentId: widget.equipmentId,
                  handleRefresh: loadData,
                ),
              );
            },
            elevation: 10,
            key: const Key('add-maintenance'),
            child: const Icon(Icons.add, size: 35),
            backgroundColor: const Color(0xFF6CCFF7),
          ),
        ),
      ),
      appBar: AppBar(
        leading: const BackButtonWhite(),
        leadingWidth: 70,
        toolbarHeight: 80,
        backgroundColor: const Color(0xFF6CCFF7),
        title: const Text(
          'Maintenance Panel',
          style: TextStyle(
              fontSize: 25.0, fontFamily: 'montBold', color: Colors.black),
        ),
      ),
      body: data == null || data.isEmpty
          ? Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              alignment: Alignment.center,
              child: const AutoSizeText(
                'No Maintenance History found for the Equipment!',
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'montBold',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(children: [
                const SizedBox(height: 20.0),
                const EquipmentCaption(
                  greenCaption: 'Complete',
                  yellowCaption: 'In progress',
                  redCaption: 'Out of service',
                ),
                const SizedBox(height: 20.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (_, i) => Card(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Color(0xFF6CCFF7),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 10,
                        ),
                        onTap: () {
                          showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      MaintenanceDetails(ctx, data[i]))
                              .then((_) => loadData());
                        },
                        leading: statusColor(data[i]["status"]),
                        title: AutoSizeText(
                          data[i]["name"],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          minFontSize: 12,
                          style: const TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                            fontFamily: 'mont',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ]),
            ),
    );
  }
}
