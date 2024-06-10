import 'package:flutter/material.dart';
import 'package:haelo_flutter/constants.dart';
import 'package:haelo_flutter/core/utils/functions.dart';
import 'package:haelo_flutter/core/utils/save_file.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/bottom_bar/presentation/screens/bottombar.dart';
import 'package:haelo_flutter/locators.dart' as di;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsDraw extends StatefulWidget {
  const SettingsDraw({Key? key}) : super(key: key);

  @override
  State<SettingsDraw> createState() => _SettingsDrawState();
}

class _SettingsDrawState extends State<SettingsDraw> {
  late SharedPreferences pref;
  bool notification_sound = true;
  bool auto_download = false;
  bool calendar_event_add = false;

  @override
  void initState() {
    pref = di.locator();

    if (pref.getBool(Constants.notification_sound) != null) {
      notification_sound = pref.getBool(Constants.notification_sound)!;
    }
    if (pref.getBool(Constants.auto_download) != null) {
      auto_download = pref.getBool(Constants.auto_download)!;
    }
    if (pref.getBool(Constants.calendar_event_add) != null) {
      calendar_event_add = pref.getBool(Constants.calendar_event_add)!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new_sharp,
            size: 24,
          ),
        ),
        backgroundColor: AppColor.white,
        titleSpacing: 0,
        centerTitle: false,
        title: Text(
          "App Settings",
          style: mpHeadLine16(
              fontWeight: FontWeight.w500,
              textColor: AppColor.bold_text_color_dark_blue),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              goToHomePage(context);
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 15),
              child: Icon(
                Icons.home_outlined,
                size: 30,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 18, right: 16, top: 0),
        child: Column(
          children: [
            SizedBox(
              height: 40,
              child: SwitchListTile(
                  title: Text(
                    "Notification Sound",
                    style: appTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  contentPadding: EdgeInsets.zero,
                  value: notification_sound,
                  activeColor: AppColor.primary,
                  activeTrackColor: AppColor.settingswitch,
                  inactiveThumbColor: AppColor.grey_color,
                  inactiveTrackColor: AppColor.grey_color,
                  onChanged: (bool value) {
                    setState(() {
                      notification_sound = value;
                      pref.setBool(Constants.notification_sound, value);
                    });
                  }),
            ),
            SizedBox(
              height: 40,
              child: SwitchListTile(
                  title: Text(
                    "Auto Download File",
                    style: appTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  contentPadding: EdgeInsets.zero,
                  value: auto_download,
                  activeColor: AppColor.primary,
                  activeTrackColor: AppColor.settingswitch,
                  inactiveThumbColor: AppColor.grey_color,
                  inactiveTrackColor: AppColor.grey_color,
                  onChanged: (bool value) {
                    if(value){
                      toast(msg: "Pdf file will be downloaded at 12am for selected Lawyers.",
                      bgColor: AppColor.grey_color, txtColor: AppColor.black,);
                    }
                    setState(() {
                      auto_download = value;
                      pref.setBool(Constants. auto_download, value);
                    });
                  }),
            ),
            SizedBox(
              height: 40,
              child: SwitchListTile(
                  title: Text(
                    "Add Events in Calendar",
                    style: appTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  contentPadding: EdgeInsets.zero,
                  value: calendar_event_add,
                  activeColor: AppColor.primary,
                  activeTrackColor: AppColor.settingswitch,
                  inactiveThumbColor: AppColor.grey_color,
                  inactiveTrackColor: AppColor.grey_color,
                  onChanged: (bool value) async {
                    print(
                        "calendar permission ${await requestPermission(Permission.calendar)}");
                    if (await requestPermission(Permission.calendar)) {
                      setState(() {
                        calendar_event_add = value;
                        pref.setBool(Constants.calendar_event_add, value);
                      });
                    }

                  }),
            ),
          ],
        ),
      ),
    );
  }
}
