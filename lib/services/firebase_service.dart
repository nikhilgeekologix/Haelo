import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/constants.dart';
import 'package:haelo_flutter/core/utils/functions.dart';
import 'package:haelo_flutter/core/utils/save_file.dart';
import 'package:haelo_flutter/core/utils/show_notification.dart';
import 'package:haelo_flutter/features/alert/data/model/auto_download_model.dart';
import 'package:haelo_flutter/features/cases/presentation/screens/casedetails.dart';
import 'package:haelo_flutter/features/task/presentation/screens/taskdetails.dart';
import 'package:haelo_flutter/features/userboard/presentation/screens/login.dart';
import 'package:haelo_flutter/locators.dart' as di;
import 'package:haelo_flutter/urls.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../locators.dart';
import '../main.dart';
import 'calendar_client.dart';

//  var _scopes =  [CalendarApi.calendarScope];
// // Function to authenticate the user with their Google account.
// Future<auth.AutoRefreshingAuthClient> _getClient() async {
//   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//   final auth.AutoRefreshingAuthClient authClient =
//   await googleUser;
//   return authClient;
// }
//
// // Function to add a new event to the user's Google Calendar.
// Future<void> _addEventToCalendar(
//     String title,
//     DateTime start,
//     DateTime end,
//     String description,
//     ) async {
//   final auth.AutoRefreshingAuthClient client = await _getClient();
//
//   final calendar.Event event = calendar.Event()
//     ..summary = title
//     ..description = description
//     ..start = calendar.EventDateTime()
//     ..end = calendar.EventDateTime();
//
//   final calendar.CalendarApi calendarApi = calendar.CalendarApi(client);
//   await calendarApi.events.insert(event, 'primary');
// }

class FirebaseService {
  late SharedPreferences pref;

  startFirebaseNotification() async {
    // await di.init();
    pref = di.locator();
    await Firebase.initializeApp(
        //options: DefaultFirebaseOptions.currentPlatform,
        );
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    print(
        "////// fcm notification sound ${pref.getBool(Constants.notification_sound)}");

    // TODO: Request permission
    final messaging = FirebaseMessaging.instance;

    // Web/iOS app users need to grant permission to receive messages
    final settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: pref.getBool(Constants.notification_sound) != null &&
              pref.getBool(Constants.notification_sound) == true
          ? true
          : false,
    );

    if (kDebugMode) {
      print('Permission granted: ${settings.authorizationStatus}');
    }

    // TODO: replace with your own VAPID key
    const vapidKey = "<YOUR_PUBLIC_VAPID_KEY_HERE>";

    // TODO: Register with FCM
    // use the registration token to send messages to users from your trusted server environment
    String? token;

    // if (DefaultFirebaseOptions.currentPlatform == DefaultFirebaseOptions.web) {
    //   token = await messaging.getToken(
    //     vapidKey: vapidKey,
    //   );
    // } else {
    token = await messaging.getToken();
    // }

    // if (kDebugMode) {
    print('Registration Token=$token');
    // }

    // TODO: Set up foreground message handler
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   if (kDebugMode) {
    //     print('Handling a foreground message: ${message.messageId}');
    //     print('Message data: ${message.data}');
    //     print('Message notification: ${message.notification?.title}');
    //     print('Message notification: ${message.notification?.body}');
    //   }
    //
    //   //  _messageStreamController.sink.add(message);
    // });

    enableIOSNotifications();
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    print("fcm>> initialMessage $initialMessage");

    await registerNotificationListeners(pref);

    // TODO: Set up background message handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  Future<void> subscribeToTopic(String topic) async {
    try {
      await FirebaseMessaging.instance.subscribeToTopic(topic);
      print('Subscribed to topic: $topic');
    } catch (e) {
      print('Error subscribing to topic: $e');
    }
  }

  Future<void> unsubscribeToTopic(String topic) async {
    try {
      await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
      print('unsubscribeToTopic to topic: $topic');
    } catch (e) {
      print('Error subscribing to topic: $e');
    }
  }
}

