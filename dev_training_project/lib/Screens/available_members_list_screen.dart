// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../Models/addmember_model.dart';
import '../app_constants.dart';
import '../PopUps/projdetail_addmember_popup.dart';

// ignore: must_be_immutable
class AddMember extends StatefulWidget {
  String projectId;
  String projectStartDate;
  var ctx;
  AddMember(this.ctx, this.projectId, this.projectStartDate, {Key? key})
      : super(key: key);

  @override
  AddMemberState createState() => AddMemberState();
}

class AddMemberState extends State<AddMember> {
  late Future futureData;
  late List convertedNames;
  late List employees;
  late List employeeData;
  late List foundEmployees;

  AddMemberState();

  Future fetchData() async {
    final data = await http.get(Uri.parse(usersUrl + '/available'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (data.statusCode == 200) {
      employeeData = jsonDecode(data.body)['data'];
      employees = listconverter(employeeData);
      foundEmployees = employees;
      return jsonDecode(data.body);
    } else {
      throw Exception('Failed to finish request');
    }
  }

  onSearch(String search) {
    setState(() {
      foundEmployees = employees
          .where((employees) =>
              employees.name.toLowerCase().contains(search.toLowerCase()))
          .toList();
    });
  }

  onStart() async {
    return futureData = await fetchData();
  }

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // var employeeData = snapshot.data['data'];
            // employees = listconverter(employeeData);
            // foundEmployees = employees;

            return Scaffold(
              appBar: AppBar(
                leading: InkWell(
                  borderRadius: BorderRadius.circular(500),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 20),
                    height: double.infinity,
                    width: double.infinity,
                    child: Container(
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 5,
                            spreadRadius: 2,
                            offset: Offset(2, 2),
                          )
                        ],
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: const Icon(
                        Icons.keyboard_backspace_rounded,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                leadingWidth: 70,
                toolbarHeight: 80,
                backgroundColor: const Color(0xFF6CCFF7),
                // ignore: prefer_const_constructors
                title: SizedBox(
                  key: const Key('add-member-text'),
                  width: double.infinity,
                  child: const AutoSizeText(
                    'Add Member',
                    maxLines: 1,
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
              body: Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(
                          bottom: 30, top: 25, left: 20, right: 20),
                      width: double.infinity,
                      child: TextField(
                        onChanged: (value) {
                          onSearch(value);
                        },
                        // => onSearch(value),
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
                    foundEmployees.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                              physics: const ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: foundEmployees.length,
                              itemBuilder: (context, index) {
                                return employeeComponent(
                                    foundEmployees[index], context);
                              },
                            ),
                          )
                        : const Center(
                            child: Text(
                              "No members available found",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'montBold',
                                fontSize: 24,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            );
          } else {
            return Container(
              key: const Key('load-add-member'),
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

  employeeComponent(MemberModel employee, context) {
    return Card(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      elevation: 0.0,
      child: ListTile(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => AddMemberPopup(widget.ctx,
                employee, widget.projectId, widget.projectStartDate),
          ).then((value) {
            if (value) {
              Navigator.of(context).pop(true);
            }
          });
        },
        leading: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              // BoxShadow(
              //   color: Colors.black38,
              //   blurRadius: 4,
              //   offset: Offset(2, 4),
              // )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: CachedNetworkImage(
              imageUrl: employee.imageTumb,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) =>
                  Image.network(defaultImageThumb),
            ),
          ),
        ),
        title: AutoSizeText(
          employee.name,
          maxLines: 1,
          style: const TextStyle(
            fontFamily: 'mont',
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

List<MemberModel> listconverter(list) {
  List<MemberModel> converted = [];
  for (var i = 0; i < list.length; i++) {
    converted.add(MemberModel(
      list[i]['id'],
      list[i]['name'],
      double.parse(list[i]['allocation']),
      list[i]['imageTumb'],
    ));
  }
  return converted;
}
