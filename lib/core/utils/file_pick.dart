import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/google_drive/g_drive_handler/gdrivehandler_function.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

Future<bool> pickImage(int useGallery, BuildContext context,callback,
    {int type = 0}) async {
  // CroppedFile? croppedFile;
  // Uint8List? localImg;
  final pickedImage = await ImagePicker().pickImage(
    source: useGallery == 1 ? ImageSource.camera : ImageSource.gallery,
  );
  //var imageFile = pickedImage != null ? CroppedFile(pickedImage.path) : null;

    if (pickedImage != null) {
      callback(pickedImage, false);
        // imageFile!.readAsBytes().then((value) {
        //     croppedFile = imageFile;
        //     callback(croppedFile, false);
        //     localImg = value;
        // });
        return true;
    }

  return false;
}

Future<Null> pickDocument(callback) async {

  CroppedFile? croppedFile;
  Uint8List? localImg;
  bool isDoc = false;

  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['jpg', 'pdf', 'png'],
  );
  if (result != null) {
    isDoc = true;
    croppedFile = null;
    localImg = null;
    String path = result.files.first.path ?? '';
    XFile file = XFile(path);

    callback( file, true);
  }
}

Future pickFromGdrive(callback, context) async{
  File? myFile = await GoogleDriveHandler().loginWithGmail(context: context,
  signInFor: 0);
  if (myFile != null) {
    //Do something with the file
    //for instance open the file
    XFile xfile=XFile(myFile.path);
    print("selected path ${myFile.path}");
    callback(xfile, true);
    //OpenFile.open(myFile.path);
  }
}