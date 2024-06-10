import 'dart:io';

import 'package:flutter/material.dart';
import 'package:haelo_flutter/constants.dart';
import 'package:haelo_flutter/features/google_drive/g_drive_handler/gdrivehandler_function.dart';
import 'package:haelo_flutter/widgets/gallery_camera_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file_plus/open_file_plus.dart';

import '../../../core/utils/file_pick.dart';

class GoogleDriveHandlerExampleApp extends StatelessWidget {
  const GoogleDriveHandlerExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final String myApiKey = "";

  static File? file;
  Map<String, String> map = {};

  @override
  Widget build(BuildContext context) {
    GoogleDriveHandler().setAPIKey(
      apiKey: Constants.api_key,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "GoogleDrive",
        ),
        centerTitle: true,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                File? myFile = await GoogleDriveHandler()
                    .loginWithGmail(context: context, signInFor: 0);
                if (myFile != null) {
                  //Do something with the file
                  //for instance open the file
                  print("selected path ${myFile.path}");
                  //OpenFile.open(myFile.path);
                } else {
                  //Discard...
                }
              },
              child: const Text(
                "Get file from google drive",
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                Map<String, String> map = await GoogleDriveHandler()
                    .loginWithGmail(
                        context: context,
                        signInFor: 1,
                        subFolerName: "My Cases");
                print("drive ids map $map");
                print("done from main page");
              },
              child: const Text(
                "Create folder",
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                map = await GoogleDriveHandler().loginWithGmail(
                    context: context, signInFor: 1, subFolerName: "Task");
                print("drive ids map $map");
                showDialog(
                    context: context,
                    builder: (ctx) => SafeArea(
                          child: GalleryCameraDialog(
                              isDoc: true,
                              is_g_Drive: false,
                              onClickValue: (isGallery) {
                                if (isGallery == 4) {
                                  pickFromGdrive(imgCallBack, context);
                                } else if (isGallery == 3) {
                                  pickDocument(imgCallBack);
                                } else {
                                  pickImage(isGallery, context, imgCallBack);
                                }
                              }),
                        )).then((value) async {});
                print("done from main page");
              },
              child: const Text(
                "Upload a file to specific folder",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> imgCallBack(XFile xfile, bool isDoc) async {
    print("gstFile");
    file = File(xfile.path);
    setState(() {});
    await GoogleDriveHandler().loginWithGmail(
        context: context,
        signInFor: 2,
        file: file,
        folderId: map['sub_folder_id'].toString());
  }
}
