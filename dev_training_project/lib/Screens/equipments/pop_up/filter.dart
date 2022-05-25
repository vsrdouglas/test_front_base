// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/Models/parameters_model.dart';
import 'package:my_app/Screens/equipments/widget/equipment_filter.dart';
import '../../../app_constants.dart';

class FilterParameters extends StatefulWidget {
  const FilterParameters(context, {Key? key}) : super(key: key);

  @override
  FilterParametersState createState() => FilterParametersState();
}

class FilterParametersState extends State<FilterParameters> {
  late Future fetchData;
  final List _selectedProcessors = [];
  final List _selectedMemory = [];
  final List _selectedStorage = [];
  final List _selectedAllNames = [];

  @override
  void initState() {
    fetchData = fetchInfoEquipments();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<dynamic>> fetchInfoEquipments() async {
    final dynamic dataAll;
    List<ParametersModel> _itemsProcessorLst = [];
    List<ParametersModel> _itemsMemoryLst = [];
    List<ParametersModel> _itemsStorageLst = [];

    final data =
        await http.get(Uri.parse('$equipments/available/filters'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    dataAll = jsonDecode(data.body);
    dataAll['processors'].forEach((processor) => _itemsProcessorLst
        .add(ParametersModel(id: processor['id'], value: processor['model'])));
    dataAll['memory'].forEach((memory) => _itemsMemoryLst.add(ParametersModel(
        id: memory['id'], value: '${memory['size']} ${memory['unit']}')));
    dataAll['storage'].forEach((storage) => _itemsStorageLst.add(
        ParametersModel(
            id: storage['id'],
            value:
                '${storage['type']} ${storage['size']} ${storage['unit']}')));

    return [_itemsProcessorLst, _itemsMemoryLst, _itemsStorageLst];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<ParametersModel> processorsList =
                (snapshot.data as List)[0];
            final List<ParametersModel> memoryList = (snapshot.data as List)[1];
            final List<ParametersModel> storageList =
                (snapshot.data as List)[2];

            return AlertDialog(
              scrollable: true,
              title: const Text(
                'Select Filter',
                maxLines: 2,
                style: TextStyle(
                  fontFamily: 'montBold',
                  fontSize: 22,
                ),
              ),
              content: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.65),
                child: Column(
                  children: [
                    EquipmentFilterWidget(
                      name: 'Processors',
                      listOfOptions: processorsList,
                      filteredOptions: _selectedProcessors,
                      selectedNames: _selectedAllNames,
                    ),
                    const SizedBox(height: 15.0),
                    EquipmentFilterWidget(
                      name: 'Memory',
                      listOfOptions: memoryList,
                      filteredOptions: _selectedMemory,
                      selectedNames: _selectedAllNames,
                    ),
                    const SizedBox(height: 15.0),
                    EquipmentFilterWidget(
                      name: 'Storage',
                      listOfOptions: storageList,
                      filteredOptions: _selectedStorage,
                      selectedNames: _selectedAllNames,
                    ),
                    const SizedBox(height: 15.0),
                  ],
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
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop([
                      true,
                      _selectedProcessors,
                      _selectedMemory,
                      _selectedStorage,
                      _selectedAllNames
                    ]);
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
