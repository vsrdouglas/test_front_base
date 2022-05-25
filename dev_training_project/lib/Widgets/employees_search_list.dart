import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/Screens/info_dashboard.dart';
import 'package:my_app/helpers.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../Models/employee_model.dart';
import '../PopUps/employees_add_employee_popup.dart';
import '../PopUps/employees_delete_member.dart';
import '../PopUps/warning_popup.dart';
import '../Screens/employee_details_screen.dart';
import '../Screens/employees_screen.dart';
import '../app_constants.dart';

// ignore: must_be_immutable
class SearchBar extends StatefulWidget {
  late List<EmployeeModel> convertedNames;
  late List<EmployeeModel> employees;
  late List<EmployeeModel> foundEmployees;
  StreamController refreshController;
  late List<EmployeeModel> foundByTecnologies;

  SearchBar(employeeList, this.refreshController, {Key? key})
      : super(key: key) {
    convertedNames = SearchBarState().listconverter(employeeList);
    employees = convertedNames;
    foundEmployees = employees;
    foundByTecnologies = employees;
  }

  @override
  SearchBarState createState() => SearchBarState();
}

class SearchBarState extends State<SearchBar> {
  Future<void> handleRefresh() async {
    await fetchData().then((res) {
      widget.refreshController.add(res);

      return null;
    });
  }

