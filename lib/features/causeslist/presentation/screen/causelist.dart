import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:haelo_flutter/constants.dart';
import 'package:haelo_flutter/core/utils/functions.dart';
import 'package:haelo_flutter/core/utils/save_file.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/alert/presentation/myalerts.dart';
import 'package:haelo_flutter/features/causeslist/cubit/main_causelistdata_cubit.dart';
import 'package:haelo_flutter/features/causeslist/cubit/main_causelistdata_state.dart';
import 'package:haelo_flutter/features/causeslist/cubit/viewandsave_cubit.dart';
import 'package:haelo_flutter/features/causeslist/cubit/viewandsave_state.dart';
import 'package:haelo_flutter/features/causeslist/cubit/viewcauselist_cubit.dart';
import 'package:haelo_flutter/features/causeslist/cubit/viewcauselist_state.dart';
import 'package:haelo_flutter/features/causeslist/data/model/showwatchlist_model.dart';
import 'package:haelo_flutter/features/causeslist/presentation/screen/causelist_page.dart';
import 'package:haelo_flutter/features/causeslist/presentation/widget/case_nos.dart';
import 'package:haelo_flutter/features/causeslist/presentation/widget/causelist_heading%20name.dart';
import 'package:haelo_flutter/features/causeslist/presentation/widget/causelist_popups.dart';
import 'package:haelo_flutter/features/causeslist/presentation/widget/customizetextfield.dart';
import 'package:haelo_flutter/features/causeslist/presentation/widget/lawyers.dart';
import 'package:haelo_flutter/locators.dart' as di;
import 'package:haelo_flutter/widgets/date_format.dart';
import 'package:haelo_flutter/widgets/date_widget.dart';
import 'package:haelo_flutter/widgets/go_prime.dart';
import 'package:haelo_flutter/widgets/progress_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../drawer_content/presentation/widgets/textformfield_decoration.dart';
import '../widget/causelist_calendar.dart';
import '../widget/download_causlist.dart';

class CauseList extends StatefulWidget {
  // final selectedLawyer;
  bool isFromHome;
  CauseList({this.isFromHome = false, Key? key}) : super(key: key);

  @override
  State<CauseList> createState() => _CauseListState();
}

class _CauseListState extends State<CauseList> {
  TextEditingController caveatNameController = TextEditingController();

  // TextEditingController _courtNumberController = TextEditingController();

  String showSelectedLawyerData = "Select";
  int showSelectedLawyerIndex = 0;
  String selectedValueListType = "";
  String selectedValueCourtNum = "";
  String selectedValueJudgeName = "";
  String selectedValueCaseNum = "";
  String selectedValuePartyName = "";
  String selectedValueJudgeTime = "";
  String searchedLawyer = "";

  DateTime dateFrom = DateTime.now();
  bool _seletedDate = false;

  bool _selectedToDate = false;
  DateTime? dateTo;

  //List for Search Operation
  List courtNumberSearchList = [];

  var defaultValue = DateTime.now();
  var viewSaveModelData;
  List<CauseWatchlist>? displayWatchList = [];
  var mainCauseListData;
  bool isLoading = true;

  var selectString = "Select";
  bool isToDateSelected = false;
  late SharedPreferences pref;
  int alreadyCreatedWatchlistCount = 0;

  bool isSelectedOneFilter = false;

  //download
  bool isDownloading = false;

  void setValueData(selectedValues, indexNum) {
    if (indexNum == 1) {
      selectedValueListType = selectedValues;
      // print("selectedValueListType-------$selectedValueListType");
    } else if (indexNum == 2) {
      selectedValueCourtNum = selectedValues;
    } else if (indexNum == 3) {
      selectedValueJudgeName = selectedValues;
    } else if (indexNum == 4) {
      selectedValueCaseNum = selectedValues;
      // print("selectedValueCaseNum-------$selectedValueCaseNum");
    } else if (indexNum == 5) {
      selectedValuePartyName = selectedValues;
    } else {
      selectedValueJudgeTime = selectedValues;
    }
    isSelectedOneFilter = true;
  }

