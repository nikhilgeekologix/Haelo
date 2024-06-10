import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:haelo_flutter/core/utils/show_notification.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

Future<bool> requestPermission(Permission permission) async {
  if (await permission.isGranted) {
    return true;
  } else {
    var result = await permission.request();
    if (result == PermissionStatus.granted) {
      return true;
    }
  }
  return false;
}

downloadFile(
  String url,
  String fileName,
) async {
  print("inside downloadfile");

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var isPersist = await Permission.storage.request().isGranted;
  print("isPersist $isPersist");

  if (isPersist) {
    var extDir = Platform.isAndroid
        ? await getExternalStorageDirectory() //FOR ANDROID
        : await getApplicationDocumentsDirectory(); //FOR iOS

    File saveFile = File(extDir!.path + "/${fileName}");
    print("saveFilepath ${saveFile.path}");
    print("is already Exist ${saveFile.existsSync()}");
    // if (!saveFile.existsSync()) {
      print("not exist");
      final id = FlutterDownloader.enqueue(
          url: url,
          savedDir: extDir!.path,
          fileName: fileName,
          showNotification: false,
          openFileFromNotification: false);

      if (Platform.isIOS) {
        final bool? result = await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            );

        if (result!) {
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();
          showNotification(fileName, saveFile!.path);
          await OpenFile.open(saveFile!.path);
        }
      } else {
        if (await requestPermission(Permission.notification)) {
          showNotification(fileName, saveFile!.path);
          await OpenFile.open(saveFile!.path);
        }
      }
    // }
    // else {
    //   toast(msg: "File already exist in your device");
    // }
  } else {
    print('Permission denied');
  }
}

Future<String> shareFilePath(
  String url,
  String fileName,
) async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var isPersist = await Permission.storage.request().isGranted;
  print("isPersist $isPersist");

  if (isPersist) {
    var extDir = Platform.isAndroid
        ? await getExternalStorageDirectory() //FOR ANDROID
        : await getApplicationDocumentsDirectory(); //FOR iOS

    File saveFile = File(extDir!.path + "/${fileName}");
    print("saveFilepath ${saveFile.path}");
    print("is already Exist ${saveFile.existsSync()}");
    if (!saveFile.existsSync()) {
      print("not exist");
      final id = FlutterDownloader.enqueue(
          url: url,
          savedDir: extDir!.path,
          fileName: fileName,
          showNotification: false,
          openFileFromNotification: false);

     return saveFile.path;
    }
    return saveFile.path;
  } else {
    print('Permission denied');
  }
  return "";
}


downloadFiles(String fileUrl, String fileName) async {
  // print("inside downloadFiles");
  var isPersist = await Permission.storage.request().isGranted;
  var isPersistNew = await Permission.storage.request().isGranted;

  if (Platform.isAndroid) {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if(int.parse(androidInfo.version.release) > 12){
      if (
      await Permission.photos.status.isDenied
      ) {
        toast(msg: "Storage permission needed for downloads.");
      }
      final photos = await Permission.photos.request().isGranted;
      isPersist = photos ;// && videos && audio;
    }
  }
  // print("ispersist new $isPersistNew");
  // print("isPersist $isPersist");
  if (isPersist || isPersistNew) {
    var _progress = 0.0;
   // callback(true, '0%', index);
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    // final http.Response tempResponse = await http.get(Uri.parse(fileUrl));
    // var appDocumentsDirectory = Platform.isAndroid ?
    // await getExternalStorageDirectory() : await getApplicationDocumentsDirectory();
    // final File tempFile = File('${appDocumentsDirectory!.path}/$fileName');
    // await tempFile.writeAsBytes(tempResponse.bodyBytes);
    var appDocumentsDirectory = Platform.isAndroid ?
    await getExternalStorageDirectory() : await getApplicationDocumentsDirectory();
    final File tempFile = File('${appDocumentsDirectory!.path}/$fileName');
    tempDownload(fileUrl, fileName);

    final http.Client client = http.Client();
    final http.Request request = http.Request('GET', Uri.parse(fileUrl));
    final http.StreamedResponse response = await client.send(request);

    var extDir;
    if (Platform.isIOS) {
      extDir = await getApplicationDocumentsDirectory();
    } else {
      extDir = Directory('/storage/emulated/0/Download');
    }
    // final String fileName = widget.fileUrl.split('/').last;
    final File file = File('${extDir.path}/$fileName');
    final IOSink sink = file.openWrite();

    int receivedBytes = 0;
    int totalBytes = response.contentLength ?? 0;

    await response.stream.listen((List<int> chunk) {
      receivedBytes += chunk.length;
      sink.add(chunk);
      _progress = (receivedBytes / totalBytes) * 100;
      //callback(true, '${_progress.round()}%', index);
    }).asFuture().then((_) async {
      await sink.flush();
      await sink.close();

      // callback(false, '', index);

      var saveFile = '${tempFile!.path}';
      // Show notification after download
      if (Platform.isIOS) {
        toast(msg: "Download Completed! Check your iPhone storage.", time: 10);
        final bool? result = await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

        if (result!) {
          Future.delayed(Duration(seconds: 1),() async {
            await OpenFile.open(saveFile);
          });
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();
          showNotification(fileName, saveFile);
        }
      }
      else {
        String path='';
        path=saveFile;
        print("path $path");
        Future.delayed(Duration(seconds: 1),() async {
          await OpenFile.open(path);
        });

        toast(msg: "Download Completed! Check your Download folder.", time: 10);
        if (await requestPermission(Permission.notification)) {
          print('================${saveFile}================');
          showNotification(fileName, saveFile);
          // callback(false, '', index);
        }
      } // Pass the file path as payload

      // TODO: Handle success or error
    }).catchError((error) {
      // Handle error
      print('Error during download: $error');
      // TODO: Handle error
    }).whenComplete(() {
      // Close the HTTP client
      print('File Downloaded!');

      client.close();
    });
  }
  else{
    print("downloadFiles $isPersist");
  }
}

tempDownload(String fileUrl, String fileName) async {
  final http.Response tempResponse = await http.get(Uri.parse(fileUrl));
  var appDocumentsDirectory = Platform.isAndroid ?
  await getExternalStorageDirectory() : await getApplicationDocumentsDirectory();
  final File tempFile = File('${appDocumentsDirectory!.path}/$fileName');
  await tempFile.writeAsBytes(tempResponse.bodyBytes);
}
