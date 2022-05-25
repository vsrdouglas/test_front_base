// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'dart:async';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:my_app/Models/equipments_detail_model.dart';
import 'package:my_app/Models/equipments_user_model.dart';
import 'package:my_app/PopUps/equipments_edit.dart';
import 'package:my_app/Screens/history_equipment/widgets/history_equipment_data.dart';
import 'package:my_app/Screens/history_equipment/widgets/history_user_equipment_card.dart';
import 'package:my_app/Widgets/details_backbutton.dart';
import '../../app_constants.dart';
import '../available_empl_equipment.dart';
import 'maintenance_history_screen.dart';

class HistoryEquipmentScreen extends StatefulWidget {
  late String equipmentId;
  HistoryEquipmentScreen(this.equipmentId, {Key? key}) : super(key: key);

  @override
  State<HistoryEquipmentScreen> createState() => HistoryEquipmentScreenState();
}

class HistoryEquipmentScreenState extends State<HistoryEquipmentScreen> {
  late StreamController refreshController;
  late EquipmentHistory equipamentInfo;
  late List<EquipmentsUserModel>? usersHistory;
  late DateTime _dateTime = DateTime.now();
  String text = '';
  late List<DateTime> blockDates;

  loadData() async {
    await fetchDataEquipmentsDetails().then((res) {
      refreshController.add(res);

      return res;
    });
  }

