import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/userboard/cubit/update_trial_cubit.dart';
import 'package:haelo_flutter/features/userboard/presentation/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constants.dart';
import '../../cubit/update_trial_state.dart';

class TrialWarning extends StatelessWidget {
  final VoidCallback onOkayPressed;
  final String? expiryDate;
  TrialWarning({required this.onOkayPressed, required this.expiryDate})
      : super();

  @override
  Widget build(BuildContext context) {
    print("expiryDate ===> $expiryDate");
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
                Center(
                  child: Image.asset(
                    ImageConstant.crown,
                    height: 50,
                    width: 50,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                          'Dear Patron,\n\n'
                          'Happy NEW YEAR 2024.\n\n'
                          'Hurray!! As an early bird offer, you are shortlisted for free FULL access to the HAeLO app till $expiryDate. You can explore and enjoy the entire suite of benefits offered by the app till $expiryDate and get any updates applied to the app in the meantime.\n\n'
                          'After $expiryDate, you are requested to purchase the access, per your need and convenience, from the plans being offered on the app. You can access the plans on GO PRIME page in the app.\n\n'
                          'Thanks\n\n'
                          'Team HAeLO',
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
                            BlocProvider.of<UpdateTrialCubit>(context)
                                .fetchUpdateTrialUser();
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
                      BlocConsumer<UpdateTrialCubit, UpdateTrialState>(
                          builder: (context, state) {
                        return SizedBox();
                        //
                      }, listener: (context, state) {
                        if (state is UpdateTrialLoaded) {
                          final model = state.model;
                          if (model.result == 1) {
                            toast(msg: model.msg.toString());
                          }
                        }
                      }),
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
