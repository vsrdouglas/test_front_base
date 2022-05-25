import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:my_app/Models/equipments_model.dart';
import 'package:my_app/PopUps/equipments_delete_warning.dart';
import 'package:my_app/PopUps/warning_popup.dart';
import 'package:my_app/Screens/history_equipment/history_equipment_screen.dart';
import 'package:my_app/app_constants.dart';
import 'package:http/http.dart' as http;

import '../../../helpers.dart';
import 'package:my_app/helpers.dart';

class EquipmentsWidget extends StatelessWidget {
  final EquipmentsModel equipments;
  final BoxConstraints constraints;
  final Function handleRefresh;
  const EquipmentsWidget(
      {required this.equipments,
      required this.constraints,
      required this.handleRefresh,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 800) {
        return Card(
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Color(0xFF6CCFF7), width: 2),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 20,
            ),
            onTap: () async {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (BuildContext context) {
                        return HistoryEquipmentScreen(equipments.id!);
                      },
                      fullscreenDialog: true))
                  .then((_) async => await handleRefresh());
            },
            leading: statusColor(equipments.equipmentStatus!),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: AutoSizeText(
                equipments.model!,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                minFontSize: 12,
                style: const TextStyle(
                    fontSize: 17,
                    color: Colors.black,
                    fontFamily: 'mont',
                    fontWeight: FontWeight.bold),
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 7.0, right: 15.0),
              child: Wrap(
                runSpacing: 7.0,
                spacing: 15.0,
                children: [
                  Text(
                    'Serial: ${equipments.serial!} ',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                        fontFamily: 'mont', fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    'Processor: ${equipments.processor!}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                        fontFamily: 'mont', fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    'Memory: ${equipments.memory!}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                        fontFamily: 'mont', fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    'Storage: ${equipments.storage!}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                        fontFamily: 'mont', fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            trailing: Wrap(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: constraints.maxWidth <= 800
                          ? constraints.maxWidth / 3
                          : constraints.maxWidth),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, right: 10),
                    child: userComputer(equipments.equipmentsUserModel?.name),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: IconButton(
                    key: Key('${equipments.serial}'),
                    icon: const Icon(Icons.close,
                        key: Key('delete-equipment'),
                        size: 30,
                        color: Colors.grey),
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            DeleteWarningEquipment(context),
                      ).then((value) async {
                        if (value) {
                          await deleteEquipment(equipments.id!, context);
                          handleRefresh();
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        return Card(
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Color(0xFF6CCFF7), width: 2),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            onTap: () async {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (BuildContext context) {
                        return HistoryEquipmentScreen(equipments.id!);
                      },
                      fullscreenDialog: true))
                  .then((_) async => await handleRefresh());
            },
            title: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ConstrainedBox(
                  //   constraints: BoxConstraints(
                  //       maxWidth: MediaQuery.of(context).size.width * 1 / 2), child:
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    width: MediaQuery.of(context).size.width * 1 / 2,
                    child: AutoSizeText(
                      equipments.model!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      minFontSize: 12,
                      style: const TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                          fontFamily: 'mont',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  // ),
                  statusColor(equipments.equipmentStatus!),
                  const Spacer(),
                  Container(
                    margin: const EdgeInsets.only(right: 10, top: 5),
                    child: IconButton(
                      key: Key('${equipments.serial}'),
                      icon: const Icon(Icons.close,
                          key: Key('delete-equipment'),
                          size: 30,
                          color: Colors.grey),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              DeleteWarningEquipment(context),
                        ).then((value) async {
                          if (value) {
                            await deleteEquipment(equipments.id!, context);
                            handleRefresh();
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 7.0, right: 15.0, left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Serial: ${equipments.serial!} ',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                        fontFamily: 'mont', fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    'Processor: ${equipments.processor!}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                        fontFamily: 'mont', fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    'Memory: ${equipments.memory!}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                        fontFamily: 'mont', fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    'Storage: ${equipments.storage!}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                        fontFamily: 'mont', fontSize: 14, color: Colors.grey),
                  ),
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    const Text(
                      'User:',
                      style: TextStyle(
                          fontFamily: 'mont', fontSize: 14, color: Colors.grey),
                    ),
                    userComputer(equipments.equipmentsUserModel?.name),
                  ]),
                ],
              ),
            ),
          ),
        );
      }
    });
  }
}

Future deleteEquipment(String equipmentId, BuildContext context) async {
  final response = await http.delete(
    Uri.parse(equipments + '/$equipmentId'),
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
          'Equiment succesfully removed',
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
