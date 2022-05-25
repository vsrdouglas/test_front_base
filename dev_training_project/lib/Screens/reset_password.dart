// ignore_for_file: avoid_print, must_be_immutable, prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/PopUps/warning_popup.dart';
import 'package:my_app/Screens/login_screen.dart';
import 'dart:convert';

import '../app_constants.dart';

class ResetPasswordScreen extends StatefulWidget {
  String email;
  var tokenKey;
  ResetPasswordScreen(this.email, this.tokenKey, {Key? key}) : super(key: key);
  @override
  ResetPasswordScreenState createState() => ResetPasswordScreenState();
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _form = GlobalKey<FormState>();
  late String password;
  late String passwordConf;
  bool obscure = true;
  bool obscure1 = true;

  FormPassword(double large) {
    return Form(
        key: _form,
        child: Column(children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: large),
            child: TextFormField(
              key: const Key('reset-new-password'),
              obscureText: obscure,
              style: const TextStyle(fontFamily: "mont", fontSize: 14),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    obscure ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      obscure = !obscure;
                    });
                  },
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6CCFF7), width: 2),
                ),
                border: const OutlineInputBorder(),
                labelText: 'New Password: ',
                labelStyle: const TextStyle(
                    color: Colors.grey, fontFamily: "mont", fontSize: 14),
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password!';
                } else if (value.length < 6) {
                  return 'Please add more than 6 characters';
                }
                return null;
              },
              onChanged: (value) {
                password = value;
              },
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: large),
            child: TextFormField(
              key: const Key('reset-confirm-password'),
              obscureText: obscure1,
              style: const TextStyle(fontFamily: "mont", fontSize: 14),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    obscure ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      obscure1 = !obscure1;
                    });
                  },
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6CCFF7), width: 2),
                ),
                border: const OutlineInputBorder(),
                labelText: 'Confirm Password: ',
                labelStyle: const TextStyle(
                    color: Colors.grey, fontFamily: "mont", fontSize: 14),
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please your password!';
                }
                if (value.length < 6) {
                  return 'Please add more than 6 characters';
                }
                if (value != password) {
                  return 'This password does not match';
                }
                return null;
              },
              onChanged: (value) {
                passwordConf = value;
              },
            ),
          ),
        ]));
  }

  sendPassword(String pass) async {
    final passToken = widget.tokenKey;
    final response = await http.post(
      Uri.parse(reset),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $passToken',
      },
      body: jsonEncode(<String, dynamic>{
        'password': pass,
        'email': widget.email,
        'reset': true
      }),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Password succesfully edited',
            style: TextStyle(fontFamily: 'mont'),
          ),
        ),
      );
      Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return const Login();
        },
      ));
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => Warning(context, response.body),
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const AutoSizeText(
          'Change your password',
          style: TextStyle(fontFamily: "montBold", fontSize: 20),
        ),
        const SizedBox(
          height: 30,
        ),
        LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth <= 600) {
            return FormPassword(30.0);
          } else if (constraints.maxWidth > 600 &&
              constraints.maxWidth <= 1000) {
            return FormPassword(200.0);
          } else if (constraints.maxWidth > 1000 &&
              constraints.maxWidth <= 1200) {
            return FormPassword(350.0);
          } else if (constraints.maxWidth > 1200 &&
              constraints.maxWidth < 1500) {
            return FormPassword(500.0);
          } else {
            return FormPassword(600.0);
          }
        }),
        const SizedBox(
          height: 40,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 15),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0)),
            shadowColor: Colors.black,
            elevation: 10.0,
          ),
          onPressed: () async {
            if (_form.currentState!.validate() == true) {
              _form.currentState!.save();
              await sendPassword(password);
            }
          },
          child: const AutoSizeText(
            'Confirm',
            maxLines: 1,
            style: TextStyle(
              fontFamily: 'montBold',
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ),
      ],
    ));
  }
}
