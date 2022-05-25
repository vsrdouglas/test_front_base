// ignore_for_file: must_be_immutable, non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

import 'Widgets/access_permisions_web.dart';
import 'Widgets/access_permission_app.dart';

class StatefulBody extends StatefulWidget {
  String username;
  var dados;
  StatefulBody(this.username, this.dados, {Key? key}) : super(key: key);
  @override
  State<StatefulBody> createState() => StatefulBodyState();
}

class StatefulBodyState extends State<StatefulBody> {
  HomePageWebTest(BoxConstraints constraints, BuildContext context) {
    double left = 0;
    if (constraints.maxWidth >= 1258) {
      left = ((constraints.maxWidth / 100) * 40) - 150;
    } else {
      left = (((constraints.maxWidth / 100) * 40) - 300);
    }
    return MaterialApp(
      home: AccessPermisionsWeb(
        accessLevel: widget.dados['data']['accessLevel'],
        left: left,
        imageThumb: widget.dados['data']['imageTumb'],
        userId: widget.dados['data']['id'],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth <= 1000) {
        return HomePageApp(
          accessLevel: widget.dados['data']['accessLevel'],
          username: widget.username,
          imageThumb: widget.dados['data']['imageTumb'],
          userId: widget.dados['data']['id'],
        );
      } else {
        // activateLog(
        //   Flav.Logs.analytics,
        //   widget.dados['data']['name'],
        // );
        return HomePageWebTest(constraints, context);
      }
    });
  }
}
