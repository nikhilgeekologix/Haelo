import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/widgets/commonButtons.dart';

import '../../../core/utils/functions.dart';
import '../../../core/utils/ui_helper.dart';
import '../../../widgets/date_format.dart';
import '../../../widgets/date_widget.dart';
import '../../../widgets/error_widget.dart';
import '../../alert/cubit/my_alert_cubit.dart';
import '../../alert/cubit/my_alert_state.dart';
import '../../alert/data/model/my_alert_model.dart';
import '../../causeslist/presentation/widget/causelist_heading name.dart';
import '../../causeslist/presentation/widget/customizetextfield.dart';
import '../cubit/displayboard_item_stage_cubit.dart';
import '../cubit/displayboard_item_stage_state.dart';

class MassAdditionOfCase extends StatefulWidget {
  const MassAdditionOfCase({super.key});

  @override
  State<MassAdditionOfCase> createState() => _NewWorkState();
}

class _NewWorkState extends State<MassAdditionOfCase> {
  bool isLoading = true;
  String selectedLawyerName = "";
  List<Lawyerlist> lawyerList = [];
  DateTime dateFrom = DateTime.now();
  DateTime? dateTo;
  String display_board_note =
      "Your cases for the above selected option would be created automatically everyday in advance.";
  List<String> myCases = ["2 (D)", "4 (D)", "6 (D)"];
  List<String> hideCases = ["3 (D)", "7 (D)", "9 (D)"];

