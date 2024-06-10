import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomSheetDialog {
  final BuildContext context;
  final Widget screen;
  final dismissable;
  final dragable;
  final double radius;
  final Color bgColor;
  final Color? barrierCol;
  final double elevation;
  BottomSheetDialog(this.context, this.screen,
      {this.dismissable = true,
      this.dragable = true,
      this.radius = 40.0,
      this.bgColor = Colors.white,
      this.barrierCol,
      this.elevation = 4});
  void showScreen() {
    showModalBottomSheet(
      elevation: elevation,
      isDismissible: dismissable,
      enableDrag: dragable,
      barrierColor: barrierCol,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radius),
            topRight: Radius.circular(radius)),
      ),
      backgroundColor: bgColor,
      context: context,
      builder: (context) => screen,
    );
  }
}
