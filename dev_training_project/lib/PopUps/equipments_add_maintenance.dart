import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:my_app/Models/maintenance_model.dart';

import '../app_constants.dart';
import 'warning_popup.dart';

class AddEquipmentsMaintenancePopup extends StatefulWidget {
  final BuildContext ctx;
  final String equipmentId;
  final VoidCallback handleRefresh;
  const AddEquipmentsMaintenancePopup(
      {required this.ctx,
      required this.equipmentId,
      required this.handleRefresh,
      Key? key})
      : super(key: key);

  @override
  AddEquipmentsMaintenancePopupState createState() =>
      AddEquipmentsMaintenancePopupState();
}

class AddEquipmentsMaintenancePopupState
    extends State<AddEquipmentsMaintenancePopup> {
  final _keyForm = GlobalKey<FormState>();
  Maintenance maintenance = Maintenance();

  addMaintenance(Maintenance maintenance) async {
    final data = await http.post(
        Uri.parse(equipments + "/maintenance/${widget.equipmentId}"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          "name": maintenance.name,
          "cost": maintenance.cost,
          "type": maintenance.type,
          "status": maintenance.status,
          "startDate": maintenance.startDate,
          "endDate": maintenance.endDate,
          "description": maintenance.description,
        }));
    if (data.statusCode == 200) {
      widget.handleRefresh();
      return ScaffoldMessenger.of(widget.ctx).showSnackBar(
        const SnackBar(
          content: Text(
            'Maintenance succesfully added',
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
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text(
        'Add Maintenance',
        style: TextStyle(
          fontFamily: 'montBold',
          fontSize: 22,
        ),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300, minWidth: 300),
            child: Form(
              key: _keyForm,
              child: Column(
                children: [
                  const SizedBox(height: 5.0),
                  TextFormField(
                    key: const Key('add-maintenance-name'),
                    style: const TextStyle(fontFamily: "mont", fontSize: 14),
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF6CCFF7), width: 2),
                      ),
                      border: OutlineInputBorder(),
                      labelText: 'Name* ',
                      labelStyle: TextStyle(
                          color: Colors.grey, fontFamily: "mont", fontSize: 14),
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
                      maintenance.name = value!;
                    },
                  ),
                  const SizedBox(height: 5.0),
                  TextFormField(
                    key: const Key('add-maintenance-cost'),
                    style: const TextStyle(fontFamily: "mont", fontSize: 14),
                    decoration: const InputDecoration(
                      prefixText: 'R\$',
                      hintText: '0000.00',
                      hintStyle: TextStyle(fontFamily: 'mont'),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF6CCFF7), width: 2),
                      ),
                      border: OutlineInputBorder(),
                      labelText: 'Cost:',
                      labelStyle: TextStyle(
                          color: Colors.grey, fontFamily: "mont", fontSize: 14),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter(',',
                          allow: false, replacementString: '.'),
                      FilteringTextInputFormatter.allow(
                          RegExp(r"^\d+\.?\d{0,2}")),
                    ],
                    onSaved: (value) {
                      if (value != null && value.isNotEmpty) {
                        maintenance.cost = double.parse(value);
                      }
                    },
                  ),
                  const SizedBox(height: 5.0),
                  DropdownButtonFormField<String>(
                    key: const Key('add-maintenance-type'),
                    value: maintenance.type,
                    onSaved: (value) {
                      maintenance.type = value!;
                    },
                    validator: (value) {
                      if (value == null || value == '') {
                        return 'Please Enter a type';
                      }
                      return null;
                    },
                    onChanged: (String? newValue) {
                      setState(() {
                        maintenance.type = newValue!;
                      });
                    },
                    icon: const Icon(Icons.keyboard_arrow_down),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(
                        color: Colors.black, fontFamily: 'mont', fontSize: 14),
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF6CCFF7), width: 2),
                      ),
                      border: OutlineInputBorder(),
                      labelText: 'Type*',
                      labelStyle: TextStyle(
                          color: Colors.grey, fontFamily: "mont", fontSize: 14),
                    ),
                    items: <String>['Maintenance', 'Test']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 14)),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 5.0),
                  DropdownButtonFormField<String>(
                    key: const Key('add-maintenance-status'),
                    value: maintenance.status,
                    onSaved: (value) {
                      maintenance.status = value!;
                    },
                    validator: (value) {
                      if (value == null || value == '') {
                        return 'Please Enter a status';
                      }
                      return null;
                    },
                    onChanged: (String? newValue) {
                      setState(() {
                        maintenance.status = newValue!;
                        if (maintenance.status == 'Complete') {
                          if (maintenance.startDate == null) {
                            maintenance.startDate =
                                DateFormat("yyyy-MM-dd").format(DateTime.now());
                            maintenance.endDate =
                                DateFormat("yyyy-MM-dd").format(DateTime.now());
                          } else {
                            maintenance.endDate = maintenance.startDate;
                          }
                        } else {
                          maintenance.startDate =
                              DateFormat("yyyy-MM-dd").format(DateTime.now());
                          maintenance.endDate = null;
                        }
                      });
                    },
                    icon: const Icon(Icons.keyboard_arrow_down),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(
                        color: Colors.black, fontFamily: 'mont', fontSize: 14),
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF6CCFF7), width: 2),
                      ),
                      border: OutlineInputBorder(),
                      labelText: 'Status*',
                      labelStyle: TextStyle(
                          color: Colors.grey, fontFamily: "mont", fontSize: 14),
                    ),
                    items: <String>['Complete', 'In progress', 'Out of service']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 14)),
                      );
                    }).toList(),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: TextFormField(
                      key: Key(maintenance.startDate ?? 'StartDate'),
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFF6CCFF7), width: 2),
                        ),
                        border: const OutlineInputBorder(),
                        labelText: 'Start Date*',
                        labelStyle: const TextStyle(
                            color: Colors.grey,
                            fontFamily: "mont",
                            fontSize: 14),
                        suffixIcon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey[600],
                        ),
                      ),
                      initialValue: maintenance.startDate,
                      validator: (value) {
                        if (maintenance.startDate == null) {
                          return 'Please enter a date.';
                        }
                        return null;
                      },
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
                                if (date != null) {
                                  maintenance.startDate =
                                      DateFormat("yyyy-MM-dd").format(date);
                                  if (maintenance.status == 'Complete') {
                                    maintenance.endDate =
                                        DateFormat("yyyy-MM-dd").format(date);
                                  }
                                }
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: TextFormField(
                      key: Key(maintenance.endDate ?? 'EndDate'),
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFF6CCFF7), width: 2),
                        ),
                        border: const OutlineInputBorder(),
                        labelText: 'End Date',
                        labelStyle: const TextStyle(
                            color: Colors.grey,
                            fontFamily: "mont",
                            fontSize: 14),
                        suffixIcon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey[600],
                        ),
                      ),
                      initialValue: maintenance.endDate,
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        showDatePicker(
                                context: context,
                                initialDate: maintenance.startDate == null
                                    ? DateTime.now()
                                    : DateFormat("yyyy-MM-dd")
                                        .parse(maintenance.startDate!),
                                firstDate: maintenance.startDate == null
                                    ? DateTime(2015)
                                    : DateFormat("yyyy-MM-dd")
                                        .parse(maintenance.startDate!),
                                lastDate: DateTime(2050))
                            .then(
                          (date) {
                            setState(
                              () {
                                if (date != null) {
                                  maintenance.endDate =
                                      DateFormat("yyyy-MM-dd").format(date);
                                }
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  TextFormField(
                    style: const TextStyle(fontFamily: "mont", fontSize: 14),
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF6CCFF7), width: 2),
                      ),
                      border: OutlineInputBorder(),
                      labelText: 'Description: ',
                      labelStyle: TextStyle(
                          color: Colors.grey, fontFamily: "mont", fontSize: 14),
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    maxLines: 3,
                    onSaved: (value) {
                      maintenance.description = value;
                    },
                  ),
                  const SizedBox(height: 5.0),
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
          key: const Key('add-maintenance-confirm'),
          onPressed: () async {
            if (_keyForm.currentState!.validate()) {
              _keyForm.currentState!.save();
              Navigator.of(context).pop(true);
              await addMaintenance(maintenance);
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
  }
}
