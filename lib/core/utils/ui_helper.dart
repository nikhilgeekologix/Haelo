import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../responsive/size_config.dart';

double sWidth(double width) => SizeConfig.setWidth(width);

double sHeight(double height) => SizeConfig.setHeight(height);

double sSize(double size) => SizeConfig.setImageSize(size);

double mediaQH(BuildContext context) => MediaQuery.of(context).size.height;

double mediaQW(BuildContext context) => MediaQuery.of(context).size.width;

double sSp(double size) => SizeConfig.setSp(size);

class AppColor {
  static const Color primary = Color(0xFF535BFE);
  static const Color settingswitch = Color(0xFFb3b7ff);
  static const Color disabled_color = Color(0xFFF5F5FF);
  static const Color text_grey_color = Color(0xFFa4a7bc);
  static const Color bold_text_color_dark_blue = Color(0xFF22215B);
  static const Color lyt_stroke_color = Color(0xFFe2e2e2);
  static const Color hint_color_grey = Color(0xFF8a89a8);
  static const Color grey_color = Color(0xFFf1f1f1);
  static const Color home_background = Color(0xFFF5F7FB);
  static const Color display_board = Color(0xFFEEF2FE);
  static const Color pending_color = Color(0xFFFFF4E7);
  static const Color pending_color_text = Color(0xFFFF9515);
  static const Color rejected_color = Color(0xFFFFE7EC);
  static const Color rejected_color_text = Color(0xFFFF1744);
  static const Color accepted_color = Color(0xFFE5FAED);
  static const Color accepted_color_text = Color(0xFF00C853);
  static const Color review_color = Color(0xFFF3F3F6);
  static const Color review_color_text = Color(0xFF22215B);
  static const Color complete_color = Color(0xFFE8FAF6);
  static const Color complete_color_text = Color(0xFF23CFA7);
  static const Color button_accept = Color(0xFF2dd2ac);
  static const Color button_reject = Color(0xFFed1b2e);
  // static const Color cases_nostay = Color(0x99FFE86F);
  // static const Color cases_intrimstay = Color(0x44FF6E40);
  // static const Color cases_fullstay = Color(0xFFc9fed6);
  static const Color cases_nostay = Color(0xFFFBEEA7);
  static const Color cases_intrimstay = Color(0xFFF8D2C9);
  static const Color cases_fullstay = Color(0xFFC9FED6);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color colorTransparent = Color(0x00000000);
  static const Color disposedColor = Color(0xFF90CAF9);
}

TextStyle mpHeadLine20(
    {Color textColor = AppColor.black,
    FontWeight fontWeight = FontWeight.w600,
    String fontFamily = "Roboto"}) {
  return TextStyle(
    fontFamily: fontFamily,
    fontWeight: fontWeight,
    color: textColor,
    fontSize: 20,
  );
}

TextStyle mpHeadLine18(
    {Color textColor = AppColor.black,
    FontWeight fontWeight = FontWeight.normal,
    TextDecoration decoration = TextDecoration.none,
    String fontFamily = "Roboto"}) {
  return TextStyle(
    fontFamily: fontFamily,
    fontWeight: fontWeight,
    color: textColor,
    decoration: decoration,
    fontSize: 18,
  );
}

TextStyle mpHeadLine16(
    {Color textColor = AppColor.black,
    FontWeight fontWeight = FontWeight.normal,
    TextDecoration decoration = TextDecoration.none,
    String fontFamily = "Roboto"}) {
  return TextStyle(
    fontFamily: fontFamily,
    fontWeight: fontWeight,
    color: textColor,
    decoration: decoration,
    fontSize: 16,
  );
}

TextStyle mpHeadLine14(
    {Color textColor = AppColor.black,
    FontWeight fontWeight = FontWeight.normal,
    TextDecoration decoration = TextDecoration.none,
    String fontFamily = "Roboto"}) {
  return TextStyle(
    fontFamily: fontFamily,
    fontWeight: fontWeight,
    decoration: decoration,
    color: textColor,
    fontSize: 14,
  );
}

TextStyle mpHeadLine12(
    {Color textColor = AppColor.black,
    FontWeight fontWeight = FontWeight.normal,
    TextDecoration decoration = TextDecoration.none,
    String fontFamily = "Roboto"}) {
  return TextStyle(
    fontFamily: fontFamily,
    fontWeight: fontWeight,
    color: textColor,
    decoration: decoration,
    fontSize: 12,
  );
}

TextStyle mpHeadLine10(
    {Color textColor = AppColor.black,
    FontWeight fontWeight = FontWeight.w400,
    TextDecoration decoration = TextDecoration.none,
    String fontFamily = "Roboto"}) {
  return TextStyle(
    fontFamily: fontFamily,
    fontWeight: fontWeight,
    color: textColor,
    fontSize: 10,
  );
}

TextStyle mpHeadLine(
    {Color textColor = AppColor.black,
    FontWeight fontWeight = FontWeight.w500,
    TextDecoration decoration = TextDecoration.none,
    double fontSize = 18,
    String fontFamily = "Roboto"}) {
  return TextStyle(
    fontFamily: fontFamily,
    fontWeight: fontWeight,
    color: textColor,
    fontSize: fontSize,
  );
}

TextStyle appTextStyle(
    {Color textColor = AppColor.black,
    FontWeight fontWeight = FontWeight.w400,
    TextDecoration decoration = TextDecoration.none,
    double fontSize = 14,
    String fontFamily = 'Roboto'}) {
  return TextStyle(
      fontFamily: fontFamily,
      fontWeight: fontWeight,
      color: textColor,
      fontSize: fontSize,
      decoration: decoration);
}

/*Color getColor(Set<MaterialState> states) {
  const Set<MaterialState> interactiveStates = <MaterialState>{
    MaterialState.pressed,
    MaterialState.hovered,
    MaterialState.focused,
  };
  if (states.any(interactiveStates.contains)) {
    return Colors.blue;
  }
  return AppColor.primary;
}*/

SizedBox getSizeBox({double? width, double? height, Widget? child}) {
  return SizedBox(
    width: width,
    height: height,
    child: child,
  );
}

Future<bool?> toast(
    {String msg = "",
    Toast toastLength = Toast.LENGTH_SHORT,
    ToastGravity toastGravity = ToastGravity.SNACKBAR,
    int time = 1,
    Color txtColor = const Color(0xffffffff),
    Color bgColor = AppColor.black}) {
  return Fluttertoast.showToast(
      msg: msg,
      toastLength: toastLength,
      gravity: toastGravity,
      timeInSecForIosWeb: time,
      backgroundColor: bgColor,
      textColor: txtColor,
      fontSize: 16.0);
}
