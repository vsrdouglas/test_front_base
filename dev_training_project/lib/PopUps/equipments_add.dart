// ignore_for_file: must_be_immutable

import '../app_constants.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:my_app/Models/equipments_detail_model.dart';
import 'package:my_app/Screens/equipments/equipments_screen.dart';
import 'warning_popup.dart';

class AddEquipmentsPopup extends StatefulWidget {
  final BuildContext ctx;
  late StreamController refreshController;
  AddEquipmentsPopup(this.ctx, this.refreshController, {Key? key})
      : super(key: key);

  @override
  AddEquipmentsPopupState createState() => AddEquipmentsPopupState();
}

class AddEquipmentsPopupState extends State<AddEquipmentsPopup> {
  final _keyForm = GlobalKey<FormState>();
  late DateTime _dateTime = DateTime.now();
  late DateTime _dateTimeW = DateTime.now();
  String text = "Purchase Date";
  late String textMemory;
  late String textProcessor;
  String? textStorageSize, textStorageType;
  final GlobalKey<FormFieldState> _key = GlobalKey<FormFieldState>();

  String textWarranty = "Warranty Due Date";
  bool check = false;
  bool checkTest = false;
  String dropdownValue = "Tunts";
  String dropdownValueSecond = "Working";
  Equipments equipment = Equipments();
  late Future futureData;
  dynamic dataProcessor, dataMemory, dataStorage;

