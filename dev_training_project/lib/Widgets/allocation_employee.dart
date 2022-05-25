// ignore_for_file: must_be_immutable, unused_local_variable, prefer_typing_uninitialized_variables

import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_app/Screens/employee_details_screen.dart';
import 'package:my_app/Screens/info_dashboard.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../helpers.dart';

class AllocationEmployee extends StatefulWidget {
  StreamController refreshControllerN;
  var infoUsersNAlocados;
  AllocationEmployee(this.refreshControllerN, this.infoUsersNAlocados,
      {Key? key})
      : super(key: key);

  @override
  _AllocationEmployeeState createState() => _AllocationEmployeeState();
}

class _AllocationEmployeeState extends State<AllocationEmployee> {
  Future handleRefresh() async {
    await infoUserNU().then((res) {
      widget.refreshControllerN.add(res);
      return null;
    });
  }

  @override
  void initState() {
    super.initState();
    // handleRefresh();
  }

  @override
  Widget build(BuildContext context) {
    var ctx = context;
    return Material(
      child: Container(
        height: 300,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFF6CCFF7),
            width: 1,
          ),
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(3)),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.5),
              offset: Offset(1, 1),
              blurRadius: 0.5,
              spreadRadius: 1,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AutoSizeText(
              'List of Unallocated Employees',
              maxLines: 1,
              style: TextStyle(
                fontFamily: "mont",
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 350.0,
                  mainAxisExtent: 55.0,
                  mainAxisSpacing: 7.0,
                  crossAxisSpacing: 35.0,
                ),
                itemCount: widget.infoUsersNAlocados.length,
                itemBuilder: (_, int i) {
                  return EmployeeWeb(usersInfo: widget.infoUsersNAlocados[i]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmployeeWeb extends StatelessWidget {
  const EmployeeWeb({Key? key, required this.usersInfo}) : super(key: key);

  final Map usersInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: ListTile(
        dense: true,
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) {
                return EmployeeDetailScreen(employee: usersInfo['id']);
              },
              fullscreenDialog: true));
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 1, vertical: -7),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(50.0),
          child: CachedNetworkImage(
            imageUrl: usersInfo['imageTumb'],
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        title: AutoSizeText(
          usersInfo['name'],
          maxLines: 1,
          style: const TextStyle(
            fontFamily: "mont",
            color: Colors.black,
            fontSize: 16,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          usersInfo['tecnologies'],
          style: const TextStyle(
            fontFamily: "mont",
            color: Colors.black,
            fontSize: 10,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Tooltip(
          message:
              'Employee is ${((1.0 - double.parse(usersInfo['allocation'])) * 100).round()}% unallocated',
          child: CircularPercentIndicator(
            radius: 15.0,
            lineWidth: 3.0,
            percent: 1.0 - double.parse(usersInfo['allocation']),
            center: Text(
              "${((1.0 - double.parse(usersInfo['allocation'])) * 100).toStringAsFixed(0)}%",
              style: const TextStyle(fontSize: 10),
            ),
            progressColor:
                checkPercent(1.0 - double.parse(usersInfo['allocation'])),
          ),
        ),
      ),
    );
  }
}
