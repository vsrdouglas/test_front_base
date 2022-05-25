// ignore_for_file: must_be_immutable

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_app/PopUps/logout.dart';
import 'package:my_app/Screens/employee_details_screen.dart';
import 'package:my_app/Screens/employees_screen.dart';
import 'package:my_app/Screens/equipments/equipments_screen.dart';
import 'package:my_app/Screens/info_dashboard.dart';
import 'package:my_app/Screens/login_screen.dart';
import 'package:my_app/Screens/manage_equipments_parameters_screen.dart';
import 'package:my_app/Screens/projects_screen.dart';
import 'package:my_app/Screens/select_project_report_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_constants.dart';

class HomePageApp extends StatefulWidget {
  final String accessLevel, username, imageThumb, userId;
  const HomePageApp(
      {required this.accessLevel,
      required this.username,
      required this.imageThumb,
      required this.userId,
      Key? key})
      : super(key: key);

  @override
  State<HomePageApp> createState() => _HomePageAppState();
}

class _HomePageAppState extends State<HomePageApp> {
  int selectedIndex = 0;
  late PageController controller;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _HomePageAppState() {
    controller = PageController(initialPage: 0);
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    controller.jumpToPage(index);
  }

  static const List<Widget> _pageOptions = [
    InfoDashBoard(),
    EquipmentsBody(),
    EmployeesBodyFinal(),
    ProjectsBody(),
    ProjectsList(),
  ];

  late final List<String> _titleOptions = <String>[
    'Welcome, ' + widget.username.split(' ')[0] + '!',
    'Equipments',
    'Employees',
    'Projects',
    'Generate Reports',
  ];

  @override
  Widget build(BuildContext context) {
    switch (widget.accessLevel) {
      case 'support':
        return Scaffold(
          appBar: AppBar(
            leadingWidth: 70,
            // toolbarHeight: 80,
            backgroundColor: const Color(0xFF6CCFF7),
            title: const AutoSizeText(
              'Equipments',
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'montBold',
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          drawer: Drawer(
            key: const Key('drawer-app'),
            elevation: 5,
            child: drawerInfos(),
          ),
          body: const EquipmentsBody(),
        );
      case 'rh':
        return Scaffold(
          appBar: AppBar(
            leadingWidth: 70,
            // toolbarHeight: 80,
            backgroundColor: const Color(0xFF6CCFF7),
            title: const AutoSizeText(
              'Employees',
              maxLines: 1,
              style: TextStyle(
                fontFamily: 'montBold',
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          drawer: Drawer(
            key: const Key('drawer-app'),
            elevation: 5,
            child: drawerInfos(),
          ),
          body: const EmployeesBodyFinal(),
        );
      default:
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            leadingWidth: 70,
            leading: IconButton(
              key: const Key('icon-button-drawer'),
              icon: const Icon(Icons.menu),
              onPressed: () => _scaffoldKey.currentState!.openDrawer(),
            ),
            backgroundColor: const Color(0xFF6CCFF7),
            title: AutoSizeText(
              _titleOptions.elementAt(selectedIndex),
              maxLines: 1,
              style: const TextStyle(
                  fontFamily: 'mont', color: Colors.black, fontSize: 20),
            ),
            centerTitle: true,
          ),
          drawer: Drawer(
            key: const Key('drawer-app'),
            elevation: 5,
            child: drawerInfos(),
          ),
          body: PageView(
            onPageChanged: (int index) {
              setState(() {
                selectedIndex = index;
              });
            },
            controller: controller,
            children: _pageOptions,
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: const Color(0xFF6CCFF7),
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                activeIcon: Image.asset(
                  "images/Home_select.png",
                  fit: BoxFit.contain,
                  width: 32,
                ),
                label: "Home Page",
                icon: Image.asset(
                  "images/home.png",
                  key: const Key('app-home-nav'),
                  fit: BoxFit.contain,
                  width: 32,
                ),
              ),
              BottomNavigationBarItem(
                activeIcon: Image.asset(
                  "images/laptop_select.png",
                  fit: BoxFit.contain,
                  width: 38,
                ),
                label: "Equipments",
                icon: Image.asset(
                  "images/equipment.png",
                  key: const Key('app-equipment-nav'),
                  fit: BoxFit.contain,
                  width: 38,
                ),
              ),
              BottomNavigationBarItem(
                activeIcon: Image.asset(
                  "images/group_selected.png",
                  fit: BoxFit.contain,
                  width: 36,
                ),
                label: "Employees",
                icon: Image.asset(
                  "images/group.png",
                  key: const Key('app-employees-nav'),
                  fit: BoxFit.contain,
                  width: 36,
                ),
              ),
              BottomNavigationBarItem(
                activeIcon: Image.asset(
                  "images/Project_selected.png",
                  fit: BoxFit.contain,
                  width: 34,
                ),
                label: "Projects",
                icon: Image.asset(
                  "images/Project_IMG.png",
                  key: const Key('app-projects-nav'),
                  fit: BoxFit.contain,
                  width: 34,
                ),
              ),
              BottomNavigationBarItem(
                activeIcon: Image.asset(
                  "images/report_selected.png",
                  fit: BoxFit.contain,
                  width: 34,
                ),
                label: "Report",
                icon: Image.asset(
                  "images/report_appBar.png",
                  key: const Key('app-report-nav'),
                  fit: BoxFit.contain,
                  width: 34,
                ),
              ),
            ],
            currentIndex: selectedIndex,
            onTap: onItemTapped,
          ),
        );
    }
  }

  Widget drawerInfos() {
    return Column(
      children: [
        SizedBox(
          height: 160,
          width: double.infinity,
          child: DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF6CCFF7),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: CachedNetworkImage(
                    height: 50,
                    width: 50,
                    imageUrl: widget.imageThumb,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        Image.network(defaultImage),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      widget.username,
                      style: const TextStyle(fontFamily: 'mont', fontSize: 18),
                    ),
                    const Spacer(),
                    IconButton(
                        key: const Key('close-menu'),
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close)),
                  ],
                ),
              ],
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.person_outlined, color: Colors.black),
          title: const Text('My Account',
              style: TextStyle(
                  fontFamily: 'mont', color: Colors.black, fontSize: 15)),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) {
                  return EmployeeDetailScreen(
                      userLogado: true, employee: widget.userId);
                },
                fullscreenDialog: true));
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings_outlined, color: Colors.black),
          title: const Text('Equipments Parameters',
              style: TextStyle(
                  fontFamily: 'mont', color: Colors.black, fontSize: 15)),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) =>
                    const ManageEquipmentsParameters()));
          },
        ),
        const Spacer(),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.black),
          title: const Text('Log out',
              style: TextStyle(
                  fontFamily: 'mont', color: Colors.black, fontSize: 15)),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => Logout(context),
            ).then((value) async {
              if (value) {
                SharedPreferences prefs = await SharedPreferences.getInstance();
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
          },
        ),
      ],
    );
  }
}
