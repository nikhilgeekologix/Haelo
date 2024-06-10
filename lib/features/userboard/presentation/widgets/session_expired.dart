import 'package:flutter/material.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/userboard/presentation/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionExpired extends StatelessWidget {
  final VoidCallback onLoginPressed;
  late SharedPreferences pref;
  SessionExpired({
    required this.pref,
    required this.onLoginPressed,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: RotatedBox(
                    quarterTurns: 2,
                    child: Icon(Icons.info_outline,
                        color: AppColor.rejected_color_text, size: 50),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Text("Your Token has been expired.\nPlease re-login",
                          style: appTextStyle(fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: InkWell(
                          onTap: () async {
                            await pref.clear();
                            onLoginPressed();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()),
                                (route) => false);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: AppColor.primary,
                                border: Border.all(color: AppColor.primary)),
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            child: Text(
                              "Login",
                              style: appTextStyle(
                                  textColor: AppColor.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
