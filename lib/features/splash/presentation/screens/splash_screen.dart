import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:haelo_flutter/constants.dart';
import 'package:haelo_flutter/core/utils/functions.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/bottom_bar/presentation/screens/bottom_nav_bar.dart';
import 'package:haelo_flutter/features/bottom_bar/presentation/screens/bottombar.dart';
import 'package:haelo_flutter/features/in_app_purchase/cubit/pay_request_cubit.dart';
import 'package:haelo_flutter/features/in_app_purchase/cubit/pay_request_state.dart';
import 'package:haelo_flutter/features/userboard/presentation/screens/login.dart';
import 'package:haelo_flutter/services/notification_model.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../main.dart';
import '../../../../services/firebase_service.dart';
import '../../../../widgets/alert_dialog.dart';
import '../../../in_app_purchase/presentation/screen/inapp_purchase.dart';
import '../../cubit/splash_cubit.dart';
import '../../cubit/splash_state.dart';
import 'package:haelo_flutter/locators.dart' as di;

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SplashScreen> {
  late SharedPreferences pref;
  bool isShowVersionDialog = false;
  bool isVersionMendatory = false;
  final ReceivePort _port = ReceivePort();

  //for notification work
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final List<FirebaseMessage> messageList = [];

  var currentVersion = "";

  @override
  void initState() {
    pref = di.locator();
    print(
        "////// notification sound ${pref.getBool(Constants.notification_sound)}");
    if (pref.getBool(Constants.notification_sound) == null) {
      pref.setBool(Constants.notification_sound, true);
    }
    Map<String, String> map = Map();
    map['Version'] = "2.0";
    BlocProvider.of<SplashCubit>(context).fetchConfig(map);

    downloadListner();

    if (Platform.isAndroid) {
      FirebaseService().subscribeToTopic("Android");
    } else {
      FirebaseService().subscribeToTopic("Apple");
    }

    super.initState();
  }

  downloadListner() {
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      if (status.toString() == "DownloadTaskStatus(3)" &&
          progress == 100 &&
          id != null) {
        String query = "SELECT * FROM task WHERE task_id='" + id + "'";
        var tasks = FlutterDownloader.loadTasksWithRawQuery(query: query);
        //if the task exists, open it
        if (tasks != null) FlutterDownloader.open(taskId: id);
      }
    });

    FlutterDownloader.registerCallback(
        downloadCallback_android); //use this for android
    // FlutterDownloader.registerCallback(downloadCallback_iOS);// use this for iOS
  }

  void notificationCall() {
    // _firebaseMessaging.requestPermission();
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

/*  static void downloadCallback_android(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }*/
  static void downloadCallback_android(String id, int status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  static void downloadCallback_iOS(String id, int status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<SplashCubit, SplashState>(
                builder: (context, state) {
              return splashUi(context);
            }, listener: (context, state) async {
              if (state is SplashLoaded) {
                final configModel = state.splashModel;
                if (configModel.result == 1) {
                  PackageInfo packageInfo = await PackageInfo.fromPlatform();
                  currentVersion = packageInfo.version;
                  // print("current version ${currentVersion}");

                  if (_isHigherThanCurrentVersion(
                      configModel.data!.appVersion!, currentVersion)) {
                    isShowVersionDialog = true;
                  }
                  if (configModel.data!.isMandatory!) {
                    isVersionMendatory = configModel.data!.isMandatory!;
                  }

                  if (!isShowVersionDialog) {
                    route(context);
                  } else {
                    _showVersionDialog(context);
                  }
                } else {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const Login()));
                }
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget splashUi(context) {
    return Stack(
      children: [
        Center(
          child: Image.asset(ImageConstant.logo),
        ),
        Positioned(
            bottom: 15,
            right: 0,
            left: 0,
            child: InkWell(
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const Login()));

                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context)=>Login()));
              },
              child: Center(
                  child: Text(
                "App Version $currentVersion",
                style: mpHeadLine12(
                    textColor: AppColor.black, fontFamily: "roboto_bold"),
              )),
            ))
      ],
    );
  }

  bool _isHigherThanCurrentVersion(String newVersion, String currentVersion) {
    var isHigher = false;
    print("newVersion>>>>>>>>>>>>>>>>>");
    print("newVersion $newVersion   currentVersion $currentVersion");
    try {
      final currentVSegments = currentVersion.split('.');
      final newVSegments = newVersion.split('.');
      final maxLength = max(currentVSegments.length, newVSegments.length);
      for (var i = 0; i < maxLength; i++) {
        final newVSegment =
            i < newVSegments.length ? int.parse(newVSegments[i]) : 0;
        final currentVSegment =
            i < currentVSegments.length ? int.parse(currentVSegments[i]) : 0;
        isHigher = newVSegment > currentVSegment;
        if (newVSegment != currentVSegment) {
          break;
        }
      }
    } on Exception catch (e) {}
    print("version    $isHigher");
    return isHigher;
  }

  void _showVersionDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
        isShowVersionDialog = false;
        route(context);
      },
    );

    Widget continueButton = TextButton(
      child: const Text('Update'),
      onPressed: () {
        String url = '';
        if (Platform.isIOS) {
          url = "https://apps.apple.com/in/app/haelo/id6447694175";
          launchUrl(Uri.parse(url));
          // route();
        } else if (Platform.isAndroid) {
          // url = 'https://play.google.com/store/apps/details?id=com.haeloapp';
          url = 'market://details?id=com.haeloapp';
          launchUrl(Uri.parse(url));
        } else {
          exit(0);
        }
      },
    );

    var actoins = <Widget>[];
    isVersionMendatory ? const SizedBox() : actoins.add(cancelButton);
    //actoins.add(cancelButton);
    actoins.add(continueButton);
    AlertDialogShow().showAlertDialog(
      context: context,
      actions: actoins,
      titleMsg:
          isVersionMendatory ? "Update Required" : "New Version Available!",
      contentStr: isVersionMendatory
          ? "You are using an older version of the app, update now to enhance your experience"
          : "For more features and best user experience, please update to the latest app version.",
    );
  }

  route(BuildContext context) {
    pref.setBool(Constants.is_court_filter, false);
    pref.setString(Constants.app_version, currentVersion);
    if (pref.getBool(Constants.IS_LOGIN) != null &&
        pref.getBool(Constants.IS_LOGIN)!) {
      // if (Platform.isIOS) {
      //   // Map<String, String> receiptData = {};
      //   // receiptData['receipt_data'] = "";
      //   // receiptData['password'] = "";
      //   // receiptData['exclude_old_transactions'] = "";
      //   // receiptData['url_type'] = "";
      //   // receiptData['plan_price'] = "";
      //   // BlocProvider.of<PayRequestCubit>(context).payRequest(receiptData);
      // } else {
      // go to dashboard;
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => BottomNavBar(
                    bottom: 0,
                  )));
      //  }
      // } else {
      //   //push replacement
      //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login()));
      // }
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Login()));
    }
  }
}
