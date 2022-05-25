// ignore_for_file: avoid_print, non_constant_identifier_names

import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/PopUps/recovery_popup.dart';
import 'package:my_app/PopUps/warning_popup.dart';
import 'dart:convert';

import '../app_constants.dart';
import 'reset_password.dart';

class RecoveryPassword extends StatefulWidget {
  const RecoveryPassword({Key? key}) : super(key: key);
  @override
  RecoveryPasswordState createState() => RecoveryPasswordState();
}

class RecoveryPasswordState extends State<RecoveryPassword> {
  final _form = GlobalKey<FormState>();
  late String email;

  FormRecovery(large) {
    return Form(
        key: _form,
        child: Column(children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: large),
            child: TextFormField(
              key: const Key('recovery-email'),
              style: const TextStyle(fontFamily: "mont", fontSize: 14),
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6CCFF7), width: 2),
                ),
                border: OutlineInputBorder(),
                labelText: 'Email: ',
                labelStyle: TextStyle(
                    color: Colors.grey, fontFamily: "mont", fontSize: 14),
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an Email!';
                }
                if (!RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value)) {
                  return 'Enter a valid Email format';
                }
                return null;
              },
              onChanged: (value) {
                email = value;
              },
            ),
          ),
        ]));
  }

  Future confirmToken(String recoveryCode) async {
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
          confirmToken(value);
        }
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => Warning(context, res.body),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Flexible(
          flex: 1,
          child: Container(
            margin: const EdgeInsets.only(top: 60, bottom: 50),
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.5,
            // margin: EdgeInsets.all(5),
            child: Image.asset(
              "images/project_login.png",
              fit: BoxFit.contain,
              width: 70,
            ),
          ),
        ),
        LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth <= 600) {
            return FormRecovery(30.0);
          } else if (constraints.maxWidth > 600 &&
              constraints.maxWidth <= 1000) {
            return FormRecovery(200.0);
          } else if (constraints.maxWidth > 1000 &&
              constraints.maxWidth <= 1200) {
            return FormRecovery(350.0);
          } else if (constraints.maxWidth > 1200 &&
              constraints.maxWidth < 1500) {
            return FormRecovery(500.0);
          } else {
            return FormRecovery(600.0);
          }
        }),
        const SizedBox(
          height: 40,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0)),
            shadowColor: Colors.black,
            elevation: 10.0,
          ),
          onPressed: () async {
            if (_form.currentState!.validate() == true) {
              _form.currentState!.save();
              resetPassword(email);
            }
          },
          child: const AutoSizeText(
            'Reset Password',
            maxLines: 2,
            style: TextStyle(
              fontFamily: 'montBold',
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ),
      ],
    ));
  }
}
