// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'Screens/login_screen.dart';
import 'body.dart';
import 'app_constants.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_driver/driver_extension.dart';
// void main() => runApp(const MyApp());

Future<void> main() async {
  enableFlutterDriverExtension();
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyCzICrpCVbN7kz9YaY4i1u1K1nb17oiKdc",
            authDomain: "project-manager-dead4.firebaseapp.com",
            databaseURL:
                "https://project-manager-dead4-default-rtdb.firebaseio.com",
            projectId: "project-manager-dead4",
            storageBucket: "project-manager-dead4.appspot.com",
            messagingSenderId: "407508055877",
            appId: "1:407508055877:web:cdf9a13ceefb4d864ef02c",
            measurementId: "G-8V695TYC6X"));
  } else {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: "AIzaSyCj9xCaX9md4pEc0HmPHP37fYMgK6EXyz0",
      appId: "1:407508055877:android:f83381c9a38b169c4ef02c",
      messagingSenderId:
          "AAAAXuFfd0U:APA91bERhalY7iEivSmninDGFNHyhxT04yKjbt6J2U9GuKqpUxVt9wMAdrYEyroi2Z8dppPBFVO2_UVJ-aa3se4D9H5-Qkn_13f4XeqGPzp809nkrLcfPcqaYzcD21cpxnmUtD7rlTHl",
      projectId: "project-manager-dead4",
    ));
  }

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var user = prefs.getString('user');
  Auth().update(prefs.getString('token'));
  late var status;

  Future checkLogin() async {
    final data = await http.get(Uri.parse(dadosUser), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    status = data.statusCode;
    return jsonDecode(data.body);
  }

  // activateLog(Flav.Logs.analytics, "Web Init");
  // setupLocator();

  runApp(
    MaterialApp(
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF6CCFF7),
          secondary: Color(0xFF6CCFF7),
        ),
        primarySwatch: Colors.blue,
        splashColor: const Color(0xFF6CCFF7),
      ),
      // navigatorObservers: [
      //   locator<AnalyticsService>().getAnalyticsObserver(),
      // ],
      home: FutureBuilder(
        future: checkLogin(),
        builder: (context, snapshot) {
          if (snapshot.hasData && status == 200) {
            return StatefulBody(user!, snapshot.data);
          } else {
            if (snapshot.hasData && status != 200) {
              return const Login();
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
          }
        },
      ),
    ),
  );
}
