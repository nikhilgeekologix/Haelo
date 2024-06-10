import 'dart:io';

import 'package:flutter/material.dart';
import 'package:haelo_flutter/core/utils/functions.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/in_app_purchase/presentation/screen/plans.dart';
import 'package:haelo_flutter/widgets/app_button.dart';

import '../features/in_app_purchase/presentation/screen/ios_plans.dart';

class GoPrime extends StatelessWidget {
  const GoPrime({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(20),
            // constraints: BoxConstraints(maxHeight: mediaQH(context) * 0.5),
            alignment: Alignment.centerLeft,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 18,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          "You don't have access of this feature with current plan. Please upgrade gold plan",
                          style: mpHeadLine14(
                              textColor: Colors.black,
                              fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: AppButton(
                              btnName: "Go Prime",
                              voidCallback: () {
                                if (Platform.isIOS) {
                                  goToPage(context, IOSPlans());
                                } else {
                                  goToPage(context, Plans());
                                }
                              },
                              isLoading: false,
                              cornerRadius: 10,
                              borderColor: AppColor.primary,
                              backgroundColor: AppColor.primary,
                              textColor: AppColor.white,
                              textSize: 14,
                              buttonHeight: 40,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
                Positioned(
                    right: 0,
                    top: 0,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.cancel_outlined,
                          size: 20,
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