// TODO: Define the background message handler
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Background message received: $message");
  // late SharedPreferences pref;

  RemoteNotification abc = message.notification!;
  print("fcm>> abc ${abc}");

  print("remotemsg bgmap ${message.notification!.toMap()}");

  await Firebase.initializeApp();
  //print("getis//// ${GetIt.I.isRegistered()}");

  // di.locator=GetIt.instance;
  // di.locator.registerLazySingleton<SharedPreferences>(
  //       () => pref);
  SharedPreferences pref = await SharedPreferences.getInstance();
  // );
  // if(!GetIt.I.isRegistered()){
  // print("locator/// ${di.init()}");
  // if (!GetIt.instance.isRegistered<T>()) {
  //   GetIt.instance.registerLazySingleton<T>(() => const T());}
  //    await di.init().then((value) => pref = di.locator());
  // pref = di.locator();
  // }
  final AndroidNotificationChannel channel = androidNotificationChannel(pref);
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@drawable/notification_icon');
  const DarwinInitializationSettings iOSSettings = DarwinInitializationSettings(
    requestSoundPermission: false,
    requestBadgePermission: false,
    requestAlertPermission: false,
  );
  const InitializationSettings initSettings =
      InitializationSettings(android: androidSettings, iOS: iOSSettings);
  flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (NotificationResponse details) {
      print("fcm>> bg onDidReceiveNotificationResponse ");
    },
    onDidReceiveBackgroundNotificationResponse: zx,
  );

  final remoteMessage = RemoteMessage(data: ((message.data) as Map).cast());

  // print("remotemsg bghandle $remoteMessage");
  final data = jsonDecode(remoteMessage!.data['data']);

  // final RemoteNotification? notification = message!.notification;
  // final AndroidNotification? android = message.notification?.android;

  print("fcm>> notification // ${data}");
  print("fcm>> notification tt// ${message.data['message_title']}");
  print("fcm>> notification flag ${data['notification_flag']}");

  //for auto download
  if (data['notification_flag'] == 6) {
    try {
      downloadPdf();
    } catch (e) {
      print("Error in downloadPdf(): $e");
    }
    /*  if (pref.getBool(Constants.auto_download) != null &&
        pref.getBool(Constants.auto_download)!) {

    }*/
  } else if (data['notification_flag'] == 5) {
    if (pref.getBool(Constants.calendar_event_add) != null &&
        pref.getBool(Constants.calendar_event_add)!) {
      if (data['start_time'] != null && data['mycases'] != null) {
        String startTime = data['start_time'];
        List events = data['mycases'];
        if (events.isNotEmpty) {
          for (int i = 0; i < events.length; i++) {
            CalendarClient().saveTheDate(
              startTime,
              events[i]['lawyer_name'],
              events[i]['msg'],
            );
          }
        }
      }
    }
  }
}

// /// this is only for testing, there is no case handle for flag > 3
// else if (data['notification_flag'] == 3) {
//   downloadPdf();
//   // CalendarClient().saveTheDate("2023-06-24 20:30:00","Hello Rahul","Background");
// }

// else {
//   await flutterLocalNotificationsPlugin.show(
//       DateTime.now().millisecond,
//       message.data['message_title'],
//       // remoteMessage!.data['message_title'],
//       "",
//       // DateTime.now().second,
//       // 'hello rahul',
//       // 'Downloaded',
//       NotificationDetails(
//         android: AndroidNotificationDetails(channel.id, channel.name,
//             channelDescription: channel.description,
//             icon: "@drawable/notification_icon",
//             styleInformation: BigTextStyleInformation(
//               data["msg"],
//               contentTitle:  message.data['message_title'],
//               summaryText: ""
//             ),
//             playSound: pref.getBool(Constants.notification_sound) != null &&
//                     pref.getBool(Constants.notification_sound) == true
//                 ? true
//                 : false),
//       ),
//       payload: jsonEncode(message.data));
// }