  addEquipments(Equipments equipment) async {
    final data = await http.post(Uri.parse(equipments),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          "model": equipment.model,
          "serial": equipment.serial,
          "processorId": equipment.processor,
          "memoryId": equipment.memory,
          "storage": {
            "type": equipment.storageType,
            "size": equipment.storageSize!.split(' ')[0],
            "unit": equipment.storageSize!.split(' ')[1],
          },
          "purchaseDate": equipment.purchaseDate,
          "warranty": equipment.warranty,
          "company": equipment.company,
          "note": equipment.note,
          "status": equipment.status,
          "billingNumber": equipment.billingNumber,
          "cost": equipment.cost
        }));
    if (data.statusCode == 200) {
      return ScaffoldMessenger.of(widget.ctx).showSnackBar(
        const SnackBar(
          content: Text(
            'Equipments succesfully added',
            style: TextStyle(fontFamily: 'mont'),
          ),
        ),
      );
    } else {
      return showDialog(
        context: widget.ctx,
        builder: (BuildContext context) => Warning(context, data.body),
      );
    }
  }

  @override
  void initState() {
    futureData = fetchInfoEquipments();
    super.initState();
  }

  fetchInfoEquipments() async {
    final data1 =
        await http.get(Uri.parse('$equipments/get/processor'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    dataProcessor = jsonDecode(data1.body);
    final data2 = await http.get(Uri.parse('$equipments/get/memory'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    dataMemory = jsonDecode(data2.body);
    final data3 =
        await http.get(Uri.parse('$equipments/get/storage'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    dataStorage = jsonDecode(data3.body);
  }

  Future<void> handleRefresh() async {
    await fetchDataEquipments().then((res) {
      widget.refreshController.add(res);

      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureData,
        builder: (context, snapshot) {
          return AlertDialog(
            scrollable: true,
            title: const Text(
              'Add Equipments',
              style: TextStyle(
                fontFamily: 'montBold',
                fontSize: 22,
              ),
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxWidth: 300, minWidth: 300),
                  child: Form(
                    key: _keyForm,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: TextFormField(
                            key: const Key('model-add'),
                            style: const TextStyle(
                                fontFamily: "mont", fontSize: 14),
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFF6CCFF7), width: 2),
                              ),
                              border: OutlineInputBorder(),
                              labelText: 'Model*: ',
                              labelStyle: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: "mont",
                                  fontSize: 14),
                            ),
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.split('')[0] == " ") {
                                return 'Please enter a valid Name!';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              equipment.model = value!;
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: TextFormField(
                            key: const Key('serial-add'),
                            style: const TextStyle(
                                fontFamily: "mont", fontSize: 14),
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFF6CCFF7), width: 2),
                              ),
                              border: OutlineInputBorder(),
                              labelText: 'Serial Number*: ',
                              labelStyle: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: "mont",
                                  fontSize: 14),
                            ),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an Serial Number!';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              equipment.serial = value!;
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: TextFormField(
                            key: const Key('billing-add'),
                            style: const TextStyle(
                                fontFamily: "mont", fontSize: 14),
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFF6CCFF7), width: 2),
                              ),
                              border: OutlineInputBorder(),
                              labelText: 'Billing Number: ',
                              labelStyle: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: "mont",
                                  fontSize: 14),
                            ),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            onSaved: (value) {
                              if (value != null && value != '') {
                                equipment.billingNumber = value;
                              }
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: TextFormField(
                            style: const TextStyle(
                                fontFamily: "mont", fontSize: 14),
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFF6CCFF7), width: 2),
                              ),
                              border: OutlineInputBorder(),
                              labelText: 'Cost: ',
                              labelStyle: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: "mont",
                                  fontSize: 14),
                              prefixText: 'R\$',
                              hintText: '0000.00',
                            ),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            inputFormatters: [
                              FilteringTextInputFormatter(',',
                                  allow: false, replacementString: '.'),
                              FilteringTextInputFormatter.allow(
                                  RegExp(r"^\d+\.?\d{0,2}")),
                            ],
                            onSaved: (value) {
                              if (value != null && value != '') {
                                equipment.cost = value;
                              }
                            },
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: DropdownButtonFormField<String>(
                              key: const Key('add-processor-equipment'),
                              onSaved: (value) {
                                equipment.processor = value!;
                              },
                              validator: (value) {
                                if (value == null || value == '') {
                                  return 'Enter a processor';
                                }
                                return null;
                              },
                              icon: const Icon(Icons.keyboard_arrow_down),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontFamily: 'mont',
                                  fontSize: 14),
                              decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xFF6CCFF7), width: 2),
                                ),
                                border: OutlineInputBorder(),
                                labelText: 'Processor*',
                                labelStyle: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: "mont",
                                    fontSize: 14),
                              ),
                              onChanged: (newValue) {
                                setState(() {
                                  textProcessor = newValue!;
                                });
                              },
                              items: dataProcessor == null
                                  ? []
                                  : dataProcessor
                                      .map<DropdownMenuItem<String>>((value) {
                                      return DropdownMenuItem<String>(
                                        value: value['id'],
                                        child: Text(value['model'],
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14)),
                                      );
                                    }).toList(),
                            )),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: DropdownButtonFormField<String>(
                            key: const Key('add-memory-equipment'),
                            onSaved: (value) {
                              equipment.memory = value!;
                            },
                            validator: (value) {
                              if (value == null || value == '') {
                                return 'Enter a memory';
                              }
                              return null;
                            },
                            icon: const Icon(Icons.keyboard_arrow_down),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontFamily: 'mont',
                                fontSize: 14),
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFF6CCFF7), width: 2),
                              ),
                              border: OutlineInputBorder(),
                              labelText: 'Memory*',
                              labelStyle: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: "mont",
                                  fontSize: 14),
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                textMemory = newValue!;
                              });
                            },
                            items: dataMemory == null
                                ? []
                                : dataMemory
                                    .map<DropdownMenuItem<String>>((value) {
                                    return DropdownMenuItem<String>(
                                      value: value['id'],
                                      child: Text(
                                          '${value['size']} ${value['unit']}',
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14)),
                                    );
                                  }).toList(),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: DropdownButtonFormField<String>(
                                  key: const Key('add-storageType-equipment'),
                                  onSaved: (value) {
                                    equipment.storageType = value!;
                                  },
                                  validator: (value) {
                                    if (value == null || value == '') {
                                      return 'Enter a storage Type';
                                    }
                                    return null;
                                  },
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: TextStyle(
                                      color: Colors.grey[600],
                                      fontFamily: 'mont',
                                      fontSize: 14),
                                  decoration: const InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFF6CCFF7), width: 2),
                                    ),
                                    border: OutlineInputBorder(),
                                    labelText: 'Storage Type*',
                                    labelStyle: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: "mont",
                                        fontSize: 14),
                                  ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      textStorageType = newValue!;
                                    });
                                    if (textStorageType != null &&
                                        textStorageSize != null) {
                                      _key.currentState?.reset();
                                    }
                                  },
                                  items: dataStorage == null
                                      ? []
                                      : storageDebug(dataStorage),
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: DropdownButtonFormField<String>(
                                  key: _key,
                                  onSaved: (value) {
                                    equipment.storageSize = value!;
                                  },
                                  validator: (value) {
                                    if (value == null || value == '') {
                                      return 'Enter a storage size';
                                    }
                                    return null;
                                  },
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    key: Key('add-storageSize-equipment'),
                                  ),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: TextStyle(
                                      color: Colors.grey[600],
                                      fontFamily: 'mont',
                                      fontSize: 14),
                                  decoration: const InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFF6CCFF7), width: 2),
                                    ),
                                    border: OutlineInputBorder(),
                                    labelText: 'Storage Size*',
                                    labelStyle: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: "mont",
                                        fontSize: 14),
                                  ),
                                  onChanged: textStorageType == null
                                      ? null
                                      : (String? newValue) {
                                          setState(() {
                                            textStorageSize = newValue!;
                                          });
                                        },
                                  items: dataStorage == null
                                      ? []
                                      : storageSizeItems(dataStorage),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: TextFormField(
                            onSaved: (valeu) {
                              if (text == "Purchase Date") {
                                equipment.purchaseDate = null;
                              } else {
                                equipment.purchaseDate = text;
                              }
                            },
                            decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFF6CCFF7), width: 2),
                              ),
                              border: const OutlineInputBorder(),
                              labelText: text,
                              labelStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontFamily: "mont",
                                  fontSize: 14),
                              suffixIcon: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.grey[600],
                              ),
                            ),
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1980),
                                      lastDate: DateTime(2050))
                                  .then(
                                (date) {
                                  setState(
                                    () {
                                      _dateTime = date!;
                                      text = DateFormat("yyyy-MM-dd")
                                          .format(_dateTime);
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              width: 100,
                              height: 50,
                              child: Text(
                                'Has warranty?',
                                maxLines: 2,
                                style:
                                    TextStyle(fontFamily: 'mont', fontSize: 15),
                              ),
                            ),
                            Checkbox(
                              value: check,
                              onChanged: (bool? value) {
                                setState(() {
                                  check = value!;
                                });
                              },
                            ),
                            Expanded(
                              child: Container(
                                height: 100,
                                padding: const EdgeInsets.only(top: 20),
                                child: TextFormField(
                                  enabled: check,
                                  onSaved: (value) {
                                    if (check &&
                                        textWarranty != "Warranty Due Date") {
                                      equipment.warranty = textWarranty;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFF6CCFF7), width: 2),
                                    ),
                                    border: const OutlineInputBorder(),
                                    labelText: textWarranty,
                                    labelStyle: const TextStyle(
                                        color: Colors.grey,
                                        fontFamily: "mont",
                                        fontSize: 14),
                                    suffixIcon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  validator: (value) {
                                    if (check) {
                                      if (textWarranty == 'Warranty Due Date') {
                                        return 'Please enter warranty date.';
                                      }
                                    }
                                    return null;
                                  },
                                  onTap: () {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(1980),
                                            lastDate: DateTime(2050))
                                        .then(
                                      (date) {
                                        setState(
                                          () {
                                            _dateTimeW = date!;
                                            textWarranty =
                                                DateFormat("yyyy-MM-dd")
                                                    .format(_dateTimeW);
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: DropdownButtonFormField<String>(
                              value: dropdownValue,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontFamily: 'mont',
                                  fontSize: 14),
                              onSaved: (value) {
                                equipment.company = value!;
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select a company';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xFF6CCFF7), width: 2),
                                ),
                                border: OutlineInputBorder(),
                                labelText: 'Company*',
                                labelStyle: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: "mont",
                                    fontSize: 14),
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                });
                              },
                              items: <String>[
                                'Tunts',
                                'AOA'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 14)),
                                );
                              }).toList(),
                            )),
                        Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: DropdownButtonFormField<String>(
                              value: dropdownValueSecond,
                              onSaved: (value) {
                                equipment.status = value!;
                              },
                              validator: (value) {
                                if (value == null || value == '') {
                                  return 'Enter a status';
                                }
                                return null;
                              },
                              icon: const Icon(Icons.keyboard_arrow_down),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontFamily: 'mont',
                                  fontSize: 14),
                              decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xFF6CCFF7), width: 2),
                                ),
                                border: OutlineInputBorder(),
                                labelText: 'Status*',
                                labelStyle: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: "mont",
                                    fontSize: 14),
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValueSecond = newValue!;
                                });
                              },
                              items: <String>[
                                'Working',
                                'Maintenance',
                                'Defective'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 14)),
                                );
                              }).toList(),
                            )),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: TextFormField(
                            style: const TextStyle(
                                fontFamily: "mont", fontSize: 14),
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFF6CCFF7), width: 2),
                              ),
                              border: OutlineInputBorder(),
                              labelText: 'Notes: ',
                              labelStyle: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: "mont",
                                  fontSize: 14),
                            ),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            maxLines: 2,
                            onSaved: (value) {
                              if (value != null && value != '') {
                                equipment.note = value;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
              TextButton(
                key: const Key('confirm-add-equipment'),
                onPressed: () async {
                  if (_keyForm.currentState!.validate()) {
                    _keyForm.currentState!.save();
                    Navigator.of(context).pop();
                    await addEquipments(equipment);
                    handleRefresh();
                  }
                },
                child: Container(
                  color: const Color(0xFF6CCFF7),
                  padding: const EdgeInsets.all(6),
                  child: const Text(
                    'Confirm',
                    style: TextStyle(
                      fontFamily: 'montBold',
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  List<DropdownMenuItem<String>> storageDebug(dynamic dataStorage) {
    List storageList = dataStorage.toList();
    List<DropdownMenuItem<String>> list = [];
    List<DropdownMenuItem<String>> listNew = [];
    for (int i = 0; i < storageList.length; i++) {
      list.add(DropdownMenuItem<String>(
        value: storageList[i]['type'],
        child: Text(storageList[i]['type'],
            style: const TextStyle(color: Colors.grey, fontSize: 14)),
      ));
    }
    listNew = list.fold([], (results, currentItem) {
      if (!results.any((item) => item.value == currentItem.value)) {
        results.add(currentItem);
      }
      return results;
    });

    return listNew;
  }

  List<DropdownMenuItem<String>> storageSizeItems(dynamic dataStorage) {
    List storageList = dataStorage.toList();
    List<DropdownMenuItem<String>> list = [];
    for (int i = 0; i < storageList.length; i++) {
      if (storageList[i]['type'] == textStorageType) {
        list.add(DropdownMenuItem<String>(
          value: '${storageList[i]['size']} ${storageList[i]['unit']}',
          child: Text('${storageList[i]['size']} ${storageList[i]['unit']}',
              style: const TextStyle(color: Colors.grey, fontSize: 14)),
        ));
      }
    }
    return list;
  }
}
