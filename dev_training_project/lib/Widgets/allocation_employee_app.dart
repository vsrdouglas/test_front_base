// ignore_for_file: must_be_immutable, unused_local_variable, prefer_typing_uninitialized_variables

import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_app/Screens/employee_details_screen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../Screens/info_dashboard.dart';
import '../helpers.dart';

class AllocationEmployeeApp extends StatefulWidget {
  StreamController refreshControllerN;
  var infoUsersNAlocados;
  AllocationEmployeeApp(this.refreshControllerN, this.infoUsersNAlocados,
      {Key? key})
      : super(key: key);

  @override
  AllocationEmployeeAppState createState() => AllocationEmployeeAppState();
}

class AllocationEmployeeAppState extends State<AllocationEmployeeApp> {
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
    return Card(
      elevation: 10,
      shadowColor: Colors.grey,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3),
        side: const BorderSide(color: Color(0xFF6CCFF7), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 30, bottom: 30, left: 20),
        child: Theme(
          data: ThemeData().copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.only(right: 20),
            title: const AutoSizeText(
              'List of Unallocated Employees',
              maxLines: 1,
              style: TextStyle(
                fontFamily: "mont",
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            children: [
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 200,
                child: ListView.builder(
                    padding: const EdgeInsets.only(
                        bottom: kFloatingActionButtonMargin + 70),
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.infoUsersNAlocados.length,
                    itemBuilder: (context, index) {
                      return employeeApp(index);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  employeeApp(i) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      margin: const EdgeInsets.only(right: 50),
      width: 300,
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) {
                return EmployeeDetailScreen(
                    employee: widget.infoUsersNAlocados[i]['id']);
              },
              fullscreenDialog: true));
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 1),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(50.0),
          child: CachedNetworkImage(
            imageUrl: widget.infoUsersNAlocados[i]['imageTumb'],
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        title: AutoSizeText(
          widget.infoUsersNAlocados[i]['name'],
          maxLines: 1,
          style: const TextStyle(
            fontFamily: "mont",
            color: Colors.black,
            fontSize: 16,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          widget.infoUsersNAlocados[i]['tecnologies'],
          style: const TextStyle(
            fontFamily: "mont",
            color: Colors.black,
            fontSize: 10,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                'Employee is ${((1.0 - double.parse(widget.infoUsersNAlocados[i]['allocation'])) * 100).round()}% unallocated',
                style: const TextStyle(fontFamily: 'mont'),
              ),
            ));
          },
          child: CircularPercentIndicator(
            radius: 15.0,
            lineWidth: 3.0,
            percent:
                1.0 - double.parse(widget.infoUsersNAlocados[i]['allocation']),
            center: Text(
              "${((1.0 - double.parse(widget.infoUsersNAlocados[i]['allocation'])) * 100).toStringAsFixed(0)}%",
              style: const TextStyle(fontSize: 8),
            ),
            progressColor: checkPercent(
                1.0 - double.parse(widget.infoUsersNAlocados[i]['allocation'])),
          ),
        ),
      ),
    );
  }
}
