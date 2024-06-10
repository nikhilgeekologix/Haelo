import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:haelo_flutter/constants.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:haelo_flutter/locators.dart' as di;

// String name = "";
// String path = "";

showNotification(String filename, String filePath) async {
  late SharedPreferences pref;
  pref = di.locator();
  // name = filename;
  // path = filePath;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@drawable/notification_icon');

  const DarwinInitializationSettings initializationSettingsIOS =
  DarwinInitializationSettings(
    requestSoundPermission: false,
    requestBadgePermission: false,
    requestAlertPermission: false,
  );
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: abc,
      onDidReceiveBackgroundNotificationResponse: zx);

  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high channel',
    'Very important notification!!',
    description: 'the first notification',
    importance: Importance.max,
      playSound: false,
  );

  DateTime dateTime = DateTime.now();
  print("////// show notification sound ${pref.getBool(Constants.notification_sound)}");

  await flutterLocalNotificationsPlugin.show(
      dateTime.second,
      '${filePath.split("/").last}',
      'Downloaded',
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: "@drawable/notification_icon",
            playSound: pref.getBool(Constants.notification_sound)!=null && pref.getBool(Constants.notification_sound)==true?true:false
        ),
      ),
      payload: filePath);
}

Future<void> abc(NotificationResponse resonse) async {
  //print('name $name path $path');
  print("abc notificaiton resonse ${resonse.payload}");
  //String pathPrefix = "/storage/emulated/0/Download/Downloads/";

  if (resonse.payload != null) {
    //  String file = pathPrefix + resonse.payload!.split("/").last;
    print("is file exist ${File(resonse.payload!).existsSync()}");

    if (File(resonse.payload!).existsSync()) {
      //  print("file $file ");
      final result = await OpenFile.open(resonse.payload)
          .then((value) => print("after opne ${value.message}"));
    }
  }
}

void zx(NotificationResponse resonse) {
  print("zx notificaiton resonse ${resonse}");
}