  @override
  void initState() {
    BlocProvider.of<MyAlertCubit>(context).fetchMyAlert();

    List<String> mergedList = mergeListsAlternately(myCases, hideCases);

    for (String caseValue in mergedList) {
      print("Case: $caseValue");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.home_background,
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
          "Mass addition of cases",
          style: mpHeadLine16(
              fontWeight: FontWeight.w500,
              textColor: AppColor.bold_text_color_dark_blue),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocConsumer<MyAlertCubit, MyAlertState>(
              builder: (context, state) {
                return const SizedBox();
              },
              listener: (context, state) {
                if (state is MyAlertLoading) {
                  setState(() {
                    isLoading = true;
                  });
                }
                if (state is MyAlertLoaded) {
                  var alertModel = state.myAlertModel;
                  if (alertModel.result == 1) {
                    setState(() {
                      lawyerList = (alertModel.data!.lawyerlist ?? [])
                          .where((entry) => entry.lawyerName!.trim().isNotEmpty)
                          .toList();

                      selectedLawyerName = lawyerList.isNotEmpty
                          ? lawyerList[0].lawyerName!.trim()
                          : '';

                      isLoading = false;
                    });
                  } else {
                    setState(() {
                      lawyerList = [];
                      isLoading = false;
                    });
                  }
                }
              },
            ),
            const SizedBox(
              height: 10,
            ),
            const CauseListHeadingName(
              headingText: "Lawyer Name",
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColor.black)),
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: DropdownButton<String>(
                isExpanded: true,
                value: selectedLawyerName,
                underline: SizedBox(),
                onChanged: (newValue) {
                  setState(() {
                    selectedLawyerName = newValue!;
                  });
                },
                items: lawyerList.map((Lawyerlist item) {
                  return DropdownMenuItem<String>(
                    value: item.lawyerName.toString(),
                    child: Text(
                      item.lawyerName.toString(),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            /* Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CauseListHeadingName(headingText: "From Date"),
                    const SizedBox(
                      height: 5,
                    ),
                    InkWell(
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        AppDatePicker()
                            .pickDate(context, DateTime.now(), DateTime(2000),
                                DateTime(2100))
                            .then((value) {
                          if (value != null) {
                            toDateClear;
                            setState(() {
                              dateFrom = value;
                              dateTo = null;
                            });
                            print("dateFrom $dateFrom");
                          }
                        });
                      },
                      child: CustomContainer(
                        displayData:
                            "${dateFrom.day.toString().length > 1 ? dateFrom.day : "0${dateFrom.day}"}/${dateFrom.month.toString().length > 1 ? dateFrom.month : "0${dateFrom.month}"}/${dateFrom.year}",
                        width: mediaQW(context) * 0.44,
                        isDropDown: false,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CauseListHeadingName(headingText: "To Date"),
                    const SizedBox(
                      height: 5,
                    ),
                    InkWell(
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        AppDatePicker()
                            .pickDate(context, dateFrom, dateFrom,
                                dateFrom.add(Duration(days: 90)))
                            .then((value) {
                          if (value != null) {
                            setState(() {
                              dateTo = value;
                            });
                          }
                        });
                      },
                      child: CustomContainer(
                        displayData: dateTo != null
                            ? "${dateTo!.day.toString().length > 1 ? dateTo!.day : "0${dateTo!.day}"}/${dateTo!.month.toString().length > 1 ? dateTo!.month : "0${dateTo!.month}"}/${dateTo!.year}"
                            : "DD/MM/YYYY",
                        width: mediaQW(context) * 0.44,
                        isDropDown: false,
                        isClose: dateTo != null ? true : false,
                        closeIconCallback: toDateClear,
                        closeState: setState,
                      ),
                    ),

                    // CauseListCalendar(
                    //   selectedDate: _selectedToDate,
                    //   currentDate: dateTo,
                    //   setDate: setSelectedDate,
                    //   isToDate: true,
                    //   defaultValue: defaultValue,
                    //   fromDateForDisable: dateFrom,
                    // ),
                    // DateWidget(false,setSelectedDate,isToDateSelected: isToDateSelected, ),
                  ],
                )
              ],
            ),*/
            const SizedBox(
              height: 20,
            ),
            Text(
              display_board_note,
              style: appTextStyle(
                  fontSize: 14,
                  textColor: Colors.redAccent,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              child: Text(
                "Save",
                style: mpHeadLine16(textColor: Colors.white),
              ),
              style: ButtonStyle(
                  fixedSize:
                      MaterialStateProperty.all(Size(mediaQW(context), 40)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30))),
                  backgroundColor: MaterialStateProperty.all(AppColor.primary)),
              onPressed: () {
                if (selectedLawyerName == "") {
                  toast(msg: "Please select Lawyer Name");
                } /*else if (dateTo == null) {
                  toast(msg: "Please select To Date");
                } else if (dateTo!.difference(dateFrom).inDays < 0) {
                  toast(msg: "To date cant be less than From date");
                }*/
                else {
                  DateTime currentDate = DateTime.now();
                  print("Current Date: $currentDate");
                  /*    var massData = {
                    "lawyer_name": selectedLawyerName,
                    "from_date": getDDMMYYYY(dateFrom.toString()),
                    "to_date":
                        dateTo != null ? getDDMMYYYY(dateTo.toString()) : "",
                  };*/

                  var massData = {
                    "lawyer_name": selectedLawyerName,
                    "from_date": getDDMMYYYY(currentDate.toString()),
                    "to_date": getDDMMYYYY(currentDate.toString()),
                  };
                  print(massData);
                  BlocProvider.of<DisplayBoardMassDataCubit>(context)
                      .fetchDisplayBoardItemStage(massData);
                }
              },
            ),
            BlocConsumer<DisplayBoardMassDataCubit, DisplayBoardMassDataState>(
              builder: (context, state) {
                return const SizedBox();
              },
              listener: (context, state) {
                if (state is DisplayBoardStageItemLoading) {
                  setState(() {
                    isLoading = true;
                  });
                }
                if (state is DisplayBoardMassDataLoaded) {
                  var addCommentList = state.displayBoardMassDataModel;
                  if (addCommentList.result == 1) {
                    setState(() {
                      isLoading = false;
                    });
                    print("comment added");
                    toast(msg: addCommentList.msg.toString());
                    Navigator.pop(context, true);
                    /*  showDialog(
                        context: context,
                        builder: (ctx) => AppMsgPopup(
                              addCommentList.msg.toString(),
                              isCloseIcon: false,
                              isError: false,
                              btnCallback: () {
                                Navigator.pop(context);

                              },
                            ));*/
                    // var caseIdDetails = {
                    //   "caseId": widget.getCaseIdd.toString(),
                    // };
                    // BlocProvider.of<CasesCommentCubit>(context)
                    //     .fetchCasesComment(caseIdDetails);
                  } else {
                    setState(() {
                      isLoading = false;
                    });
                    showDialog(
                        context: context,
                        builder: (ctx) => AppMsgPopup(
                              addCommentList.msg.toString(),
                            ));
                  }
                }
              },
            ),
          ],
        ),
      )),
    );
  }

  void toDateClear(state) {
    state(() {
      dateTo = null;
    });
  }

  List<String> mergeListsAlternately(List<String> list1, List<String> list2) {
    List<String> result = [];

    for (int i = 0; i < list1.length; i++) {
      result.add(list1[i]);
      result.add(list2[i]);
    }

    return result;
  }
}
