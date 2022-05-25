// ignore_for_file: non_constant_identifier_names
import 'dart:async';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:my_app/Models/addmember_model.dart';
import 'package:my_app/PopUps/empdetail_admin_popup.dart';
import 'package:my_app/PopUps/empdetail_complete_tecnologies.dart';
import 'package:my_app/PopUps/empdetail_edit_pic.dart';
import 'package:my_app/PopUps/empldetail_delete_warning.dart';
import 'package:my_app/PopUps/level_access.dart';
import 'package:my_app/PopUps/recovery_popup.dart';
import 'package:my_app/Screens/reset_password.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../PopUps/empdetail_edit_employee_popup.dart';
import '../PopUps/empdetail_wagehistory_popup.dart';
import '../PopUps/warning_popup.dart';
import '../Widgets/details_backbutton.dart';
import '../app_constants.dart';
import '../helpers.dart';
import 'info_dashboard.dart';
import 'list_projects_add.dart';
import 'project_detail_screen.dart';

// ignore: must_be_immutable
class EmployeeDetailScreen extends StatefulWidget {
  late String em;
  bool? userLogado;
  EmployeeDetailScreen({Key? key, this.userLogado, required String employee})
      : super(key: key) {
    em = employee;
  }

  @override
  EmployeeDetailScreenState createState() => EmployeeDetailScreenState();
}

class EmployeeDetailScreenState extends State<EmployeeDetailScreen> {
  late String userDetail = widget.em;
  late StreamController refreshController;
  late DateTime _dateTime = DateTime.now();
  String text = 'End Date';
  late SharedPreferences prefs;
  String? accessLevel;

  addproject(ctx, userInfo) {
    return Card(
      elevation: 0.0,
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: ListTile(
        title: Container(
          margin: const EdgeInsets.only(top: 25, bottom: 5),
          child: const AutoSizeText(
            'Active Projects: ',
            maxLines: 1,
            style: TextStyle(
              fontFamily: 'montBold',
              fontSize: 20,
            ),
          ),
        ),
        subtitle: Container(
          margin: const EdgeInsets.only(bottom: 25),
          child: AutoSizeText(
            'Availability: ' +
                ((1 - checkAvailability(userInfo)) * 100).round().toString() +
                '%',
            maxLines: 1,
            style: const TextStyle(
              fontFamily: 'mont',
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ),
        trailing: Visibility(
          visible: accessLevel! == 'admin',
          child: ElevatedButton(
            onPressed: (1 - checkAvailability(userInfo)) == 0
                ? null
                : () async {
                    await Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) {
                          return ListProjects(
                              ctx,
                              MemberModel(
                                  userInfo['id'],
                                  userInfo['name'],
                                  checkAvailability(userInfo),
                                  userInfo['imageTumb']));
                        },
                        fullscreenDialog: true));
                    await fetchDataDetails();
                    handleRefresh();
                    EInfoDashBoardState().handleRefresh1();
                    EInfoDashBoardState().handleRefresh2();
                    EInfoDashBoardState().handleRefresh3();
                  },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(
                side: BorderSide.none,
              ),
              primary: (1 - checkAvailability(userInfo)) == 0
                  ? const Color(0x55CCCCCC)
                  : const Color(0xFF6CCFF7),
              fixedSize: const Size(70, 70),
              shadowColor: Colors.black,
              elevation: 10.0,
            ),
            child: const Icon(
              Icons.add,
              key: Key('assigment-user'),
              size: 30,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Future confirmToken(String recoveryCode, email) async {
    final res = await http.post(Uri.parse(resetToken),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: jsonEncode(<String, String>{
          "email": email,
          "recoveryKey": recoveryCode,
        }));
    if (res.statusCode == 200) {
      Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return ResetPasswordScreen(email, jsonDecode(res.body)['token']);
        },
      ));
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => Warning(context, res.body),
      );
    }
  }