// if (kDebugMode) {
//   print("Handling a background message: ${message.messageId}");
//   print('Message data: ${message.data}');
//   print('bgMessage notification: ${message.notification?.title}');
//   print('bgMessage notification: ${message.notification?.body}');
// }
Future<void> registerNotificationListeners(pref) async {
  print("fcm>> hii/// from registerNotificationListeners");
  final AndroidNotificationChannel channel = androidNotificationChannel(pref);
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@drawable/notification_icon');
  const DarwinInitializationSettings iOSSettings = DarwinInitializationSettings(
    requestSoundPermission: false,
    requestBadgePermission: false,
    requestAlertPermission: false,
  );
  const InitializationSettings initSettings =
      InitializationSettings(android: androidSettings, iOS: iOSSettings);
  flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (NotificationResponse details) {
      if (details.payload != null) {
        final _remoteMessage =
            RemoteMessage(data: (jsonDecode(details.payload!) as Map).cast());
        print("fcm>> remotemsg $_remoteMessage");
        print("fcm>> data/// ${_remoteMessage!.data['data']}");

        final flag = jsonDecode(_remoteMessage!.data['data']);

        print("fcm>> data/3 ${flag['notification_flag']}");
        print("fcm>> data/3 ${pref.getBool(Constants.IS_LOGIN)!}");

        if (pref.getBool(Constants.IS_LOGIN) != null &&
            pref.getBool(Constants.IS_LOGIN)!) {
          //for bottombar (dashboard) route
          if (flag['notification_flag'] == 3) {
            navigatorKey.currentState!.pushNamed('/bottomBar');
          }

          //for task details
          if (flag['notification_flag'] == 1) {
            if (isPrime(pref) &&
                (planName(pref) == Constants.goldPlan ||
                    planName(pref) == Constants.platinumPlan)) {
              navigatorKey.currentState!.push(MaterialPageRoute(
                  builder: ((context) => TaskDetails(flag['id']))));
            }
          }
          //for case history
          if (flag['notification_flag'] == 2) {
            if (isPrime(pref) &&
                (planName(pref) == Constants.goldPlan ||
                    planName(pref) == Constants.platinumPlan)) {
              navigatorKey.currentState!.push(MaterialPageRoute(
                  builder: ((context) => CaseDetails(
                        caseId: flag['id'],
                        index: 2,
                      ))));
            }
          }
          //for paper details
          if (flag['notification_flag'] == 4) {
            if (isPrime(pref) &&
                (planName(pref) == Constants.goldPlan ||
                    planName(pref) == Constants.platinumPlan)) {
              navigatorKey.currentState!.push(MaterialPageRoute(
                  builder: ((context) => CaseDetails(
                        caseId: flag['id'],
                        index: 3,
                      ))));
            }
          }
        } else {
          // by default => login route
          navigatorKey.currentState!
              .push(MaterialPageRoute(builder: ((context) => Login())));
        }
      }
    },
    onDidReceiveBackgroundNotificationResponse: zx,
  );
// onMessage is called when the app is in foreground and a notification is received
  FirebaseMessaging.onMessage.listen((RemoteMessage? message) async {
    print("fcm>> hii/// from onMessage ${message!.data}");
    print("fcm>> hii/// from onMessage ${message!.notification}");

    // homeController.getHomeData(
    //   withLoading: false,
    // );
    // consoleLog(message, key: 'firebase_message');
    final RemoteNotification? notification = message!.notification;
    final AndroidNotification? android = message.notification?.android;
// If `onMessage` is triggered with a notification, construct our own
    // local notification to show to users using the created channel.
    print("fcm>> hii/// notification $notification //androud $android");

    final remoteMessage = RemoteMessage(data: ((message!.data!) as Map).cast());
    final data = jsonDecode(remoteMessage.data['data']);

    print("fcm>> notification data ${data}");
    print("fcm>> notification flag ${data['notification_flag']}");

    //for auto download
    if (data['notification_flag'] == 6) {
      try {
        downloadPdf();
      } catch (e) {
        print("Error in downloadPdf(): $e");
      }
      /* if (pref.getBool(Constants.auto_download) != null &&
          pref.getBool(Constants.auto_download)!) {
      }*/
    } else if (data['notification_flag'] == 5) {
      if (pref.getBool(Constants.calendar_event_add) != null &&
          pref.getBool(Constants.calendar_event_add)!) {
        if (data['start_time'] != null && data['mycases'] != null) {
          String startTime = data['start_time'];
          List events = data['mycases'];
          if (events.isNotEmpty) {
            for (int i = 0; i < events.length; i++) {
              CalendarClient().saveTheDate(
                startTime,
                events[i]['lawyer_name'],
                events[i]['msg'],
              );
            }
          }
        }
      }
    }
    // else if (data['notification_flag'] == 3) {
    //   CalendarClient().saveTheDate("2023-06-24 20:30:00","Hello Rahul","Realme 6");
    // }
    else {
      //if (notification != null && android != null) {
      await flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        remoteMessage.data['message_title'],
        "",
        NotificationDetails(
          android: AndroidNotificationDetails(channel.id, channel.name,
              channelDescription: channel.description,
              icon: "@drawable/notification_icon",
              styleInformation: BigTextStyleInformation(
                  // _remoteMessage!.data['message_title'],
                  data["msg"],
                  contentTitle: remoteMessage!.data['message_title'],
                  summaryText: ""),
              playSound: pref.getBool(Constants.notification_sound) != null &&
                      pref.getBool(Constants.notification_sound) == true
                  ? true
                  : false),
        ),
        payload: jsonEncode(message.data),
      );
      //}
    }

    // print('fgMessage notification: ${message.notification?.title}');
    // print('fgMessage notification: ${message.notification?.body}');
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
    print("fcm>> onmessageopeedn app ");
    print("fcm>> onmessageopeedn msg ${message} ");

    if (message != null) {
      final _remoteMessage = message;
      print("fcm>> remotemsg $_remoteMessage");
      print("fcm>> data/// ${_remoteMessage!.data['data']}");

      final flag = jsonDecode(_remoteMessage!.data['data']);

      print("fcm>> data/3 ${flag['notification_flag']}");
      print("fcm>> data/3 ${pref.getBool(Constants.IS_LOGIN)!}");

      if (pref.getBool(Constants.IS_LOGIN) != null &&
          pref.getBool(Constants.IS_LOGIN)!) {
        //for bottombar (dashboard) route
        if (flag['notification_flag'] == 3) {
          navigatorKey.currentState!.pushNamed('/bottomBar');
        }

        //for task details
        if (flag['notification_flag'] == 1) {
          if (isPrime(pref) &&
              (planName(pref) == Constants.goldPlan ||
                  planName(pref) == Constants.platinumPlan))
            navigatorKey.currentState!.push(MaterialPageRoute(
                builder: ((context) => TaskDetails(flag['id']))));
        }
        //for case history
        if (flag['notification_flag'] == 2) {
          if (isPrime(pref) &&
              (planName(pref) == Constants.goldPlan ||
                  planName(pref) == Constants.platinumPlan))
            navigatorKey.currentState!.push(MaterialPageRoute(
                builder: ((context) => CaseDetails(
                      caseId: flag['id'],
                      index: 2,
                    ))));
        }
        //for paper details
        if (flag['notification_flag'] == 4) {
          if (isPrime(pref) &&
              (planName(pref) == Constants.goldPlan ||
                  planName(pref) == Constants.platinumPlan))
            navigatorKey.currentState!.push(MaterialPageRoute(
                builder: ((context) => CaseDetails(
                      caseId: flag['id'],
                      index: 3,
                    ))));
        }
      } else {
        // by default => login route
        navigatorKey.currentState!
            .push(MaterialPageRoute(builder: ((context) => Login())));
      }
    }
  });
}

