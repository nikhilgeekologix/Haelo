import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/userboard/cubit/update_trial_cubit.dart';

import '../../../../constants.dart';

class SessionEndPopup extends StatelessWidget {
  final VoidCallback onOkayPressed;
  String message;
  String title;
  SessionEndPopup(
      {required this.onOkayPressed, required this.message, required this.title})
      : super();

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
                Text(
                  title,
                  style:
                      appTextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Text(message,
                          style: appTextStyle(fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: InkWell(
                          onTap: () async {
                            Navigator.pop(context);
                            onOkayPressed();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: AppColor.primary,
                                border: Border.all(color: AppColor.primary)),
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            child: Text(
                              "Okay",
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