  Future resetPassword(String email) async {
    final res = await http.post(Uri.parse(forgotUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: jsonEncode(<String, String>{"email": email}));
    if (res.statusCode == 200) {
      showDialog(
        context: context,
        builder: (BuildContext context) => RecoveryCode(context, email),
      ).then((value) {
        if (value != '') {
          confirmToken(value, email);
        }
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => Warning(context, res.body),
      );
    }
  }

  Future fetchDataDetails() async {
    final data =
        await http.get(Uri.parse(usersUrl + '/' + userDetail), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    prefs = await SharedPreferences.getInstance();
    accessLevel = prefs.getString('access');
    return jsonDecode(data.body);
  }

  Future deleteProjectMember(
      String projectId, String endDate, String userId) async {
    // /:projectId/remove/:userId
    final res = await http.put(
      Uri.parse(projectsUrl + '$projectId/remove/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'endDate': endDate,
      }),
    );
    if (res.statusCode == 200) {
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Member assignment succesfully removed',
            style: TextStyle(fontFamily: 'mont'),
          ),
        ),
      );
      // return ProjectData.fromJson(jsonDecode(response.body));
    } else {
      return showDialog(
        context: context,
        builder: (BuildContext context) => Warning(context, res.body),
      );
    }
  }

  Future infoUserMe() async {
    final res = await http.get(Uri.parse(dadosUser), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    prefs = await SharedPreferences.getInstance();
    accessLevel = prefs.getString('access');
    return jsonDecode(res.body);
  }

  loadData() async {
    if (widget.userLogado == true) {
      infoUserMe().then((res) async {
        refreshController.add(res);
        return res;
      });
    } else {
      fetchDataDetails().then((res) async {
        refreshController.add(res);
        return res;
      });
    }
  }

  void _openHistoryPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) => WageHistoryPopup(userDetail),
    );
  }

  void _openProjectDetail(dynamic projetos) {
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return ProjectDetailScreen(
              projetos['id'], projetos['status'], projetos['name']);
        },
        fullscreenDialog: true));
  }

  void _openEditPopup(
      parentCtx, userId, String dadoEditado, String currentValue) {
    showDialog(
      context: context,
      builder: (BuildContext context) => EditEmployeePopup(context, parentCtx,
          refreshController, userId, dadoEditado, currentValue),
    );
  }

  _openAdminPopup(userInfo) {
    showDialog(
      context: context,
      builder: (BuildContext context) => SelectLevel(context),
    ).then((value) async {
      if (value[0]) {
        await sendEdit(userInfo, value[1]);
        handleRefresh();
      }
    });
  }

  _revokeAccess(userInfo) {
    showDialog(
      context: context,
      builder: (BuildContext context) => RevokeAcess(context),
    ).then((value) async {
      if (value) {
        await sendRevokeAccess(userInfo);
        handleRefresh();
      }
    });
  }

  _returnAccess(userInfo) async {
    await returnAccess(userInfo);
    handleRefresh();
  }

  sendRevokeAccess(userInfo) async {
    final response = await http.put(
        Uri.parse(usersUrl + '/revoke/' + userInfo['id']),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'This employee doesnt have access anymore',
            style: TextStyle(fontFamily: 'mont'),
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => Warning(context, response.body),
      );
    }
  }

  returnAccess(userInfo) async {
    final response = await http.put(Uri.parse(usersUrl + '/' + userInfo['id']),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          'hasAccess': true,
          'accessLevel': userInfo['accessLevel']
        }));
    if (response.statusCode == 200) {
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'This employee have access of ${userInfo['accessLevel']}',
            style: const TextStyle(fontFamily: 'mont'),
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

  sendEdit(userInfo, String level) async {
    final response = await http.put(
      Uri.parse(usersUrl + '/' + userInfo['id']),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: userInfo['hasAccess']
          ? jsonEncode(<String, String>{'accessLevel': level.toLowerCase()})
          : jsonEncode(<String, dynamic>{
              'hasAccess': true,
              'accessLevel': level.toLowerCase()
            }),
    );
    if (response.statusCode == 200) {
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'This employee now has an access level of $level',
            style: const TextStyle(fontFamily: 'mont'),
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

  Widget checkAdmin(bool? hasAccess, dynamic userInfo) {
    if (hasAccess == null || !hasAccess) {
      return Container();
    } else {
      switch (userInfo['accessLevel']) {
        case 'admin':
          return IconButton(
            icon: const Icon(
              Icons.admin_panel_settings_rounded,
              size: 30,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'This employee is already an Admin',
                    style: TextStyle(fontFamily: 'mont'),
                  ),
                ),
              );
            },
          );
        case 'rh':
          return IconButton(
            icon: const Icon(
              Icons.supervisor_account_rounded,
              size: 30,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'This employee has a RH Role',
                    style: TextStyle(fontFamily: 'mont'),
                  ),
                ),
              );
            },
          );
        case 'support':
          return IconButton(
            icon: const Icon(
              Icons.support_agent_rounded,
              size: 30,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'This employee has a Support role',
                    style: TextStyle(fontFamily: 'mont'),
                  ),
                ),
              );
            },
          );
        default:
          return Container();
      }
    }
  }

  sendEditImage(imageFile, userId) async {
    final response = await http.put(
      Uri.parse(usersUrl + '/' + userId),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        "imageUri": imageFile[0],
        "imageTumb": imageFile[1]
      }),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'User picture sucessul Updated',
            style: TextStyle(fontFamily: 'mont'),
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => Warning(context, response.body),
      );
    }
  }

  BodyUserApp(ctx, userInfo) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButtonWhite(),
        leadingWidth: 70,
        toolbarHeight: 80,
        backgroundColor: const Color(0xFF6CCFF7),
      ),
      body: ListView(
        key: const Key('employee-scroll'),
        scrollDirection: Axis.vertical,
        children: [
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 150,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: AlignmentDirectional.bottomEnd,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    userInfo['imageUri'] == null
                        ? Container(
                            margin: const EdgeInsets.only(left: 15, right: 10),
                            child: Image.asset(
                              "images/user.png",
                              fit: BoxFit.contain,
                              width: 35,
                            ),
                          )
                        : Flexible(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100.0),
                              child: CachedNetworkImage(
                                filterQuality: FilterQuality.high,
                                fit: BoxFit.cover,
                                imageUrl: userInfo['imageUri'],
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Image.network(defaultImage),
                                height: 130,
                                width: 130,
                              ),
                            ),
                          ),
                  ],
                ),
                Positioned(
                  height: 30,
                  width: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext ctx) =>
                            EditPic(context, userInfo['imageUri']),
                      ).then((value) async {
                        await sendEditImage(value, userInfo['id']);
                      }).then((value) => handleRefresh());
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(
                        side: BorderSide.none,
                      ),
                      fixedSize: const Size(30, 30),
                      shadowColor: Colors.black,
                      elevation: 10.0,
                    ),
                    child: const Icon(
                      Icons.photo_camera,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.only(bottom: 5),
              child: AutoSizeText(
                userInfo['name'],
                maxLines: 1,
                style: const TextStyle(
                  fontFamily: 'montBold',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            checkAdmin(userInfo['hasAccess'], userInfo),
          ]),
          Card(
            elevation: 3.0,
            shadowColor: Colors.grey,
            margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3),
              side: const BorderSide(color: Color(0xFF6CCFF7), width: 1),
            ),
            child: ListTile(
              title: Container(
                margin: const EdgeInsets.only(top: 5),
                child: const AutoSizeText(
                  'Name:',
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: 'mont',
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ),
              subtitle: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 20),
                child: AutoSizeText(
                  userInfo['name'],
                  maxLines: 1,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontFamily: 'mont',
                    fontSize: 17,
                  ),
                ),
              ),
              trailing: IconButton(
                key: const Key('edit-name-employee'),
                icon: const Icon(
                  Icons.edit,
                  size: 30,
                ),
                onPressed: () {
                  _openEditPopup(
                    ctx,
                    userInfo['id'],
                    'Name',
                    userInfo['name'],
                  );
                  handleRefresh();
                },
              ),
            ),
          ),
          Card(
            key: const Key('employee-drag-point'),
            elevation: 3.0,
            shadowColor: Colors.grey,
            margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3),
              side: const BorderSide(color: Color(0xFF6CCFF7), width: 1),
            ),
            child: ListTile(
              title: Container(
                margin: const EdgeInsets.only(top: 5),
                child: const AutoSizeText(
                  'Role:',
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: 'mont',
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ),
              subtitle: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 20),
                child: AutoSizeText(
                  userInfo['accessLevel'] ?? 'Employee',
                  maxLines: 1,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontFamily: 'mont',
                    fontSize: 17,
                  ),
                ),
              ),
              trailing: accessLevel == 'admin'
                  ? IconButton(
                      key: const Key('edit-role-employee'),
                      icon: const Icon(
                        Icons.edit,
                        size: 30,
                      ),
                      onPressed: () {
                        _openAdminPopup(userInfo);
                        handleRefresh();
                      },
                    )
                  : null,
            ),
          ),
          Card(
            elevation: 3.0,
            shadowColor: Colors.grey,
            margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3),
              side: const BorderSide(color: Color(0xFF6CCFF7), width: 1),
            ),
            child: ListTile(
              title: Container(
                margin: const EdgeInsets.only(top: 5),
                child: const AutoSizeText(
                  'Email:',
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: 'mont',
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ),
              subtitle: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 20),
                child: AutoSizeText(
                  userInfo['email'],
                  maxLines: 1,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontFamily: 'mont',
                    fontSize: 17,
                  ),
                ),
              ),
              trailing: IconButton(
                key: const Key('edit-email-employee'),
                icon: const Icon(
                  Icons.edit,
                  size: 30,
                ),
                onPressed: () {
                  _openEditPopup(
                      ctx, userInfo['id'], 'Email', userInfo['email']);
                  handleRefresh();
                },
              ),
            ),
          ),
          Card(
            elevation: 3.0,
            shadowColor: Colors.grey,
            margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3),
              side: const BorderSide(color: Color(0xFF6CCFF7), width: 1),
            ),
            child: ListTile(
              title: Container(
                margin: const EdgeInsets.only(top: 5),
                child: const AutoSizeText(
                  'Cost per Month:',
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: 'mont',
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ),
              subtitle: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 20),
                child: AutoSizeText(
                  'R\$' + userInfo['monthlyWage'],
                  maxLines: 1,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontFamily: 'mont',
                    fontSize: 17,
                  ),
                ),
              ),
              trailing: Wrap(children: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.history,
                    size: 30,
                  ),
                  onPressed: () {
                    _openHistoryPopup();
                  },
                ),
                IconButton(
                  key: const Key('edit-cost-employee'),
                  icon: const Icon(
                    Icons.edit,
                    size: 30,
                  ),
                  onPressed: () {
                    _openEditPopup(
                        ctx, userInfo['id'], 'Cost', userInfo['monthlyWage']);
                    handleRefresh();
                  },
                ),
              ]),
            ),
          ),
          Card(
            elevation: 3.0,
            shadowColor: Colors.grey,
            margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3),
              side: const BorderSide(color: Color(0xFF6CCFF7), width: 1),
            ),
            child: ListTile(
              title: Container(
                margin: const EdgeInsets.only(top: 5),
                child: const AutoSizeText(
                  'Technologies:',
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: 'mont',
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ),
              subtitle: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 20),
                child: AutoSizeText(
                  userInfo['tecnologies'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontFamily: 'mont',
                    fontSize: 17,
                  ),
                ),
              ),
              trailing: Wrap(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.read_more,
                      size: 30,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            CompleteTechnologies(userInfo['tecnologies']),
                      );
                    },
                  ),
                  IconButton(
                    key: const Key('editTechnologies'),
                    icon: const Icon(
                      Icons.edit,
                      size: 30,
                    ),
                    onPressed: () {
                      _openEditPopup(ctx, userInfo['id'], 'Technologies',
                          userInfo['tecnologies']);
                      handleRefresh();
                    },
                  ),
                ],
              ),
            ),
          ),
          if (userInfo['id'] == prefs.getString('id')) ...[
            Card(
              elevation: 3.0,
              shadowColor: Colors.grey,
              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3),
                side: const BorderSide(color: Color(0xFF6CCFF7), width: 1),
              ),
              child: ListTile(
                title: Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: const AutoSizeText(
                    'Password:',
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'mont',
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ),
                subtitle: Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 20),
                  child: const AutoSizeText(
                    'Change Your Password',
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.black87,
                      fontFamily: 'mont',
                      fontSize: 17,
                    ),
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.edit,
                    size: 30,
                  ),
                  onPressed: () {
                    resetPassword(prefs.getString('email')!);
                    handleRefresh();
                  },
                ),
              ),
            ),
          ],
          Visibility(
            visible: (userInfo['hasAccess'] != true) &&
                (userInfo['accessLevel'] == null ||
                    userInfo['accessLevel'] == 'employee') &&
                accessLevel == 'admin',
            child: Card(
              elevation: 10.0,
              color: const Color(0xFF6CCFF7),
              shadowColor: Colors.grey,
              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3),
                side: const BorderSide(color: Color(0xFF6CCFF7), width: 1),
              ),
              child: ListTile(
                onTap: () {
                  _openAdminPopup(userInfo);
                },
                subtitle: Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  child: const AutoSizeText(
                    'Level of Access',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.black87,
                      fontFamily: 'montBold',
                      fontSize: 17,
                    ),
                  ),
                ),
                trailing: Container(
                  margin: const EdgeInsets.all(10),
                  child: const Icon(
                    Icons.add_moderator_outlined,
                    color: Colors.black54,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: (userInfo['hasAccess'] == true) && accessLevel == 'admin',
            child: Card(
              elevation: 10.0,
              color: const Color(0xFF6CCFF7),
              shadowColor: Colors.grey,
              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3),
                side: const BorderSide(color: Color(0xFF6CCFF7), width: 1),
              ),
              child: ListTile(
                key: const Key('text-revoke-access'),
                onTap: () {
                  _revokeAccess(userInfo);
                },
                subtitle: Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  child: const AutoSizeText(
                    'Revoke Access ',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.black87,
                      fontFamily: 'montBold',
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: ((userInfo['accessLevel'] == 'rh' ||
                        userInfo['accessLevel'] == 'support' ||
                        userInfo['accessLevel'] == 'admin') &&
                    userInfo['hasAccess'] == false) &&
                accessLevel == 'admin',
            child: Card(
              elevation: 10.0,
              color: const Color(0xFF6CCFF7),
              shadowColor: Colors.grey,
              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3),
                side: const BorderSide(color: Color(0xFF6CCFF7), width: 1),
              ),
              child: ListTile(
                key: const Key('text-return-access'),
                onTap: () {
                  _returnAccess(userInfo);
                },
                subtitle: Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  child: const AutoSizeText(
                    'Return Access',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.black87,
                      fontFamily: 'montBold',
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          addproject(context, userInfo),
          const SizedBox(
            height: 10,
          ),
          userInfo['projects'].isNotEmpty
              ? ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: userInfo['projects'].length,
                  itemBuilder: (context, index) {
                    return projectComponent(
                        userInfo['projects'][index], userInfo['id']);
                  },
                )
              : Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: const Text(
                      "No active projects",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'mont',
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  BodyUserWeb(ctx, userInfo) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButtonWhite(),
        leadingWidth: 70,
        toolbarHeight: 80,
        backgroundColor: const Color(0xFF6CCFF7),
      ),
      body: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Container(
          width: MediaQuery.of(ctx).size.width * 0.25,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey, width: 0.7)),
            boxShadow: [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 4,
                offset: Offset(2, 4),
              ),
            ],
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            primary: false,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(children: [
                    const SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      width: 150,
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              userInfo['imageUri'] == null
                                  ? Container(
                                      margin: const EdgeInsets.only(
                                          left: 15, right: 10),
                                      child: Image.asset(
                                        "images/user.png",
                                        fit: BoxFit.contain,
                                        width: 35,
                                      ),
                                    )
                                  : Flexible(
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                        child: CachedNetworkImage(
                                          filterQuality: FilterQuality.high,
                                          fit: BoxFit.cover,
                                          imageUrl: userInfo['imageUri'],
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              Image.network(defaultImage),
                                          height: 130,
                                          width: 130,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                          Positioned(
                            height: 30,
                            width: 60,
                            child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext ctx) =>
                                      EditPic(context, userInfo['imageUri']),
                                ).then((value) async {
                                  await sendEditImage(value, userInfo['id']);
                                }).then((value) => handleRefresh());
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(
                                  side: BorderSide.none,
                                ),
                                fixedSize: const Size(30, 30),
                                shadowColor: Colors.black,
                                elevation: 10.0,
                              ),
                              child: const Icon(
                                Icons.photo_camera,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(children: [
                        Expanded(
                          child: Text(
                            userInfo['name'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'montBold',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        checkAdmin(userInfo['hasAccess'], userInfo),
                      ]),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ListTile(
                      title: Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: const AutoSizeText(
                          'Name:',
                          maxLines: 1,
                          style: TextStyle(
                            fontFamily: 'mont',
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      subtitle: Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 20),
                        child: AutoSizeText(
                          userInfo['name'],
                          maxLines: 1,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontFamily: 'mont',
                            fontSize: 17,
                          ),
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.edit,
                          size: 30,
                        ),
                        onPressed: () {
                          _openEditPopup(
                            ctx,
                            userInfo['id'],
                            'Name',
                            userInfo['name'],
                          );
                          handleRefresh();
                        },
                      ),
                    ),
                    ListTile(
                        title: Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: const AutoSizeText(
                            'Role:',
                            maxLines: 1,
                            style: TextStyle(
                              fontFamily: 'mont',
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        subtitle: Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 20),
                          child: AutoSizeText(
                            userInfo['accessLevel'] ?? 'Employee',
                            maxLines: 1,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontFamily: 'mont',
                              fontSize: 17,
                            ),
                          ),
                        ),
                        trailing: accessLevel == 'admin'
                            ? IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  size: 30,
                                ),
                                onPressed: () {
                                  _openAdminPopup(userInfo);
                                  handleRefresh();
                                },
                              )
                            : null),
                    ListTile(
                      title: Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: const AutoSizeText(
                          'Email:',
                          maxLines: 1,
                          style: TextStyle(
                            fontFamily: 'mont',
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      subtitle: Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 20),
                        child: AutoSizeText(
                          userInfo['email'],
                          maxLines: 1,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontFamily: 'mont',
                            fontSize: 17,
                          ),
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.edit,
                          size: 30,
                        ),
                        onPressed: () {
                          _openEditPopup(
                              ctx, userInfo['id'], 'Email', userInfo['email']);
                          handleRefresh();
                        },
                      ),
                    ),
                    ListTile(
                      title: Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: const AutoSizeText(
                          'Cost per Month:',
                          maxLines: 1,
                          style: TextStyle(
                            fontFamily: 'mont',
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      subtitle: Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 20),
                        child: AutoSizeText(
                          'R\$' + userInfo['monthlyWage'],
                          maxLines: 1,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontFamily: 'mont',
                            fontSize: 17,
                          ),
                        ),
                      ),
                      trailing: Wrap(children: <Widget>[
                        IconButton(
                          icon: const Icon(
                            Icons.history,
                            size: 30,
                          ),
                          onPressed: () {
                            _openHistoryPopup();
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            size: 30,
                          ),
                          onPressed: () {
                            _openEditPopup(ctx, userInfo['id'], 'Cost',
                                userInfo['monthlyWage']);
                            handleRefresh();
                          },
                        ),
                      ]),
                    ),
                    ListTile(
                      title: Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: const AutoSizeText(
                          'Technologies:',
                          maxLines: 1,
                          style: TextStyle(
                            fontFamily: 'mont',
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      subtitle: Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 20),
                        child: AutoSizeText(
                          userInfo['tecnologies'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontFamily: 'mont',
                            fontSize: 17,
                          ),
                        ),
                      ),
                      trailing: Wrap(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.read_more,
                              size: 30,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    CompleteTechnologies(
                                        userInfo['tecnologies']),
                              );
                            },
                          ),
                          IconButton(
                            key: const Key('editTechnologies'),
                            icon: const Icon(
                              Icons.edit,
                              size: 30,
                            ),
                            onPressed: () {
                              _openEditPopup(ctx, userInfo['id'],
                                  'Technologies', userInfo['tecnologies']);
                              handleRefresh();
                            },
                          ),
                        ],
                      ),
                    ),
                    if (userInfo['id'] == prefs.getString('id')) ...[
                      ListTile(
                        title: Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: const AutoSizeText(
                            'Password:',
                            maxLines: 1,
                            style: TextStyle(
                              fontFamily: 'mont',
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        subtitle: Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 20),
                          child: const AutoSizeText(
                            'Change Your Password',
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.black87,
                              fontFamily: 'mont',
                              fontSize: 17,
                            ),
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.edit,
                            size: 30,
                          ),
                          onPressed: () {
                            resetPassword(prefs.getString('email')!);
                            handleRefresh();
                          },
                        ),
                      ),
                    ],
                  ]),
                  ///////////////////////
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Visibility(
                        visible: (userInfo['hasAccess'] == false ||
                                userInfo['hasAccess'] == null) &&
                            (userInfo['accessLevel'] == null ||
                                userInfo['accessLevel'] == 'employee') &&
                            accessLevel == 'admin',
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Card(
                            elevation: 10.0,
                            color: const Color(0xFF6CCFF7),
                            shadowColor: Colors.grey,
                            margin: const EdgeInsets.only(
                                left: 20, right: 20, top: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3),
                              side: const BorderSide(
                                  color: Color(0xFF6CCFF7), width: 1),
                            ),
                            child: ListTile(
                              onTap: () {
                                _openAdminPopup(userInfo);
                              },
                              subtitle: Container(
                                margin:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                child: const AutoSizeText(
                                  'Level of Access ',
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontFamily: 'montBold',
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                              trailing: Container(
                                margin: const EdgeInsets.all(10),
                                child: const Icon(
                                  Icons.add_moderator_outlined,
                                  color: Colors.black54,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: (userInfo['hasAccess'] == true) &&
                            accessLevel == 'admin',
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Card(
                            elevation: 10.0,
                            color: const Color(0xFF6CCFF7),
                            shadowColor: Colors.grey,
                            margin: const EdgeInsets.only(
                                left: 20, right: 20, top: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3),
                              side: const BorderSide(
                                  color: Color(0xFF6CCFF7), width: 1),
                            ),
                            child: ListTile(
                              onTap: () {
                                _revokeAccess(userInfo);
                              },
                              subtitle: Container(
                                margin:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                child: const AutoSizeText(
                                  'Revoke Access',
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontFamily: 'montBold',
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: ((userInfo['accessLevel'] == 'rh' ||
                                    userInfo['accessLevel'] == 'support' ||
                                    userInfo['accessLevel'] == 'admin') &&
                                userInfo['hasAccess'] == false) &&
                            accessLevel == 'admin',
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Card(
                            elevation: 10.0,
                            color: const Color(0xFF6CCFF7),
                            shadowColor: Colors.grey,
                            margin: const EdgeInsets.only(
                                left: 20, right: 20, top: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3),
                              side: const BorderSide(
                                  color: Color(0xFF6CCFF7), width: 1),
                            ),
                            child: ListTile(
                              onTap: () {
                                _returnAccess(userInfo);
                              },
                              subtitle: Container(
                                margin:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                child: const AutoSizeText(
                                  'Return Access',
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontFamily: 'montBold',
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ]),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 50),
            //height: MediaQuery.of(ctx).size.height,
            // width: MediaQuery.of(ctx).size.width * 0.75,
            child: Column(children: [
              const SizedBox(
                height: 50,
              ),
              addproject(context, userInfo),
              const SizedBox(
                height: 10,
              ),
              userInfo['projects'].isNotEmpty
                  ? ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: userInfo['projects'].length,
                      itemBuilder: (context, index) {
                        return projectComponent(
                            userInfo['projects'][index], userInfo['id']);
                      },
                    )
                  : Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: const Text(
                          "No active projects",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'mont',
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
            ]),
          ),
        ),
      ]),
    );
  }

  @override
  void dispose() {
    super.dispose();
    refreshController.close();
  }

  @override
  void initState() {
    super.initState();
    refreshController = StreamController();
    loadData();
  }

  Future handleRefresh() async {
    if (widget.userLogado == true) {
      await infoUserMe().then((res) {
        refreshController.add(res);
        return;
      });
    } else {
      await fetchDataDetails().then((res) {
        refreshController.add(res);
        return;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<dynamic>(
        stream: refreshController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            dynamic userInfo = snapshot.data['data'];
            return LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxWidth <= 800) {
                return BodyUserApp(context, userInfo);
              } else {
                return BodyUserWeb(context, userInfo);
              }
            });
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

  projectComponent(dynamic projectInfo, id) {
    String? accessLevel = prefs.getString('access');
    return Card(
      elevation: 3.0,
      shadowColor: Colors.black54,
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3),
        side: const BorderSide(color: Color(0xFF6CCFF7), width: 1),
      ),
      child: ListTile(
        onTap: accessLevel != 'admin'
            ? null
            : () => _openProjectDetail(projectInfo),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        title: AutoSizeText(
          projectInfo['name'],
          maxLines: 1,
          style: const TextStyle(
            color: Colors.black87,
            fontFamily: 'mont',
            fontSize: 20,
          ),
        ),
        trailing: Wrap(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 12, right: 10),
              child: Text(
                'Allocation:',
                style: TextStyle(fontFamily: 'mont', fontSize: 12),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5, right: 20),
              child: CircularPercentIndicator(
                radius: 15.0,
                lineWidth: 3.0,
                percent: checkAllocation(projectInfo),
                center: Text(
                  "${((checkAllocation(projectInfo)) * 100).toStringAsFixed(0)}%",
                  style: const TextStyle(fontSize: 8),
                ),
                progressColor: Colors.green,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 30, color: Colors.grey),
              padding: EdgeInsets.zero,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext ctx) =>
                      DeleteWarningEmploDetail(context),
                ).then((value) async {
                  if (value) {
                    await showDatePicker(
                            helpText: 'Select the last day he worked',
                            context: context,
                            initialDate: DateFormat('yyyy-MM-dd').parse(
                                projectInfo['projectHasUsers'][
                                    projectInfo['projectHasUsers'].length -
                                        1]['startDate']),
                            firstDate: DateFormat('yyyy-MM-dd').parse(
                                projectInfo['projectHasUsers'][
                                    projectInfo['projectHasUsers'].length -
                                        1]['startDate']),
                            lastDate: DateTime(2050))
                        .then(
                      (date) {
                        setState(
                          () {
                            _dateTime = date!;
                            text = DateFormat("yyyy-MM-dd").format(_dateTime);
                          },
                        );
                      },
                    );
                    await deleteProjectMember(projectInfo['id'], text, id);
                    handleRefresh();
                    EInfoDashBoardState().handleRefresh1();
                    EInfoDashBoardState().handleRefresh2();
                    EInfoDashBoardState().handleRefresh3();
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
