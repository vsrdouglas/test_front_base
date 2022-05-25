import 'dart:async';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:my_app/PopUps/delete_parameters.dart';
import 'package:my_app/PopUps/warning_popup.dart';
import 'package:my_app/Widgets/details_backbutton.dart';
import 'package:http/http.dart' as http;

import '../PopUps/equipments_add_memory.dart';
import '../PopUps/equipments_add_processor.dart';
import '../PopUps/equipments_add_storage.dart';
import '../app_constants.dart';

class ManageEquipmentsParameters extends StatefulWidget {
  const ManageEquipmentsParameters({Key? key}) : super(key: key);

  @override
  State<ManageEquipmentsParameters> createState() =>
      _ManageEquipmentsParametersState();
}

class _ManageEquipmentsParametersState extends State<ManageEquipmentsParameters>
    with TickerProviderStateMixin {
  StreamController? refreshController;
  String equipmentType = "Processor";

  @override
  void initState() {
    refreshController = StreamController();
    loadData('processor');
    super.initState();
  }

  deleteParameters(id, parameter) async {
    final response = await http.delete(
      Uri.parse(equipments + '/$parameter/' + id),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$parameter succesfully removed',
            style: const TextStyle(fontFamily: 'mont'),
          ),
        ),
      );
    } else {
      return showDialog(
        context: context,
        builder: (BuildContext context) =>
            Warning(context, response.body, infoData: true),
      );
    }
  }

  @override
  void dispose() {
    refreshController!.close();
    super.dispose();
  }

  Future fetchDataEquipmentsParameters(String value) async {
    final data =
        await http.get(Uri.parse(equipments + '/get/$value'), headers: {
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

  loadData(String value) async {
    refreshController!.add(null);
    await fetchDataEquipmentsParameters(value).then((res) {
      refreshController!.add(res);

      return res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: refreshController!.stream,
      builder: (context, AsyncSnapshot snapshot) {
        return LayoutBuilder(
          builder: (context, BoxConstraints constraints) {
            if (constraints.maxWidth > 800) {
              return parametersWeb(constraints, snapshot, context);
            } else {
              return parametersApp(constraints, snapshot, context);
            }
          },
        );
      },
    );
  }

  Widget buttonEquipments(
      {required String parameter, required AsyncSnapshot<dynamic> snapshot}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Text(
            parameter == 'processor'
                ? 'Processor Parameters'
                : parameter == 'memory'
                    ? 'Memory Parameters'
                    : 'Storage Parameters',
            style: const TextStyle(fontFamily: 'montBold', fontSize: 16),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            color: Color(0xFF6CCFF7), width: 2),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      margin: const EdgeInsets.symmetric(
                        vertical: 3.0,
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        title: AutoSizeText(
                          parameter == 'processor'
                              ? snapshot.data[index]['model']
                              : '${snapshot.data[index]['size']} ${snapshot.data[index]['unit']}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          minFontSize: 12,
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontFamily: 'mont',
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: parameter == 'storage'
                            ? AutoSizeText(snapshot.data[index]['type'],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                minFontSize: 12,
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                    fontFamily: 'mont',
                                    fontWeight: FontWeight.bold))
                            : null,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: IconButton(
                                icon: const Icon(Icons.edit,
                                    size: 30, color: Colors.grey),
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  switch (parameter) {
                                    case 'processor':
                                      showDialog(
                                        context: context,
                                        builder: (_) => EquipmentsAddProcessor(
                                          parentCtx: context,
                                          parameters: snapshot.data[index],
                                          refresh: () => loadData('processor'),
                                        ),
                                      );
                                      break;
                                    case 'memory':
                                      showDialog(
                                          context: context,
                                          builder: (_) => EquipmentsAddMemory(
                                                parentCtx: context,
                                                parameters:
                                                    snapshot.data[index],
                                                refresh: () => loadData(
                                                    equipmentType
                                                        .toLowerCase()),
                                              ));
                                      break;
                                    case 'storage':
                                      showDialog(
                                          context: context,
                                          builder: (_) => EquipmentsAddStorage(
                                                parentCtx: context,
                                                parameters:
                                                    snapshot.data[index],
                                                refresh: () => loadData(
                                                    equipmentType
                                                        .toLowerCase()),
                                              ));
                                      break;
                                    default:
                                  }
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: IconButton(
                                icon: const Icon(Icons.close,
                                    size: 30, color: Colors.grey),
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  switch (equipmentType) {
                                    case 'Processor':
                                      showDialog(
                                              context: context,
                                              builder: (_) =>
                                                  DeleteWarningParameters(
                                                      context, 'processor'))
                                          .then((value) async {
                                        if (value) {
                                          await deleteParameters(
                                              snapshot.data[index]['id'],
                                              'processor');
                                        }
                                      });
                                      break;
                                    case 'Memory':
                                      showDialog(
                                              context: context,
                                              builder: (_) =>
                                                  DeleteWarningParameters(
                                                      context, 'memory'))
                                          .then((value) async {
                                        if (value) {
                                          await deleteParameters(
                                              snapshot.data[index]['id'],
                                              'memory');
                                        }
                                      });
                                      break;
                                    case 'Storage':
                                      showDialog(
                                              context: context,
                                              builder: (_) =>
                                                  DeleteWarningParameters(
                                                      context, 'storage'))
                                          .then((value) async {
                                        if (value) {
                                          await deleteParameters(
                                              snapshot.data[index]['id'],
                                              'storage');
                                        }
                                      });
                                      break;
                                    default:
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }))
        ],
      ),
    );
  }

  Widget parametersApp(BoxConstraints constraints,
      AsyncSnapshot<dynamic> snapshot, BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: 70,
        toolbarHeight: 80,
        backgroundColor: const Color(0xFF6CCFF7),
        leading: const BackButtonWhite(),
        title: const SizedBox(
          width: double.infinity,
          child: AutoSizeText(
            'Equipments Parameters',
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'montBold',
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth / 10),
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            DropdownButtonFormField<String>(
                key: const Key('dropdown-parameters'),
                value: equipmentType,
                elevation: 16,
                icon: const Icon(Icons.keyboard_arrow_down),
                iconSize: 24,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF6CCFF7), width: 2),
                  ),
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(
                      color: Colors.grey, fontFamily: "mont", fontSize: 14),
                ),
                style: const TextStyle(
                    fontFamily: 'mont', fontSize: 14, color: Colors.black),
                items: <String>['Processor', 'Memory', 'Storage']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    equipmentType = value!;
                  });
                  loadData(value!.toLowerCase());
                }),
            const SizedBox(height: 45.0),
            snapshot.hasData
                ? Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: Color(0xFF6CCFF7), width: 2),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          margin: const EdgeInsets.symmetric(
                            vertical: 3.0,
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ),
                            title: AutoSizeText(
                              equipmentType == 'Processor'
                                  ? snapshot.data[index]['model']
                                  : '${snapshot.data[index]['size']} ${snapshot.data[index]['unit']}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              minFontSize: 12,
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontFamily: 'mont',
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: equipmentType == 'Storage'
                                ? AutoSizeText(snapshot.data[index]['type'],
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    minFontSize: 12,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                        fontFamily: 'mont',
                                        fontWeight: FontWeight.bold))
                                : null,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: IconButton(
                                    key: Key('edit-parameters$index'),
                                    icon: const Icon(Icons.edit,
                                        size: 30, color: Colors.grey),
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      switch (equipmentType) {
                                        case 'Processor':
                                          showDialog(
                                            context: context,
                                            builder: (_) =>
                                                EquipmentsAddProcessor(
                                              parentCtx: context,
                                              parameters: snapshot.data[index],
                                              refresh: () =>
                                                  loadData('processor'),
                                            ),
                                          );
                                          break;
                                        case 'Memory':
                                          showDialog(
                                              context: context,
                                              builder: (_) =>
                                                  EquipmentsAddMemory(
                                                    parentCtx: context,
                                                    parameters:
                                                        snapshot.data[index],
                                                    refresh: () => loadData(
                                                        equipmentType
                                                            .toLowerCase()),
                                                  ));
                                          break;
                                        case 'Storage':
                                          showDialog(
                                              context: context,
                                              builder: (_) =>
                                                  EquipmentsAddStorage(
                                                    parentCtx: context,
                                                    parameters:
                                                        snapshot.data[index],
                                                    refresh: () => loadData(
                                                        equipmentType
                                                            .toLowerCase()),
                                                  ));
                                          break;
                                        default:
                                      }
                                    },
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: IconButton(
                                    key: Key('delete-parameters$index'),
                                    icon: const Icon(Icons.close,
                                        size: 30, color: Colors.grey),
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      switch (equipmentType) {
                                        case 'Processor':
                                          showDialog(
                                                  context: context,
                                                  builder: (_) =>
                                                      DeleteWarningParameters(
                                                          context, 'processor'))
                                              .then((value) async {
                                            if (value) {
                                              await deleteParameters(
                                                  snapshot.data[index]['id'],
                                                  'processor');
                                              loadData('processor');
                                            }
                                          });
                                          break;
                                        case 'Memory':
                                          showDialog(
                                                  context: context,
                                                  builder: (_) =>
                                                      DeleteWarningParameters(
                                                          context, 'memory'))
                                              .then((value) async {
                                            if (value) {
                                              await deleteParameters(
                                                  snapshot.data[index]['id'],
                                                  'memory');
                                              loadData('memory');
                                            }
                                          });
                                          break;
                                        case 'Storage':
                                          showDialog(
                                                  context: context,
                                                  builder: (_) =>
                                                      DeleteWarningParameters(
                                                          context, 'storage'))
                                              .then((value) async {
                                            if (value) {
                                              await deleteParameters(
                                                  snapshot.data[index]['id'],
                                                  'storage');
                                              loadData('storage');
                                            }
                                          });
                                          break;
                                        default:
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF6CCFF7),
                      ),
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 60,
        height: 60,
        child: FittedBox(
          child: FloatingActionButton(
            heroTag: 'btn6',
            onPressed: () {
              switch (equipmentType) {
                case 'Processor':
                  showDialog(
                    context: context,
                    builder: (_) => EquipmentsAddProcessor(
                        parentCtx: context,
                        refresh: () => loadData(equipmentType.toLowerCase())),
                  );
                  break;
                case 'Memory':
                  showDialog(
                      context: context,
                      builder: (_) => EquipmentsAddMemory(
                            parentCtx: context,
                            refresh: () =>
                                loadData(equipmentType.toLowerCase()),
                          ));
                  break;
                case 'Storage':
                  showDialog(
                      context: context,
                      builder: (_) => EquipmentsAddStorage(
                            parentCtx: context,
                            refresh: () =>
                                loadData(equipmentType.toLowerCase()),
                          ));
                  break;
                default:
              }
            },
            elevation: 10,
            child: const Icon(
              Icons.add,
              size: 35,
              key: Key('add-button'),
            ),
            backgroundColor: const Color(0xFF6CCFF7),
          ),
        ),
      ),
    );
  }

  Widget parametersWeb(BoxConstraints constraints,
      AsyncSnapshot<dynamic> snapshot, BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          leading: const BackButtonWhite(),
          leadingWidth: 70,
          toolbarHeight: 80,
          backgroundColor: const Color(0xFF6CCFF7),
          title: Row(
            children: const [
              Spacer(),
              Text(
                'Equipments Parameters',
                style: TextStyle(
                    fontSize: 25.0,
                    fontFamily: 'montBold',
                    color: Colors.black),
              ),
            ],
          )),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth / 8),
        child: Column(
          children: [
            const SizedBox(height: 70.0),
            Row(
              children: [
                Expanded(
                  child: Container(),
                ),
                const SizedBox(width: 55.0),
                Expanded(
                  child: DropdownButtonFormField<String>(
                      value: equipmentType,
                      elevation: 16,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      iconSize: 24,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFF6CCFF7), width: 2),
                        ),
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(
                            color: Colors.grey,
                            fontFamily: "mont",
                            fontSize: 14),
                      ),
                      style: const TextStyle(
                          fontFamily: 'mont',
                          fontSize: 14,
                          color: Colors.black),
                      items: <String>['Processor', 'Memory', 'Storage']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 14),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          equipmentType = value!;
                        });
                        loadData(value!.toLowerCase());
                      }),
                ),
              ],
            ),
            const SizedBox(height: 45.0),
            snapshot.hasData
                ? Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: Color(0xFF6CCFF7), width: 2),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          margin: const EdgeInsets.symmetric(
                            vertical: 3.0,
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ),
                            title: AutoSizeText(
                              equipmentType == 'Processor'
                                  ? snapshot.data[index]['model']
                                  : '${snapshot.data[index]['size']} ${snapshot.data[index]['unit']}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              minFontSize: 12,
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontFamily: 'mont',
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: equipmentType == 'Storage'
                                ? AutoSizeText(snapshot.data[index]['type'],
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    minFontSize: 12,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                        fontFamily: 'mont',
                                        fontWeight: FontWeight.bold))
                                : null,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: IconButton(
                                    icon: const Icon(Icons.edit,
                                        size: 30, color: Colors.grey),
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      switch (equipmentType) {
                                        case 'Processor':
                                          showDialog(
                                            context: context,
                                            builder: (_) =>
                                                EquipmentsAddProcessor(
                                              parentCtx: context,
                                              parameters: snapshot.data[index],
                                              refresh: () =>
                                                  loadData('processor'),
                                            ),
                                          );
                                          break;
                                        case 'Memory':
                                          showDialog(
                                              context: context,
                                              builder: (_) =>
                                                  EquipmentsAddMemory(
                                                    parentCtx: context,
                                                    parameters:
                                                        snapshot.data[index],
                                                    refresh: () => loadData(
                                                        equipmentType
                                                            .toLowerCase()),
                                                  ));
                                          break;
                                        case 'Storage':
                                          showDialog(
                                              context: context,
                                              builder: (_) =>
                                                  EquipmentsAddStorage(
                                                    parentCtx: context,
                                                    parameters:
                                                        snapshot.data[index],
                                                    refresh: () => loadData(
                                                        equipmentType
                                                            .toLowerCase()),
                                                  ));
                                          break;
                                        default:
                                      }
                                    },
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: IconButton(
                                    icon: const Icon(Icons.close,
                                        size: 30, color: Colors.grey),
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      switch (equipmentType) {
                                        case 'Processor':
                                          showDialog(
                                                  context: context,
                                                  builder: (_) =>
                                                      DeleteWarningParameters(
                                                          context, 'processor'))
                                              .then((value) async {
                                            if (value) {
                                              await deleteParameters(
                                                  snapshot.data[index]['id'],
                                                  'processor');
                                              loadData('processor');
                                            }
                                          });
                                          break;
                                        case 'Memory':
                                          showDialog(
                                                  context: context,
                                                  builder: (_) =>
                                                      DeleteWarningParameters(
                                                          context, 'memory'))
                                              .then((value) async {
                                            if (value) {
                                              await deleteParameters(
                                                  snapshot.data[index]['id'],
                                                  'memory');
                                              loadData('memory');
                                            }
                                          });
                                          break;
                                        case 'Storage':
                                          showDialog(
                                                  context: context,
                                                  builder: (_) =>
                                                      DeleteWarningParameters(
                                                          context, 'storage'))
                                              .then((value) async {
                                            if (value) {
                                              await deleteParameters(
                                                  snapshot.data[index]['id'],
                                                  'storage');
                                              loadData('storage');
                                            }
                                          });
                                          break;
                                        default:
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF6CCFF7),
                      ),
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 60,
        height: 60,
        child: FittedBox(
          child: FloatingActionButton(
            heroTag: 'btn6',
            onPressed: () {
              switch (equipmentType) {
                case 'Processor':
                  showDialog(
                    context: context,
                    builder: (_) => EquipmentsAddProcessor(
                        parentCtx: context,
                        refresh: () => loadData(equipmentType.toLowerCase())),
                  );
                  break;
                case 'Memory':
                  showDialog(
                      context: context,
                      builder: (_) => EquipmentsAddMemory(
                            parentCtx: context,
                            refresh: () =>
                                loadData(equipmentType.toLowerCase()),
                          ));
                  break;
                case 'Storage':
                  showDialog(
                      context: context,
                      builder: (_) => EquipmentsAddStorage(
                            parentCtx: context,
                            refresh: () =>
                                loadData(equipmentType.toLowerCase()),
                          ));
                  break;
                default:
              }
            },
            elevation: 10,
            child: const Icon(
              Icons.add,
              size: 35,
              key: Key('add-button'),
            ),
            backgroundColor: const Color(0xFF6CCFF7),
          ),
        ),
      ),
    );
  }
}
