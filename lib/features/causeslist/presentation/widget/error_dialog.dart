import 'package:flutter/material.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:provider/provider.dart';
// import 'package:tutorials_freak/core/utils/theme_provider.dart';

// import '../core/ui_helper.dart';

class AlertDialogShow {
  showAlertDialog(
      {required BuildContext context, List<Widget>? actions, String titleMsg = "", String contentStr = ""}) {
    // set up the buttons

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(titleMsg),
      content: Text(contentStr),
      actions: actions,
    );
    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class ErrorDialog {
  showLogoutDialog(BuildContext contextLogout,
      {IconData icon = Icons.close,
      Color iconColor = Colors.red,
      String msg = "",
      String buttonName = "OK",
      Color btnColor = Colors.red,
      Color txtColor = Colors.white}) {
    showDialog(
      context: contextLogout,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.all(6),
                  child: Icon(icon, size: 40, color: iconColor),
                  decoration: BoxDecoration(
                      border: Border.all(color: iconColor, width: 2), borderRadius: BorderRadius.circular(40)),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    msg,
                    style: mpHeadLine14(
                      fontWeight: FontWeight.w400,
                      // // textColor: Provider.of<ThemeProvider>(context, listen: false).themeMode == ThemeMode.dark
                      //     ? AppColor.White
                      //     : AppColor.inputSubTitleColor
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    child: Text(
                      "  $buttonName  ",
                      style: mpHeadLine16(textColor: txtColor, fontWeight: FontWeight.w500),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        color: btnColor, border: Border.all(color: btnColor), borderRadius: BorderRadius.circular(30)),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
