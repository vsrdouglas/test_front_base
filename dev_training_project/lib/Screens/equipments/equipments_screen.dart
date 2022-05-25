import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../app_constants.dart';
import 'package:my_app/Screens/equipments/equipments_search_list.dart';

class EquipmentsBody extends StatefulWidget {
  const EquipmentsBody({Key? key}) : super(key: key);

  @override
  EquipmentsBodyState createState() => EquipmentsBodyState();
}

class EquipmentsBodyState extends State<EquipmentsBody> {
  late StreamController refreshController;

  loadData() async {
    fetchDataEquipments().then((res) async {
      refreshController.add(res);
      return res;
    });
  }

  Future handleRefresh() async {
    await fetchDataEquipments().then((res) {
      refreshController.add(res);
      return null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    refreshController.close();
  }

  @override
  void initState() {
    refreshController = StreamController();
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<dynamic>(
        stream: refreshController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            dynamic equipmentsJson = snapshot.data;
            return SearchBarEquipments(equipmentsJson, refreshController);
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
        });
  }
}

Future fetchDataEquipments() async {
  final data = await http.get(Uri.parse(equipments), headers: {
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
