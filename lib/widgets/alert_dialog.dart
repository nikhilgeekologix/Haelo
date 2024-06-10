import 'package:flutter/material.dart';
import 'package:haelo_flutter/constants.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';

class AlertDialogShow {
  showAlertDialog(
      {required BuildContext context,
      List<Widget>? actions,
      String titleMsg = "",
      String contentStr = ""}) {
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


class AppDialogShow{
  showErrorDialog(BuildContext context, msg){

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ErrorWidget(msg);
      },
    );
  }
}

AlertDialog errorDialog(final msg, BuildContext context) {
  return AlertDialog(
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      titlePadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 1),
      title: Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        height: mediaQH(context) * 0.06,
        // width: mediaQW(context) * 0.9,
        decoration: BoxDecoration(
          color: AppColor.rejected_color_text,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColor.white,
                width: 2)),
            padding: EdgeInsets.all(6),
            child: Image.asset(
              ImageConstant.close,
              color: Colors.white,
              height: 15,
              width: 15,
            ),
          ),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(msg, style: appTextStyle(), textAlign: TextAlign.center),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColor.rejected_color_text,
                      border: Border.all(color: AppColor.rejected_color_text)),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Text(
                    "OK",
                    style: appTextStyle(
                      textColor: AppColor.white,
                      fontSize: 16
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      actions: <Widget>[]);
}
