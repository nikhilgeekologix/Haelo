import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/cases/cubit/casehistory_cubit.dart';
import 'package:haelo_flutter/features/cases/cubit/casehistory_state.dart';
import 'package:haelo_flutter/features/cases/cubit/editcounsel_cubit.dart';

class CustomAlert extends StatefulWidget {
  final getCaseID;
  final seniorCounselEngaged;

  const CustomAlert({Key? key, this.getCaseID, this.seniorCounselEngaged})
      : super(key: key);

  @override
  State<CustomAlert> createState() => _CustomAlertState();
}

class _CustomAlertState extends State<CustomAlert> {
  bool isCheck = false;

  @override
  void initState() {
    super.initState();
    isCheck = widget.seniorCounselEngaged;
  }

  @override
  Widget build(BuildContext context) {
    print("seniorCounselEngaged ${widget.seniorCounselEngaged}");

    return AlertDialog(
      // insetPadding: EdgeInsets.symmetric(vertical: 305),
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        // height: mediaQH(context) * 0.183,
        // // width: mediaQW(context) * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  "Update",
                  style: mpHeadLine14(
                      fontWeight: FontWeight.w600,
                      textColor: AppColor.bold_text_color_dark_blue),
                ),
              ),
            ),
            const Divider(
              thickness: 1,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Checkbox(
                    checkColor: AppColor.white,
                    // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    /*fillColor: MaterialStateColor.resolveWith(
                        (states) => AppColor.primary),*/
                    value: isCheck,
                    onChanged: (value) {
                      setState(() {
                        print("isCheck$isCheck");
                        isCheck = value!;
                        // if (value!) {
                        //   isCheck ;
                        // } else {
                        //   isCheck ;
                        // }
                        // isCheck = value;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                const Text("Senior Counsel Engaged"),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                BlocConsumer<CaseHistoryCubit, CaseHistoryState>(
                    builder: (context, state) {
                      if (state is CaseHistoryLoaded) {
                        var caseHistoryList = state.caseHistoryModel;
                        if (caseHistoryList.result == 1) {
                          if (caseHistoryList.data != null) {
                            var caseHistoryData = caseHistoryList.data;
                            return const SizedBox();
                          }
                        } else {
                          toast(msg: caseHistoryList.msg.toString());
                        }
                      }
                      return const SizedBox();
                    },
                    listener: (context, state) {}),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Map<String, String> editCounsel = {
                        "caseId": widget.getCaseID.toString(),
                        "seniorCounsel": isCheck.toString(),
                        // "interimStay": "0"
                      };
                      BlocProvider.of<EditCounselCubit>(context)
                          .fetchEditCounsel(editCounsel);
                      var caseIdDetails = {
                        "caseId": widget.getCaseID.toString(),
                      };
                      BlocProvider.of<CaseHistoryCubit>(context)
                          .fetchCaseHistory(caseIdDetails);

                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: mediaQH(context) * 0.05,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(5)),
                          border: Border.all(color: AppColor.primary)),
                      child: Text(
                        "Yes",
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
                        borderRadius:
                            BorderRadius.only(bottomRight: Radius.circular(5)),
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
    );
  }
}
