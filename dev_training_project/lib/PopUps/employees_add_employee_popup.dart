// ignore_for_file: avoid_print, body_might_complete_normally_nullable

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_app/Screens/info_dashboard.dart';
import 'package:path/path.dart' as path;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_native_image/flutter_native_image.dart' as imagethumb;
import 'package:image/image.dart' as imageweb;
import 'package:flutter/foundation.dart';
import '../Models/employee_model.dart';
import 'warning_popup.dart';
import '../Screens/employees_screen.dart';
import '../app_constants.dart';

// ignore: must_be_immutable
class AddEmployeePopup extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  var parentCtx;
  StreamController refreshController;
  bool flag;

  AddEmployeePopup(
      BuildContext context, this.parentCtx, this.refreshController, this.flag,
      {Key? key})
      : super(key: key);
  @override
  AddEmployeePopupState createState() => AddEmployeePopupState();
}

class AddEmployeePopupState extends State<AddEmployeePopup> {
  final _form = GlobalKey<FormState>();
  final _createdUser =
      EmployeeCreation('', '', '', '', '', '', 0.0, null, null);
  FirebaseStorage storage = FirebaseStorage.instance;
  String urlApp = '';
  late String fileNameIma, fileNameImaT;
  String dropdownRole = 'Employee';
  String urlWeb = '';
  bool? loader;
  Widget fileImage = ClipRRect(
    borderRadius: BorderRadius.circular(50.0),
    child: Image.network(
      defaultImage,
      height: 40,
      width: 40,
    ),
  );

  _uploadApp(String inputSource) async {
    XFile? pickedImage;
    final picker = ImagePicker();
    try {
      pickedImage = await picker.pickImage(
          source: inputSource == 'camera'
              ? ImageSource.camera
              : ImageSource.gallery,
          imageQuality: 1,
          maxWidth: 1920);

      setState(() {
        loader = true;
      });

      final String fileName = path.basename(pickedImage!.path);
      final String fileNameThumb = fileName + '_thumb';

      File imageFile = File(pickedImage.path);

      File compressedFile = await imagethumb.FlutterNativeImage.compressImage(
        imageFile.path,
        targetWidth: 130,
        targetHeight: 130,
      );

      try {
        await storage.ref(fileName).putFile(
              imageFile,
            );

        await storage.ref(fileNameThumb).putFile(
              compressedFile,
            );

        setState(() {
          fileNameIma = fileName;
          fileNameImaT = fileNameThumb;
        });

        final ref = storage.ref(fileNameIma);
        final refere = storage.ref(fileNameThumb);

        final String fileUrl = await ref.getDownloadURL();
        final String fileUrlThumb = await refere.getDownloadURL();

        setState(() {
          urlApp = fileUrl;
          _createdUser.imageUri = fileUrl;
          _createdUser.imageTumb = fileUrlThumb;
          loader = false;
        });
      } on FirebaseException catch (error) {
        print(error);
      }
    } catch (err) {
      print(err);
    }
  }

  Future<String?> pickAndUploadFileWeb() async {
    final ref = FirebaseStorage.instance
        .refFromURL('gs://project-manager-dead4.appspot.com');
    String res;
    String resThumb;

    final filePickerRes = await FilePicker.platform.pickFiles();
    if (filePickerRes != null) {
      if (filePickerRes.count == 1) {
        setState(() {
          loader = true;
        });
        final file = filePickerRes.files.single;
        final upTask = await ref.child(file.name).putData(file.bytes!);
        res = (await upTask.ref.getDownloadURL()).toString();

        //thumb
        final fileThumb = file;
        Uint8List resizedData = fileThumb.bytes!;
        List<int> fileBytes = fileThumb.bytes!;
        imageweb.Image decodedImage =
            imageweb.decodeImage(fileBytes) as imageweb.Image;

        imageweb.Image thumbnail =
            imageweb.copyResize(decodedImage, width: 130, height: 130);

        resizedData = (imageweb.encodePng(thumbnail) as Uint8List?)!;

        final upTaskThumb =
            await ref.child('thumb' + fileThumb.name).putData(resizedData);
        resThumb = (await upTaskThumb.ref.getDownloadURL()).toString();
      } else {
        throw Exception('Only one file allowed');
      }
      setState(() {
        urlWeb = res;
        _createdUser.imageTumb = resThumb;
        _createdUser.imageUri = urlWeb;
        loader = false;
      });
      return res;
    }
  }

  _loadImagesWeb() async {
    if (urlWeb == '') {
      return defaultImage;
    }
    return urlWeb;
  }

  _loadImagesApp() async {
    if (urlApp == '') {
      return defaultImage;
    }
    return urlApp;
  }

  Future<void> handleRefresh() async {
    if (widget.flag) {
      await infoEmployeesU().then((res) {
        widget.refreshController.add(res);

        return null;
      });
    } else {
      await fetchData().then((res) {
        widget.refreshController.add(res);

        return null;
      });
    }
  }

