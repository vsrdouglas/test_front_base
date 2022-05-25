// ignore_for_file: must_be_immutable
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:file_saver/file_saver.dart';
import 'package:my_app/Screens/equipments/pop_up/filter.dart';
import 'package:my_app/Screens/equipments/widget/equipment_caption.dart';
import 'package:my_app/Screens/equipments/widget/equipments_widget.dart';
import 'package:path_provider/path_provider.dart';

import '../../app_constants.dart';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/Models/equipments_model.dart';
import 'package:my_app/Models/equipments_user_model.dart';
import 'package:my_app/PopUps/equipments_add.dart';
import 'package:my_app/PopUps/warning_popup.dart';
import 'package:my_app/Screens/equipments/equipments_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class SearchBarEquipments extends StatefulWidget {
  late List<EquipmentsModel> convertedNames;
  late List<EquipmentsModel> equipmentsInfo;
  late List<EquipmentsModel> foundEquipments;
  late StreamController refreshController;

  SearchBarEquipments(equipmentsList, this.refreshController, {Key? key})
      : super(key: key) {
    convertedNames = listconverter(equipmentsList);
    equipmentsInfo = convertedNames;
    foundEquipments = equipmentsInfo;
  }

  @override
  SearchBarEquipmentsState createState() => SearchBarEquipmentsState();
}

class SearchBarEquipmentsState extends State<SearchBarEquipments> {
  bool checkFilter = false;
  String? filterOptions;

  onSearch(String search) {
    String text = 'Available';
    setState(() {
      widget.foundEquipments = widget.equipmentsInfo
              .where((equipments) => equipments.model!
                  .toLowerCase()
                  .contains(search.toLowerCase()))
              .toList() +
          widget.equipmentsInfo
              .where((equipments) => equipments.processor!
                  .toLowerCase()
                  .contains(search.toLowerCase()))
              .toList() +
          widget.equipmentsInfo
              .where((equipments) => equipments.memory!
                  .toLowerCase()
                  .contains(search.toLowerCase()))
              .toList() +
          widget.equipmentsInfo
              .where((equipments) => equipments.storage!
                  .toLowerCase()
                  .contains(search.toLowerCase()))
              .toList();
      List<EquipmentsModel> foundNames =
          widget.equipmentsInfo.where((equipments) {
        if (equipments.equipmentsUserModel != null) {
          return equipments.equipmentsUserModel!.name
              .toLowerCase()
              .contains(search.toLowerCase());
        } else {
          return text.toLowerCase().contains(search.toLowerCase());
        }
      }).toList();
      widget.foundEquipments =
          (widget.foundEquipments + foundNames).toSet().toList();
    });
  }

  Future<void> handleRefresh() async {
    await fetchDataEquipments().then((res) {
      widget.refreshController.add(res);

      return null;
    });
  }