  void setSelectedDate(dateSelected, isFrom) {
    if (isFrom) {
      dateFrom = dateSelected;
      // isToDateSelected=false;
      // dateTo=null;
    } else {
      dateTo = dateSelected;
      isToDateSelected = true;
    }
    setState(() {});
  }

  void setLawyerDataCallback(String lawyerNames) {
    // print("lawyerNames/// $lawyerNames");
    setState(() {
      showSelectedLawyerData = lawyerNames;
      isSelectedOneFilter = true;
    });
    // print("setLawyerData");
  }

  void setCaseNoCallback(String caseNo) {
    // print("lawyerNames/// $lawyerNames");
    setState(() {
      selectedValueCaseNum = caseNo;
      isSelectedOneFilter = true;
    });
    // print("setLawyerData");
  }

  void todateClear(state) {
    state(() {
      dateTo = null;
      isToDateSelected = false;
    });
  }

  @override
  void initState() {
    pref = di.locator();
    if (widget.isFromHome) {
      toast(msg: "Create Quick Search");
    }
    fetchData();
    // print("widget.selectedLawyer ${widget.selectedLawyer}");

    super.initState();
  }

  fetchData() {
    var mainCauseList = {
      "dateFrom": getDDMMYYYY(dateFrom.toString()),
      "dateTo": dateTo != null ? getDDMMYYYY(dateTo.toString()) : "",
    };
    setState(() {
      isLoading = true; // Show loader
      mainCauseListData = null; // Reset mainCauseListData
    });
    BlocProvider.of<MainCauseListDataCubit>(context)
        .fetchMainCauseListData(mainCauseList);
  }

