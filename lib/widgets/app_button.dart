import 'package:flutter/material.dart';

import '../core/utils/ui_helper.dart';

class AppButton extends StatelessWidget {
  final String btnName;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final double textSize;
  final Color shadowColor;
  final double cornerRadius;
  final VoidCallback? voidCallback;
  final Widget? child;
  final bool isLoading;
  final double buttonHeight;
  final double buttonWidth;
  final FontWeight fontweight;

  AppButton(
      {required this.btnName,
      this.backgroundColor = AppColor.primary,
      this.borderColor = AppColor.primary,
      this.cornerRadius = 10,
      this.textColor = Colors.white,
      this.textSize = 16.0,
      this.voidCallback,
      this.shadowColor = Colors.grey,
      this.child,
      this.isLoading = false,
      this.buttonHeight = 48,
      this.buttonWidth = double.maxFinite,
      this.fontweight = FontWeight.w600});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: buttonHeight,
      width: buttonWidth,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(cornerRadius))),
          side: BorderSide(color: borderColor ?? Colors.transparent),
          elevation: 2,
          //shadowColor: Colors.grey,
        ),
        onPressed: () {
          if (!isLoading) {
            voidCallback!();
          }
        },
        child: child ??
            Text(btnName,
                style: appTextStyle(
                    textColor: textColor!,
                    fontWeight: fontweight,
                    fontSize: textSize,
                    fontFamily: "gilroy_semi_bold")),
      ),
    );
  }
}
