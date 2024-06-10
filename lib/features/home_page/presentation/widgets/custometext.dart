import 'package:flutter/material.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'divider_custom.dart';

class NeoText extends StatelessWidget {
  final String text;
  // final double size;
  // final FontWeight fontWeight;
  // final Color color;
  // final double wordSpacing;
  Icon iconss;

  NeoText({
    required this.text,
    // required this.size,
    // required this.fontWeight,
    // required this.color,
    // required this.wordSpacing,
    required this.iconss,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          // margin: EdgeInsets.only(left: 5, top: 10),
          padding: EdgeInsets.all(7.5),
          child: Row(
            children: [
              const SizedBox(
                width: 6,
              ),
              iconss,
              const SizedBox(
                width: 12,
              ),
              Flexible(
                // width: mediaQW(context) * 0.5,
                child: Text(
                  text,
                  // style: TextStyle(
                  //   fontSize: size,
                  //   fontWeight: fontWeight,
                  //   color: color,
                  //   wordSpacing: wordSpacing,
                  // ),
                  style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w500, wordSpacing: 0.5),
                ),
              ),
            ],
          ),
        ),
        DividerCustom(),
      ],
    );
  }
}