Future<void> enableIOSNotifications() async {
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    //sound: pref.getBool(Constants.notification_sound)!=null && pref.getBool(Constants.notification_sound)==true?true:false,
  );
}

AndroidNotificationChannel androidNotificationChannel(pref) {
  print("hii/// from androidNotificationChannel");
  return AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.max,
      playSound: pref.getBool(Constants.notification_sound) != null &&
              pref.getBool(Constants.notification_sound) == true
          ? true
          : false);
}

void zx(NotificationResponse resonse) {
  print("fcm>> zx notificaiton resonse ${resonse}");
}

Future<void> downloadPdf() async {
  print("Before SharedPreferences");
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print("After SharedPreferences");
  print("fcm>> call auto download api here");

  var headers = {
    'Authorization': 'Bearer ${prefs.getString(Constants.ACCESS_TOKEN)}',
    'Version': "1.0"
  };

  try {
    http.Response response = await http.Client().post(
      Uri.parse(
        // "https://haeloapp.in/staging/api/" + Urls.PDF_DOWNLOAD,
        Urls.BASE_URL + Urls.PDF_DOWNLOAD_NOTIFICATION,
      ),
      body: {},
      headers: headers,
    );
    //print("get response body ${response.body}");
    // print("get response url ${response.request!.url}");
    // print("get response head ${response.request!.headers}");
    // print("get response head ${response}");

    var responsed = (json.decode(response.body));
    print("responsed $responsed");
    // AutoDownloadModel.fromJson(responsed);
    if (responsed["result"] == 1) {
      if (responsed['data']['pdf_url'] != null &&
          responsed['data']['pdf_url'].toString().isNotEmpty) {
        print("url fetched");
        downloadCallback(responsed['data']['pdf_url'].toString());
      }
    }
    // return _fetchResponse(response);
  } catch (e) {
    print("Error in downloadPdf $e");
    // throw ServerException('Failed to get data');
  }
}

Future<void> downloadCallback(String url) async {
  var extDir;
  if (Platform.isIOS) {
    extDir = await getApplicationDocumentsDirectory();
  } else {
    extDir = Directory('/storage/emulated/0/Download');
  }
  DateTime now = DateTime.now();
  File saveFile =
      File(extDir!.path + "/_${now.day}${now.second}_${url.split("/").last}");

  await Dio()
      .download(
    url.toString(),
    saveFile.path,
  )
      .then((value) async {
    if (await requestPermission(Permission.notification)) {
      showNotification(saveFile.path, saveFile.path);
    }
  });
  print("download complete toast");
}
