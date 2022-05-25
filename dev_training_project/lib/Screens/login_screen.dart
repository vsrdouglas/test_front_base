// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/PopUps/warning_popup.dart';
import 'package:my_app/Screens/recovery_password.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../app_constants.dart';
import '../body.dart';
import 'first_acess.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final _form = GlobalKey<FormState>();
  late String email;
  late String emailShared;
  late var dados;
  var firstAcess;
  late String username;
  late String password;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool obscure = true;
  late FocusNode myFocusNode;

  FormApp(double large) {
    return Form(
        key: _form,
        child: Column(children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: large),
            child: TextFormField(
              key: const Key('email-text-field'),
              autofocus: true,
              controller: _emailController,
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
          Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: large),
            child: TextFormField(
              key: const Key('password-text-field'),
              controller: _passwordController,
              obscureText: obscure,
              style: const TextStyle(fontFamily: "mont", fontSize: 14),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    obscure ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    FocusScope.of(context).requestFocus(myFocusNode);
                    setState(() {
                      obscure = !obscure;
                    });
                  },
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6CCFF7), width: 2),
                ),
                border: const OutlineInputBorder(),
                labelText: 'Password: ',
                labelStyle: const TextStyle(
                    color: Colors.grey, fontFamily: "mont", fontSize: 14),
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password!';
                }
                return null;
              },
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(myFocusNode);
              },
              onChanged: (value) {
                password = value;
              },
            ),
          ),
        ]));
  }

  Future getUserName() async {
    final res = await http.get(Uri.parse(dadosUser), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    return jsonDecode(res.body);
  }

  Future login(String email, String password) async {
    final res = await http.post(Uri.parse(loginUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body:
            jsonEncode(<String, String>{"email": email, "password": password}));

    if (res.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString('token', jsonDecode(res.body)['token']);

      setState(() {
        _emailController.clear();
        _passwordController.clear();
      });

      Auth().update(jsonDecode(res.body)['token']);
      dados = await getUserName();
      username = dados['data']['name'].toString();
      emailShared = dados['data']['email'].toString();
      if (dados['data']['firstAccess'] == null) {
        firstAcess = '';
      }

      prefs.setString('user', username);
      prefs.setString('id', dados['data']['id'].toString());
      prefs.setString('email', emailShared);
      prefs.setString('access', dados['data']['accessLevel']);

      Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
        builder: (BuildContext context) {
          if (firstAcess == '') {
            return FirstAcess(dados);
          } else {
            return StatefulBody(username, dados);
          }
        },
      ));
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
    myFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  void initState() {
    myFocusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
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
            return FormApp(30.0);
          } else if (constraints.maxWidth > 600 &&
              constraints.maxWidth <= 1000) {
            return FormApp(200.0);
          } else if (constraints.maxWidth > 1000 &&
              constraints.maxWidth <= 1200) {
            return FormApp(350.0);
          } else if (constraints.maxWidth > 1200 &&
              constraints.maxWidth < 1500) {
            return FormApp(500.0);
          } else {
            return FormApp(600.0);
          }
        }),
        const SizedBox(
          height: 40,
        ),
        ElevatedButton(
          key: const Key('btn-sign-in'),
          focusNode: myFocusNode,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0)),
            shadowColor: Colors.black,
            elevation: 10.0,
            onPrimary: const Color(0xFF6CCFF7),
          ),
          onPressed: () async {
            if (_form.currentState!.validate() == true) {
              _form.currentState!.save();
              await login(email, password);
            }
          },
          child: const AutoSizeText(
            'Sign In',
            maxLines: 1,
            style: TextStyle(
              fontFamily: 'montBold',
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (BuildContext context) {
                return const RecoveryPassword();
              },
              fullscreenDialog: true,
            ));
          },
          child: const AutoSizeText('Forgot my password',
              style: TextStyle(
                  fontFamily: "mont",
                  fontSize: 14,
                  color: Colors.black,
                  decoration: TextDecoration.underline)),
        ),
      ],
    ));
  }
}
