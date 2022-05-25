import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:my_app/Screens/history_equipment/history_equipment_screen.dart';

// ignore: must_be_immutable
class Warning extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  var errorBody;
  late String errorMessage;
  bool infoData;
  late dynamic equipmentsParameters;
  late List<Widget>? infosEquipments;
  Warning(BuildContext context, this.errorBody,
      {this.infoData = false, Key? key})
      : super(key: key) {
    errorMessage = checkError(errorBody);
    if (infoData) {
      equipmentsParameters = jsonDecode(errorBody)['data'];
      infosEquipments =
          equipmentsParametersString(equipmentsParameters, context);
    }
  }

  String checkError(error) {
    var errorChecking = jsonDecode(error)['error'];

    if (errorChecking is List) {
      String message = 'The following went wrong:\n';
      switch (errorChecking.length) {
        case 1:
          message = message + errorChecking[0];
          break;
        default:
          for (var i = 0; i < errorChecking.length; i++) {
            message = message + errorChecking[i] + '\n';
          }
      }
      return (message);
    }
    return ('The following went wrong:\n' + errorChecking);
  }

  equipmentsParametersString(dynamic equipmentModel, context) {
    List<Widget> list = [];
    for (int i = 0; i < equipmentModel.length; i++) {
      list.add(Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
        ),
        margin: const EdgeInsets.only(top: 10),
        child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) {
                    return HistoryEquipmentScreen(equipmentModel[i]['id']);
                  },
                  fullscreenDialog: true));
            },
            child: Card(
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Color(0xFF6CCFF7), width: 2),
                borderRadius: BorderRadius.circular(5.0),
              ),
              elevation: 3.0,
              shadowColor: Colors.grey[500],
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  equipmentModel[i]['model'],
                  textAlign: TextAlign.start,
                  style: const TextStyle(fontFamily: 'mont', fontSize: 14),
                ),
              ),
            )),
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: const Key('warning-popup'),
      title: const Text(
        'Warning',
        style: TextStyle(
          color: Colors.red,
          fontFamily: "montBold",
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 0),
              padding: const EdgeInsets.only(top: 0, bottom: 0, left: 0),
              child: Text(
                errorMessage,
                style: const TextStyle(fontFamily: 'mont', fontSize: 14),
              ),
            ),
            infoData == true &&
                    infosEquipments != null &&
                    infosEquipments!.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: infosEquipments!.length,
                    itemBuilder: (context, index) {
                      return infosEquipments![index];
                    },
                  )
                : Container(),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Ok',
            key: Key('text-warning'),
            style: TextStyle(
              fontFamily: 'montBold',
              color: Color(0xFF213e4b),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
