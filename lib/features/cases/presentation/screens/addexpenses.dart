import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/core/utils/functions.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/bottom_bar/presentation/screens/bottombar.dart';
import 'package:haelo_flutter/features/cases/cubit/addexpensesfees_cubit.dart';
import 'package:haelo_flutter/features/cases/cubit/addexpensesfees_state.dart';
import 'package:haelo_flutter/features/drawer_content/presentation/widgets/textformfield_decoration.dart';
import 'package:haelo_flutter/widgets/commonButtons.dart';
import 'package:haelo_flutter/widgets/date_format.dart';
import 'package:haelo_flutter/widgets/error_widget.dart';
import 'package:haelo_flutter/widgets/progress_indicator.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class AddExpenses extends StatefulWidget {
  final getCaseId;
  final bool type;

  const AddExpenses({Key? key, this.getCaseId, this.type = false})
      : super(key: key);

  @override
  State<AddExpenses> createState() => _AddExpensesState();
}

class _AddExpensesState extends State<AddExpenses> {
  bool _seletedDate = false;
  DateTime date = DateTime.now();

  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _amountController = TextEditingController();

  var type;
  bool isFirstTime = false;

  final formKeyAddExpenses = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  final FocusNode _amount = FocusNode();

  /// Creates the [KeyboardActionsConfig] to hook up the fields
  /// and their focus nodes to our [FormKeyboardActions].
  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: false,
      actions: [
        KeyboardActionsItem(focusNode: _amount),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new_sharp,
            size: 24,
          ),
        ),
        titleSpacing: -5,
        title: Text(
          // "Add Expenses",
          widget.type ? "Add Fees" : "Add Expenses",
          style: mpHeadLine16(
              fontWeight: FontWeight.w500,
              textColor: AppColor.bold_text_color_dark_blue),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              goToHomePage(context);
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 15),
              child: Icon(
                Icons.home_outlined,
                size: 30,
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: KeyboardActions(
          config: _buildConfig(context),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          TextFormField(
                            controller: _amountController,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            maxLength: 6,
                            keyboardType: TextInputType.number,
                            focusNode: _amount,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 10),
                              labelText: "Amount",
                              disabledBorder: disableboarder,
                              errorBorder: errorboarder,
                              focusedBorder: focusboarder,
                              border: boarder,
                            ),
                            // validator: FormValidation().validateAmount,
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          InkWell(
                            onTap: () async {
                              DateTime? newDate = await showDatePicker(
                                context: context,
                                initialDate: date,
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: AppColor.primary,
                                        // <-- SEE HERE
                                        onPrimary: Colors.white,
                                        // <-- SEE HERE
                                        onSurface: Colors.black, // <-- SEE HERE
                                      ),
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                            // primary: AppColor.primary,
                                            // button text color
                                            ),
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (newDate == null) return;
                              setState(() {
                                date = newDate;
                                _seletedDate = true;
                              });
                            },
                            child: Container(
                              alignment: Alignment.centerLeft,
                              height: mediaQH(context) * 0.06,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black38, width: 1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              width: mediaQW(context) * 1,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: _seletedDate == false
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Date",
                                            style: mpHeadLine16(
                                                textColor: Colors.black54),
                                          ),
                                          const Icon(
                                            Icons.arrow_drop_down_sharp,
                                            color: Colors.black54,
                                          )
                                        ],
                                      )
                                    : Text(
                                        "${date.day.toString().length > 1 ? date.day : "0${date.day}"}/${date.month.toString().length > 1 ? date.month : "0${date.month}"}/${date.year}",
                                        style: mpHeadLine16(
                                            fontWeight: FontWeight.w500),
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: _descriptionController,
                            cursorColor: Colors.black,
                            minLines: 1,
                            maxLines: 20,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              labelText: "Description",
                              disabledBorder: disableboarder,
                              errorBorder: errorboarder,
                              focusedBorder: focusboarder,
                              border: boarder,
                            ),
                            // validator: FormValidation().validateDesciptionname,
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          CommonButtons(
                            buttonText: "Add",
                            buttonCall: () {
                              // isFirstTime = true;
                              // if (formKeyAddExpenses.currentState!.validate()) ;
                              // var todayDate = DateTime.now();
                              if (_amountController.text.isEmpty) {
                                toast(msg: "Please enter amount.");
                                return;
                              }
                              if (_amountController.text
                                  .replaceAll("0", "")
                                  .isEmpty) {
                                toast(msg: "Please enter a valid amount.");
                                return;
                              }
                              if (!_seletedDate) {
                                toast(msg: "Please select date.");
                                return;
                              }
                              if (_descriptionController.text.isEmpty) {
                                toast(msg: "Please enter description.");
                                return;
                              }
                              setState(() {
                                isLoading = true;
                              });
                              var addFeesExpenses = {
                                "caseId": widget.getCaseId.toString(),
                                "type": widget.type ? "1" : "0",
                                "amount": _amountController.text,
                                "date": getYYYYMMDDNew(date.toString()),
                                "description": _descriptionController.text,
                              };
                              BlocProvider.of<AddExpensesFeesCubit>(context)
                                  .fetchAddExpensesFees(addFeesExpenses);
                            },
                          ),
                        ],
                      ),
                      BlocConsumer<AddExpensesFeesCubit, AddExpensesFeesState>(
                          builder: (context, state) {
                        return const SizedBox();
                      }, listener: (context, state) {
                        if (state is AddExpensesFeesLoading) {
                          setState(() {
                            isLoading = true;
                          });
                        }
                        if (state is AddExpensesFeesLoaded) {
                          var addExpensesFeesList = state.addExpensesFeesModel;
                          if (addExpensesFeesList.result == 1) {
                            setState(() {
                              isLoading = false;
                            });
                            toast(msg: addExpensesFeesList.msg.toString());
                            Navigator.pop(context, true);
                            /*    showDialog(
                                context: context,
                                builder: (ctx) => AppMsgPopup(
                                      addExpensesFeesList.msg.toString(),
                                      isCloseIcon: false,
                                      isError: false,
                                      btnCallback: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context, true);
                                      },
                                    ));*/
                            // Navigator.pop(context);

                            // return const SizedBox();
                          } else {
                            setState(() {
                              isLoading = false;
                            });
                            showDialog(
                                context: context,
                                builder: (ctx) => AppMsgPopup(
                                      addExpensesFeesList.msg.toString(),
                                    ));
                          }
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      }),
                      // BlocConsumer<FeesCubit, FeesState>(builder: (context, state) {
                      //   return const SizedBox();
                      // }, listener: (context, state) {
                      //   if (state is FeesLoaded) {
                      //     setState(() {
                      //       isLoading=true;
                      //     });
                      //   }
                      //   if (state is FeesLoaded) {
                      //     var feesList = state.feesModel;
                      //     if (feesList.result == 1) {
                      //       setState(() {
                      //         isLoading=false;
                      //       });
                      //       Navigator.pop(context);
                      //     } else {
                      //       toast(msg: feesList.msg.toString());
                      //     }
                      //   }
                      // }),
                      // BlocConsumer<ExpensesCubit, ExpensesState>(builder: (context, state) {
                      //   return const SizedBox();
                      // }, listener: (context, state) {
                      //   if (state is ExpensesLoaded) {
                      //     var expensesList = state.expensesModel;
                      //     if (expensesList.result == 1) {
                      //       Navigator.pop(context);
                      //     } else {
                      //       toast(msg: expensesList.msg.toString());
                      //     }
                      //   }
                      // }),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: isLoading,
                child: const Center(child: AppProgressIndicator()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
