// ignore_for_file: avoid_print, body_might_complete_normally_nullable

import 'dart:async';
import 'dart:io' as app;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_app/app_constants.dart';
import 'package:flutter_native_image/flutter_native_image.dart' as imagethumb;
import 'package:image/image.dart' as imageweb;
import 'package:path/path.dart' as path;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cached_network_image/cached_network_image.dart';

// ignore: must_be_immutable
class EditPic extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  var parentCtx;
  String urlOrigem;

  EditPic(this.parentCtx, this.urlOrigem, {Key? key}) : super(key: key);
  @override
  EditPicState createState() => EditPicState();
}

class EditPicState extends State<EditPic> {
  FirebaseStorage storage = FirebaseStorage.instance;
  late String fileNameIma, fileNameImaT;
  String urlApp = '';
  String urlWeb = '';
  List urlImage = [];
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

      app.File imageFile = app.File(pickedImage.path);

      app.File compressedFile =
          await imagethumb.FlutterNativeImage.compressImage(
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
          urlImage.add(fileUrl);
          urlImage.add(fileUrlThumb);
          urlApp = fileUrl;
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
        urlImage.add(res);
        urlImage.add(resThumb);
        urlWeb = res;
        loader = false;
      });
      return res;
    }
  }

  _loadImagesWeb() async {
    if (urlWeb == '') {
      return widget.urlOrigem;
    }
    return urlWeb;
  }

  _loadImagesApp() async {
    if (urlApp == '') {
      return widget.urlOrigem;
    }
    return urlApp;
  }

  _saveUser() async {
    Navigator.of(context).pop(urlImage);
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
        'Edit Image',
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
                  }
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: Image.network(
                      defaultImage,
                      height: 40,
                      width: 40,
                    ),
                  );
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
                  fontSize: 15,
                ),
              ),
            ),
          ]),
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
            if (loader == false) {
              await _saveUser();
            }
          },
          child: Container(
            color: loader == false
                ? const Color(0xFF6CCFF7)
                : const Color(0xFF6CCFF7).withOpacity(0.5),
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
