// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:http/http.dart' as http;

import '../Models/employee_model.dart';
import 'warning_popup.dart';
import '../app_constants.dart';

// ignore: must_be_immutable
class RecoveryCode extends StatefulWidget {
  var parentCtx;
  String email;
  RecoveryCode(BuildContext context, this.email, {Key? key}) : super(key: key);
  @override
  RecoveryCodeState createState() => RecoveryCodeState();
}

class RecoveryCodeState extends State<RecoveryCode> {
  late var recoveryCode;

  createUser(EmployeeCreation userData, ctx) async {
    final response = await http.post(
      Uri.parse(usersUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {
      return ScaffoldMessenger.of(widget.parentCtx).showSnackBar(
        const SnackBar(
          content: Text(
            'User succesfully added',
            style: TextStyle(fontFamily: 'mont'),
          ),
        ),
      );
    } else {
      return showDialog(
        context: widget.parentCtx,
        builder: (BuildContext context) => Warning(context, response.body),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text(
        'Enter the Recovery Code!',
        style: TextStyle(
          fontFamily: 'montBold',
          fontSize: 22,
        ),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'The recovery code has sended to the following email: ${widget.email}',
            maxLines: 3,
            style: const TextStyle(
              fontFamily: 'mont',
              fontSize: 15,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          PinCodeTextField(
            appContext: context,
            length: 8,
            obscureText: false,
            animationType: AnimationType.fade,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(5),
              fieldHeight: 40,
              fieldWidth: 30,
              activeFillColor: Colors.white,
              inactiveColor: Colors.black,
              activeColor: const Color(0xFF6CCFF7),
            ),
            animationDuration: const Duration(milliseconds: 300),
            enableActiveFill: false,
            onCompleted: (v) {
              recoveryCode = v;
            },
            onChanged: (value) {
              setState(() {
                // recoveryCode = value;
              });
            },
            beforeTextPaste: (text) {
              return true;
            },
          )

          // child: TextFormField(
          //   maxLength: 8,
          //   maxLengthEnforcement: MaxLengthEnforcement.enforced,
          //   style: const TextStyle(fontFamily: "mont", fontSize: 14),
          //   decoration: const InputDecoration(
          //     enabledBorder: OutlineInputBorder(
          //       borderSide:
          //           BorderSide(color: Color(0xFF6CCFF7), width: 2),
          //     ),
          //     border: OutlineInputBorder(),
          //     labelText: 'Recovery Code: ',
          //     labelStyle: TextStyle(
          //         color: Colors.grey, fontFamily: "mont", fontSize: 14),
          //   ),
          //   keyboardType: TextInputType.name,
          //   textInputAction: TextInputAction.next,
          //   validator: (value) {
          //     if (value == null ||
          //         value.isEmpty ||
          //         value.split('')[0] == " ") {
          //       return 'Please enter a valid recovery code!';
          //     }
          //     return null;
          //   },
          //   onSaved: (value) {
          //     recoveryCode = value;
          //   },
          // ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop('');
          },
          child: const Text(
            'Cancel',
            style: TextStyle(
              fontFamily: 'mont',
              color: Color(0xFF213e4b),
              fontSize: 15,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(recoveryCode);
          },
          child: Container(
            color: const Color(0xFF6CCFF7),
            padding: const EdgeInsets.all(6),
            child: const Text(
              'Confirm',
              style: TextStyle(
                fontFamily: 'montBold',
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