  xmlDownload() async {
    final response = await http
        .get(Uri.parse(equipments + '/report/xml'), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'text/html,application/xml',
      'Authorization': 'Bearer $token',
    });
    //
    if (response.statusCode == 200) {
      DateTime date = DateTime.now();
      Uint8List data = Uint8List.fromList(response.bodyBytes);
      String fileName =
          'EquipmentsSheet_${date.year}${date.month}${date.day}_${date.hour}${date.minute}';

      if (kIsWeb) {
        await FileSaver.instance.saveFile(fileName, data, 'xlsx',
            mimeType: MimeType.MICROSOFTEXCEL);
      } else {
        bool status = await Permission.storage.isGranted;
        if (!status) await Permission.storage.request();

        //Saves to device

        //Saves to temporary folder to open it
        final appStorage = await getTemporaryDirectory();
        final File file = File('${appStorage.path}/$fileName.xlsx');
        file.writeAsBytes(response.bodyBytes);
        log('file path: ' + file.path);
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => Warning(context, response.body),
      );
    }
  }

  Future<void> sendFilter(List parameters) async {
    final response = await http.post(Uri.parse(equipments + '/filter'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, List>{
          "processor": parameters[1],
          "memory": parameters[2],
          "storage": parameters[3],
        }));
    if (response.statusCode == 200) {
      widget.refreshController.add(jsonDecode(response.body));
      setState(() {
        checkFilter = true;
        filterOptions = '${parameters[4].join(', ')}';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Filter succesfully applied',
            style: TextStyle(fontFamily: 'mont'),
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => Warning(context, response.body),
      );
    }
  }

  cancelButton() async {
    widget.refreshController.add(await fetchDataEquipments());
    setState(() {
      checkFilter = false;
      filterOptions = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    var ctx = context;
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth <= 800) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    IconButton(
                        key: const Key('filter-icon'),
                        onPressed: () async {
                          checkFilter
                              ? cancelButton()
                              : showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          FilterParameters(context))
                                  .then((value) async {
                                  if (value[0]) {
                                    await sendFilter(value);
                                  }
                                });
                        },
                        icon: Icon(
                          checkFilter
                              ? Icons.cancel_sharp
                              : Icons.filter_list_rounded,
                          size: 30,
                          color: Colors.grey.shade500,
                        )),
                    const Spacer(),
                    DecoratedBox(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xFF6CCFF7)),
                      child: IconButton(
                        onPressed: () async => await xmlDownload(),
                        iconSize: 30.0,
                        color: Colors.white,
                        icon: const Icon(
                          Icons.download,
                          semanticLabel: 'Download equipments in .XLS',
                        ),
                      ),
                    ),
                  ],
                ),
                Visibility(
                    visible: filterOptions != null,
                    child: AutoSizeText(
                      filterOptions == null
                          ? ''
                          : 'Filter Applied: ${filterOptions!}',
                      style: const TextStyle(fontFamily: 'mont', fontSize: 15),
                    )),
                const SizedBox(height: 10.0),
                const EquipmentCaption(
                    greenCaption: 'Working',
                    yellowCaption: 'Maintenance',
                    redCaption: 'Defective'),
                SizedBox(
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
                const SizedBox(height: 30.0),
                widget.foundEquipments.isNotEmpty
                    ? Expanded(
                        child: RefreshIndicator(
                          onRefresh: handleRefresh,
                          child: ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              itemCount: widget.foundEquipments.length,
                              itemBuilder: (context, index) => EquipmentsWidget(
                                  equipments: widget.foundEquipments[index],
                                  constraints: constraints,
                                  handleRefresh: handleRefresh)),
                        ),
                      )
                    : const Center(
                        child: Text(
                          "No equipments found",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'montBold',
                            fontSize: 24,
                          ),
                        ),
                      ),
              ],
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 150.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15.0),
                Row(
                  children: [
                    IconButton(
                        onPressed: () async {
                          checkFilter
                              ? await cancelButton()
                              : showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          FilterParameters(context))
                                  .then((value) async {
                                  if (value[0]) {
                                    await sendFilter(value);
                                  }
                                });
                        },
                        icon: Icon(
                          checkFilter
                              ? Icons.cancel_sharp
                              : Icons.filter_list_rounded,
                          size: 30,
                          color: Colors.grey.shade500,
                        )),
                    const Spacer(),
                    DecoratedBox(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xFF6CCFF7)),
                      child: IconButton(
                        onPressed: () async => await xmlDownload(),
                        iconSize: 30.0,
                        color: Colors.white,
                        icon: const Icon(
                          Icons.download,
                          semanticLabel: 'Download equipments in .XLS',
                        ),
                      ),
                    ),
                  ],
                ),
                Visibility(
                    visible: filterOptions != null,
                    child: AutoSizeText(
                      filterOptions == null
                          ? ''
                          : 'Filter Applied: ${filterOptions!}',
                      style: const TextStyle(fontFamily: 'mont', fontSize: 15),
                    )),
                const SizedBox(height: 20.0),
                Row(
                  children: const [
                    Spacer(),
                    EquipmentCaption(
                        greenCaption: 'Working',
                        yellowCaption: 'Maintenance',
                        redCaption: 'Defective'),
                  ],
                ),
                SizedBox(
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
                const SizedBox(height: 30.0),
                widget.foundEquipments.isNotEmpty
                    ? Expanded(
                        child: RefreshIndicator(
                          onRefresh: handleRefresh,
                          child: ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              itemCount: widget.foundEquipments.length,
                              itemBuilder: (context, index) => EquipmentsWidget(
                                  equipments: widget.foundEquipments[index],
                                  constraints: constraints,
                                  handleRefresh: handleRefresh)),
                        ),
                      )
                    : const Center(
                        child: Text(
                          "No equipments found",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'montBold',
                            fontSize: 24,
                          ),
                        ),
                      ),
              ],
            ),
          );
        }
      }),
      floatingActionButton: SizedBox(
        width: 60,
        height: 60,
        child: FittedBox(
          child: FloatingActionButton(
            heroTag: 'btn3',
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) =>
                    AddEquipmentsPopup(ctx, widget.refreshController),
              );
            },
            elevation: 10,
            child: const Icon(Icons.add, key: Key('add-equipment'), size: 35),
            backgroundColor: const Color(0xFF6CCFF7),
          ),
        ),
      ),
    );
  }
}

List<EquipmentsModel> listconverter(list) {
  List<EquipmentsModel> converted = [];
  for (var i = 0; i < list.length; i++) {
    converted.add(EquipmentsModel(
        equipmentStatus: list[i]['status'],
        id: list[i]['id'],
        memory: '${list[i]['memory']['size']} ${list[i]['memory']['unit']}',
        model: list[i]['model'],
        processor: list[i]['processor']['model'],
        serial: list[i]['serial'],
        storage:
            '${list[i]['storage']['type']} ${list[i]['storage']['size']} ${list[i]['storage']['unit']}',
        equipmentsUserModel: list[i]['userHasEquipments'] != null &&
                list[i]['userHasEquipments'].isNotEmpty
            ? EquipmentsUserModel(
                name: list[i]['userHasEquipments'].first['user']['name'],
                endDate: list[i]['userHasEquipments'].first['endDate'])
            : null));
  }
  return converted;
}
