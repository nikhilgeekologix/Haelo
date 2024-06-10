import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_list_view/flutter_list_view.dart';
import 'package:googleapis/admob/v1.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/alert/data/datasource/my_alert_datasource.dart';
import 'package:haelo_flutter/features/causeslist/presentation/screen/causelist_page.dart';
import 'package:flutter/scheduler.dart';
import 'package:haelo_flutter/features/causeslist/data/model/date_court_model.dart';
import 'package:haelo_flutter/features/causeslist/presentation/widget/causelist_heading%20name.dart';
import 'package:haelo_flutter/features/causeslist/presentation/widget/customizetextfield.dart';
import 'package:haelo_flutter/features/causeslist/presentation/widget/datelist_courtno_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/constants.dart';
import 'package:haelo_flutter/core/utils/functions.dart';
import 'package:haelo_flutter/core/utils/save_file.dart';
import 'package:haelo_flutter/features/alert/cubit/my_alert_cubit.dart';
import 'package:haelo_flutter/features/alert/cubit/my_alert_state.dart';
import 'package:haelo_flutter/features/cases/cubit/deletecomment_state.dart';
import 'package:haelo_flutter/features/cases/presentation/screens/addcomment.dart';
import 'package:haelo_flutter/features/cases/presentation/screens/casedetails.dart';
import 'package:haelo_flutter/features/cases/presentation/screens/updatecomment.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/color_node.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/no_data_widget.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/pdf_screen.dart';
import 'package:haelo_flutter/features/causeslist/presentation/screen/addcase_causelist.dart';
import 'package:haelo_flutter/features/home_page/presentation/widgets/case_info.dart';
import 'package:haelo_flutter/features/order_comment_history/cubit/order_comment_history_cubit.dart';
import 'package:haelo_flutter/features/order_comment_history/cubit/order_comment_history_state.dart';
import 'package:haelo_flutter/features/order_comment_history/data/model/WatchlistDataType.dart';
import 'package:haelo_flutter/widgets/date_format.dart';
import 'package:haelo_flutter/widgets/error_widget.dart';
import 'package:haelo_flutter/widgets/go_prime.dart';
import 'package:haelo_flutter/widgets/progress_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:haelo_flutter/locators.dart' as di;
import '../../../../core/utils/bottom_sheet_dialog.dart';
import '../../../../widgets/date_widget.dart';
import '../../../cases/cubit/deletecomment_cubit.dart';
import 'package:haelo_flutter/features/alert/data/model/my_alert_model.dart';
import 'package:haelo_flutter/features/order_comment_history/data/model/order_comment_history_model.dart';

import '../widgets/order_cmt_history_filter.dart';

/// first class
class OrderCmtHistory4 extends StatelessWidget {
  WatchListDataType? selectedLawyer;
  bool isFromCmt;

  OrderCmtHistory4({Key? key, this.selectedLawyer, this.isFromCmt = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MyAlertCubit>(
            create: (BuildContext context) => MyAlertCubit(di.locator())),
      ],
      child: OrderCmtHistoryPageSecond(
        selectedLawyer: selectedLawyer,
        isFromCmt: isFromCmt,
      ),
    );
  }
}

/// second class
class OrderCmtHistoryPageSecond extends StatefulWidget {
  WatchListDataType? selectedLawyer;
  bool isFromCmt;

  // Function? state;

  OrderCmtHistoryPageSecond(
      {Key? key, this.selectedLawyer, this.isFromCmt = false})
      : super(key: key);

  @override
  State<OrderCmtHistoryPageSecond> createState() => _ViewCauseListSecondState();
}

class _ViewCauseListSecondState extends State<OrderCmtHistoryPageSecond> {
  @override
  Widget build(BuildContext context) {
    return OrderCmtHistoryPage(
        selectedLawyer: widget.selectedLawyer, isFromCmt: widget.isFromCmt);
  }
}

class OrderCmtHistoryPage extends StatefulWidget {
  WatchListDataType? selectedLawyer;
  bool isFromCmt;

  OrderCmtHistoryPage({this.selectedLawyer, this.isFromCmt = false});

  @override
  State<OrderCmtHistoryPage> createState() =>
      _OrderCmtHistoryState(this.selectedLawyer);
}

class _OrderCmtHistoryState extends State<OrderCmtHistoryPage> {
  WatchListDataType? currentLawyer;
  bool isLoading = true;

  List causeList = [];
  List<Lawyerlist> lawyerList = [];
  List<Watchlist> watchList = [];

  // List dates = [];
  List<CaseList>? caseList = [];
  List<CaseList> filteredCases = [];
  int recursiveDateCall = 0;
  late SharedPreferences pref;
  List<WatchListDataType>? dropDownList = [];
  bool isDrag = false;

  // final List<AutoScrollController> _innerScrollControllers = [];
  List<CaseList> newList = [];
  List<CaseList> filterHiddenCasesList = [];
  int listFirstVisibleIndex = 0;
  int filterFirstVisibleIndex = 0;
  final ScrollController _horizontalDateController = ScrollController();
  List<DatesCourtModel> newDatesCourt = [];
  List<DatesCourtModel> filterDatesCourt = [];

  //filter work
  String selectedFilter = "";
  String userDate = "";
  List<CaseList> filterList = [];
  bool isFilter = false;

  FlutterListViewController listViewController = FlutterListViewController();
  FlutterListViewController filterViewController = FlutterListViewController();

  // int listviewHeaderIndex=0;
  int _horizontalDateIndex = 0;
  WatchListDataType? tempSelectedLawyer;
  MyAlertDataSource? dataSource;

  // int scrolledIndex=0;
  Map<String, String> lastscrolledMap = {};
  DateTime dateFrom = DateTime.now();

  bool isChecked = false;
  bool isHiddenCases = true;
  List<String> selectedList = [];
  String selectedDateList = "";
  String caseId = "";

  _OrderCmtHistoryState(selectedLawyer);

  void _goToElement(int index) {
    // print("horizontalIndex $index");
    _horizontalDateController.animateTo((100.0 * index),
        // 100 is the height of container and index of 6th element is 5
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeOut);
  }

  // List<GlobalKey> itemKeys=[];

  @override
  void initState() {
    // tempSelectedLawyer=selectedLawyer!;
    // selectedLawyer=null;
    if (widget.selectedLawyer != null) {
      currentLawyer = widget.selectedLawyer!;
    }
    // print("in cmt init:: ${currentLawyer!.lawyerName}");
    pref = di.locator();
    // print("init locator ${di.locator.currentScopeName}");
    // // di.locator.registerFactory(() => MyAlertCubit(dataSource!));
    // di.locator.registerLazySingleton(() => MyAlertCubit(dataSource!));
    BlocProvider.of<MyAlertCubit>(context).fetchMyAlert();

    listViewController.addListener(() {
      print("setMainListIndex Is Running ");
      setMainListIndex();
    });

    listViewController.sliverController.stickyIndex.addListener(() {
      print("setMainListIndex Is stickyIndex ");
      setMainListIndex();
    });

    filterViewController.addListener(() {
      setFilterListIndex();
    });

    filterViewController.sliverController.stickyIndex.addListener(() {
      setFilterListIndex();
    });

    super.initState();
  }

