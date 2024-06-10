// import 'dart:convert';
//
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// // import "package:mistry_store/locator.dart" as di;
//
// class FirebaseMessagingService {
//   FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//
//   FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//   // late SharedPreferences pref;
//
//   Future initialize() async {
//     // await Firebase.initializeApp(
//     //   //options: DefaultFirebaseOptions.currentPlatform,
//     // );
//     FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
//     FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     // pref = di.locator();
//     _firebaseMessaging.setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//     _firebaseMessaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//     var initializationSettingsAndroid =
//     const AndroidInitializationSettings('@mipmap/ic_launcher');
//     const DarwinInitializationSettings iOSSettings =
//     DarwinInitializationSettings();
//     var initializationSettings = InitializationSettings(
//         android: initializationSettingsAndroid, iOS: iOSSettings);
//
//     print("onAPP hii/// 7-2");
//     _flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//     );
//
//     void showNotification(RemoteMessage message) async {
//       var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
//         'channelId',
//         'channelName',
//         channelDescription: 'channelDescription',
//         importance: Importance.max,
//         priority: Priority.high,
//         icon: '@mipmap/ic_launcher',
//         playSound: true,
//       );
//
//       var platformChannelSpecifics = NotificationDetails(
//         android: androidPlatformChannelSpecifics,
//       );
//
//       await _flutterLocalNotificationsPlugin.show(
//         0,
//         message.notification?.title,
//         message.notification?.body,
//         platformChannelSpecifics,
//         payload: message.data.toString(),
//       );
//     }
//
//     String? token;
//
//     token = await _firebaseMessaging.getToken();
//
//     // if (kDebugMode) {
//     //   print('Registration Token=$token');
//     // }
//     // sgtl.fcm_token = token.toString();
//     print('Registration Token=$token');
//     enableIOSNotifications();
//     RemoteMessage? initialMessage =
//     await FirebaseMessaging.instance.getInitialMessage();
//     if (initialMessage != null) {
//       final _remoteMessage =
//       RemoteMessage(data: ((initialMessage!.data!)).cast());
//
//       // final data = NotificationModel.fromJson(_remoteMessage!.data);
//       final data = (_remoteMessage!.data);
//
//       // print("initialMessage notification flag ${data.payloadType}");
//
//       print("initialMessage remotemsg $_remoteMessage");
//
//       // print("initialMessage data/3 ${data.payloadType}");
//       // sgtl.byNotification = true;
//
//       Future.delayed(const Duration(seconds: 5), () async {
//         if (pref.getBool('loggedIn') == true) {
//           print("initialMessage payload ${data["notificationFlag"]}");
//           if (data["notificationFlag"] == "33") {
//             // navigatorKey.currentState!.push(MaterialPageRoute(
//             //     builder: ((context) => const StockAnalysis())));
//           }
//
//           if (data["notificationFlag"] == "2") {
//
//           }
//           if (data["notificationFlag"] == "3") {
//
//           }
//
//           if (data["notificationFlag"] == "4") {
//             // navigatorKey.currentState!.pushAndRemoveUntil(
//             //     MaterialPageRoute(
//             //         builder: ((context) => Dashboard(
//             //               index: 4,
//             //               orderTabIndex: 0,
//             //             ))),
//             //     (Route<dynamic> route) => false);
//           }
//           if (data["notificationFlag"] == "5") {
//             // navigatorKey.currentState!.push(
//             //     MaterialPageRoute(builder: ((context) => PointsEarned())));
//           }
//         } else {}
//       });
//
//       print("Initial message: ${initialMessage.notification?.body}");
//     }
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       final _remoteMessage = RemoteMessage(data: ((message.data)).cast());
//       if (_remoteMessage.data['notification_flag'] != null) {
//         String payloadType = _remoteMessage.data['notification_flag'];
//
//         String orderEstId = _remoteMessage.data['stock_symbol'];
//
//         if (pref.getBool('loggedIn') == true) {
//           if (payloadType == "33") {
//             // navigatorKey.currentState!.push(MaterialPageRoute(
//             //     builder: ((context) => const StockAnalysis())));
//           }
//           if (payloadType == "2") {
//             // navigatorKey.currentState!.push(
//             //   MaterialPageRoute(
//             //     builder: ((context) => OrderDetails(
//             //           true,
//             //           orderEstId.toString(),
//             //           "ESTIMATE",
//             //           projectsList: projectsList,
//             //           itemCallback: () {},
//             //         )),
//             //   ),
//             // );
//           }
//           if (payloadType == "3") {
//             // print("RemoteMessage onDidReceiveNotificationResponse");
//             // navigatorKey.currentState!.push(MaterialPageRoute(
//             //     builder: ((context) =>
//             //         OrderHistoryDetails(orderEstId.toString()))));
//           }
//           if (payloadType == "4") {
//             // navigatorKey.currentState!.pushAndRemoveUntil(
//             //     MaterialPageRoute(
//             //         builder: ((context) => Dashboard(
//             //               index: 4,
//             //               orderTabIndex: 0,
//             //             ))),
//             //     (Route<dynamic> route) => false);
//           }
//           if (payloadType == "5") {
//             // navigatorKey.currentState!.push(
//             //     MaterialPageRoute(builder: ((context) => PointsEarned())));
//           }
//         } else {
//           // by default => login route
//           // navigatorKey.currentState!.push(
//           //     MaterialPageRoute(builder: ((context) => OnbaordingScreen())));
//         }
//       }
//     });
//
//     await registerNotificationListeners(
//       // pref,
//     );
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       // Handle incoming messages when the app is in the foreground
//       ///first
//       showNotification(message);
//       print('onMessage Received message: onMessage');
//       print('onMessage Received message: ${message.notification?.title}');
//
//       print("onMessage invoice_or_est ${message.data['invoice_or_est']}");
//       print("onMessage payload_type ${message.data['payload_type']}");
//       // print('Received message: ${message.notification?.apple!.imageUrl}');
//     });
//
//     // TODO: Set up background message handler
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   }
// }
//
// // TODO: Define the background message handler
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // late SharedPreferences pref;
//   print("remotemsg bg ${message.notification}");
//   if (Firebase.apps.isEmpty) {
//     await Firebase.initializeApp();
//   }
//   // await Firebase.initializeApp();
//   SharedPreferences pref = await SharedPreferences.getInstance();
//   // await di.init().then((value) => pref = di.locator());
//   final AndroidNotificationChannel channel = androidNotificationChannel();
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//       AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);
//   const AndroidInitializationSettings androidSettings =
//   AndroidInitializationSettings('@mipmap/ic_launcher');
//   const DarwinInitializationSettings iOSSettings = DarwinInitializationSettings(
//     requestSoundPermission: false,
//     requestBadgePermission: false,
//     requestAlertPermission: false,
//   );
//   const InitializationSettings initSettings = InitializationSettings(
//     android: androidSettings,
//     iOS: iOSSettings,
//   );
//   print("onAPP hii/// 7-1");
//   flutterLocalNotificationsPlugin.initialize(
//     initSettings,
//     onDidReceiveNotificationResponse: (NotificationResponse details) {
//       if (details.payload != null) {
//         print("background Payload: ${details.payload}");
//         print("background Encoded: ${jsonEncode(details.payload)}");
//         print("background Decoded: ${jsonDecode(jsonEncode(details.payload))}");
//
//         final splitNames = details.payload!.split(',');
//         print(splitNames);
//         int indexOfPayload = splitNames.indexWhere(
//                 (element) => element.toString().contains("notification_flag"));
//         int indexOfId = splitNames.indexWhere(
//                 (element) => element.toString().contains("stock_symbol"));
//         String payloadType =
//         splitNames[indexOfPayload].split(": ")[1].split('"')[0];
//         String orderEstId = splitNames[indexOfId].split(": ")[1].split('"')[0];
//
//         if (pref.getBool('loggedIn') == true) {
//           if (payloadType == "33") {
//             // navigatorKey.currentState!.push(MaterialPageRoute(
//             //     builder: ((context) => const StockAnalysis())));
//           }
//           if (payloadType == "2") {
//             // navigatorKey.currentState!.push(
//             //   MaterialPageRoute(
//             //     builder: ((context) => OrderDetails(
//             //           true,
//             //           orderEstId.toString(),
//             //           "ESTIMATE",
//             //           projectsList: projectsList,
//             //           itemCallback: () {},
//             //         )),
//             //   ),
//             // );
//           }
//           if (payloadType == "3") {
//             // print("background onDidReceiveNotificationResponse");
//             // navigatorKey.currentState!.push(MaterialPageRoute(
//             //     builder: ((context) =>
//             //         OrderHistoryDetails(orderEstId.toString()))));
//           }
//           if (payloadType == "4") {
//             // navigatorKey.currentState!.pushAndRemoveUntil(
//             //     MaterialPageRoute(
//             //         builder: ((context) => Dashboard(
//             //               index: 4,
//             //               orderTabIndex: 0,
//             //             ))),
//             //     (Route<dynamic> route) => false);
//           }
//           if (payloadType == "5") {
//             // navigatorKey.currentState!.push(
//             //     MaterialPageRoute(builder: ((context) => PointsEarned())));
//           }
//         } else {
//           // by default => login route
//           // navigatorKey.currentState!.push(
//           //     MaterialPageRoute(builder: ((context) => OnbaordingScreen())));
//         }
//       }
//     },
//     onDidReceiveBackgroundNotificationResponse: (NotificationResponse details) {
//       if (details.payload != null) {
//         print("Payload: ${details.payload}");
//         print("Encoded: ${jsonEncode(details.payload)}");
//         print("Decoded: ${jsonDecode(jsonEncode(details.payload))}");
//
//         final splitNames = details.payload!.split(',');
//         print(splitNames);
//         int indexOfPayload = splitNames.indexWhere(
//                 (element) => element.toString().contains("notification_flag"));
//         int indexOfId = splitNames.indexWhere(
//                 (element) => element.toString().contains("stock_symbol"));
//         String payloadType =
//         splitNames[indexOfPayload].split(": ")[1].split('"')[0];
//         String orderEstId = splitNames[indexOfId].split(": ")[1].split('"')[0];
//
//         if (pref.getBool('loggedIn') == true) {
//           if (payloadType == "33") {
//             // navigatorKey.currentState!.push(MaterialPageRoute(
//             //     builder: ((context) => const StockAnalysis())));
//           }
//
//           if (payloadType == "2") {
//             // navigatorKey.currentState!.push(
//             //   MaterialPageRoute(
//             //     builder: ((context) => OrderDetails(
//             //           true,
//             //           orderEstId.toString(),
//             //           "ESTIMATE",
//             //           projectsList: projectsList,
//             //           itemCallback: () {},
//             //         )),
//             //   ),
//             // );
//           }
//           if (payloadType == "3") {
//             // print("onDidReceiveNotificationResponse");
//             // navigatorKey.currentState!.push(MaterialPageRoute(
//             //     builder: ((context) =>
//             //         OrderHistoryDetails(orderEstId.toString()))));
//           }
//           if (payloadType == "4") {
//             // navigatorKey.currentState!.pushAndRemoveUntil(
//             //     MaterialPageRoute(
//             //         builder: ((context) => Dashboard(
//             //               index: 4,
//             //               orderTabIndex: 0,
//             //             ))),
//             //     (Route<dynamic> route) => false);
//           }
//           if (payloadType == "5") {
//             // navigatorKey.currentState!.push(
//             //     MaterialPageRoute(builder: ((context) => PointsEarned())));
//           }
//         } else {
//           // by default => login route
//           // navigatorKey.currentState!.push(
//           //     MaterialPageRoute(builder: ((context) => OnbaordingScreen())));
//         }
//       }
//     },
//   );
//
//   final _remoteMessage = RemoteMessage(data: ((message.data)).cast());
//   print("RemoteMessage remotemsg bghandle $_remoteMessage");
//
//   if (_remoteMessage.data['notification_flag'] != null) {
//     String payloadType = _remoteMessage.data['notification_flag'];
//     String orderEstId = _remoteMessage.data['stock_symbol'];
//
//     if (pref.getBool('loggedIn') == true) {
//       if (payloadType == "33") {
//         // navigatorKey.currentState!.push(
//         //     MaterialPageRoute(builder: ((context) => const StockAnalysis())));
//       }
//       if (payloadType == "2") {
//         // navigatorKey.currentState!.push(
//         //   MaterialPageRoute(
//         //     builder: ((context) => OrderDetails(
//         //           true,
//         //           orderEstId.toString(),
//         //           "ESTIMATE",
//         //           projectsList: projectsList,
//         //           itemCallback: () {},
//         //         )),
//         //   ),
//         // );
//       }
//       if (payloadType == "3") {
//         print("RemoteMessage onDidReceiveNotificationResponse");
//         // navigatorKey.currentState!.push(MaterialPageRoute(
//         //     builder: ((context) =>
//         //         OrderHistoryDetails(orderEstId.toString()))));
//       }
//       if (payloadType == "4") {
//         // navigatorKey.currentState!.pushAndRemoveUntil(
//         //     MaterialPageRoute(
//         //         builder: ((context) => Dashboard(
//         //               index: 4,
//         //               orderTabIndex: 0,
//         //             ))),
//         //     (Route<dynamic> route) => false);
//       }
//       if (payloadType == "5") {
//         // navigatorKey.currentState!
//         //     .push(MaterialPageRoute(builder: ((context) => PointsEarned())));
//       }
//     } else {
//       // navigatorKey.currentState!
//       //     .push(MaterialPageRoute(builder: ((context) => OnbaordingScreen())));
//     }
//   }
//
//   if (kDebugMode) {
//     print("RemoteMessage Handling a background message: ${message.messageId}");
//     print('Message data: ${message.data}');
//     print('Message notification: ${message.notification?.title}');
//     print('Message notification: ${message.notification?.body}');
//   }
// }
//
// Future<void> registerNotificationListeners(
//     // pref
//     ) async {
//   SharedPreferences pref = await SharedPreferences.getInstance();
//   print("onAPP hii/// from registerNotificationListeners");
//   final AndroidNotificationChannel channel = androidNotificationChannel();
//   print("onAPP hii/// 2");
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//   print("onAPP hii/// 3");
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//       AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);
//   print("onAPP hii/// 4");
//   const AndroidInitializationSettings androidSettings =
//   AndroidInitializationSettings('@mipmap/ic_launcher');
//   print("onAPP hii/// 5");
//   const DarwinInitializationSettings iOSSettings = DarwinInitializationSettings(
//     requestSoundPermission: false,
//     requestBadgePermission: false,
//     requestAlertPermission: false,
//   );
//   print("onAPP hii/// 6");
//   const InitializationSettings initSettings = InitializationSettings(
//     android: androidSettings,
//     iOS: iOSSettings,
//   );
//   print("onAPP hii/// 7");
//   flutterLocalNotificationsPlugin.initialize(
//     initSettings,
//     onDidReceiveNotificationResponse: (NotificationResponse details) {
//       print("onAPP hii/// 8");
//       if (details.payload != null) {
//         print("onAPP Payload: ${details.payload}");
//         print("onAPP Encoded: ${jsonEncode(details.payload)}");
//         print("onAPP Decoded: ${jsonDecode(jsonEncode(details.payload))}");
//
//         print("onAPP hii/// 9");
//         final splitNames = details.payload!.split(',');
//         print(splitNames);
//         int indexOfPayload = splitNames.indexWhere(
//                 (element) => element.toString().contains("notification_flag"));
//         int indexOfId = splitNames.indexWhere(
//                 (element) => element.toString().contains("stock_symbol"));
//         String payloadType =
//         splitNames[indexOfPayload].split(": ")[1].split('"')[0];
//         String orderEstId = splitNames[indexOfId].split(": ")[1].split('"')[0];
//
//         print("onAPP hii/// 10 $payloadType  $orderEstId");
//         Future.delayed(Duration(milliseconds: 500), () async {
//           if (pref.getBool('loggedIn') == true) {
//             if (payloadType == "33") {
//               // navigatorKey.currentState!.push(MaterialPageRoute(
//               //     builder: ((context) => const StockAnalysis())));
//             }
//             if (payloadType == "2") {
//               // navigatorKey.currentState!.push(
//               //   MaterialPageRoute(
//               //     builder: ((context) => OrderDetails(
//               //           true,
//               //           orderEstId.toString(),
//               //           "ESTIMATE",
//               //           projectsList: projectsList,
//               //           itemCallback: () {},
//               //         )),
//               //   ),
//               // );
//             }
//             if (payloadType == "3") {
//               // print("onAPP onDidReceiveNotificationResponse");
//               // navigatorKey.currentState!.push(MaterialPageRoute(
//               //     builder: ((context) =>
//               //         OrderHistoryDetails(orderEstId.toString()))));
//             }
//             if (payloadType == "4") {
//               // navigatorKey.currentState!.pushAndRemoveUntil(
//               //     MaterialPageRoute(
//               //         builder: ((context) => Dashboard(
//               //               index: 4,
//               //               orderTabIndex: 0,
//               //             ))),
//               //     (Route<dynamic> route) => false);
//             }
//             if (payloadType == "5") {
//               // navigatorKey.currentState!.push(
//               //     MaterialPageRoute(builder: ((context) => PointsEarned())));
//             }
//           } else {
//             // by default => login route
//             // navigatorKey.currentState!.push(
//             //     MaterialPageRoute(builder: ((context) => OnbaordingScreen())));
//           }
//         });
//       }
//     },
//     onDidReceiveBackgroundNotificationResponse: (NotificationResponse details) {
//       if (details.payload != null) {
//         print("onAPP bg Payload: ${details.payload}");
//         print("onAPP bg Encoded: ${jsonEncode(details.payload)}");
//         print("onAPP bg Decoded: ${jsonDecode(jsonEncode(details.payload))}");
//
//         final splitNames = details.payload!.split(',');
//         print(splitNames);
//         int indexOfPayload = splitNames.indexWhere(
//                 (element) => element.toString().contains("payload_type"));
//         int indexOfId = splitNames.indexWhere(
//                 (element) => element.toString().contains("invoice_or_est"));
//         String payloadType =
//         splitNames[indexOfPayload].split(": ")[1].split('"')[0];
//         String orderEstId = splitNames[indexOfId].split(": ")[1].split('"')[0];
//
//         if (pref.getBool('loggedIn') == true) {
//           if (payloadType == "33") {
//             // navigatorKey.currentState!.push(MaterialPageRoute(
//             //     builder: ((context) => const StockAnalysis())));
//           }
//           if (payloadType == "2") {
//             // navigatorKey.currentState!.push(
//             //   MaterialPageRoute(
//             //     builder: ((context) => OrderDetails(
//             //           true,
//             //           orderEstId.toString(),
//             //           "ESTIMATE",
//             //           projectsList: projectsList,
//             //           itemCallback: () {},
//             //         )),
//             //   ),
//             // );
//           }
//           if (payloadType == "3") {
//             // navigatorKey.currentState!.push(MaterialPageRoute(
//             //     builder: ((context) =>
//             //         OrderHistoryDetails(orderEstId.toString()))));
//           }
//           if (payloadType == "4") {
//             // navigatorKey.currentState!.pushAndRemoveUntil(
//             //     MaterialPageRoute(
//             //         builder: ((context) => Dashboard(
//             //               index: 4,
//             //               orderTabIndex: 0,
//             //             ))),
//             //     (Route<dynamic> route) => false);
//           }
//           if (payloadType == "5") {
//             // navigatorKey.currentState!.push(
//             //     MaterialPageRoute(builder: ((context) => PointsEarned())));
//           }
//         } else {
//           // by default => login route
//           // navigatorKey.currentState!.push(
//           //     MaterialPageRoute(builder: ((context) => OnbaordingScreen())));
//         }
//       }
//     },
//   );
// // onMessage is called when the app is in foreground and a notification is received
//   FirebaseMessaging.onMessage.listen((RemoteMessage? message) async {
//     print("onMessage new hii/// from onMessage ${message!.data}");
//     print("onMessage new hii/// from onMessage ${message!.notification}");
//
//     final RemoteNotification? notification = message!.notification;
//     final AndroidNotification? android = message.notification?.android;
// // If `onMessage` is triggered with a notification, construct our own
//     // local notification to show to users using the created channel.
//     print("onMessage new hii/// notification $notification //androud $android");
//
//     final _remoteMessage =
//     RemoteMessage(data: ((message!.data!) as Map).cast());
//     // final data = NotificationModel.fromJson(_remoteMessage!.data);
//
//     // print("onMessage new notification flag ${data.payloadType}");
//
//     print("onMessage new remotemsg $_remoteMessage");
//
//     // print("onMessage new data/3 ${data.payloadType}");
//
//     if (pref.getBool('loggedIn') == true) {
//     } else {
//       await flutterLocalNotificationsPlugin.show(
//         notification.hashCode,
//         "Mistry.Store",
//         "",
//         // data.postDetails!.message,
//         NotificationDetails(
//           android: AndroidNotificationDetails(channel.id, channel.name,
//               channelDescription: channel.description,
//               icon: 'nifty_fg___',
//               styleInformation: BigTextStyleInformation(
//                 _remoteMessage.data['message_title'],
//               ),
//               playSound: true),
//         ),
//         payload: jsonEncode(message.data),
//       );
//     }
//   });
// }
//
// Future<void> enableIOSNotifications() async {
//   await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//     alert: true, // Required to display a heads up notification
//     badge: true,
//   );
// }
//
// AndroidNotificationChannel androidNotificationChannel() {
//   print("android hii/// from androidNotificationChannel");
//   return const AndroidNotificationChannel(
//       'high_importance_channel', // id
//       'High Importance Notifications', // title
//       description:
//       'This channel is used for important notifications.', // description
//       importance: Importance.max,
//       playSound: true);
// }
//
// void zx(NotificationResponse resonse) {
//   print("zx notificaiton resonse ${resonse}");
// }
