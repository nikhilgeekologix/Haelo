import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/drawer_content/cubit/delete_account/delete_account_cubit.dart';
import 'package:haelo_flutter/features/drawer_content/cubit/delete_account/delete_account_state.dart';
import 'package:haelo_flutter/features/userboard/presentation/screens/login.dart';
import 'package:haelo_flutter/widgets/progress_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeleteAccount extends StatelessWidget {
   SharedPreferences pref;
  DeleteAccount({required this.pref,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            Container(
                margin:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30),

              color: AppColor.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.only(left: 20, right: 20, top: 25),
                    child: Text(
                      "Are you sure you want to delete your account?",
                      textAlign: TextAlign.center,
                      style: mpHeadLine14(fontWeight: FontWeight.w600),
                    ),
                  ),
                        SizedBox(
                          height: 8,
                        ),
                        Text( "You will lost all your data.",
                          textAlign: TextAlign.center,
                          style: appTextStyle(
                            textColor: AppColor.black,
                          ),
                        ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            //Navigator.pop(context);
                            BlocProvider.of<DeleteAccountCubit>(context)
                                .deleteAccount();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: mediaQH(context) * 0.05,
                            decoration: BoxDecoration(
                                border:
                                Border.all(color: AppColor.primary)),
                            child: Text(
                              "Yes",
                              style:
                              mpHeadLine16(textColor: AppColor.primary),
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
                              color: AppColor.primary,
                            ),
                            child: Text(
                              "No",
                              style:
                              mpHeadLine16(textColor: AppColor.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            // Container(
            //   decoration: BoxDecoration(
            //       color: Colors.white, borderRadius: BorderRadius.circular(10)),
            //   margin:
            //   const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30),
            //   padding:
            //   const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16),
            //   child: Column(
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       SizedBox(
            //         height: 10,
            //       ),
            //       Center(
            //         child: Text("Are you sure you want to delete your account?",
            //           style: appTextStyle(
            //               fontWeight: FontWeight.w600,
            //               fontSize: 20,
            //               textColor: AppColor.black),
            //           textAlign: TextAlign.center,
            //         ),
            //       ),
            //       SizedBox(
            //         height: 8,
            //       ),
            //       Text( "You will lost all your data.",
            //         textAlign: TextAlign.center,
            //         style: appTextStyle(
            //           textColor: AppColor.black,
            //         ),
            //       ),
            //       SizedBox(
            //         height: 16,
            //       ),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.end,
            //         children: [
            //           InkWell(
            //             onTap: (){
            //               Navigator.pop(context);
            //             },
            //             child: Padding(
            //               padding: const EdgeInsets.all(8.0),
            //               child: Text("Cancel",
            //               style: appTextStyle(
            //                 textColor: Colors.black54,
            //               ),),
            //             ),
            //           ),
            //           const SizedBox(
            //             width: 4,
            //           ),
            //           InkWell(
            //             onTap: (){
            //               BlocProvider.of<DeleteAccountCubit>(context)
            //                   .deleteAccount();
            //             },
            //             child: Padding(
            //               padding: const EdgeInsets.all(8.0),
            //               child: Text("Yes, Delete",
            //               style: appTextStyle(
            //                 textColor: AppColor.primary,
            //               ),),
            //             ),
            //           ),
            //           const SizedBox(
            //             width: 4,
            //           ),
            //
            //         ],
            //       )
            //     ],
            //   ),
            // ),
            BlocConsumer<DeleteAccountCubit, DeleteAccountState>(
                builder: (context, state) {
                  if (state is DeleteAccountLoading) {
                    return const AppProgressIndicator();
                  }
                  return const SizedBox();
                }, listener: (context, state) async {
              if (state is DeleteAccountLoaded) {
                Navigator.pop(context);
                var model = state.model;
                if (model.result == 1) {
                  Navigator.pop(context);
                  await pref.clear();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Login()),
                          (route) => false);
                  toast(msg: model.msg ?? "Deleted");
                } else {
                  toast(msg: model.msg ?? "Something went wrong");
                }
              }
              // else{
              //   await pref.clear();
              //   Navigator.pushAndRemoveUntil(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) => Login()),
              //           (route) => false);
              // }
            }),
          ],
        ),
      ],
    );
  }
}