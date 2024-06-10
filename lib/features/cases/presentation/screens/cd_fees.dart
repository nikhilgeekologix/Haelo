import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/constants.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/cases/cubit/accountsdelete_cubit.dart';
import 'package:haelo_flutter/features/cases/cubit/accountsdelete_state.dart';
import 'package:haelo_flutter/features/cases/cubit/fees_cubit.dart';
import 'package:haelo_flutter/features/cases/cubit/fees_state.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/no_data_widget.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/tab_progress_indicator.dart';
import 'package:haelo_flutter/widgets/error_widget.dart';
import 'package:haelo_flutter/widgets/progress_indicator.dart';

import 'addexpenses.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:haelo_flutter/locators.dart' as di;

class Fees extends StatefulWidget {
  final getCaseId;
  const Fees({Key? key, this.getCaseId}) : super(key: key);
  @override
  State<Fees> createState() => _FeesState();
}

class _FeesState extends State<Fees> {
  bool isLoading = true;
  late SharedPreferences pref;
  @override
  void initState() {
    pref = di.locator();
    var caseIdDetails = {
      "caseId": widget.getCaseId.toString(),
    };
    BlocProvider.of<FeesCubit>(context).fetchFees(caseIdDetails);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  BlocConsumer<FeesCubit, FeesState>(builder: (context, state) {
                    if (state is FeesLoaded) {
                      var feesList = state.feesModel;
                      if (feesList.result == 1) {
                        if (feesList.data != null) {
                          var feesData = feesList.data;
                          //toast(msg: feesList.msg.toString());
                          return feesData!.caseList!.isNotEmpty
                              ? ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: feesData!.caseList!.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10, top: 8),
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Description: ",
                                                          style: mpHeadLine12(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                              feesData
                                                                  .caseList![
                                                                      index]
                                                                  .description
                                                                  .toString(),
                                                              style:
                                                                  mpHeadLine12()),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 8,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        RichText(
                                                          text: TextSpan(
                                                              text: "Amt: ",
                                                              style: mpHeadLine12(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                              children: <TextSpan>[
                                                                TextSpan(
                                                                    text:
                                                                        "${feesData.caseList![index].amount.toString()} /-",
                                                                    style:
                                                                        mpHeadLine12()),
                                                              ]),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 8,
                                                    ),
                                                    RichText(
                                                      text: TextSpan(
                                                          text: "Date: ",
                                                          style: mpHeadLine12(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                                text: feesData
                                                                    .caseList![
                                                                        index]
                                                                    .date
                                                                    .toString(),
                                                                style:
                                                                    mpHeadLine12()),
                                                          ]),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              pref.getString(Constants
                                                          .USER_TYPE) !=
                                                      "2"
                                                  ? InkWell(
                                                      onTap: () {
                                                        showDialog(
                                                            context: context,
                                                            builder: (ctx) {
                                                              return AlertDialog(
                                                                // insetPadding: EdgeInsets.symmetric(vertical: 305),
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                content:
                                                                    SizedBox(
                                                                  height: mediaQH(
                                                                          context) *
                                                                      0.16,
                                                                  // width: mediaQW(context) * 0.8,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            left:
                                                                                20,
                                                                            right:
                                                                                20,
                                                                            top:
                                                                                25),
                                                                        child:
                                                                            Text(
                                                                          "Are you sure to delete this fees?",
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style:
                                                                              mpHeadLine14(fontWeight: FontWeight.w600),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            25,
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                InkWell(
                                                                              onTap: () {
                                                                                setState(() {
                                                                                  isLoading = true;
                                                                                });
                                                                                Navigator.pop(context);
                                                                                var accountsDelete = {
                                                                                  "accountId": feesData.caseList![index].id.toString(),
                                                                                };
                                                                                BlocProvider.of<AccountsDeleteCubit>(context).fetchAccountsDelete(accountsDelete);
                                                                              },
                                                                              child: Container(
                                                                                alignment: Alignment.center,
                                                                                height: mediaQH(context) * 0.05,
                                                                                decoration: BoxDecoration(borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(5)), border: Border.all(color: AppColor.primary)),
                                                                                child: Text(
                                                                                  "Yes",
                                                                                  style: mpHeadLine16(textColor: AppColor.primary),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                InkWell(
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
                                                              );
                                                            });
                                                      },
                                                      child: const Icon(
                                                        Icons.delete,
                                                        size: 20,
                                                        color: AppColor
                                                            .button_reject,
                                                      ),
                                                    )
                                                  : SizedBox(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : NoDataAvailable("Fees will be shown here.");
                        }
                      }
                      return NoDataAvailable("Fees will be shown here.");
                    }
                    return const SizedBox();
                  }, listener: (context, state) {
                    if (state is FeesLoading) {
                      setState(() {
                        isLoading = true;
                      });
                    } else {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  }),
                  BlocConsumer<AccountsDeleteCubit, AccountsDeleteState>(
                      builder: (context, state) {
                    return const SizedBox();
                  }, listener: (context, state) {
                    if (state is AccountsDeleteLoaded) {
                      var accountsDeleteList = state.accountsDeleteModel;
                      if (accountsDeleteList.result == 1) {
                        setState(() {
                          isLoading = false;
                        });

                        toast(msg: accountsDeleteList.msg.toString());
                        /* showDialog(
                            context: context,
                            builder: (ctx) => AppMsgPopup(
                              accountsDeleteList.msg.toString(),
                              isCloseIcon: false,
                              isError: false,
                              btnCallback: () {
                                Navigator.pop(context);
                              },));*/
                        var caseIdDetails = {
                          "caseId": widget.getCaseId.toString(),
                        };
                        BlocProvider.of<FeesCubit>(context)
                            .fetchFees(caseIdDetails);
                      } else {
                        setState(() {
                          isLoading = false;
                        });
                        showDialog(
                            context: context,
                            builder: (ctx) => AppMsgPopup(
                                  accountsDeleteList.msg.toString(),
                                ));
                      }
                    }
                  }),
                ],
              ),
            ),
            Visibility(
              visible: isLoading,
              child: const Center(child: AppProgressIndicator()),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: pref.getString(Constants.USER_TYPE) != "2"
            ? FloatingActionButton(
                // isExtended: true,
                child: Icon(Icons.add),
                backgroundColor: AppColor.primary,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddExpenses(
                                getCaseId: widget.getCaseId.toString(),
                                type: true,
                              ))).then((value) {
                    if (value != null && value == true) {
                      var caseIdDetails = {
                        "caseId": widget.getCaseId.toString(),
                      };
                      BlocProvider.of<FeesCubit>(context)
                          .fetchFees(caseIdDetails);
                    }
                  });
                })
            : SizedBox());
  }
}
