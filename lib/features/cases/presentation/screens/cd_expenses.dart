import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/cases/cubit/accountsdelete_cubit.dart';
import 'package:haelo_flutter/features/cases/cubit/accountsdelete_state.dart';
import 'package:haelo_flutter/features/cases/cubit/expenses_cubit.dart';
import 'package:haelo_flutter/features/cases/cubit/expenses_state.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/no_data_widget.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/tab_progress_indicator.dart';
import 'package:haelo_flutter/widgets/error_widget.dart';
import 'package:haelo_flutter/widgets/progress_indicator.dart';

import '../../../../constants.dart';
import 'addexpenses.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:haelo_flutter/locators.dart' as di;

class Expenses extends StatefulWidget {
  final getCaseId;
  const Expenses({Key? key, this.getCaseId}) : super(key: key);

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  bool isLoading = false;
  late SharedPreferences pref;
  @override
  void initState() {
    pref = di.locator();
    var caseIdDetails = {
      "caseId": widget.getCaseId.toString(),
    };
    BlocProvider.of<ExpensesCubit>(context).fetchExpenses(caseIdDetails);
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
                  BlocConsumer<ExpensesCubit, ExpensesState>(
                      builder: (context, state) {
                        if (state is ExpensesLoading) {
                          return TabProgressIndicator();
                        }
                        if (state is ExpensesLoaded) {
                          var expensesList = state.expensesModel;
                          if (expensesList.result == 1) {
                            if (expensesList.data != null) {
                              var expensesData = expensesList.data;
                              // toast(msg: expensesList.msg.toString());
                              return expensesData!.caseList!.isNotEmpty
                                  ? ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      itemCount: expensesData!.caseList!.length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8, left: 10, right: 10),
                                          child: Card(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
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
                                                                  expensesData
                                                                      .caseList![
                                                                          index]
                                                                      .description
                                                                      .toString(),
                                                                  style:
                                                                      mpHeadLine12()),
                                                            ),
                                                          ],
                                                        ),
                                                        // RichText(
                                                        //   text: TextSpan(
                                                        //       text: "Description: ",
                                                        //       style: mpHeadLine12(fontWeight: FontWeight.w600),
                                                        //       children: <TextSpan>[
                                                        //         TextSpan(
                                                        //             text: expensesData.caseList![index].description.toString(),
                                                        //             style: mpHeadLine12()),
                                                        //       ]),
                                                        // ),
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
                                                                            "${expensesData.caseList![index].amount.toString()} /-",
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
                                                                    text: expensesData
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
                                                                context:
                                                                    context,
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
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(
                                                                                left: 20,
                                                                                right: 20,
                                                                                top: 25),
                                                                            child:
                                                                                Text(
                                                                              "Are you sure to delete this expense?",
                                                                              textAlign: TextAlign.center,
                                                                              style: mpHeadLine14(fontWeight: FontWeight.w600),
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Expanded(
                                                                                child: InkWell(
                                                                                  onTap: () {
                                                                                    setState(() {
                                                                                      isLoading = true;
                                                                                    });
                                                                                    Navigator.pop(context);
                                                                                    var accountsDelete = {
                                                                                      "accountId": expensesData.caseList![index].id.toString(),
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
                                  : NoDataAvailable(
                                      "Expenses will be shown here.");
                            }
                          }
                          return NoDataAvailable(
                              "Expenses will be shown here.");
                        }
                        return const SizedBox();
                      },
                      listener: (context, state) {}),
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
                        /*  showDialog(
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
                        BlocProvider.of<ExpensesCubit>(context)
                            .fetchExpenses(caseIdDetails);
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
                                type: false,
                              ))).then((value) {
                    print("hello return $value");
                    if (value != null && value == true) {
                      var caseIdDetails = {
                        "caseId": widget.getCaseId.toString(),
                      };
                      BlocProvider.of<ExpensesCubit>(context)
                          .fetchExpenses(caseIdDetails);
                    }
                  });
                })
            : SizedBox());
  }
}