  createUser(EmployeeCreation userData, ctx) async {
    if (_createdUser.imageUri == null || _createdUser.imageUri == '') {
      _createdUser.imageUri = defaultImage;
    }
    if (_createdUser.imageTumb == null || _createdUser.imageTumb == '') {
      _createdUser.imageTumb = defaultImageThumb;
    }
    final response = await http.post(
      Uri.parse(usersUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'name': userData.name,
        'email': userData.email,
        'monthlyWage': userData.wage,
        'imageUri': userData.imageUri,
        'imageTumb': userData.imageTumb,
        'accessLevel': userData.accessLevel,
        'hasAccess': userData.hasAccess,
        'tecnologies': userData.tecnologies,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(widget.parentCtx).showSnackBar(
        const SnackBar(
          content: Text(
            'User succesfully added',
            style: TextStyle(fontFamily: 'mont'),
          ),
        ),
      );
    } else {
      showDialog(
        context: widget.parentCtx,
        builder: (BuildContext context) => Warning(context, response.body),
      );
    }
  }

  _saveUser() async {
    if (_form.currentState!.validate() == true) {
      _form.currentState!.save();
      Navigator.of(context).pop(true);
      await createUser(_createdUser, context);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text(
        'Add Employee',
        style: TextStyle(
          fontFamily: 'montBold',
          fontSize: 22,
        ),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: FutureBuilder(
                future: kIsWeb ? _loadImagesWeb() : _loadImagesApp(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (loader == null) {
                      return fileImage;
                    } else if (loader == true) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: const CircularProgressIndicator(),
                      );
                    } else {
                      return SizedBox(
                        height: 50,
                        width: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child: CachedNetworkImage(
                            imageUrl: snapshot.data.toString(),
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Image.network(defaultImage),
                          ),
                        ),
                      );
                    }
                  } else {
                    return fileImage;
                  }
                },
              ),
            ),
            TextButton(
              onPressed: () {
                if (kIsWeb) {
                  pickAndUploadFileWeb();
                } else {
                  _uploadApp('gallery');
                }
              },
              child: const Text(
                'Pick your Image',
                style: TextStyle(
                  fontFamily: 'mont',
                  color: Color(0xFF213e4b),
                  fontSize: 13,
                ),
              ),
            ),
          ]),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 232),
            child: Form(
              key: _form,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: TextFormField(
                      key: const Key('add-employee-name'),
                      style: const TextStyle(fontFamily: "mont", fontSize: 14),
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFF6CCFF7), width: 2),
                        ),
                        border: OutlineInputBorder(),
                        labelText: 'Name: ',
                        labelStyle: TextStyle(
                            color: Colors.grey,
                            fontFamily: "mont",
                            fontSize: 14),
                      ),
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.split('')[0] == " ") {
                          return 'Please enter a valid Name!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _createdUser.name = value;
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: TextFormField(
                      key: const Key('add-employee-email'),
                      style: const TextStyle(fontFamily: "mont", fontSize: 14),
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFF6CCFF7), width: 2),
                        ),
                        border: OutlineInputBorder(),
                        labelText: 'Email: ',
                        labelStyle: TextStyle(
                            color: Colors.grey,
                            fontFamily: "mont",
                            fontSize: 14),
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
                      onSaved: (value) {
                        _createdUser.email = value;
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: TextFormField(
                      key: const Key('add-employee-cost'),
                      style: const TextStyle(fontFamily: "mont", fontSize: 14),
                      decoration: const InputDecoration(
                        prefixText: 'R\$',
                        hintText: '0000.00',
                        hintStyle: TextStyle(fontFamily: 'mont'),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFF6CCFF7), width: 2),
                        ),
                        border: OutlineInputBorder(),
                        labelText: 'Cost :',
                        labelStyle: TextStyle(
                            color: Colors.grey,
                            fontFamily: "mont",
                            fontSize: 14),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter(',',
                            allow: false, replacementString: '.'),
                        FilteringTextInputFormatter.allow(
                            RegExp(r"^\d+\.?\d{0,2}")),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a Cost!';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Enter a number greater than 0';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        _createdUser.wage = value;
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: DropdownButtonFormField<String>(
                      key: const Key('add-employee-access'),
                      validator: (value) {
                        if (value == null || value == '') {
                          return 'Please Enter a level';
                        }
                      },
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownRole = newValue!;
                          _createdUser.accessLevel = dropdownRole.toLowerCase();
                          _createdUser.hasAccess =
                              dropdownRole == 'Employee' ? false : true;
                        });
                      },
                      icon: const Icon(Icons.keyboard_arrow_down),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'mont',
                          fontSize: 14),
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFF6CCFF7), width: 2),
                        ),
                        border: OutlineInputBorder(),
                        labelText: 'Level of Access*',
                        labelStyle: TextStyle(
                            color: Colors.grey,
                            fontFamily: "mont",
                            fontSize: 14),
                      ),
                      items: <String>['Employee', 'Support', 'RH', 'Admin']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 14)),
                        );
                      }).toList(),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: TextFormField(
                      key: const Key('add-employee-technologies'),
                      style: const TextStyle(fontFamily: "mont", fontSize: 14),
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFF6CCFF7), width: 2),
                        ),
                        border: OutlineInputBorder(),
                        labelText: 'Technologies: ',
                        labelStyle: TextStyle(
                            color: Colors.grey,
                            fontFamily: "mont",
                            fontSize: 14),
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      maxLines: 2,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a Technologie!';
                        }
                      },
                      onSaved: (value) {
                        _createdUser.tecnologies = value;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
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
          onPressed: () async {
            await _saveUser();
            handleRefresh();
            EInfoDashBoardState().handleRefresh1();
            EInfoDashBoardState().handleRefresh2();
            EInfoDashBoardState().handleRefresh3();
          },
          child: Container(
            key: const Key('confirm-add-employee'),
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
