import 'package:flutter/material.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';

class CommonButtons extends StatelessWidget {
  final String buttonText;
  final buttonCall;

  CommonButtons({
    required this.buttonText,
    required this.buttonCall,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(
        buttonText,
        style: mpHeadLine16(textColor: Colors.white),
      ),
      style: ButtonStyle(
          fixedSize: MaterialStateProperty.all(Size(mediaQW(context), 40)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
          backgroundColor: MaterialStateProperty.all(AppColor.primary)),
      onPressed: buttonCall,
    );
  }
}
