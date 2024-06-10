import 'dart:async';

import 'package:flutter/material.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';

class WatchListAndUpdatePopup extends StatelessWidget {
  final btnCallback;
  final btnUpdateManuallyCallback;
  String heading1;
  String heading2;

  WatchListAndUpdatePopup(
      {Key? key,
      this.btnCallback,
      this.btnUpdateManuallyCallback,
      required this.heading1,
      required this.heading2})
      : super(key: key);

  /* WatchListAndUpdatePopup(
      {this.isError = true,
      this.isCloseIcon = true,
      this.btnCallback,
      Key? key})
      : super(key: key);*/

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                    color: AppColor.rejected_color_text,
                  )),
              ListTile(
                title: Text(heading1),
                onTap: () {
                  Navigator.pop(context);
                  btnCallback();
                },
              ),
              Divider(
                height: 1,
                color: AppColor.grey_color,
              ),
              ListTile(
                title: Text(heading2),
                onTap: () {
                  Navigator.pop(context);
                  btnUpdateManuallyCallback();
                  print('Text Tile 2 clicked');
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