  void setMainListIndex() {
    print("setMainListIndex Is Running");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        print(
            "stickyIndex.value ==> ${listViewController.sliverController.stickyIndex.value}");
        print("listFirstVisibleIndex ==> $listFirstVisibleIndex");
        print(
            "listFirstVisibleIndex ==> ${listViewController.sliverController.stickyIndex.value!}");
        if (listViewController.sliverController.stickyIndex.value != null &&
            listFirstVisibleIndex !=
                listViewController.sliverController.stickyIndex.value!) {
          listFirstVisibleIndex =
              listViewController.sliverController.stickyIndex.value!;
          int idxx = newDatesCourt.indexWhere((element) =>
              element.date == (newList[listFirstVisibleIndex].causeListDate!));
          print("idxx; $idxx");
          if (_horizontalDateIndex != idxx) {
            _horizontalDateIndex = idxx;
            print("_horizontalDateIndex; $_horizontalDateIndex");
            _goToElement(idxx);
          }
        }
      });
    });
  }

  void setFilterListIndex() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (filterViewController.sliverController.stickyIndex.value != null &&
            filterFirstVisibleIndex !=
                filterViewController.sliverController.stickyIndex.value!) {
          filterFirstVisibleIndex =
              filterViewController.sliverController.stickyIndex.value!;
          if (filterFirstVisibleIndex < filterList.length) {
            int idxx = filterDatesCourt.indexWhere((element) =>
                element.date ==
                (filterList[filterFirstVisibleIndex].causeListDate!));
            if (_horizontalDateIndex != idxx) {
              _horizontalDateIndex = idxx;
              print("_horizontalDateIndex; $_horizontalDateIndex");
              _goToElement(idxx);
            }
          } else {
            filterFirstVisibleIndex = 0;
          }
        }
      });
    });
  }

  @override
  void dispose() {
    listViewController.removeListener(() {});
    // di.locator.reset();
    super.dispose();
  }

  void fetchData({String? date}) {
    isDrag = false;
    var body = {"lawyerName": currentLawyer!.lawyerName.toString()};
    if (date != null) {
      body['requestType'] = "calendar";
      body['requestedDate'] = date;
    }
    BlocProvider.of<OrderCommentHistoryCubit>(context)
        .fetchOrderCmtHistory(body);
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
        backgroundColor: AppColor.white,
        titleSpacing: 0,
        centerTitle: false,
        title: Text(
          "Order Comment History",
          style: mpHeadLine16(
              fontWeight: FontWeight.w500,
              textColor: AppColor.bold_text_color_dark_blue),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: InkWell(
              onTap: () {
                print("isPrime(pref) ${isPrime(pref)}");
                if (!isHiddenCases) {
                  setState(() {
                    isHiddenCases = true;
                  });
                  showDialog(
                      context: context,
                      builder: (ctx) => AppMsgPopup(
                            "Show hidden cases",
                            isCloseIcon: true,
                            isError: false,
                          ));
                  // toast(msg: "Hidden case Visible");
                } else {
                  setState(() {
                    isHiddenCases = false;
                  });
                  showDialog(
                      context: context,
                      builder: (ctx) => AppMsgPopup(
                            "Hide hidden cases",
                            isCloseIcon: true,
                            isError: true,
                          ));
                  // toast(msg: "Hidden case Invisible");
                }
              },
              child: !isHiddenCases
                  ? Icon(
                      Icons.remove_red_eye_outlined,
                      size: 26,
                    )
                  : Icon(
                      Icons.remove_red_eye,
                      size: 26,
                    ),
            ),
          ),
          selectedList.isNotEmpty && isChecked
              ? InkWell(
                  onTap: () async {
                    print("caseId ==>  $caseId");
                    String resultString = selectedList.join(', ');
                    final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddComment(
                                  getCaseIdd: resultString,
                                  isCaseHistory: true,
                                  getDateOfListing: selectedDateList != ""
                                      ? selectedDateList
                                      : "",
                                )));

                    if (result == true) {
                      fetchData();
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: const Icon(
                      Icons.add,
                      size: 30,
                    ),
                  ),
                )
              : SizedBox(),
          InkWell(
            onTap: () {
              print("isPrime(pref) ${isPrime(pref)}");
              if (!isPrime(pref)) {
                FocusScope.of(context).requestFocus(FocusNode());
                showDialog(
                    context: context,
                    builder: (ctx) => SafeArea(
                          child: GoPrime(),
                        ));
                return;
              }
              FocusScope.of(context).requestFocus(FocusNode());
              // DateTime fromDt =
              // DateFormat("dd/MM/yyyy").parse(dateFrom.toString());

              AppDatePicker()
                  .pickDate(context, dateFrom, DateTime(2000), DateTime(2100))
                  .then((value) {
                if (value != null) {
                  setState(() {
                    dateFrom = value;
                    fetchData(date: getYYYYMMDDNew(dateFrom.toString()));
                  });
                }
              });
              // showDialog(
              //     context: context,
              //     builder: (ctx) {
              //       return AlertDialog(
              //         insetPadding:
              //         const EdgeInsets.symmetric(horizontal: 15),
              //         contentPadding: EdgeInsets.zero,
              //         content: StatefulBuilder(
              //           builder: (BuildContext context,
              //               void Function(void Function()) setState) {
              //             return SizedBox(
              //               // height: mediaQH(context) * 0.269,
              //               // width: mediaQW(context) * 0.98,
              //               child: Column(
              //                 mainAxisSize: MainAxisSize.min,
              //                 children: [
              //                   Padding(
              //                     padding:
              //                     const EdgeInsets.only(top: 7),
              //                     child: Text(
              //                       "Select Date",
              //                       style: mpHeadLine12(
              //                           fontWeight: FontWeight.w500),
              //                     ),
              //                   ),
              //                   const Divider(
              //                     thickness: 1,
              //                     color: AppColor.grey_color,
              //                   ),
              //                   const SizedBox(
              //                     height: 20,
              //                   ),
              //                   Padding(
              //                     padding: const EdgeInsets.symmetric(
              //                         horizontal: 10),
              //                     child: Row(
              //                       mainAxisAlignment:
              //                       MainAxisAlignment.spaceBetween,
              //                       crossAxisAlignment:
              //                       CrossAxisAlignment.start,
              //                       children: [
              //                          Column(
              //                           crossAxisAlignment:
              //                           CrossAxisAlignment.start,
              //                           children: [
              //                             CauseListHeadingName(
              //                                 headingText: "Select Date"),
              //                             SizedBox(
              //                               height: 5,
              //                             ),
              //                             InkWell(
              //                               onTap: () {
              //                                 FocusScope.of(context)
              //                                     .requestFocus(
              //                                     FocusNode());
              //                                 DateTime fromDt =
              //                                 DateFormat("dd/MM/yyyy").parse(dateFrom.toString());
              //
              //
              //                                 AppDatePicker()
              //                                     .pickDate(
              //                                     context,
              //                                     fromDt,
              //                                     DateTime(2000),
              //                                     DateTime(2100))
              //                                     .then((value) {
              //                                   if (value != null) {
              //                                     setState(() {
              //                                       dateFrom = value;
              //                                     });
              //                                   }
              //                                 });
              //                               },
              //                               child: CustomContainer(
              //                                 displayData:
              //                                 "${dateFrom.day}/${dateFrom.month}/${dateFrom.year}",
              //                                 width: mediaQW(context) *
              //                                     0.4,
              //                                 isDropDown: false,
              //                               ),
              //                             ),
              //
              //                           ],
              //                         ),
              //                         const SizedBox(
              //                           width: 10,
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //                   const SizedBox(
              //                     height: 20,
              //                   ),
              //                   Row(
              //                     children: [
              //                       Expanded(
              //                         child: InkWell(
              //                           onTap: () {
              //                             Navigator.pop(context);
              //                           },
              //                           child: Container(
              //                             alignment: Alignment.center,
              //                             height:
              //                             mediaQH(context) * 0.05,
              //                             decoration: BoxDecoration(
              //                               border: Border.all(
              //                                   color:
              //                                   AppColor.primary),
              //                               borderRadius:
              //                               const BorderRadius.only(
              //                                   bottomLeft:
              //                                   Radius.circular(
              //                                       5)),
              //                             ),
              //                             child: Text(
              //                               "Cancel",
              //                               style: mpHeadLine16(
              //                                   textColor:
              //                                   AppColor.primary),
              //                             ),
              //                           ),
              //                         ),
              //                       ),
              //                       Expanded(
              //                         child: InkWell(
              //                           onTap: () {
              //
              //                             Navigator.pop(context);
              //                           },
              //                           child: Container(
              //                             alignment: Alignment.center,
              //                             height:
              //                             mediaQH(context) * 0.05,
              //                             decoration:
              //                             const BoxDecoration(
              //                               borderRadius:
              //                               BorderRadius.only(
              //                                   bottomRight:
              //                                   Radius.circular(
              //                                       5)),
              //                               color: AppColor.primary,
              //                             ),
              //                             child: Text(
              //                               "View",
              //                               style: mpHeadLine16(
              //                                   textColor:
              //                                   AppColor.white),
              //                             ),
              //                           ),
              //                         ),
              //                       )
              //                     ],
              //                   ),
              //                 ],
              //               ),
              //             );
              //           },
              //         ),
              //       );
              //     });
            },
            child: const Icon(
              Icons.calendar_today,
              size: 26,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 10, left: 10),
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {
                BottomSheetDialog(context,
                        OrderCmtHistoryFilter(filterData, selectedFilter))
                    .showScreen();
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.filter_alt_outlined,
                    size: 25,
                    color: AppColor.bold_text_color_dark_blue,
                  ),
                  selectedFilter.isEmpty
                      ? SizedBox()
                      : Positioned(
                          right: 5,
                          top: 1,
                          child: Container(
                            color: AppColor.white,
                            padding: EdgeInsets.all(1),
                            child: Icon(
                              Icons.brightness_1,
                              size: 5,
                              color: AppColor.rejected_color_text,
                            ),
                          ))
                ],
              ),
            ),
          ),
          GestureDetector(
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
          )
        ],
      ),
      body: Stack(
        children: [
          BlocConsumer<MyAlertCubit, MyAlertState>(
            builder: (context, state) {
              return const SizedBox();
            },
            listener: (context, state) {
              print("current state>>>> ${state}");
              if (state is MyAlertLoading) {
                setState(() {
                  isLoading = true;
                  isDrag = false;
                });
              }
              if (state is MyAlertLoaded) {
                var alertModel = state.myAlertModel;
                if (alertModel.result == 1) {
                  isDrag = false;
                  setState(() {
                    caseList = [];
                    newList = [];
                    listFirstVisibleIndex = 0;
                    filterFirstVisibleIndex = 0;
                    causeList = alertModel.data!.causeWatchlist ?? [];
                    lawyerList = alertModel.data!.lawyerlist ?? [];
                    watchList = alertModel.data!.watchlist ?? [];
                    dropDownList = [];
                    lastscrolledMap = {};

                    for (int i = 0; i < causeList!.length; i++) {
                      if (causeList[i].watchlistName != null &&
                          causeList[i].watchlistName!.isNotEmpty) {
                        dropDownList!.add(
                          WatchListDataType(
                            "causelist",
                            lawyerName: causeList[i].lawyerlist != null
                                ? causeList[i].lawyerlist
                                : "",
                            watchlistName: causeList[i].watchlistName,
                          ),
                        );
                      }
                    }

                    for (int j = 0; j < lawyerList!.length; j++) {
                      dropDownList!.add(WatchListDataType("lawyer",
                          lawyerName: lawyerList[j].lawyerName != null &&
                                  lawyerList[j]
                                      .lawyerName!
                                      .toString()
                                      .isNotEmpty
                              ? lawyerList[j].lawyerName!
                              : lawyerList[j].selectedCaseNo ?? ""));
                    }

                    for (int k = 0; k < watchList!.length; k++) {
                      if (watchList[k].watchlistName != null &&
                          watchList[k].watchlistName!.isNotEmpty) {
                        dropDownList!.add(
                          WatchListDataType(
                            "watchlist",
                            watchlistName: watchList[k].watchlistName,
                            lawyerName: watchList[k].caselist!.join(","),
                          ),
                        );
                      }
                    }

                    if (dropDownList!.isNotEmpty) {
                      if (currentLawyer != null) {
                        // print("previous data");
                        // print("previous ${currentLawyer!.lawyerName}");
                        int idx = dropDownList!.indexWhere((element) =>
                            element.lawyerName == currentLawyer!.lawyerName);
                        // print("idx $idx");
                        if (idx != -1) {
                          currentLawyer = dropDownList![idx];
                        } else {
                          int inx = dropDownList!.indexWhere((element) =>
                              element.caseNo == currentLawyer!.caseNo);
                          // print("inx $inx");
                          if (inx != -1) {
                            currentLawyer = dropDownList![inx];
                          } else {
                            currentLawyer = dropDownList![0];
                          }
                        }
                        // currentLawyer = widget.currentLawyer;
                      } else {
                        Lawyerlist checkedLawyer = lawyerList.firstWhere(
                            (element) => element.is_default == true,
                            orElse: () => Lawyerlist());
                        print("checkedLawyer $checkedLawyer");

                        int checkedIndex = dropDownList!.indexWhere((element) =>
                            (element.lawyerName == checkedLawyer.lawyerName ||
                                (checkedLawyer.selectedCaseNo != null &&
                                    checkedLawyer.selectedCaseNo!.isNotEmpty &&
                                    element.lawyerName ==
                                        checkedLawyer.selectedCaseNo)) &&
                            element.type == "lawyer");

                        print("new data $checkedIndex");
                        if (checkedIndex != -1) {
                          currentLawyer = dropDownList![checkedIndex];
                          print(
                              "hello ${dropDownList![checkedIndex].lawyerName} and type ${dropDownList![checkedIndex].type}");
                        } else {
                          currentLawyer = dropDownList![0];
                        }
                        //print("new data");
                        print("new ${currentLawyer!.lawyerName}");
                      }

                      fetchData();
                      print("currentLawyer ${currentLawyer!.lawyerName}");
                    }
                    isLoading = false;
                  });
                } else {
                  setState(() {
                    causeList = [];
                    lawyerList = [];
                    watchList = [];
                    isLoading = false;
                    isDrag = false;
                  });
                }
              }
            },
          ),
          AbsorbPointer(
            absorbing: isLoading,
            child: Opacity(
              opacity: !isLoading ? 1.0 : 0.0,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ColorNode(AppColor.white, "Not set"),
                          ColorNode(AppColor.cases_nostay, "No stay"),
                          ColorNode(AppColor.cases_intrimstay, "Interim stay"),
                          ColorNode(AppColor.cases_fullstay, "Full stay"),
                          ColorNode(AppColor.disposedColor, "Disposed"),
                          ColorNode(AppColor.text_grey_color, "Hidden"),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Note: History will be for last 7 days rolling.",
                        style: mpHeadLine12(textColor: Colors.red.shade800),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                  dropDownList!.isNotEmpty
                      ? Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 40,
                                // width: mediaQW(context),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black54, width: 1),
                                  borderRadius: BorderRadius.circular(5),
                                  color: AppColor.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 3,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                margin: EdgeInsets.fromLTRB(15, 5, 5, 5),
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: DropdownButton<WatchListDataType>(
                                  value: currentLawyer!,
                                  underline: SizedBox(),
                                  isExpanded: true,
                                  onChanged: (WatchListDataType? newValue) {
                                    setState(() {
                                      if (newValue != currentLawyer) {
                                        currentLawyer = newValue!;
                                        filterList = [];
                                        isFilter = false;
                                        selectedFilter = "";
                                        filterFirstVisibleIndex = 0;
                                        lastscrolledMap = {};
                                        print("dropdown change");
                                        fetchData();
                                      }
                                    });
                                  },
                                  items: dropDownList!
                                      .map<DropdownMenuItem<WatchListDataType>>(
                                          (value) {
                                    return DropdownMenuItem<WatchListDataType>(
                                      value: value,
                                      child: Text(
                                        value.type == "causelist" ||
                                                value.type == "watchlist"
                                            ? value.watchlistName!
                                            : value.lawyerName!,
                                        style: mpHeadLine16(
                                            textColor: AppColor.black),
                                      ),
                                      // value: value.lawyerName != null &&
                                      //         value.lawyerName!.isNotEmpty
                                      //     ? value.lawyerName
                                      //     : value.selectedCaseNo,
                                      // child: Text(value.lawyerName != null &&
                                      //         value.lawyerName!.isNotEmpty
                                      //     ? value.lawyerName!
                                      //     : value.selectedCaseNo!),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                var fromDate = DateTime.now();
                                //Navigator.pop(context);
                                // if(widget.selectedLawyer!=null && widget.isFromCmt){
                                //   print("order cmt pop");
                                //   Navigator.pop(context);
                                // }
                                print("is order cmt ${widget.isFromCmt}");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ViewCauseListScreenNew(
                                              mainCauseListdata: {
                                                "dateFrom": getDDMMYYYY(
                                                    fromDate.toString()),
                                                "lawyerName": currentLawyer!
                                                    .lawyerName
                                                    .toString(),
                                              },
                                              isFromHomepage: true,
                                              isDownloadOption: true,
                                              isGotoCourt: true,
                                              isQuickSearch: true,
                                              quickScrollDate: getYYYYMMDDNew(
                                                  fromDate.toString()),
                                              // isFromCmt: widget.isFromCmt,
                                            ))).then((value) {});
                              },
                              child: Container(
                                  height: 35,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColor.primary, width: 1),
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 3,
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                      color: AppColor.primary),
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(left: 10, right: 20),
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Text(
                                    "View\nCauselist",
                                    style: appTextStyle(
                                        fontSize: 10,
                                        textColor: AppColor.white,
                                        fontWeight: FontWeight.w500),
                                  )),
                            )
                          ],
                        )
                      : isLoading
                          ? SizedBox()
                          : NoDataAvailable("Data not found."),
                  SizedBox(
                    height: 15,
                  ),
                  //Text("current index ${listViewController.sliverController.stickyIndex.value}"),
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: BlocConsumer<OrderCommentHistoryCubit,
                        OrderCommentHistoryState>(builder: (context, state) {
                      // if (state is OrderCommentHistoryLoading) {
                      //   return AppProgressIndicator();
                      // }
                      if (state is OrderCommentHistoryLoaded) {
                        var model = state.model;
                        if (model.result == 1 && model.data != null) {
                          if (filterList.isEmpty && !isFilter) {
                            filteredCases =
                                filterHiddenCases(newList, isHiddenCases);
                          } else {
                            filteredCases =
                                filterHiddenCases(filterList, isHiddenCases);
                          }

                          for (var element in filteredCases) {
                            print(
                                "OrderCommentHistoryCubit causeListDate ${element.causeListDate}");
                          }
                          for (var element in newDatesCourt) {
                            print(
                                "OrderCommentHistoryCubit newDatesCourt ${element.date}");
                          }

                          List<DatesCourtModel> commonDates = [];
                          List<DatesCourtModel> filterDates = [];

                          filterDates = List.from(newDatesCourt);

                          if (!isHiddenCases) {
                            for (var element in filteredCases) {
                              String? causeListDate = element.causeListDate;
                              List<DatesCourtModel> matchingDates = filterDates
                                  .where(
                                    (date) => date.date == causeListDate,
                                  )
                                  .toList();

                              if (matchingDates.isNotEmpty) {
                                commonDates.addAll(matchingDates);
                              }
                            }

                            filterDates = commonDates.toSet().toList();
                            for (var element in filterDates) {
                              print(
                                  "OrderCommentHistoryCubit Common Dates: ${element.date}");
                            }
                          } else {
                            filterDates = newDatesCourt;
                            for (var element in newDatesCourt) {
                              print(
                                  "OrderCommentHistoryCubit Original Dates: ${element.date}");
                            }
                          }

                          return filterList.isEmpty && !isFilter
                              ? Stack(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: Scrollbar(
                                          controller: listViewController,
                                          interactive: true,
                                          thickness: 8,
                                          radius: const Radius.circular(10),
                                          child: FlutterListView(
                                              reverse: false,
                                              shrinkWrap: true,
                                              anchor: 1,
                                              delegate: FlutterListViewDelegate(
                                                (BuildContext context,
                                                    int index) {
                                                  return listCard(
                                                      filteredCases[index],
                                                      index);
                                                },
                                                childCount:
                                                    filteredCases.length,
                                                onItemSticky: (index) =>
                                                    filteredCases[index]
                                                            .isdateChange !=
                                                        null &&
                                                    filteredCases[index]
                                                            .isdateChange ==
                                                        true,
                                                stickyAtTailer: false,
                                              ),
                                              controller: listViewController)),
                                    ),
                                    Positioned(
                                      top: 0,
                                      left: 10,
                                      right: 20,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: filterDates.length > 1
                                              ? Colors.white
                                              : AppColor.home_background,
                                          boxShadow: filterDates.length > 1
                                              ? [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    spreadRadius: 2,
                                                    blurRadius: 3,
                                                    offset: Offset(0,
                                                        3), // changes position of shadow
                                                  ),
                                                ]
                                              : [],
                                        ),
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 1, horizontal: 10),
                                        height: 35,
                                        width: mediaQW(context),
                                        child: ListView(
                                          scrollDirection: Axis.horizontal,
                                          controller: _horizontalDateController,
                                          shrinkWrap: true,
                                          children: filterDates.map((e) {
                                            return InkWell(
                                              onTap: () {
                                                dateSelectCallback(e.date!);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: e.date ==
                                                          (filteredCases[
                                                                  listFirstVisibleIndex]
                                                              .causeListDate!)
                                                      ? AppColor.primary
                                                      : AppColor.white,
                                                  border: Border.all(
                                                    color: AppColor.primary,
                                                  ),
                                                ),
                                                margin:
                                                    EdgeInsets.only(right: 10),
                                                alignment: Alignment.center,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 5),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      (e.date!),
                                                      style: appTextStyle(
                                                        textColor: e.date ==
                                                                (filteredCases[
                                                                        listFirstVisibleIndex]
                                                                    .causeListDate!)
                                                            ? AppColor.white
                                                            : AppColor.primary,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : filterList.isNotEmpty
                                  ? Stack(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(top: 10),
                                          child: Scrollbar(
                                              controller: filterViewController,
                                              interactive: true,
                                              thickness: 8,
                                              radius: const Radius.circular(10),
                                              child: FlutterListView(
                                                  reverse: false,
                                                  shrinkWrap: true,
                                                  anchor: 1,
                                                  delegate:
                                                      FlutterListViewDelegate(
                                                    (BuildContext context,
                                                        int index) {
                                                      // if(index==filterList.length){
                                                      //   return SizedBox(height: mediaQH(context)/1.5,);
                                                      // }
                                                      filteredCases =
                                                          filterHiddenCases(
                                                              filterList,
                                                              isHiddenCases);
                                                      return listCard(
                                                          filteredCases[index],
                                                          index);
                                                    },
                                                    childCount:
                                                        filteredCases.length,
                                                    onItemSticky:
                                                        (index) => //index==filterList.length?false:
                                                            filteredCases[index]
                                                                    .isdateChange !=
                                                                null &&
                                                            filteredCases[index]
                                                                    .isdateChange ==
                                                                true,
                                                    stickyAtTailer: false,
                                                  ),
                                                  controller:
                                                      filterViewController)),
                                        ),
                                        Positioned(
                                          top: 0,
                                          left: 10,
                                          right: 20,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: filterDatesCourt.length > 1
                                                  ? Colors.white
                                                  : AppColor.home_background,
                                              boxShadow: filterDatesCourt
                                                          .length >
                                                      1
                                                  ? [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.5),
                                                        spreadRadius: 2,
                                                        blurRadius: 3,
                                                        offset: Offset(0,
                                                            3), // changes position of shadow
                                                      ),
                                                    ]
                                                  : [],
                                            ),
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 1, horizontal: 10),
                                            height: 35,
                                            width: mediaQW(context),
                                            child: ListView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                controller:
                                                    _horizontalDateController,
                                                shrinkWrap: true,
                                                children:
                                                    filterDatesCourt.map((e) {
                                                  return InkWell(
                                                    onTap: () {
                                                      dateSelectCallback(
                                                          e.date!,
                                                          isFilter: true);
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: e.date ==
                                                                  (filteredCases[
                                                                          filterFirstVisibleIndex]
                                                                      .causeListDate!)
                                                              ? AppColor.primary
                                                              : AppColor.white,
                                                          border: Border.all(
                                                            color: AppColor
                                                                .primary,
                                                          )),
                                                      margin: EdgeInsets.only(
                                                          right: 10),
                                                      alignment:
                                                          Alignment.center,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 16,
                                                          vertical: 5),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            (e.date!),
                                                            style: appTextStyle(
                                                              textColor: e.date ==
                                                                      (filteredCases[
                                                                              filterFirstVisibleIndex]
                                                                          .causeListDate!)
                                                                  ? AppColor
                                                                      .white
                                                                  : AppColor
                                                                      .primary,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }).toList()),
                                          ),
                                        ),
                                      ],
                                    )
                                  : NoDataAvailable("filter data not found.");
                        } else {
                          return NoDataAvailable("Data not found.");
                        }
                      }
                      return SizedBox();
                    }, listener: (context, state) {
                      if (state is OrderCommentHistoryLoading) {
                        setState(() {
                          isLoading = true;
                        });
                      }
                      if (state is OrderCommentHistoryLoaded) {
                        var model = state.model;
                        if (model.result == 1 &&
                            model.data != null &&
                            model.data!.caseList!.isNotEmpty) {
                          caseList = [];
                          caseList = model.data!.caseList!;

                          print("caseList ${caseList!.length}");

                          // _innerScrollControllers.addAll(List.generate(
                          //     caseList!.length, (_) => AutoScrollController()));

                          listFirstVisibleIndex = 0;
                          filterFirstVisibleIndex = 0;
                          newList = [];

                          for (int i = 0; i < caseList!.length; i++) {
                            //  print("in index $i>> ${newList.any((element) => element.causeListDate==caseList![i].causeListDate)}");
                            if (!newList.any((element) =>
                                element.causeListDate ==
                                caseList![i].causeListDate)) {
                              CaseList casData = CaseList();
                              casData.benchName = caseList![i].benchName;
                              casData.caseId = caseList![i].caseId;
                              casData.caseNo = caseList![i].caseNo;
                              casData.case_title = caseList![i].case_title;
                              casData.causeListDate =
                                  caseList![i].causeListDate;
                              casData.commentDetails =
                                  caseList![i].commentDetails;
                              casData.courtNo = caseList![i].courtNo;
                              casData.dateOfListinng =
                                  caseList![i].dateOfListinng;
                              casData.orderFile = caseList![i].orderFile;
                              casData.sno = caseList![i].sno;
                              casData.stage = caseList![i].stage;
                              casData.userDate = caseList![i].userDate;
                              casData.intrim_stay = caseList![i].intrim_stay;
                              casData.is_disposed = caseList![i].is_disposed;
                              casData.is_hide = caseList![i].is_hide;
                              casData.date_type = caseList![i].date_type;
                              casData.court_date = caseList![i].court_date;
                              casData.no_of_weeks = caseList![i].no_of_weeks;
                              casData.last_comment_date =
                                  caseList![i].last_comment_date;
                              casData.commentUpdateDate =
                                  caseList![i].commentUpdateDate;
                              casData.commentDate = caseList![i].commentDate;
                              casData.lastCauseListDate =
                                  caseList![i].lastCauseListDate;
                              // GlobalKey subListKey = GlobalKey();
                              // casData.subListgKey = subListKey;
                              // cas=caseList![i];
                              casData.isdateChange = true;
                              newList.add(casData);
                            }

                            CaseList cas = CaseList();
                            cas.benchName = caseList![i].benchName;
                            cas.caseId = caseList![i].caseId;
                            cas.caseNo = caseList![i].caseNo;
                            cas.case_title = caseList![i].case_title;
                            cas.causeListDate = caseList![i].causeListDate;
                            cas.commentDetails = caseList![i].commentDetails;
                            cas.courtNo = caseList![i].courtNo;
                            cas.dateOfListinng = caseList![i].dateOfListinng;
                            cas.orderFile = caseList![i].orderFile;
                            cas.sno = caseList![i].sno;
                            cas.stage = caseList![i].stage;
                            cas.userDate = caseList![i].userDate;
                            cas.intrim_stay = caseList![i].intrim_stay;
                            cas.is_disposed = caseList![i].is_disposed;
                            cas.is_hide = caseList![i].is_hide;
                            cas.date_type = caseList![i].date_type;
                            cas.court_date = caseList![i].court_date;
                            cas.no_of_weeks = caseList![i].no_of_weeks;
                            cas.last_comment_date =
                                caseList![i].last_comment_date;
                            cas.commentUpdateDate =
                                caseList![i].commentUpdateDate;
                            cas.commentDate = caseList![i].commentDate;
                            cas.lastCauseListDate =
                                caseList![i].lastCauseListDate;
                            // GlobalKey subListKey = GlobalKey();
                            // cas.subListgKey = subListKey;

                            cas.isdateChange = false;
                            newList.add(cas);
                          }

                          for (int i = 0; i < newList.length; i++) {
                            if (i == 0 ||
                                newList[i].courtNo ==
                                    "Before Registrar (Admin.)" ||
                                newList[i].courtNo ==
                                    "Before Dy. Registrar (Judicial)") {
                              newList[i].iscourtChange = false;
                            } else {
                              if (newList[i - 1].courtNo ==
                                  "Before Registrar (Admin.)") {
                                newList[i].iscourtChange = true;
                              } else if (newList[i - 1].courtNo ==
                                  "Before Dy. Registrar (Judicial)") {
                                newList[i].iscourtChange = true;
                              } else if (int.parse(newList[i].courtNo!) !=
                                  int.parse(newList[i - 1].courtNo!)) {
                                newList[i].iscourtChange = true;
                              } else {
                                newList[i].iscourtChange = false;
                              }
                            }
                          }

                          newDatesCourt = [];
                          for (int i = 0; i < newList!.length; i++) {
                            if (!newDatesCourt.any((element) =>
                                element.date == newList[i].causeListDate)) {
                              DatesCourtModel model = DatesCourtModel();
                              model.date = newList[i].causeListDate!;
                              model.courtNo = [];
                              model.courtNo!.add(newList[i].courtNo);
                              newDatesCourt.add(model);
                            } else {
                              int index = newDatesCourt.indexWhere((element) =>
                                  element.date == newList[i].causeListDate);
                              //model.courtNo=[];
                              if (!newDatesCourt[index]
                                  .courtNo!
                                  .contains(newList[i].courtNo)) {
                                newDatesCourt[index]
                                    .courtNo!
                                    .add(newList[i].courtNo);
                              }
                              // newDatesCourt[index]=model;
                            }
                          }

                          print("hellonewList ${newList.length}");
                          print("hellocaseLisst ${caseList!.length}");
                          // print("lastscrolledMap $lastscrolledMap");

                          filterData(selectedFilter);
                          setState(() {
                            isLoading = false;
                            DateTime now = DateTime.now();

                            Future.delayed(Duration(seconds: 1), () {
                              if (lastscrolledMap.isNotEmpty) {
                                isLoading = false;
                                Future.delayed(Duration(milliseconds: 100), () {
                                  // listViewController.position.jumpTo(scrollOffset);
                                  int index = newList!.indexWhere((element) =>
                                      lastscrolledMap['date'] ==
                                          (element.causeListDate!) &&
                                      lastscrolledMap['sno'] ==
                                          element.sno.toString() &&
                                      lastscrolledMap['courtno'] ==
                                          element.courtNo.toString());
                                  print("index $index");
                                  listViewController.sliverController
                                      .jumpToIndex(index != -1 ? index : 0);
                                  lastscrolledMap = {};
                                });
                              } else {
                                dateSelectCallback(
                                    getddMMYYYY_with_splash((now.toString())),
                                    isNextDateScroll: true);
                              }
                            });
                          });
                        } else {
                          setState(() {
                            isLoading = false;
                            caseList = [];
                            listFirstVisibleIndex = 0;
                            filterFirstVisibleIndex = 0;
                            newList = [];
                            lastscrolledMap = {};
                          });
                        }
                      }
                      if (state is OrderCommentHistoryError) {
                        if (state.message == "InternetFailure()") {
                          toast(msg: "Please check internet connection");
                        } else {
                          toast(msg: "Something went wrong");
                        }
                      }
                    }),
                  ),
                  BlocConsumer<DeleteCommentCubit, DeleteCommentState>(
                      builder: (context, state) {
                    return const SizedBox();
                  }, listener: (context, state) {
                    if (state is DeleteCommentLoaded) {
                      var deleteCommentList = state.deleteCommentModel;
                      if (deleteCommentList.result == 1) {
                        lastscrolledMap = {};
                        toast(msg: deleteCommentList.msg.toString());
                        fetchData();
                        /*    showDialog(
                            context: context,
                            builder: (ctx) => AppMsgPopup(
                                  deleteCommentList.msg.toString(),
                                  isCloseIcon: false,
                                  isError: false,
                                  btnCallback: () {
                                    Navigator.pop(context);
                                    lastscrolledMap = {};
                                    fetchData();
                                  },
                                ));*/
                      } else {
                        showDialog(
                            context: context,
                            builder: (ctx) => AppMsgPopup(
                                  deleteCommentList.msg.toString(),
                                ));
                      }
                    }
                  }),
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
      floatingActionButton: !isLoading &&
              newDatesCourt.length > 1 &&
              newList.isNotEmpty &&
              !isFilter
          ? InkWell(
              onTap: () {
                // dateSelectCallback("16/08/2023");
                showDialog(
                    context: context,
                    builder: (ctx) => CauseDateListCourtNo(newDatesCourt,
                        dateSelectCallback, datesCourtSelectCallback, false));
              },
              child: Container(
                height: 40,
                width: 30,
                color: AppColor.white,
                child: Image.asset(
                  ImageConstant.scroll,
                  color: AppColor.primary,
                  height: 40,
                  width: 30,
                ),
              ),
            )
          : SizedBox(),
    );
  }

  Widget listCard(CaseList item, int index) {
    //
    DateTime causeDate = DateFormat("dd/MM/yyyy").parse(item.causeListDate!);
    bool isUserDate = false;
    DateTime now = DateTime.now();
    if (item.commentUpdateDate != null && item.commentUpdateDate!.isNotEmpty) {
      DateTime dateOfListing =
          DateFormat("dd/MM/yyyy").parse(item.commentUpdateDate!);
      isUserDate = causeDate.isAtSameMomentAs(dateOfListing) ||
          causeDate.isBefore(dateOfListing);
    }

    print("causeListDate ==> ${item.causeListDate!}");
    if (item.userDate != null && item.userDate!.isNotEmpty) {
      userDate = getEEEddMMyyHistory(item.userDate!);
      print("userDate ==> ${getEEEddMMyyHistory(item.userDate!)}");
    }

    return (item.isdateChange != null && item.isdateChange == true)
        ? Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColor.primary,
                ),
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                child: Text(
                  (item.causeListDate!),
                  style: appTextStyle(
                    textColor: AppColor.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Spacer(),
            ],
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              item.iscourtChange != null && item.iscourtChange == true
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 3,
                        ),
                        Container(
                          height: 1,
                          color: Colors.redAccent,
                          width: mediaQW(context),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    )
                  : SizedBox(),
              Card(
                elevation: 4,
                // key: item.subListgKey,
                color: item.is_disposed == true
                    ? AppColor.disposedColor
                    : item.is_hide == 1 && isHiddenCases
                        ? AppColor.text_grey_color
                        : item.intrim_stay.toString().toLowerCase() == "no stay"
                            ? AppColor.cases_nostay
                            : item.intrim_stay.toString().toLowerCase() ==
                                    "interim stay"
                                ? AppColor.cases_intrimstay
                                : item.intrim_stay.toString().toLowerCase() ==
                                        "full stay"
                                    ? AppColor.cases_fullstay
                                    : AppColor.white,
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: item.sno != null &&
                                item.sno.toString().contains("D")
                            ? AppColor.white
                            : AppColor.rejected_color_text)),
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Selection
                      item.caseId != null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                item.caseId != null
                                    ? SizedBox(
                                        width: 26,
                                        height: 26,
                                        child: Checkbox(
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          value: item.isSelected,
                                          onChanged: (boolValue) {
                                            setState(() {
                                              if (boolValue!) {
                                                item.isSelected = true;
                                                caseId = item.caseId.toString();
                                                print(
                                                    "caseId ${item.caseId.toString()}");
                                                selectedList.add(caseId);
                                                selectedDateList = item
                                                    .causeListDate
                                                    .toString();
                                                isChecked = true;
                                              } else {
                                                item.isSelected = false;
                                                selectedDateList = "";
                                                selectedList.remove(
                                                    item.caseId.toString());
                                              }
                                              print(
                                                  "selectedList $selectedList");
                                            });
                                          },
                                          checkColor: AppColor.white,
                                          activeColor: AppColor.primary,
                                          /* fillColor: MaterialStateProperty.all(
                                              AppColor.primary),*/
                                        ),
                                      )
                                    : SizedBox(),
                                Flexible(
                                  child: RichText(
                                    text: TextSpan(
                                        text: "Court No.:",
                                        style: mpHeadLine12(
                                            fontWeight: FontWeight.w600,
                                            textColor: item.is_disposed == true
                                                ? AppColor.white
                                                : AppColor.black),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: item.courtNo != null
                                                  ? item.courtNo.toString()
                                                  : "",
                                              style: mpHeadLine12(
                                                  textColor:
                                                      item.is_disposed == true
                                                          ? AppColor.white
                                                          : AppColor.black)),
                                        ]),
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                          text: "S.No.:  ",
                                          style: mpHeadLine12(
                                              fontWeight: FontWeight.w600,
                                              textColor:
                                                  item.is_disposed == true
                                                      ? AppColor.white
                                                      : AppColor.black),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: item.sno != null
                                                    ? item.sno.toString()
                                                    : "",
                                                style: mpHeadLine12(
                                                    textColor:
                                                        item.is_disposed == true
                                                            ? AppColor.white
                                                            : AppColor.black)),
                                          ]),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    SizedBox(
                                      height: 20,
                                      width: 30,
                                      child: PopupMenuButton<int>(
                                        onSelected: (i) async {
                                          if (i == 1) {
                                            if (item.caseId != null) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          CaseDetails(
                                                            caseId: item.caseId,
                                                            index: 2,
                                                          )));
                                            } else {
                                              await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddCaseCauseList(
                                                            getCaseNum: item
                                                                .caseNo
                                                                .toString(),
                                                          ))).then((value) {
                                                if (value != null && value) {
                                                  setState(() {
                                                    lastscrolledMap['sno'] =
                                                        item.sno.toString();
                                                    lastscrolledMap['courtno'] =
                                                        item.courtNo.toString();
                                                    lastscrolledMap['date'] =
                                                        item.causeListDate
                                                            .toString();
                                                  });
                                                  fetchData();
                                                }
                                              });
                                            }
                                          }
                                        },
                                        padding: const EdgeInsets.only(
                                            top: 0, bottom: 7),
                                        icon: Icon(
                                          Icons.more_vert_outlined,
                                          size: 20,
                                          color: item.is_disposed == true
                                              ? AppColor.white
                                              : AppColor.black,
                                        ),
                                        itemBuilder: (context) => [
                                          PopupMenuItem(
                                            value: 1,
                                            child: Text(item.caseId != null
                                                ? "Case Details"
                                                : "Create Case"),
                                          ),
                                          // if(item.caseId!=null) const PopupMenuItem(
                                          //   value: 2,
                                          //   child:  Text(
                                          //       "Add Comment"),
                                          // ),
                                        ],
                                        color: Colors.white,
                                        elevation: 2,
                                      ),
                                    ),
                                    causeDate.difference(now).inDays > -1
                                        ? InkWell(
                                            onTap: () {
                                              Map<String, String> summary = {
                                                "dateToday": getYYYYMMDD(item
                                                    .causeListDate
                                                    .toString()),
                                                "courtNo":
                                                    item.courtNo.toString(),
                                                "benchName": item.benchName !=
                                                        null
                                                    ? item.benchName.toString()
                                                    : "",
                                              };
                                              showDialog(
                                                  context: context,
                                                  barrierDismissible: true,
                                                  builder:
                                                      (BuildContext context) {
                                                    return CourtInfo(summary);
                                                  });
                                            },
                                            child: Container(
                                              height: 30,
                                              width: 30,
                                              alignment: Alignment.center,
                                              child: Icon(
                                                Icons.info,
                                                color: AppColor.primary,
                                                size: 20,
                                              ),
                                            ),
                                          )
                                        : SizedBox(),
                                  ],
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: RichText(
                                    text: TextSpan(
                                        text: "Court No.:",
                                        style: mpHeadLine12(
                                            fontWeight: FontWeight.w600,
                                            textColor: item.is_disposed == true
                                                ? AppColor.white
                                                : AppColor.black),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: item.courtNo != null
                                                  ? item.courtNo.toString()
                                                  : "",
                                              style: mpHeadLine12(
                                                  textColor:
                                                      item.is_disposed == true
                                                          ? AppColor.white
                                                          : AppColor.black)),
                                        ]),
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                          text: "S.No.:  ",
                                          style: mpHeadLine12(
                                              fontWeight: FontWeight.w600,
                                              textColor:
                                                  item.is_disposed == true
                                                      ? AppColor.white
                                                      : AppColor.black),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: item.sno != null
                                                    ? item.sno.toString()
                                                    : "",
                                                style: mpHeadLine12(
                                                    textColor:
                                                        item.is_disposed == true
                                                            ? AppColor.white
                                                            : AppColor.black)),
                                          ]),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    SizedBox(
                                      height: 20,
                                      width: 30,
                                      child: PopupMenuButton<int>(
                                        onSelected: (i) async {
                                          if (i == 1) {
                                            if (item.caseId != null) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          CaseDetails(
                                                            caseId: item.caseId,
                                                            index: 2,
                                                          )));
                                            } else {
                                              await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddCaseCauseList(
                                                            getCaseNum: item
                                                                .caseNo
                                                                .toString(),
                                                          ))).then((value) {
                                                if (value != null && value) {
                                                  setState(() {
                                                    lastscrolledMap['sno'] =
                                                        item.sno.toString();
                                                    lastscrolledMap['courtno'] =
                                                        item.courtNo.toString();
                                                    lastscrolledMap['date'] =
                                                        item.causeListDate
                                                            .toString();
                                                  });
                                                  fetchData();
                                                }
                                              });
                                            }
                                          }
                                        },
                                        padding: const EdgeInsets.only(
                                            top: 0, bottom: 7),
                                        icon: Icon(
                                          Icons.more_vert_outlined,
                                          size: 20,
                                          color: item.is_disposed == true
                                              ? AppColor.white
                                              : AppColor.black,
                                        ),
                                        itemBuilder: (context) => [
                                          PopupMenuItem(
                                            value: 1,
                                            child: Text(item.caseId != null
                                                ? "Case Details"
                                                : "Create Case"),
                                          ),
                                          // if(item.caseId!=null) const PopupMenuItem(
                                          //   value: 2,
                                          //   child:  Text(
                                          //       "Add Comment"),
                                          // ),
                                        ],
                                        color: Colors.white,
                                        elevation: 2,
                                      ),
                                    ),
                                    causeDate.difference(now).inDays > -1
                                        ? InkWell(
                                            onTap: () {
                                              Map<String, String> summary = {
                                                "dateToday": getYYYYMMDD(item
                                                    .causeListDate
                                                    .toString()),
                                                "courtNo":
                                                    item.courtNo.toString(),
                                                "benchName": item.benchName !=
                                                        null
                                                    ? item.benchName.toString()
                                                    : "",
                                              };
                                              showDialog(
                                                  context: context,
                                                  barrierDismissible: true,
                                                  builder:
                                                      (BuildContext context) {
                                                    return CourtInfo(summary);
                                                  });
                                            },
                                            child: Container(
                                              height: 30,
                                              width: 30,
                                              alignment: Alignment.center,
                                              child: Icon(
                                                Icons.info,
                                                color: AppColor.primary,
                                                size: 20,
                                              ),
                                            ),
                                          )
                                        : SizedBox(),
                                  ],
                                ),
                              ],
                            ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Judge(s) Name: ",
                            style: mpHeadLine12(
                                fontWeight: FontWeight.w600,
                                textColor: item.is_disposed == true
                                    ? AppColor.white
                                    : AppColor.black),
                          ),
                          Flexible(
                            child: Text(
                                item.benchName != null
                                    ? item.benchName.toString()
                                    : "",
                                style: mpHeadLine12(
                                    textColor: item.is_disposed == true
                                        ? AppColor.white
                                        : AppColor.black)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height:
                            item.orderFile != null && item.orderFile!.isNotEmpty
                                ? 10
                                : 0,
                      ),
                      item.orderFile != null && item.orderFile!.isNotEmpty
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Order Judgement:",
                                      style: mpHeadLine12(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => PDFScreen(
                                                    path:
                                                        "https://d6kpk9izjhild.cloudfront.net/${item.orderFile!}")));
                                      },
                                      child: Icon(
                                        Icons.remove_red_eye,
                                        color: AppColor.primary,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        DateTime now = DateTime.now();
                                        var fileName =
                                            "${now.millisecondsSinceEpoch}_Judgement Details.${item.orderFile!.toString().split(".").last}";
                                        await downloadFiles(
                                            "https://d6kpk9izjhild.cloudfront.net/${item.orderFile!}",
                                            fileName);
                                      },
                                      child: Icon(
                                        Icons.download,
                                        color: AppColor.primary,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )
                          : SizedBox(),
                      const SizedBox(
                        height: 10,
                      ),
                      RichText(
                        text: TextSpan(
                            text: "Stage:  ",
                            style: mpHeadLine12(
                                fontWeight: FontWeight.w600,
                                textColor: item.is_disposed == true
                                    ? AppColor.white
                                    : AppColor.black),
                            children: <TextSpan>[
                              TextSpan(
                                  text: item.stage != null
                                      ? item.stage.toString()
                                      : "",
                                  style: mpHeadLine12(
                                      textColor: item.is_disposed == true
                                          ? AppColor.white
                                          : AppColor.black)),
                            ]),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      item.caseNo != null
                          ? RichText(
                              text: TextSpan(
                                  text: "Case No:  ",
                                  style: mpHeadLine12(
                                      fontWeight: FontWeight.w600,
                                      textColor: item.is_disposed == true
                                          ? AppColor.white
                                          : AppColor.black),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: item.caseNo != null
                                            ? item.caseNo.toString()
                                            : "",
                                        style: mpHeadLine12(
                                            textColor: item.is_disposed == true
                                                ? AppColor.white
                                                : AppColor.black)),
                                  ]),
                            )
                          : SizedBox(),
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () async {
                          if (item.caseId != null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CaseDetails(
                                          caseId: item.caseId,
                                          index: 2,
                                        )));
                          }
                        },
                        child: RichText(
                          text: TextSpan(
                              text: "Case Title:  ",
                              style: mpHeadLine12(
                                  fontWeight: FontWeight.w600,
                                  textColor: AppColor.primary),
                              children: <TextSpan>[
                                TextSpan(
                                    text: item.case_title != null
                                        ? item.case_title.toString()
                                        : "",
                                    style: mpHeadLine12(
                                        textColor: AppColor.primary)),
                              ]),
                        ),
                      ),
                      SizedBox(
                        height: item.caseId != null ? 10 : 0,
                      ),
                      item.caseId != null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Comments:",
                                      style: mpHeadLine14(
                                          fontWeight: FontWeight.w600,
                                          textColor: item.is_disposed == true
                                              ? AppColor.white
                                              : AppColor.black),
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    if (item.caseId != null) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => AddComment(
                                                    getCaseIdd: item.caseId,
                                                    isCaseHistory: true,
                                                    getDateOfListing:
                                                        item.causeListDate !=
                                                                null
                                                            ? (item
                                                                .causeListDate!)
                                                            : "",
                                                  ))).then((value) {
                                        if (value != null && value == true) {
                                          print(
                                              "isFilter $isFilter listFirstVisibleIndex>> $listFirstVisibleIndex");
                                          print(
                                              "filterFirstVisibleIndex>> $filterFirstVisibleIndex");
                                          setState(() {
                                            // if(isFilter){
                                            //   scrolledIndex=filterFirstVisibleIndex;
                                            // }else{
                                            lastscrolledMap['sno'] =
                                                item.sno.toString();
                                            lastscrolledMap['courtno'] =
                                                item.courtNo.toString();
                                            lastscrolledMap['date'] =
                                                item.causeListDate.toString();
                                            // scrolledIndex=listFirstVisibleIndex;
                                            // }
                                          });

                                          fetchData();
                                        }
                                      });
                                    }
                                  },
                                  child: const Icon(
                                    Icons.add,
                                    size: 20,
                                  ),
                                )
                              ],
                            )
                          : SizedBox(),
                      const SizedBox(
                        height: 10,
                      ),
                      item.caseId != null && item.commentDetails!.isEmpty
                          ? Card(
                              color: AppColor.home_background.withOpacity(0.9),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "No comment added on Last Causelist date.",
                                        style: mpHeadLine12(
                                            fontWeight: FontWeight.w500,
                                            textColor: AppColor.black)),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text("Last Causelist date : ",
                                                  style: mpHeadLine10(
                                                      textColor:
                                                          AppColor.black)),
                                              Text(
                                                  item.lastCauseListDate
                                                      .toString(),
                                                  style: mpHeadLine10(
                                                      textColor:
                                                          AppColor.black)),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text("Last Edit date : ",
                                                  style: mpHeadLine10(
                                                      textColor:
                                                          AppColor.black)),
                                              Text(
                                                  formatCauseListDateString(item
                                                      .commentDate
                                                      .toString()),
                                                  style: mpHeadLine10(
                                                      textColor:
                                                          AppColor.black)),
                                            ],
                                          )
                                        ]),
                                  ],
                                ),
                              ),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.vertical,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: item.commentDetails!.length,
                              itemBuilder: (context, i) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      top: 6, left: 6, right: 6),
                                  child: Card(
                                    color: AppColor.home_background,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("By:",
                                                  style: mpHeadLine12(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      textColor: item
                                                                  .is_disposed ==
                                                              true
                                                          ? AppColor.white
                                                          : AppColor
                                                              .bold_text_color_dark_blue)),
                                              SizedBox(
                                                width: mediaQW(context) * 0.52,
                                                child: Text(
                                                    item.commentDetails![i]
                                                            .userName
                                                            .toString() +
                                                        "(${item.commentDetails![i].mobNo.toString()}"
                                                            ")",
                                                    style: mpHeadLine12(
                                                        textColor: item
                                                                    .is_disposed ==
                                                                true
                                                            ? AppColor.white
                                                            : AppColor
                                                                .bold_text_color_dark_blue)),
                                              ),
                                              // const SizedBox(
                                              //   width: 45,
                                              // ),
                                              /*   item.commentDetails![i].mobNo
                                                          .toString() ==
                                                      pref.getString(
                                                          Constants.MOB_NO)
                                                  ? */
                                              Row(
                                                children: [
                                                  item.commentDetails![i].mobNo
                                                              .toString() ==
                                                          pref.getString(
                                                              Constants.MOB_NO)
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
                                                                          0.18,
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
                                                                              "Are you sure, you want to delete this comment?",
                                                                              textAlign: TextAlign.center,
                                                                              style: mpHeadLine14(fontWeight: FontWeight.w600),
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                25,
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Expanded(
                                                                                child: InkWell(
                                                                                  onTap: () {
                                                                                    Navigator.pop(context);
                                                                                    var deleteComment = {
                                                                                      "commentId": item.commentDetails![i].commentId.toString(),
                                                                                    };
                                                                                    BlocProvider.of<DeleteCommentCubit>(context).fetchDeleteComment(deleteComment);
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
                                                          child: Icon(
                                                            Icons.delete,
                                                            size: 20,
                                                            color: Colors
                                                                .red.shade800,
                                                          ),
                                                        )
                                                      : SizedBox(),
                                                  const SizedBox(
                                                    width: 15,
                                                  ),
                                                  GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        EditComment(
                                                                          getCaseIdd:
                                                                              item.caseId,
                                                                          commentId: item
                                                                              .commentDetails![i]
                                                                              .commentId
                                                                              .toString(),
                                                                          getComment: item
                                                                              .commentDetails![i]
                                                                              .comment
                                                                              .toString(),
                                                                          isCaseHistory:
                                                                              true,
                                                                          getDateOfListing: item.causeListDate != null
                                                                              ? (item.causeListDate!)
                                                                              : "",
                                                                          // apiDateOfListing: item.commentUpdateDate,
                                                                          courtDate:
                                                                              item.court_date,
                                                                          dateType: item.date_type != null && item.date_type!.isNotEmpty
                                                                              ? item.date_type
                                                                              : "",
                                                                          noOfWeek: item.no_of_weeks != null && item.no_of_weeks!.toString().isNotEmpty
                                                                              ? item.no_of_weeks
                                                                              : "",
                                                                        ))).then(
                                                            (value) {
                                                          if (value != null &&
                                                              value == true) {
                                                            setState(() {
                                                              lastscrolledMap[
                                                                      'sno'] =
                                                                  item.sno
                                                                      .toString();
                                                              lastscrolledMap[
                                                                      'courtno'] =
                                                                  item.courtNo
                                                                      .toString();
                                                              lastscrolledMap[
                                                                      'date'] =
                                                                  item.causeListDate
                                                                      .toString();
                                                            });
                                                            fetchData();
                                                          }
                                                        });
                                                      },
                                                      child: Icon(Icons.edit,
                                                          size: 20,
                                                          color: Colors
                                                              .red.shade800))
                                                ],
                                              )
                                              // : SizedBox(),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          SizedBox(
                                            width: mediaQW(context) * 0.8,
                                            child: Text(
                                                item.commentDetails![i].comment
                                                    .toString(),
                                                style: mpHeadLine12(
                                                    fontWeight: FontWeight.w500,
                                                    textColor: item
                                                                .is_disposed ==
                                                            true
                                                        ? AppColor.white
                                                        : AppColor
                                                            .bold_text_color_dark_blue)),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          // used Row in place of richtext so that card occupies appropriate space in page.
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                        "Last Causelist date : ",
                                                        style: mpHeadLine10(
                                                            textColor: AppColor
                                                                .black)),
                                                    Text(
                                                        item.lastCauseListDate
                                                            .toString(),
                                                        style: mpHeadLine10(
                                                            textColor: AppColor
                                                                .black)),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text("Last Edit date : ",
                                                        style: mpHeadLine10(
                                                            textColor: AppColor
                                                                .black)),
                                                    Text(
                                                        formatCauseListDateString(
                                                            item.commentDate
                                                                .toString()),
                                                        style: mpHeadLine10(
                                                            textColor: AppColor
                                                                .black)),
                                                  ],
                                                )
                                              ]),
                                          /*  Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                  item.commentDetails![i]
                                                              .timestamp !=
                                                          null
                                                      ? formatTimestampToDate(
                                                          item
                                                              .commentDetails![
                                                                  i]
                                                              .timestamp
                                                              .toString())
                                                      : "",
                                                  style: mpHeadLine10(
                                                      textColor: item
                                                                  .is_disposed ==
                                                              true
                                                          ? AppColor.white
                                                          : AppColor
                                                              .bold_text_color_dark_blue)),
                                            ],
                                          ),*/
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                      SizedBox(
                        height: item.commentDetails != null ? 10 : 0,
                      ),

                      item.userDate != null && item.causeListDate! != userDate
                          ? Row(
                              children: [
                                Text(
                                  "Next Date: ",
                                  style: mpHeadLine12(
                                      fontWeight: FontWeight.w600,
                                      textColor: item.is_disposed == true
                                          ? AppColor.white
                                          : AppColor.black),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: AppColor.primary,
                                  ),
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 5),
                                  child: Text(
                                      item.userDate != null
                                          ? getDDMMMMYYYY(getCaseMMMMDYYYY(
                                              item.userDate.toString()))
                                          : "No date given in this matter",
                                      style: mpHeadLine12(
                                          textColor: item.is_disposed == true
                                              ? AppColor.white
                                              : AppColor.white)),
                                )
                              ],
                            )
                          : SizedBox()
                      /*    RichText(
                        text: TextSpan(
                            text: "Next Date: ",
                            style: mpHeadLine12(
                                fontWeight: FontWeight.w600,
                                textColor: item.is_disposed == true
                                    ? AppColor.white
                                    : AppColor.white),
                            children: <TextSpan>[
                              TextSpan(
                                  text: item.userDate != null
                                      ? getDDMMMMYYYY(getCaseMMMMDYYYY(
                                          item.userDate.toString()))
                                      : "No date given in this matter",
                                  style: mpHeadLine12(
                                      textColor: item.is_disposed == true
                                          ? AppColor.white
                                          : AppColor.white)),
                            ]),
                      )*/
                    ],
                  ),
                ),
              ),
            ],
          );
  }

  void dateSelectCallback(String date,
      {bool isNextDateScroll = false, bool isFilter = false}) {
    setState(() {
      isLoading = true;
    });
    print("dateSelectCallback $date");
    if (!isFilter) {
      int index =
          newList.indexWhere((element) => date == (element.causeListDate!));
      //
      print("dateSelectCallback index $index");
      print("isFilter ${!isFilter}");
      print("filterList ${filterList.length}");
      print("filterList ${filterList}");
      // print("dateSelectCallback sno ${caseList![index].sno}");
      // int index = 4;

      if (index != -1) {
        // print("heelo ${indcontroller.originIndex}");
        // indcontroller.jumpToIndex(43);
        // ancscrollController!.jumpTo(33);
        // ancscrollController!.scrollToIndex(index: 333);
        listViewController.sliverController.jumpToIndex(index);
        // _outerScrollController
        //     .scrollToIndex(index, preferPosition: AutoScrollPosition.begin)
        //     .then((value) {
        setState(() {
          isLoading = false;
        });
        // });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      int index =
          filterList.indexWhere((element) => date == (element.causeListDate!));
      //
      print("isFilter ${!isFilter}");
      print("filterList ${filterList.length}");
      print("filterList ${filterList}");
      print("dateSelectCallback index $index");
      // print("dateSelectCallback sno ${caseList![index].sno}");
      // int index = 4;

      if (index != -1) {
        filterViewController.sliverController.jumpToIndex(index);
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void datesCourtSelectCallback(String date, String courtNo) {
    print("courtSelectCallback");
    setState(() {
      isLoading = true;
    });
    int index = newList.indexWhere((element) =>
        date == element.causeListDate && courtNo == element.courtNo);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      listViewController.sliverController.jumpToIndex(index);
      setState(() {
        isLoading = false;
      });
    });
  }

  void filterData(String filterType) {
    // print("filter by $filterType");
    // print("filter lastscrolledMap $lastscrolledMap");

    setState(() {
      filterList = [];
      isFilter = false;
      selectedFilter = "";
      filterFirstVisibleIndex = 0;
      // isfilterLoading = true;
    });
    // print("filter byfilterList $filterList");
    if (filterType.isNotEmpty) {
      print("filterList ${filterList.length}");
      print("filterList ${filterList}");
      for (int i = 0; i < newList.length; i++) {
        // print("newlist for index $i //isdateChange ${newList[i].isdateChange}");
        // if(newList[i].isdateChange!=null && newList[i].isdateChange==true){
        //   filterList.add(newList[i]);
        // }

        if (filterType == "Order judgement File available") {
          if (newList[i].orderFile != null &&
              newList[i].orderFile!.isNotEmpty) {
            // if(newList[i].isdateChange!=null && newList[i].isdateChange==true){
            //   filterList.add(newList[i]);
            // }
            if (!filterList!.any((element) =>
                element.causeListDate == newList![i].causeListDate)) {
              newList[i].isdateChange = true;
              filterList.add(newList[i]);
            }
            if (!filterList.contains(newList[i])) {
              filterList.add(newList[i]);
            }
            // filterList.add(newList[i]);
          }
        } else if (filterType == "No Order judgement File available") {
          if (newList[i].orderFile == null || newList[i].orderFile!.isEmpty) {
            if (!filterList!.any((element) =>
                element.causeListDate == newList![i].causeListDate)) {
              newList[i].isdateChange = true;
              filterList.add(newList[i]);
            }

            // if(newList[i].isdateChange!=null && newList[i].isdateChange==true){
            //   filterList.add(newList[i]);
            // }
            if (!filterList.contains(newList[i])) {
              filterList.add(newList[i]);
            }
          }
        } else if (filterType == "Comments available") {
          print(
              "ok ggole ${newList[i].commentDetails != null && newList[i].commentDetails!.isNotEmpty}");
          if (newList[i].commentDetails != null &&
              newList[i].commentDetails!.isNotEmpty) {
            // print("added on index $i and sno ${newList[i].sno} and "
            //     "isdateChange ${newList[i].isdateChange}"
            //   "date ${newList[i].causeListDate}");

            // if(newList[i].isdateChange!=null && newList[i].isdateChange==true){
            //   filterList.add(newList[i]);
            // }
            if (!filterList.any((element) =>
                element.causeListDate == newList[i].causeListDate)) {
              newList[i].isdateChange = true;
              filterList.add(newList[i]);
            }
            if (!filterList.contains(newList[i])) {
              filterList.add(newList[i]);
            }

            // if(filterList.every((element) => element.isdateChange==newList[i].isdateChange)){
            //   filterList.add(newList[i]);
            // }

            // if(!filterList.contains(newList[i])) {
            //   filterList.add(newList[i]);
            // }else{
            //   print("not matched");
            // }
          }
        } else if (filterType == "Comments not available") {
          if (newList[i].commentDetails == null ||
              newList[i].commentDetails!.isEmpty) {
            // print("sno ${newList[i].sno} and "
            //     "isdateChange ${newList[i].isdateChange}"
            //     "date ${newList[i].causeListDate} && contains ${filterList.contains(newList[i])}");

            // if(newList[i].isdateChange!=null && newList[i].isdateChange==true){
            //   filterList.add(newList[i]);
            // }
            if (!filterList!.any((element) =>
                element.causeListDate == newList![i].causeListDate)) {
              newList[i].isdateChange = true;
              filterList.add(newList[i]);
            }
            if (!filterList.contains(newList[i])) {
              filterList.add(newList[i]);
            }
            // else
            //     filterList.every((element) =>
            //     element.isdateChange!=newList[i].isdateChange)){
            //   filterList.add(newList[i]);
            // }

            //  if(filterList.every((element) =>
            // element.sno!=newList[i].sno && element.courtNo!=newList[i].courtNo
            //      && element.causeListDate!=newList[i].causeListDate
            //  )){
            //    filterList.add(newList[i]);
            //  }else{
            //    print("good");
            //  }
          }
        }
      }

      for (int i = 0; i < filterList.length; i++) {
        if (i == 0 ||
            filterList[i].courtNo == "Before Registrar (Admin.)" ||
            filterList[i].courtNo == "Before Dy. Registrar (Judicial)") {
          filterList[i].iscourtChange = false;
        } else {
          if (filterList[i - 1].courtNo == "Before Registrar (Admin.)") {
            filterList[i].iscourtChange = true;
          } else if (filterList[i - 1].courtNo ==
              "Before Dy. Registrar (Judicial)") {
            filterList[i].iscourtChange = true;
          } else if (int.parse(filterList[i].courtNo!) !=
              int.parse(filterList[i - 1].courtNo!)) {
            filterList[i].iscourtChange = true;
          } else {
            filterList[i].iscourtChange = false;
          }
        }
      }

      filterDatesCourt = [];
      for (int i = 0; i < filterList!.length; i++) {
        if (!filterDatesCourt
            .any((element) => element.date == filterList[i].causeListDate)) {
          DatesCourtModel model = DatesCourtModel();
          model.date = filterList[i].causeListDate!;
          model.courtNo = [];
          model.courtNo!.add(filterList[i].courtNo);
          filterDatesCourt.add(model);
        } else {
          int index = filterDatesCourt.indexWhere(
              (element) => element.date == filterList[i].causeListDate);
          if (!filterDatesCourt[index]
              .courtNo!
              .contains(filterList[i].courtNo)) {
            filterDatesCourt[index].courtNo!.add(filterList[i].courtNo);
          }
        }
      }

      print("filterList ${filterList.length}");
      if (filterList.length < 3) {
        Future.delayed(Duration(milliseconds: 1000), () {
          print("jumped");
          filterViewController.sliverController.jumpToIndex(0);
        });
      }

      selectedFilter = filterType;
      isFilter = true;
    } else {
      filterList = [];
      isFilter = false;
      selectedFilter = "";
    }
    Future.delayed(Duration(milliseconds: 100), () {
      //filterViewController.sliverController.jumpToIndex(0);
      setState(() {});
    });
  }

  String getEEEddMMyyHistory(String inputDateString) {
    DateTime inputDate =
        DateFormat('EEE, dd MMM yyyy HH:mm:ss zzz').parse(inputDateString);
    String outputDate = DateFormat('dd/MM/yyyy').format(inputDate);
    return outputDate;
  }

  List<CaseList> filterHiddenCases(List<CaseList> cases, bool showHidden) {
    if (showHidden) {
      return cases;
    } else {
      return cases.where((caseItem) => caseItem.is_hide == 0).toList();
    }
  }

  String formatCauseListDateString(String dateString) {
    String formattedDate = "N/A";
    if (dateString != "None") {
      print("formatCauseListDateString$dateString");
      DateTime dateTime =
          DateFormat('yyyy-MM-dd HH:mm:ss.SSSSSS').parse(dateString);
      formattedDate = DateFormat('dd MMM yyyy').format(dateTime);
    }
    return formattedDate;
  }
}