  downloadData(String file, String fileName) async {
    await downloadFiles(file, fileName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColor.home_background,
      appBar: AppBar(
          elevation: 0,
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              !widget.isFromHome
                  ? InkWell(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: Icon(Icons.menu),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: const Icon(
                          Icons.arrow_back_ios_new_sharp,
                          size: 24,
                        ),
                      ),
                    ),
              Expanded(
                child: Text(
                  "Cause List",
                  style: mpHeadLine18(
                      fontWeight: FontWeight.w500,
                      textColor: AppColor.bold_text_color_dark_blue),
                ),
              ),
            ],
          ),
          actions: [
            MultiBlocProvider(
              providers: [
                BlocProvider<ViewCauseListCubit>(
                    create: (BuildContext context) =>
                        ViewCauseListCubit(di.locator())),
              ],
              child: Builder(builder: (context) {
                return BlocConsumer<ViewCauseListCubit, ViewCauseListState>(
                  builder: (context, state) {
                    return isDownloading
                        ? Center(
                            child: Container(
                                height: 20,
                                width: 20,
                                margin: EdgeInsets.only(right: 10),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                )))
                        : InkWell(
                            onTap: () {
                              print("isPrime(pref) ${isPrime(pref)}");
                              if (!isPrime(pref)) {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                showDialog(
                                    context: context,
                                    builder: (ctx) => SafeArea(
                                          child: GoPrime(),
                                        ));
                                return;
                              }
                              // DateTime firstDate = DateFormat("dd/MM/yyyy")
                              //     .parse(dateFrom.toString());
                              //
                              // DateTime? lastDate;

                              if (dateTo != null) {
                                // lastDate = DateFormat("dd/MM/yyyy")
                                //     .parse(dateTo.toString());
                                // print("hello ${lastDate.difference(firstDate).inDays}");
                                if (dateTo!.difference(dateFrom).inDays > 30) {
                                  toast(
                                      msg:
                                          "You can not download more than 1 month data. Please select date accordingly.");
                                  return;
                                  // lastDate=firstDate.add(Duration(days: 30));
                                }
                                //print("lastDate ${lastDate!}");
                              }

                              String lawyerName = "";
                              if (showSelectedLawyerData.toString() !=
                                  "Select") {
                                lawyerName = showSelectedLawyerData.toString();
                                if (showSelectedLawyerData.isNotEmpty) {
                                  lawyerName = "$lawyerName, $searchedLawyer";
                                }
                                // print('??111lawyername $lawyerName');
                              } else {
                                if (showSelectedLawyerData.isNotEmpty) {
                                  lawyerName = showSelectedLawyerData;
                                }
                              }
                              var viewModelData = {
                                "dateFrom": getDDMMYYYY(dateFrom.toString()),
                                "dateTo": dateTo != null
                                    ? getDDMMYYYY(dateTo.toString())
                                    : "",
                                "causeListType":
                                    selectedValueListType.toString(),
                                "courtNo": selectedValueCourtNum.toString(),
                                "benchName": selectedValueJudgeName.toString(),
                                "caseNo": selectedValueCaseNum.toString(),
                                "lawyerName": lawyerName.toString(),
                                "partyName": selectedValuePartyName.toString(),
                                "judgeTime": selectedValueJudgeTime.toString(),
                                "caveatName": caveatNameController.text,
                                "pageNo": "1"
                              };

                              showDialog(
                                  context: context,
                                  builder: (ctx) => DownloadCauseList(
                                      viewModelData, context,
                                      isOnlyExcel: true),
                                  barrierColor: Colors.black26);
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.download),
                            ),
                          );
                  },
                  listener: (context, state) {
                    if (state is ViewCauseListLoading) {
                      setState(() {
                        isDownloading = true;
                      });
                    }
                    if (state is ViewCauseListLoaded) {
                      var viewCauseModel = state.viewCauseListModel;
                      if (viewCauseModel.result == 1 &&
                          viewCauseModel.data != null &&
                          state.viewCauseListModel!.data!.excel_url != null &&
                          state.viewCauseListModel!.data!.excel_url!
                              .isNotEmpty) {
                        toast(msg: "Downloading started");
                        DateTime now = DateTime.now();
                        var fileName =
                            "HAeLo_File_causesList_${getYYYYMMDDownload(getDDMMYYYY(dateFrom.toString()))}_${now.millisecondsSinceEpoch}.${state.viewCauseListModel!.data!.excel_url!.toString().split(".").last}";

                        downloadData(state.viewCauseListModel!.data!.excel_url!,
                            fileName);
                        setState(() {
                          isDownloading = false;
                        });
                      } else {
                        setState(() {
                          isDownloading = false;
                        });
                      }
                    }
                  },
                );
              }),
            ),
            Container(
              margin: const EdgeInsets.only(right: 15, left: 7),
              child: !widget.isFromHome
                  ? InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyAlerts()));
                      },
                      child: SvgPicture.asset(ImageConstant.bell),
                    )
                  : GestureDetector(
                      onTap: () {
                        goToHomePage(context);
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.home_outlined,
                          size: 30,
                        ),
                      ),
                    ),
            )
          ]),
      body: SafeArea(
        child: Stack(
          children: [
            BlocConsumer<MainCauseListDataCubit, MainCauseListDataState>(
              builder: (context, state) {
                if (isLoading || mainCauseListData == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return const SizedBox();
                }
              },
              listener: (context, state) {
                if (state is MainCauseListDataLoading) {
                  setState(() {
                    isLoading = true;
                  });
                }
                if (state is MainCauseListDataLoaded) {
                  var causeListDataModel = state.mainCauseListDataModel;
                  if (causeListDataModel.result == 1) {
                    mainCauseListData = causeListDataModel.data;
                    setState(() {
                      isLoading = true;
                    });
                    if (mainCauseListData != null &&
                        mainCauseListData.lawyerName.isNotEmpty) {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  } else {
                    toast(msg: causeListDataModel.msg.toString());
                    setState(() {
                      isLoading = false;
                    });
                  }
                }
              },
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, top: 5, bottom: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CauseListHeadingName(
                                    headingText: "From Date"),
                                const SizedBox(
                                  height: 5,
                                ),
                                InkWell(
                                  onTap: () {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    AppFromDatePicker()
                                        .pickDate(context, DateTime.now(),
                                            DateTime(2000), DateTime(2100))
                                        .then((value) {
                                      if (value != null) {
                                        clearFilter();
                                        setState(() {
                                          dateFrom = value;
                                          dateTo = null;
                                          isToDateSelected = false;
                                        });
                                        print("dateFrom $dateFrom");
                                        fetchData();
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
                                // DateWidget(true,setSelectedDate, ),
                                // CauseListCalendar(
                                //   selectedDate: _seletedDate,
                                //   currentDate: dateFrom,
                                //   setDate: setSelectedDate,
                                //   defaultValue: defaultValue,
                                // ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CauseListHeadingName(
                                    headingText: "To Date"),
                                const SizedBox(
                                  height: 5,
                                ),
                                InkWell(
                                  onTap: () {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    AppDatePicker()
                                        .pickDate(context, dateFrom, dateFrom,
                                            dateFrom.add(Duration(days: 90)))
                                        .then((value) {
                                      if (value != null) {
                                        setState(() {
                                          dateTo = value;
                                          isToDateSelected = true;
                                          fetchData();
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
                                    closeIconCallback: todateClear,
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
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const CauseListHeadingName(
                            headingText: "Cause List Type"),
                        const SizedBox(
                          height: 5,
                        ),
                        InkWell(
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            if (mainCauseListData != null &&
                                mainCauseListData.causeListType.isNotEmpty) {
                              showDialog(
                                  context: context,
                                  builder: (ctx) => CauseListPopup(
                                      mainCauseListData.causeListType,
                                      1,
                                      setValueData));
                            }
                          },
                          child: CustomContainer(
                            displayData: selectedValueListType.isNotEmpty
                                ? selectedValueListType
                                : selectString,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const CauseListHeadingName(
                          headingText: "Court Number",
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        InkWell(
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            if (mainCauseListData != null &&
                                mainCauseListData.courtNo.isNotEmpty) {
                              showDialog(
                                  context: context,
                                  builder: (ctx) => CauseListPopup(
                                      mainCauseListData.courtNo,
                                      2,
                                      setValueData));
                            }
                          },
                          child: CustomContainer(
                            displayData: selectedValueCourtNum.isNotEmpty
                                ? selectedValueCourtNum
                                : selectString,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const CauseListHeadingName(
                          headingText: "Judge Name",
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        InkWell(
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            if (mainCauseListData != null &&
                                mainCauseListData.benchName.isNotEmpty) {
                              showDialog(
                                  context: context,
                                  builder: (ctx) => CauseListPopup(
                                      mainCauseListData.benchName,
                                      3,
                                      setValueData));
                            }
                          },
                          child: CustomContainer(
                            displayData: selectedValueJudgeName.isNotEmpty
                                ? selectedValueJudgeName
                                : selectString,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const CauseListHeadingName(
                          headingText: "Case Number",
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        InkWell(
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            if (mainCauseListData != null &&
                                mainCauseListData.caseNo.isNotEmpty) {
                              showDialog(
                                  context: context,
                                  builder: (ctx) => CaseNoWidget(
                                      mainCauseListData.caseNo,
                                      setCaseNoCallback));
                            }
                          },
                          child: CustomContainer(
                            displayData: selectedValueCaseNum.isNotEmpty
                                ? selectedValueCaseNum
                                : selectString,
                          ),
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
                        InkWell(
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              if (mainCauseListData != null &&
                                  mainCauseListData.lawyerName.isNotEmpty) {
                                showDialog(
                                    context: context,
                                    builder: (ctx) => Lawyers(
                                        mainCauseListData,
                                        setLawyerDataCallback,
                                        setSearchedLawyer,
                                        showSelectedLawyerData));
                              }
                            },
                            child: CustomContainer(
                              displayData: showSelectedLawyerData.toString(),
                            )),
                        /*const SizedBox(
                          height: 5,
                        ),
                        searchedLawyer.isNotEmpty
                            ? CustomContainer(
                                displayData: searchedLawyer.toString(),
                                isDropDown: false,
                              )
                            : SizedBox(),*/
                        const SizedBox(
                          height: 10,
                        ),
                        const CauseListHeadingName(
                          headingText: "Party Name",
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        InkWell(
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            if (mainCauseListData != null &&
                                mainCauseListData.partyName.isNotEmpty) {
                              showDialog(
                                  context: context,
                                  builder: (ctx) => CauseListPopup(
                                      mainCauseListData.partyName,
                                      5,
                                      setValueData));
                            }
                          },
                          child: CustomContainer(
                            displayData: selectedValuePartyName.isNotEmpty
                                ? selectedValuePartyName
                                : selectString,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const CauseListHeadingName(
                          headingText: "Judge Time",
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        InkWell(
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            if (mainCauseListData != null &&
                                mainCauseListData.judgeTime.isNotEmpty) {
                              showDialog(
                                  context: context,
                                  builder: (ctx) => CauseListPopup(
                                      mainCauseListData.judgeTime,
                                      6,
                                      setValueData));
                            }
                          },
                          child: CustomContainer(
                            displayData: selectedValueJudgeTime.isNotEmpty
                                ? selectedValueJudgeTime
                                : selectString,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const CauseListHeadingName(
                          headingText: "Caveatee Name",
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          height: 35,
                          child: TextField(
                            controller: caveatNameController,
                            decoration: InputDecoration(
                              alignLabelWithHint: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              hintText: "Enter Caveatee Name",
                              labelStyle: const TextStyle(color: Colors.black),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: const BorderSide(
                                    width: 1, color: Colors.black),
                              ),
                              disabledBorder: disableboarder,
                              errorBorder: errorboarder,
                              focusedBorder: focusboarder,
                              border: boarder,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            // print("lawyer_count ${mainCauseListData.lawyer_count}");
                            if (!isPrime(pref)) {
                              if (mainCauseListData.lawyer_count > 0) {
                                //show a popup with a msg and go prime option
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                showDialog(
                                    context: context,
                                    builder: (ctx) => SafeArea(
                                          child: GoPrime(),
                                        ));
                                return;
                              }
                            }
                            DateTime today = DateTime.now();

                            if (dateTo != null && dateTo!.isBefore(dateFrom)) {
                              toast(msg: "To date cant be less than From date");
                              return;
                            }

                            // if (!isToDateSelected &&
                            //     today.difference(dateFrom).inDays > 0) {
                            //   toast(msg: "Please select To date");
                            //   return;
                            // }
                            if (!isToDateSelected &&
                                today.difference(dateFrom).inDays > 0) {
                              setState(() {
                                DateFormat format = DateFormat("dd/MM/yyyy");
                                print(
                                    format.parse(mainCauseListData.cause_date));
                                dateTo =
                                    format.parse(mainCauseListData.cause_date);
                                print("date $dateTo");
                              });
                              // toast(msg: "Please select To date");
                              // return;
                            } else {
                              setState(() {
                                dateTo = null;
                              });
                            }

                            // String lawyerName = "";
                            // if (showSelectedLawyerData.toString() != "Select") {
                            //   lawyerName = showSelectedLawyerData.toString();
                            // }

                            // print(
                            //     "selectedValueCaseNum? $selectedValueCaseNum");
                            // print(
                            //     "selectedValueCaseNum?? $showSelectedLawyerData");
                            if (showSelectedLawyerData.toString() == "Select" &&
                                (selectedValueCaseNum.isEmpty ||
                                    selectedValueCaseNum == "None")) {
                              toast(
                                  msg:
                                      "Please select lawyer name or case number!!");
                              return;
                            }
                            showDialog(
                                context: context,
                                builder: (ctx) {
                                  return AlertDialog(
                                    // insetPadding: EdgeInsets.symmetric(vertical: 305),
                                    contentPadding: EdgeInsets.zero,
                                    content: SizedBox(
                                      height: mediaQH(context) * 0.16,
                                      width: mediaQW(context) * 0.9,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 25),
                                            child: Text(
                                              "Alerts can be set for Lawyer name or case number.Are you sure you want to continue?",
                                              textAlign: TextAlign.center,
                                              style: mpHeadLine14(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    String lawyerName = "";
                                                    if (showSelectedLawyerData
                                                            .toString() !=
                                                        "Select") {
                                                      lawyerName =
                                                          showSelectedLawyerData
                                                              .toString();
                                                      if (searchedLawyer
                                                          .isNotEmpty) {
                                                        lawyerName =
                                                            "$lawyerName, $searchedLawyer";
                                                      }
                                                      print(
                                                          '??111lawyername $lawyerName');
                                                    } else {
                                                      if (searchedLawyer
                                                          .isNotEmpty) {
                                                        lawyerName =
                                                            searchedLawyer;
                                                      }
                                                    }
                                                    print(
                                                        '??lawyername $lawyerName');
                                                    viewSaveModelData = {
                                                      "dateFrom": getDDMMYYYY(
                                                          dateFrom.toString()),
                                                      "dateTo": dateTo != null
                                                          ? getDDMMYYYY(
                                                              dateTo.toString())
                                                          : "",
                                                      "causeListType":
                                                          selectedValueListType
                                                              .toString(),
                                                      "courtNo":
                                                          selectedValueCourtNum
                                                              .toString(),
                                                      "judgeName":
                                                          selectedValueJudgeName
                                                              .toString(),
                                                      "caseNo":
                                                          selectedValueCaseNum
                                                              .toString(),
                                                      "lawyerName":
                                                          lawyerName.toString(),
                                                      "partyName":
                                                          selectedValuePartyName
                                                              .toString(),
                                                      "judgeTime":
                                                          selectedValueJudgeTime
                                                              .toString(),
                                                      "caveatName":
                                                          caveatNameController
                                                              .text
                                                    };
                                                    var viewValueList = {
                                                      "lawyer":
                                                          lawyerName.toString(),
                                                      "FROM_DATE": getDDMMYYYY(
                                                          dateFrom.toString()),
                                                      "TO_DATE": dateTo != null
                                                          ? getDDMMYYYY(
                                                              dateTo.toString())
                                                          : "",
                                                      "COURT_NUMBER":
                                                          selectedValueCourtNum
                                                              .toString(),
                                                      "SELECTED_JUDGES_NAME":
                                                          selectedValueJudgeName
                                                              .toString(),
                                                      "SELECTED_CAUSE_TYPE":
                                                          selectedValueListType
                                                              .toString(),
                                                      "SELECTED_CASE_NUMBER":
                                                          selectedValueCaseNum
                                                              .toString(),
                                                      "SELECTED_LAWYER_NAME":
                                                          lawyerName.toString(),
                                                      "SELECTED_PARTY_NAME":
                                                          selectedValuePartyName
                                                              .toString(),
                                                      "alert_id": "",
                                                    };
                                                    var viewList = {
                                                      "filter": jsonEncode(
                                                          viewValueList)
                                                    };
                                                    //print("viewList $viewList");
                                                    Navigator.pop(context);
                                                    BlocProvider.of<
                                                                ViewSaveCubit>(
                                                            context)
                                                        .fetchViewSave(
                                                            viewList);
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    height:
                                                        mediaQH(context) * 0.05,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        5)),
                                                        border: Border.all(
                                                            color: AppColor
                                                                .primary)),
                                                    child: Text(
                                                      "YES",
                                                      style: mpHeadLine14(
                                                          textColor:
                                                              AppColor.primary),
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
                                                    height:
                                                        mediaQH(context) * 0.05,
                                                    decoration:
                                                        const BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          5)),
                                                      color: AppColor.primary,
                                                    ),
                                                    child: Text(
                                                      "NO",
                                                      style: mpHeadLine16(
                                                          textColor:
                                                              AppColor.white),
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
                          child: Container(
                            alignment: Alignment.center,
                            height: mediaQH(context) * 0.05,
                            decoration: BoxDecoration(
                                border: Border.all(color: AppColor.primary)),
                            child: Text(
                              "View & Save Alert",
                              style: mpHeadLine16(textColor: AppColor.primary),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            DateTime today = DateTime.now();

                            String toDate = "";
                            // print("diff ${today}  $dateFrom");
                            // print("diff>> ${today.difference(dateFrom).inDays}");
                            // print("diff/// ${today.isBefore(dateFrom)}");
                            // print("diff??? ${today.isAfter(dateFrom)}");
                            // if(dateTo!=null)
                            // print("toDate ${dateTo!.difference(dateFrom).inDays}");
                            // print("isToDateSelected ${isToDateSelected}");
                            // print("dateTo ${dateTo}");

                            if (dateTo != null &&
                                dateTo!.difference(dateFrom).inDays < 0) {
                              toast(msg: "To date cant be less than From date");
                              return;
                            }

                            if (!isToDateSelected &&
                                today.difference(dateFrom).inDays > 0) {
                              setState(() {
                                DateFormat format = DateFormat("dd/MM/yyyy");
                                print(
                                    format.parse(mainCauseListData.cause_date));
                                dateTo =
                                    format.parse(mainCauseListData.cause_date);
                                // print("date $dateTo");
                              });
                            }
                            // else{
                            //   setState(() {
                            //     dateTo=null;
                            //   });
                            // }
                            // if(isToDateSelected && )

                            String lawyerName = "";
                            if (showSelectedLawyerData.toString() != "Select") {
                              lawyerName = showSelectedLawyerData.toString();
                              if (searchedLawyer.isNotEmpty) {
                                lawyerName = "$lawyerName, $searchedLawyer";
                              }
                              // print('??111lawyername $lawyerName');
                            } else {
                              if (searchedLawyer.isNotEmpty) {
                                lawyerName = searchedLawyer;
                              }
                            }
                            print(
                                "selectedValuePartyName $selectedValuePartyName");
                            if (!isSelectedOneFilter) {
                              toast(msg: "Please select any other filter also");
                              return;
                            }

                            var viewModelData = {
                              "dateFrom": getDDMMYYYY(dateFrom.toString()),
                              "dateTo": dateTo != null
                                  ? getDDMMYYYY(dateTo.toString())
                                  : "",
                              "causeListType": selectedValueListType.toString(),
                              "courtNo": selectedValueCourtNum.toString(),
                              "judgeName": selectedValueJudgeName.toString(),
                              "caseNo": selectedValueCaseNum.toString(),
                              "lawyerName": lawyerName.toString(),
                              "partyName": selectedValuePartyName.toString(),
                              "judgeTime": selectedValueJudgeTime.toString(),
                              "caveatName": caveatNameController.text
                            };
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ViewCauseListScreenNew(
                                          mainCauseListdata: viewModelData,
                                          isFromHomepage: true,
                                        )));
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: mediaQH(context) * 0.05,
                            decoration: const BoxDecoration(
                              color: AppColor.primary,
                            ),
                            child: Text(
                              "View",
                              style: mpHeadLine16(textColor: AppColor.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: InkWell(
                      onTap: () {
                        clearFilter();
                      },
                      child: Text(
                        "Clear Filter",
                        style: mpHeadLine16(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            BlocConsumer<ViewSaveCubit, ViewSaveState>(
                builder: (context, state) {
              return const SizedBox();
            }, listener: (context, state) {
              if (state is ViewSaveLoading) {
                setState(() {
                  isLoading = true;
                });
              } else {
                setState(() {
                  isLoading = false;
                });
              }
              if (state is ViewSaveLoaded) {
                var viewSaveList = state.viewSaveModel;
                if (viewSaveList.result == 1) {
                  mainCauseListData.lawyer_count++;
                  toast(msg: viewSaveList.msg.toString());
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewCauseListScreenNew(
                                mainCauseListdata: viewSaveModelData,
                                isFromHomepage: true,
                              )));
                } else {
                  toast(msg: viewSaveList.msg.toString());
                }
              }
            }),
            Visibility(
              visible: isLoading,
              child: const Center(child: AppProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }

  void setSearchedLawyer(String name) {
    setState(() {
      searchedLawyer = name;
    });
  }

  void clearFilter() {
    setState(() {
      isLoading = true;
      dateTo = null;
      isToDateSelected = false;
      dateFrom = DateTime.now();
      showSelectedLawyerData = "Select";
      showSelectedLawyerIndex = 0;
      selectedValueListType = "";
      selectedValueCourtNum = "";
      selectedValueJudgeName = "";
      selectedValueCaseNum = "";
      selectedValuePartyName = "";
      selectedValueJudgeTime = "";
      selectString = "Select";
      caveatNameController.text = "";
      searchedLawyer = "";
      isSelectedOneFilter = false;
    });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
  }
}
