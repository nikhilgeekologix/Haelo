import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:haelo_flutter/constants.dart';
import 'package:haelo_flutter/features/cases/presentation/screens/casedetails.dart';
import 'package:haelo_flutter/features/task/presentation/screens/taskdetails.dart';
import 'package:haelo_flutter/features/userboard/presentation/screens/login.dart';
import 'package:haelo_flutter/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:haelo_flutter/locators.dart' as di;

ValueNotifier<int> counter = ValueNotifier(0);

class FCMNotificationService {
  StreamSubscription? _tokenSubscription;
  StreamSubscription? _messageTapSubscription;
  StreamSubscription? _foregroundMessageSubscription;
  late SharedPreferences pref;

  /// Create a [AndroidNotificationChannel] for heads up notifications
  late AndroidNotificationChannel channel;

  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  // Android resource asset name which used for notification icon
  final String notificationIconName = '@mipmap/ic_launcher';

  Future<void> init() async {
    print("in fcm init");
      await _setupNotifications();
      FirebaseMessaging.onMessage.listen((message) async {
        print("pushmessage" + message.toString());
      });
      print("before background");
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

  }

  Future<void> _setupNotifications() async {
    await Firebase.initializeApp(
      //options: DefaultFirebaseOptions.currentPlatform,
    );
    final instance = FirebaseMessaging.instance;
    await di.init();
    pref = di.locator();

    if (Platform.isAndroid) {
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      // Initialize settings for only Android as FlutterLocalNotificationsPlugin
      // used for android platform only (For forground)
      final initializationSettingsAndroid =
      AndroidInitializationSettings(notificationIconName);
      final initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
      );

      //onSelectNotification: To handle foreground notification tap callback
      print("before payload");
      await flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onDidReceiveNotificationResponse: (NotificationResponse details) {
            print("click on notification ");
            print("click on details ${details.notificationResponseType.name} ");
            print("click on payload ${details.payload} ");
            print("click on input ${details.input} ");
            print("click on actionId ${details.actionId} ");
            print("click on id ${details.id} ");
            if (details.payload != null) {
              final _remoteMessage =
              RemoteMessage(data: (jsonDecode(details.payload!) as Map).cast());
              print("remotemsg $_remoteMessage");
              print("data/// ${_remoteMessage!.data['data']}");

              final flag=jsonDecode(_remoteMessage!.data['data']);

              print("data/3 ${flag['notification_flag']}");
              print("data/3 ${pref.getBool(Constants.IS_LOGIN)!}");


              if(pref.getBool(Constants.IS_LOGIN) != null &&
                  pref.getBool(Constants.IS_LOGIN) !) {
                //for bottombar (dashboard) route
                if(flag['notification_flag']==3) {
                  navigatorKey.currentState!.pushNamed('/bottomBar');
                }

                //for task details
                if(flag['notification_flag']==1) {
                  navigatorKey.currentState!.push(MaterialPageRoute(builder: ((context) =>  TaskDetails(flag['id']))));
                }
                //for case history
                if(flag['notification_flag']==2) {
                  navigatorKey.currentState!.push(MaterialPageRoute(builder:
                  ((context) =>  CaseDetails(
                    caseId:  flag['id'],
                    index: 2,
                  ))));
                }
                //for paper details
                if(flag['notification_flag']==4) {
                  navigatorKey.currentState!.push(MaterialPageRoute(builder:
                  ((context) =>  CaseDetails(
                    caseId:  flag['id'],
                    index: 3,
                  ))));
                }
              }
              else{// by default => login route
                navigatorKey.currentState!.push(MaterialPageRoute(builder: ((context) => Login())));
              }
            }
          },
         );

      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description:
        'This channel is used for important notifications.', // description
        importance: Importance.high,
      );

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      // Android-Forground: Create and display notification on tray
      _foregroundMessageSubscription =
          FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
            final RemoteNotification? notification = message.notification;
            final AndroidNotification? android = message.notification?.android;
            print("inside forgroundsubs");

            final data = message.data;
            print("data type ${data['type']}");
            print("//////////////data type ${notification}");

            if (notification != null && android != null) {
              flutterLocalNotificationsPlugin.show(
                  notification.hashCode,
                  notification.title,
                  notification.body,
                  NotificationDetails(
                    android: AndroidNotificationDetails(
                      channel.id,
                      channel.name,
                      channelDescription: channel.description,
                     // icon: notificationIconName,
                    ),
                  ),
                  payload: jsonEncode(message.data));
            }
          });
    }

    await instance.requestPermission();

    await instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    final token = await instance.getToken();
    if (token != null) {
      print("fcmtoken $token");
    }

    final message = await instance.getInitialMessage();
    if (message != null) {
      _messageTapHandler(message);
    }
    _messageTapSubscription =
        FirebaseMessaging.onMessageOpenedApp.listen(_messageTapHandler);
  }


  void _messageTapHandler(RemoteMessage message) {
    print('inside msg tap handler');
      final messagePayload = message.data;


      final messageActionType = messagePayload['notification_type'];


  }


  void dispose() {
    _tokenSubscription?.cancel();
    _messageTapSubscription?.cancel();
    _foregroundMessageSubscription?.cancel();
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    print('message from background handler');
    print("Handling a background message: ${message.messageId}");

    // If this is null, then this handler method is called
    final RemoteNotification? notification = message.notification;
    final AndroidNotification? android = message.notification?.android;

    print("inside background ${notification!.body}");
    print("inside background");


    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: notificationIconName,
            ),
          ),
          payload: jsonEncode(message.data));
    }
  }
}
