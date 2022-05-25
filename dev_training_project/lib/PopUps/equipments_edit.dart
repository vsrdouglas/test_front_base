// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:my_app/Models/equipments_detail_model.dart';
import '../app_constants.dart';

class EditEquipments extends StatefulWidget {
  var ctx;
  Equipments equipment;
  Function loadData;

  EditEquipments(this.equipment, this.ctx, {required this.loadData, Key? key})
      : super(key: key);

  @override
  EditEquipmentsState createState() => EditEquipmentsState();
}

class EditEquipmentsState extends State<EditEquipments> {
  final _keyForm = GlobalKey<FormState>();
  bool checkWarranty = false;
  late String textStorageSize, textProcessor, textMemory;
  late Future futureData;
  String? textStorageType;
  final GlobalKey<FormFieldState> _key = GlobalKey<FormFieldState>();
  dynamic dataProcessor, dataMemory, dataStorage;

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

  @override
  void initState() {
    textProcessor = widget.equipment.processor!;
    textMemory = widget.equipment.memory!;
    futureData = fetchInfoEquipments();
    super.initState();
    checkWarranty = widget.equipment.warranty != null;
  }

  editEquipments() async {
    final data =
        await http.put(Uri.parse(equipments + '/${widget.equipment.id}'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(<String, dynamic>{
              "model": widget.equipment.model,
              "serial": widget.equipment.serial,
              "processorId": widget.equipment.processorId,
              "memoryId": widget.equipment.memoryId,
              "storage": {
                "type": widget.equipment.storageType,
                "size": widget.equipment.storageSize!.split(' ')[0],
                "unit": widget.equipment.storageSize!.split(' ')[1],
              },
              "billingNumber": widget.equipment.billingNumber,
              "cost":
                  widget.equipment.cost == '' ? null : widget.equipment.cost,
              "purchaseDate": widget.equipment.purchaseDate,
              "warranty": widget.equipment.warranty,
              "company": widget.equipment.company,
              "note": widget.equipment.note,
              "status": widget.equipment.status
            }));
    if (data.statusCode == 200) {
      return ScaffoldMessenger.of(widget.ctx).showSnackBar(
        const SnackBar(
          content: Text(
            'Equipments succesfully edit',
            style: TextStyle(fontFamily: 'mont'),
          ),
        ),
      );
    } else {
      throw Exception('Failed to finish request');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureData,
        builder: (context, snapshot) {
          return AlertDialog(
            scrollable: true,
            title: const Text(
              'Edit Equipment',
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
                            key: const Key('model-edit'),
                            style: const TextStyle(
                                fontFamily: "mont", fontSize: 14),
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFF6CCFF7), width: 2),
                              ),
                              border: OutlineInputBorder(),
                              labelText: 'Model: ',
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
                            initialValue: widget.equipment.model,
                            onSaved: (value) {
                              widget.equipment.model = value!;
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: TextFormField(
                            key: const Key('serial-edit'),
                            style: const TextStyle(
                                fontFamily: "mont", fontSize: 14),
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFF6CCFF7), width: 2),
                              ),
                              border: OutlineInputBorder(),
                              labelText: 'Serial Number: ',
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
                            initialValue: widget.equipment.serial,
                            onSaved: (value) {
                              widget.equipment.serial = value!;
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: TextFormField(
                            key: const Key('billing-edit'),
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
                            initialValue: widget.equipment.billingNumber,
                            onSaved: (value) {
                              widget.equipment.billingNumber = value!;
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: TextFormField(
                            key: const Key('cost-edit'),
                            style: const TextStyle(
                                fontFamily: "mont", fontSize: 14),
                            decoration: const InputDecoration(
                              prefixText: 'R\$',
                              hintText: '0000.00',
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
                            ),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            initialValue: widget.equipment.cost,
                            onSaved: (value) {
                              widget.equipment.cost = value!;
                            },
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: DropdownButtonFormField<String>(
                              key: const Key('processor-equipment-edit'),
                              value: widget.equipment.processorId,
                              onSaved: (value) {
                                if (value != null) {
                                  widget.equipment.processorId = value;
                                }
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
                            key: const Key('memory-equipment-edit'),
                            value: widget.equipment.memoryId,
                            onSaved: (value) {
                              if (value != null) {
                                widget.equipment.memoryId = value;
                              }
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
                                  key: const Key('storagetype-equipment-edit'),
                                  value: widget.equipment.storageType,
                                  onSaved: (value) {
                                    if (value != null) {
                                      widget.equipment.storageType = value;
                                    }
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
                                      widget.equipment.storageType =
                                          textStorageType;
                                    });
                                    if (widget.equipment.storageType != null &&
                                        widget.equipment.storageSize != null) {
                                      _key.currentState?.reset();
                                      widget.equipment.storageSize = null;
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
                                  value: widget.equipment.storageSize,
                                  onSaved: (value) {
                                    if (value != null) {
                                      widget.equipment.storageSize = value;
                                    }
                                  },
                                  validator: (value) {
                                    if (value == null || value == '') {
                                      return 'Please Enter a Storage Size';
                                    }
                                    return null;
                                  },
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    key: Key('storageSize-equipment-edit'),
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
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      textStorageSize = newValue!;
                                      widget.equipment.storageSize =
                                          textStorageSize;
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
                            key: Key(widget.equipment.purchaseDate ??
                                'Purchase Date'),
                            decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFF6CCFF7), width: 2),
                              ),
                              border: const OutlineInputBorder(),
                              labelText: widget.equipment.purchaseDate ??
                                  'Purchase Date',
                              labelStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontFamily: "mont",
                                  fontSize: 14),
                              suffixIcon: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.grey[600],
                              ),
                            ),
                            initialValue: widget.equipment.purchaseDate,
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
                                      widget.equipment.purchaseDate =
                                          DateFormat("yyyy-MM-dd")
                                              .format(date!);
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
                              value: checkWarranty,
                              onChanged: (bool? value) {
                                setState(() {
                                  checkWarranty = value!;
                                });
                              },
                            ),
                            Expanded(
                              child: Container(
                                height: 100,
                                padding: const EdgeInsets.only(top: 20),
                                child: TextFormField(
                                  key: Key(
                                      widget.equipment.warranty ?? 'Warranty'),
                                  enabled: checkWarranty,
                                  initialValue: widget.equipment.warranty,
                                  decoration: InputDecoration(
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFF6CCFF7), width: 2),
                                    ),
                                    border: const OutlineInputBorder(),
                                    labelText: 'Warranty Due Date',
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
                                    if (checkWarranty) {
                                      if (widget.equipment.warranty ==
                                          'Warranty') {
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
                                            widget.equipment.warranty =
                                                DateFormat("yyyy-MM-dd")
                                                    .format(date!);
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
                              value: widget.equipment.company,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontFamily: 'mont',
                                  fontSize: 14),
                              onSaved: (value) {
                                widget.equipment.company = value!;
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
                                  widget.equipment.company = newValue!;
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
                              value: widget.equipment.status,
                              onSaved: (value) {
                                widget.equipment.status = value!;
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
                                labelText: 'Status',
                                labelStyle: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: "mont",
                                    fontSize: 14),
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  widget.equipment.status = newValue!;
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
                            initialValue: widget.equipment.note,
                            onSaved: (value) {
                              if (value != null && value != '') {
                                widget.equipment.note = value;
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
                  Navigator.of(context).pop(false);
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
                onPressed: () async {
                  if (_keyForm.currentState!.validate()) {
                    _keyForm.currentState!.save();
                    Navigator.of(context).pop(true);
                    await editEquipments();
                    widget.loadData();
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
      if (storageList[i]['type'] == widget.equipment.storageType) {
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