  @override
  void initState() {
    fetchBlockDate();
    refreshController = StreamController();
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: refreshController.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          equipamentInfo = convertList(snapshot.data);
          usersHistory = getListUsers(snapshot.data);
          return LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth <= 800) {
              return EquipmentScreenApp(constraints, context);
            } else {
              return EquipmentScreenWeb(constraints, context);
            }
          });
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

  Future fetchDataEquipmentsDetails() async {
    final data = await http
        .get(Uri.parse(equipments + '/${widget.equipmentId}'), headers: {
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

  Future closeAssignment(String idAssign, String endDate) async {
    await http.put(Uri.parse(equipments + '/$idAssign/close?endDate=$endDate'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
  }

  List<Widget> checkEmployees(
      Map<dynamic, EquipmentsUserModel> userInfo, BuildContext context) {
    if (userInfo.isNotEmpty) {
      if (userInfo.entries.first.value.endDate != null) {
        return [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: historyButton(
              context,
              title: 'Assign Equipment',
              equipmentId: equipamentInfo.equipmentInfo.id!,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ...employeeList(userInfo),
        ];
      } else {
        return employeeList(userInfo);
      }
    } else {
      return [
        Container(
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          alignment: Alignment.center,
          child: const AutoSizeText(
            'No History found for the Equipment!',
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              fontFamily: 'montBold',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ];
    }
  }

  EquipmentScreenApp(BoxConstraints constraints, ctx) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: const BackButtonWhite(),
          leadingWidth: 70,
          toolbarHeight: 80,
          backgroundColor: const Color(0xFF6CCFF7),
          centerTitle: true,
          title: Text(
            equipamentInfo.equipmentInfo.model ?? '',
            style: const TextStyle(
                fontFamily: 'montBold', fontSize: 24.0, color: Colors.black),
          ),
          actions: [
            IconButton(
              key: const Key('edit-equipments-history'),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => EditEquipments(
                          equipamentInfo.equipmentInfo,
                          ctx,
                          loadData: () => loadData(),
                        ));
              },
              icon: const Icon(
                Icons.mode_edit,
                color: Color(0xFF213E4B),
              ),
              iconSize: 30,
            )
          ],
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 22.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 70.0),
              child: historyButton(
                context,
                title: 'Maintenance',
                equipmentId: equipamentInfo.equipmentInfo.id!,
                name: equipamentInfo.equipmentInfo.model,
              ),
            ),
            const SizedBox(
              height: 5.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 70.0),
              child: historyButton(
                context,
                title: usersHistory == null ||
                        usersHistory!.isEmpty ||
                        usersHistory!.first.endDate != null
                    ? 'Assign Equipment'
                    : 'Close Assignment',
                equipmentId: equipamentInfo.equipmentInfo.id!,
                idAssign: usersHistory == null || usersHistory!.isEmpty
                    ? null
                    : usersHistory?.first.idAssign,
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            TabBar(
              labelStyle: const TextStyle(
                fontFamily: 'mont',
                fontSize: 16,
              ),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey[700],
              indicatorColor: const Color(0xFF6CCFF7),
              indicatorPadding: const EdgeInsets.symmetric(horizontal: 40.0),
              tabs: const [
                Tab(text: 'Detail'),
                Tab(key: Key('history-equipment'), text: 'History'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  HistoryEquipmentDataApp(
                    equipamentHistory: equipamentInfo,
                  ),
                  SingleChildScrollView(
                      primary: false,
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 30),
                        child: Column(
                          children:
                              checkEmployees(usersHistory!.asMap(), context),
                        ),
                      )),
                ],
              ),
            )
          ],
        ),
      ), //
    );
  }

  EquipmentScreenWeb(BoxConstraints constraints, ctx) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButtonWhite(),
        leadingWidth: 70,
        toolbarHeight: 80,
        backgroundColor: const Color(0xFF6CCFF7),
      ),
      body: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Container(
          width: constraints.maxWidth * 0.25,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey, width: 0.7)),
            boxShadow: [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 4,
                offset: Offset(2, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
            child: Column(
              children: [
                const SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        equipamentInfo.equipmentInfo.model ?? '',
                        style: const TextStyle(
                          fontFamily: 'montBold',
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5.0),
                    IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => EditEquipments(
                                  equipamentInfo.equipmentInfo,
                                  ctx,
                                  loadData: () => loadData(),
                                ));
                      },
                      icon: const Icon(
                        Icons.mode_edit,
                        color: Colors.black,
                      ),
                      iconSize: 30,
                    )
                  ],
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      color: Colors.white,
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      child: HistoryEquipmentData(
                        equipamentHistory: equipamentInfo,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                historyButton(context,
                    title: 'Maintenance',
                    equipmentId: equipamentInfo.equipmentInfo.id!,
                    name: equipamentInfo.equipmentInfo.model),
                const SizedBox(height: 5),
                historyButton(context,
                    title: usersHistory == null ||
                            usersHistory!.isEmpty ||
                            usersHistory!.first.endDate != null
                        ? 'Assign Equipment'
                        : 'Close Assignment',
                    equipmentId: equipamentInfo.equipmentInfo.id!,
                    idAssign: usersHistory == null || usersHistory!.isEmpty
                        ? null
                        : usersHistory?.first.idAssign),
              ],
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.only(left: 30),
            margin: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(children: [
              const SizedBox(
                height: 50,
              ),
              ListTile(
                title: Container(
                  padding: const EdgeInsets.only(left: 10),
                  width: double.infinity,
                  child: const AutoSizeText(
                    'Equipment History:',
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'montBold',
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: SingleChildScrollView(
                      primary: false,
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 30),
                        child: Column(
                          children:
                              checkEmployees(usersHistory!.asMap(), context),
                        ),
                      )),
                ),
              ),
            ]),
          ),
        ),
      ]),
    );
  }

  Future fetchBlockDate() async {
    final data = await http.get(
        Uri.parse(equipments + '/block_dates/${widget.equipmentId}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
    blockDates = listConverterDateTime(jsonDecode(data.body)['dates']);
  }

  bool _predicate(DateTime day) {
    if (blockDates.contains(day)) {
      return false;
    } else {
      return true;
    }
  }

  historyButton(
    context, {
    required String title,
    required String equipmentId,
    String? name,
    String? idAssign,
    double? paddingHorizontal,
    double? paddingVertical,
  }) {
    return GestureDetector(
      onTap: () {
        if (title == "Maintenance") {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) {
                return MaintenanceHistory(
                  model: name!,
                  equipmentId: equipmentId,
                );
              },
              fullscreenDialog: true));
        } else if (title == "Assign Equipment") {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (BuildContext context) {
                    return ListAvailableEquipment(
                        context, equipmentId, blockDates);
                  },
                  fullscreenDialog: true))
              .then((_) => loadData());
        } else {
          showDatePicker(
                  context: context,
                  selectableDayPredicate: _predicate,
                  initialDate: DateFormat("yyyy-MM-dd")
                      .parse(usersHistory!.first.startDate!),
                  firstDate: DateFormat("yyyy-MM-dd")
                      .parse(usersHistory!.first.startDate!),
                  lastDate: DateTime(2050))
              .then(
            (date) async {
              setState(
                () {
                  _dateTime = date!;
                  text = DateFormat("yyyy-MM-dd").format(_dateTime);
                },
              );
              if (text != '') {
                await closeAssignment(idAssign!, text);
                loadData();
                fetchBlockDate();
              }
            },
          );
        }
      },
      child: Card(
        elevation: 10,
        margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
        shadowColor: Colors.black,
        color: const Color(0xFF6CCFF7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(color: Color(0xFF6CCFF7), width: 1),
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: paddingHorizontal ?? 30.0,
            vertical: paddingVertical ?? 10.0,
          ),
          child: Center(
            child: AutoSizeText(
              title,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black87,
                fontFamily: 'montBold',
                fontSize: 17,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

EquipmentHistory convertList(infoEquipment) {
  EquipmentHistory equipmentHistory;
  equipmentHistory = EquipmentHistory(
    equipmentInfo: Equipments(
      id: infoEquipment['equipment']['id'],
      model: infoEquipment['equipment']['model'],
      serial: infoEquipment['equipment']['serial'],
      processor: infoEquipment['equipment']['processor']['model'],
      processorId: infoEquipment['equipment']['processorId'],
      memory:
          '${infoEquipment['equipment']['memory']['size']} ${infoEquipment['equipment']['memory']['unit']}',
      memoryId: infoEquipment['equipment']['memoryId'],
      storage:
          '${infoEquipment['equipment']['storage']['type']} ${infoEquipment['equipment']['storage']['size']} ${infoEquipment['equipment']['storage']['unit']}',
      storageSize:
          '${infoEquipment['equipment']['storage']['size']} ${infoEquipment['equipment']['storage']['unit']}',
      storageType: infoEquipment['equipment']['storage']['type'],
      purchaseDate: infoEquipment['equipment']['purchaseDate'],
      warranty: infoEquipment['equipment']['warranty'],
      status: infoEquipment['equipment']['status'],
      company: infoEquipment['equipment']['company']['company'],
      note: infoEquipment['equipment']['note'],
      cost: infoEquipment['equipment']['cost'],
      billingNumber: infoEquipment['equipment']['billingNumber'],
    ),
  );
  return equipmentHistory;
}

List<EquipmentsUserModel>? getListUsers(infoEquipment) {
  List<EquipmentsUserModel> listUsers = [];
  infoEquipment['userHasEquipments'].forEach((user) {
    listUsers.add(EquipmentsUserModel(
      name: user['user']['name'],
      userId: user['userId'],
      equipmentId: user['equipmentId'],
      endDate: user['endDate'],
      startDate: user['startDate'],
      imageThumb: user['user']['imageTumb'],
      idAssign: user['id'],
    ));
  });

  return listUsers;
}

List<DateTime> listConverterDateTime(list) {
  List<DateTime> converted = [];
  for (var i = 0; i < list.length; i++) {
    converted.add(DateFormat("yyyy-MM-dd").parse(list[i]));
  }
  return converted;
}

List<Widget> employeeList(Map<dynamic, EquipmentsUserModel> userInfo) {
  List<Widget> list = userInfo.entries
      .map((value) => HistoryUserEquipmentCard(
            name: value.value.name,
            startDate: value.value.startDate!,
            endDate: value.value.endDate,
            employeeImageThumb: value.value.imageThumb!,
          ))
      .toList();
  return list;
}
