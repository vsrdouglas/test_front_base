import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_app/PopUps/logout.dart';
import 'package:my_app/Screens/employee_details_screen.dart';
import 'package:my_app/Screens/employees_screen.dart';
import 'package:my_app/Screens/equipments/equipments_screen.dart';
import 'package:my_app/Screens/info_dashboard.dart';
import 'package:my_app/Screens/login_screen.dart';
import 'package:my_app/Screens/projects_screen.dart';
import 'package:my_app/Screens/select_project_report_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/manage_equipments_parameters_screen.dart';
import '../app_constants.dart';

class AccessPermisionsWeb extends StatelessWidget {
  final double left;
  final String accessLevel, imageThumb, userId;
  const AccessPermisionsWeb(
      {required this.accessLevel,
      required this.left,
      required this.imageThumb,
      required this.userId,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<PopupMenuItem> listPopUpItemRh = [
      const PopupMenuItem(
          child: ListTile(
            key: Key('my-account'),
            leading: Icon(Icons.person_outlined, color: Colors.black),
            title: Text(
              'My Account',
              style: TextStyle(
                  fontFamily: 'mont', color: Colors.black, fontSize: 15),
            ),
          ),
          value: 'account'),
      const PopupMenuItem(
          child: ListTile(
            key: Key('log-out'),
            leading: Icon(Icons.logout, color: Colors.black),
            title: Text(
              'Log out',
              style: TextStyle(
                  fontFamily: 'mont', color: Colors.black, fontSize: 15),
            ),
          ),
          value: 'logout'),
    ];

    List<PopupMenuItem> listPopUpItemAdm = [
      const PopupMenuItem(
          child: ListTile(
            key: Key('my-account'),
            leading: Icon(Icons.person_outlined, color: Colors.black),
            title: Text(
              'My Account',
              style: TextStyle(
                  fontFamily: 'mont', color: Colors.black, fontSize: 15),
            ),
          ),
          value: 'account'),
      const PopupMenuItem(
          child: ListTile(
            key: Key('equipments-parameters'),
            leading: Icon(Icons.settings_outlined, color: Colors.black),
            title: Text(
              'Equipments Parameters',
              style: TextStyle(
                  fontFamily: 'mont', color: Colors.black, fontSize: 15),
            ),
          ),
          value: 'equipments'),
      const PopupMenuItem(
          child: ListTile(
            key: Key('log-out'),
            leading: Icon(Icons.logout, color: Colors.black),
            title: Text(
              'Log out',
              style: TextStyle(
                  fontFamily: 'mont', color: Colors.black, fontSize: 15),
            ),
          ),
          value: 'logout'),
    ];

    List<Widget> appBarActions = [
      PopupMenuButton(
        key: const Key('dropdown-menu-button'),
        itemBuilder: (_) =>
            accessLevel != 'rh' ? listPopUpItemAdm : listPopUpItemRh,
        onSelected: (value) {
          switch (value) {
            case 'logout':
              showDialog(
                context: context,
                builder: (BuildContext context) => Logout(context),
              ).then((value) async {
                if (value) {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove('user');
                  prefs.remove('token');
                  prefs.remove('id');
                  prefs.remove('access');
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext ctx) => const Login()));
                }
              });
              break;
            case 'account':
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) {
                    return EmployeeDetailScreen(
                        userLogado: true, employee: userId);
                  },
                  fullscreenDialog: true));
              break;
            case 'equipments':
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      const ManageEquipmentsParameters()));
              break;
          }
        },
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: CachedNetworkImage(
              imageUrl: imageThumb,
              fit: BoxFit.cover,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => Image.network(defaultImage),
            ),
          ),
        ),
      ),
    ];

    switch (accessLevel) {
      case 'rh':
        return DefaultTabController(
          length: 1,
          child: Scaffold(
            appBar: AppBar(
              leadingWidth: 200,
              //toolbarHeight: 80,
              title:
                  TabBar(padding: EdgeInsets.only(left: left * 2), tabs: const [
                Tab(
                  key: Key('employees-nav'),
                  child: Text(
                    "Employees",
                    style: TextStyle(fontFamily: "mont", fontSize: 15),
                  ),
                ),
              ]),
              backgroundColor: const Color(0xFF6CCFF7),
              iconTheme: const IconThemeData(
                color: Color(0xFF213e4b),
              ),
              leading: Container(
                margin: const EdgeInsets.only(left: 30),
                child: Image.asset(
                  "images/appBarLogo1.png",
                  fit: BoxFit.contain,
                  width: 200,
                ),
              ),
              actions: appBarActions,
            ),
            body: const TabBarView(
              children: [
                EmployeesBodyFinal(),
              ],
            ),
          ),
        );
      case 'support':
        return DefaultTabController(
          length: 1,
          child: Scaffold(
            appBar: AppBar(
              leadingWidth: 200,
              //toolbarHeight: 80,
              title:
                  TabBar(padding: EdgeInsets.only(left: left * 2), tabs: const [
                Tab(
                  key: Key('equipment-nav'),
                  child: Text(
                    "Equipments",
                    style: TextStyle(fontFamily: "mont", fontSize: 15),
                  ),
                ),
              ]),
              backgroundColor: const Color(0xFF6CCFF7),
              iconTheme: const IconThemeData(
                color: Color(0xFF213e4b),
              ),
              leading: Container(
                margin: const EdgeInsets.only(left: 30),
                child: Image.asset(
                  "images/appBarLogo1.png",
                  fit: BoxFit.contain,
                  width: 200,
                ),
              ),
              actions: appBarActions,
            ),
            body: const TabBarView(
              children: [
                EquipmentsBody(),
              ],
            ),
          ),
        );
      default: //accessLevel == 'admin'
        return DefaultTabController(
          length: 5,
          child: Scaffold(
            appBar: AppBar(
              leadingWidth: 200,
              title: TabBar(padding: EdgeInsets.only(left: left), tabs: const [
                Tab(
                  key: Key('dashboard-nav'),
                  child: Text(
                    "DashBoard",
                    style: TextStyle(fontFamily: "mont", fontSize: 15),
                  ),
                ),
                Tab(
                  key: Key('equipment-nav'),
                  child: Text(
                    "Equipments",
                    style: TextStyle(fontFamily: "mont", fontSize: 15),
                  ),
                ),
                Tab(
                  key: Key('employees-nav'),
                  child: Text(
                    "Employees",
                    style: TextStyle(fontFamily: "mont", fontSize: 15),
                  ),
                ),
                Tab(
                  key: Key('projects-nav'),
                  child: Text(
                    "Projects",
                    style: TextStyle(fontFamily: "mont", fontSize: 15),
                  ),
                ),
                Tab(
                  key: Key('report-nav'),
                  child: Text(
                    "Report",
                    style: TextStyle(fontFamily: "mont", fontSize: 15),
                  ),
                ),
              ]),
              backgroundColor: const Color(0xFF6CCFF7),
              iconTheme: const IconThemeData(
                color: Color(0xFF213e4b),
              ),
              leading: Container(
                margin: const EdgeInsets.only(left: 30),
                child: Image.asset(
                  "images/appBarLogo1.png",
                  fit: BoxFit.contain,
                  width: 200,
                ),
              ),
              actions: appBarActions,
            ),
            body: const TabBarView(
              children: [
                InfoDashBoard(),
                EquipmentsBody(),
                EmployeesBodyFinal(),
                ProjectsBody(),
                ProjectsList(),
              ],
            ),
          ),
        );
    }
  }
}
