import 'package:flutter/material.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';

class AppConfirmation extends StatelessWidget {
  final msg;
  final confirmCallback;
  AppConfirmation(this.msg,this.confirmCallback,{Key? key}) : super(key: key);

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
            children: [
              Container(

                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                      child: Text(msg, style: appTextStyle(
                        fontWeight: FontWeight.w500
                      ), textAlign: TextAlign.center),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    Row(
                      children: [

                        Expanded(
                          child: InkWell(
                            onTap: () {
                              confirmCallback();
                              Navigator.pop(context);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: mediaQH(context) * 0.05,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(5)),
                                  border: Border.all(color: AppColor.primary)),
                              child: Text(
                                "YES",
                                style: mpHeadLine16(textColor: AppColor.primary),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: mediaQH(context) * 0.05,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(bottomRight: Radius.circular(5)),
                                color: AppColor.primary,
                              ),
                              child: Text(
                                "No",
                                style: mpHeadLine16(textColor: AppColor.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ],
    );
  }
}