  deleteEmployee(id) async {
    final response = await http.delete(
      Uri.parse(usersUrl + '/' + id),
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
            'User succesfully removed',
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

  onSearch(String search) {
    setState(() {
      widget.foundEmployees = widget.employees
          .where((employees) =>
              employees.name.toLowerCase().contains(search.toLowerCase()))
          .toList();

      widget.foundByTecnologies = widget.employees
          .where((employees) => employees.tecnologies
              .toLowerCase()
              .contains(search.toLowerCase()))
          .toList();
      widget.foundEmployees = widget.foundEmployees + widget.foundByTecnologies;
      widget.foundEmployees = widget.foundEmployees.toSet().toList();
    });
  }

  Future<bool> openEmployeeDetail({required String employee}) async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          return EmployeeDetailScreen(employee: employee);
        },
        fullscreenDialog: true));
    return true;
  }

  @override
  void dispose();

  @override
  void initState() {
    super.initState();
    // handleRefresh();
  }

  @override
  Widget build(BuildContext context) {
    var ctx = context;
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxWidth <= 800) {
                return Container(
                  key: const Key('employee-search-list'),
                  // margin: EdgeInsets.symmetric(horizontal: 150),
                  padding: const EdgeInsets.only(
                      bottom: 30, top: 25, left: 20, right: 20),
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
                );
              } else {
                return Container(
                  key: const Key('employee-search-list'),
                  margin: const EdgeInsets.symmetric(horizontal: 150),
                  padding: const EdgeInsets.only(
                      bottom: 30, top: 25, left: 20, right: 20),
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
                );
              }
            }),
            widget.foundEmployees.isNotEmpty
                ? Expanded(
                    child: RefreshIndicator(
                      onRefresh: handleRefresh,
                      child: ListView.builder(
                        primary: false,
                        padding: const EdgeInsets.only(
                            bottom: kFloatingActionButtonMargin + 70),
                        physics: const ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.foundEmployees.length,
                        itemBuilder: (context, index) {
                          return LayoutBuilder(builder: (context, constraints) {
                            if (constraints.maxWidth <= 800) {
                              return employeeComponent(
                                  employee: widget.foundEmployees[index],
                                  number: index);
                            } else {
                              return employeeComponentWeb(
                                  employee: widget.foundEmployees[index],
                                  number: index);
                            }
                          });
                        },
                      ),
                    ),
                  )
                : const Center(
                    child: Text(
                      "No employees found",
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
      floatingActionButton: SizedBox(
        width: 60,
        height: 60,
        child: FittedBox(
          child: FloatingActionButton(
            key: const Key('add-user-button'),
            heroTag: 'btn1',
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AddEmployeePopup(
                    context, ctx, widget.refreshController, false),
              );
            },
            elevation: 10,
            child: const Icon(Icons.add, size: 35),
            backgroundColor: const Color(0xFF6CCFF7),
          ),
        ),
      ),
    );
  }

  employeeComponent({required EmployeeModel employee, required int number}) {
    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Color(0xFF6CCFF7), width: 2),
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 3.0,
      shadowColor: Colors.grey[500],
      margin: const EdgeInsets.symmetric(
        vertical: 3,
        horizontal: 20,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 10,
        ),
        onTap: () {
          openEmployeeDetail(employee: employee.id)
              .then((_) => handleRefresh());
        },
        title: Container(
          margin: const EdgeInsets.only(left: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: CachedNetworkImage(
                      filterQuality: FilterQuality.low,
                      fit: BoxFit.cover,
                      imageUrl: employee.imageTumb,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          Image.network(defaultImageThumb),
                      height: 40,
                      width: 40,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: IconButton(
                      icon: Icon(Icons.close,
                          key: Key('delete-employee$number'),
                          size: 30,
                          color: Colors.grey),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              DeleteWarning(context),
                        ).then((value) async {
                          if (value) {
                            await deleteEmployee(employee.id);
                            handleRefresh();
                            EInfoDashBoardState().handleRefresh1();
                            EInfoDashBoardState().handleRefresh2();
                            EInfoDashBoardState().handleRefresh3();
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
              AutoSizeText(employee.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  minFontSize: 12,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontFamily: 'mont',
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        subtitle: Container(
          margin: const EdgeInsets.only(left: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 5),
              Row(mainAxisSize: MainAxisSize.min, children: [
                const Text(
                  'Availability:',
                  style: TextStyle(
                      fontFamily: 'mont', fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(width: 30),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: CircularPercentIndicator(
                    radius: 15.0,
                    lineWidth: 3.0,
                    percent: 1.0 - employee.allocation,
                    center: Text(
                      "${((1.0 - employee.allocation) * 100).toStringAsFixed(0)}%",
                      style: const TextStyle(fontSize: 8),
                    ),
                    progressColor: checkPercent((1.0 - employee.allocation)),
                  ),
                ),
              ]),
              const SizedBox(height: 5),
              AutoSizeText(
                'Technologies: ${employee.tecnologies}',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(
                    fontFamily: 'mont', fontSize: 14, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }

  employeeComponentWeb({required EmployeeModel employee, required int number}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 150),
      child: Card(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFF6CCFF7), width: 2),
          borderRadius: BorderRadius.circular(5.0),
        ),
        margin: const EdgeInsets.symmetric(
          vertical: 3.0,
          horizontal: 20,
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 10,
          ),
          onTap: () {
            openEmployeeDetail(employee: employee.id)
                .then((_) => handleRefresh());
          },
          leading: Container(
            margin: const EdgeInsets.only(left: 15, right: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: CachedNetworkImage(
                filterQuality: FilterQuality.low,
                fit: BoxFit.cover,
                imageUrl: employee.imageTumb,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    Image.network(defaultImageThumb),
                height: 40,
                width: 40,
              ),
            ),
          ),
          title: AutoSizeText(employee.name,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              minFontSize: 12,
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontFamily: 'mont',
                  fontWeight: FontWeight.bold)),
          subtitle: AutoSizeText(
            employee.tecnologies,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
                fontFamily: 'mont', fontSize: 15, color: Colors.black),
          ),
          trailing: Wrap(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 12, right: 10),
                child: Text(
                  'Availability:',
                  style: TextStyle(fontFamily: 'mont', fontSize: 12),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5, right: 20),
                child: CircularPercentIndicator(
                  radius: 15.0,
                  lineWidth: 3.0,
                  percent: 1.0 - employee.allocation,
                  center: Text(
                    "${((1.0 - employee.allocation) * 100).toStringAsFixed(0)}%",
                    style: const TextStyle(fontSize: 8),
                  ),
                  progressColor: checkPercent((1.0 - employee.allocation)),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 10),
                child: IconButton(
                  icon: Icon(Icons.close,
                      key: Key('delete-employee$number'),
                      size: 30,
                      color: Colors.grey),
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => DeleteWarning(context),
                    ).then((value) async {
                      if (value) {
                        await deleteEmployee(employee.id);
                        handleRefresh();
                        EInfoDashBoardState().handleRefresh1();
                        EInfoDashBoardState().handleRefresh2();
                        EInfoDashBoardState().handleRefresh3();
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<EmployeeModel> listconverter(list) {
    List<EmployeeModel> converted = [];
    for (var i = 0; i < list.length; i++) {
      converted.add(EmployeeModel(
          list[i]['id'],
          list[i]['name'],
          list[i]['email'],
          list[i]['monthlyWage'],
          list[i]['imageUri'],
          list[i]['imageTumb'],
          list[i]['tecnologies'],
          double.parse(list[i]['allocation'])));
    }
    return converted;
  }
}
