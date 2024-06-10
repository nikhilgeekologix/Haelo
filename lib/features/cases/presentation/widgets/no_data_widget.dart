import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haelo_flutter/constants.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';

class NoDataAvailable extends StatelessWidget {
  final text;
   bool isTopmMargin=true;
   NoDataAvailable(this.text,{this.isTopmMargin=true,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: !isTopmMargin?EdgeInsets.zero:EdgeInsets.only(top: mediaQH(context)/3),
      alignment: Alignment.center,
      child: Column(
        children: [
          Image.asset(ImageConstant.error,
          height: 100),
          SizedBox(height: 15,),
          Text(text, style: appTextStyle(
              fontWeight: FontWeight.w500, textColor: AppColor.bold_text_color_dark_blue,
          fontSize: 15),
          )
        ],
      ),
    );
  }
}
