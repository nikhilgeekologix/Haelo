import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_list_view/flutter_list_view.dart';
import 'package:haelo_flutter/constants.dart';
import 'package:haelo_flutter/core/utils/functions.dart';
import 'package:haelo_flutter/core/utils/save_file.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/alert/cubit/my_alert_cubit.dart';
import 'package:haelo_flutter/features/alert/cubit/my_alert_state.dart';
import 'package:haelo_flutter/features/alert/data/datasource/my_alert_datasource.dart';
import 'package:haelo_flutter/features/alert/data/model/my_alert_model.dart';
import 'package:haelo_flutter/features/cases/cubit/deletecomment_state.dart';
import 'package:haelo_flutter/features/cases/presentation/screens/addcomment.dart';
import 'package:haelo_flutter/features/cases/presentation/screens/casedetails.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/color_node.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/no_data_widget.dart';
import 'package:haelo_flutter/features/causeslist/data/model/date_court_model.dart';
import 'package:haelo_flutter/features/causeslist/presentation/widget/datelist_courtno_dialog.dart';
import 'package:haelo_flutter/features/home_page/presentation/widgets/case_info.dart';
import 'package:haelo_flutter/features/order_comment_history/data/model/WatchlistDataType.dart';
import 'package:haelo_flutter/locators.dart' as di;
import 'package:haelo_flutter/widgets/date_format.dart';
import 'package:haelo_flutter/widgets/error_widget.dart';
import 'package:haelo_flutter/widgets/progress_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../cases/cubit/deletecomment_cubit.dart';
import '../../../causeslist/cubit/hidecauselist_cubit.dart';
import '../../../causeslist/cubit/hidecauselist_state.dart';
import '../../cubit/pending_order_download_file_cubit.dart';
import '../../cubit/pending_order_download_file_state.dart';
import '../../cubit/pending_order_report_cubit.dart';
import '../../cubit/pending_order_report_state.dart';
import '../../cubit/pending_order_update_cubit.dart';
import '../../cubit/pending_order_update_state.dart';
import '../../data/model/pending_oder_report_model.dart';

/// first class
class PendingCmtHistory extends StatelessWidget {
  WatchListDataType? selectedLawyer;
  bool isFromCmt;

  PendingCmtHistory({Key? key, this.selectedLawyer, this.isFromCmt = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MyAlertCubit>(
            create: (BuildContext context) => MyAlertCubit(di.locator())),
      ],
      child: PendingCmtReportPageSecond(
        selectedLawyer: selectedLawyer,
        isFromCmt: isFromCmt,
      ),
    );
  }
}

/// second class
class PendingCmtReportPageSecond extends StatefulWidget {
  WatchListDataType? selectedLawyer;
  bool isFromCmt;

  // Function? state;

  PendingCmtReportPageSecond(
      {Key? key, this.selectedLawyer, this.isFromCmt = false})
      : super(key: key);

  @override
  State<PendingCmtReportPageSecond> createState() =>
      _ViewCauseListSecondState();
}

class _ViewCauseListSecondState extends State<PendingCmtReportPageSecond> {
  @override
  Widget build(BuildContext context) {
    return PendingCmtReportPage(
        selectedLawyer: widget.selectedLawyer, isFromCmt: widget.isFromCmt);
  }
}

class PendingCmtReportPage extends StatefulWidget {
  WatchListDataType? selectedLawyer;
  bool isFromCmt;

  PendingCmtReportPage({this.selectedLawyer, this.isFromCmt = false});

  @override
  State<PendingCmtReportPage> createState() =>
      _OrderCmtHistoryState(this.selectedLawyer);
}

class _OrderCmtHistoryState extends State<PendingCmtReportPage> {
  WatchListDataType? currentLawyer;
  bool isLoading = true;
  bool isHiddenCases = true;
  List causeList = [];
  List<Lawyerlist> lawyerList = [];
  List<Watchlist> watchList = [];
  bool showToast = true;
  // List dates = [];
  List<CaseList>? caseList = [];
  List<CaseList> filteredCases = [];

  int recursiveDateCall = 0;
  late SharedPreferences pref;
  List<WatchListDataType>? dropDownList = [];
  bool isDrag = false;

  // final List<AutoScrollController> _innerScrollControllers = [];
  List<CaseList> newList = [];
  int listFirstVisibleIndex = 0;
  int filterFirstVisibleIndex = 0;
  final ScrollController _horizontalDateController = ScrollController();
  List<DatesCourtModel> newDatesCourt = [];
  List<DatesCourtModel> filterDatesCourt = [];

  //filter work
  String selectedFilter = "";
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

  //for search only
  bool isSearch = false;
  bool isSearchFilter = false;
  TextEditingController search_textController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  List<CaseList> searchList = [];

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
    print("setMainListIndex Is Running ");
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

          print("setMainListIndex listViewController: $listViewController");
          print(
              "setMainListIndex sliverController: ${listViewController?.sliverController}");
          print(
              "setMainListIndex stickyIndex: ${listViewController?.sliverController?.stickyIndex?.value}");
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
    BlocProvider.of<PendingOrderReportCubit>(context).fetchPendingOrderReport();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.home_background,
      appBar: AppBar(
        leading: !isSearch
            ? GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back_ios_new_sharp,
                  size: 24,
                ),
              )
            : SizedBox(),
        backgroundColor: AppColor.white,
        titleSpacing: 0,
        centerTitle: false,
        title: Text(
          "Pending Order Report",
          style: mpHeadLine16(
              fontWeight: FontWeight.w500,
              textColor: AppColor.bold_text_color_dark_blue),
        ),
        actions: [
          isChecked && !isSearch
              ? InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddComment()));
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
          !isSearch
              ? Padding(
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
                        /*  AppMsgPopup(
                          "Hidden case Visible",
                          isCloseIcon: false,
                          isError: false,
                        );*/
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
                        ? const Icon(
                            Icons.remove_red_eye_outlined,
                            size: 26,
                          )
                        : const Icon(
                            Icons.remove_red_eye,
                            size: 26,
                          ),
                  ),
                )
              : SizedBox(),
          newList.isEmpty
              ? SizedBox()
              : !isSearch
                  ? Container(
                      margin: EdgeInsets.only(right: 5, left: 5),
                      child: InkWell(
                          onTap: () => setState(() {
                                isSearch = true;
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                _focusNode.requestFocus();
                              }),
                          child: const Icon(
                            Icons.search,
                            size: 26,
                            color: Colors.black,
                          )),
                    )
                  : Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 12),
                        child: TextField(
                          onChanged: (value) {
                            searchFilterList(value);
                            setState(() {
                              isSearchFilter = false;
                            });
                          },
                          focusNode: _focusNode,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  searchFilterList("");
                                  setState(() {
                                    isSearch = false;
                                    isSearchFilter = false;
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                  });
                                  /* Clear the search field */
                                },
                              ),
                              hintText: 'Search...',
                              border: InputBorder.none),
                        ),
                      ),
                    ),
          !isSearch
              ? GestureDetector(
                  onTap: () {
                    var pendingOrderData = {
                      "lawyerName": currentLawyer!.lawyerName.toString(),
                      "downloadFile": "Excel",
                    };
                    BlocProvider.of<PendingOrderDownloadFileCubit>(context)
                        .fetchPendingOrderDownloadFile(pendingOrderData);
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(
                      Icons.download,
                      size: 25,
                    ),
                  ),
                )
              : SizedBox(),
          !isSearch
              ? GestureDetector(
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
              : SizedBox()
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

                    for (int i = 0; i < causeList.length; i++) {
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

                    for (int j = 0; j < lawyerList.length; j++) {
                      dropDownList!.add(WatchListDataType("lawyer",
                          lawyerName: lawyerList[j].lawyerName != null &&
                                  lawyerList[j]
                                      .lawyerName!
                                      .toString()
                                      .isNotEmpty
                              ? lawyerList[j].lawyerName!
                              : lawyerList[j].selectedCaseNo ?? ""));
                    }

                    for (int k = 0; k < watchList.length; k++) {
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
                        Lawyerlist checkedLawyer = lawyerList!.firstWhere(
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
                  dropDownList!.isNotEmpty
                      ? Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Note: Only cases which are created in your 'My cases', will be tracked in this report.",
                                    style: mpHeadLine12(
                                        textColor: Colors.red.shade800),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ),
                            ),
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
                    child: BlocConsumer<PendingOrderReportCubit,
                        PendingOrderReportState>(builder: (context, state) {
                      // if (state is OrderCommentHistoryLoading) {
                      //   return AppProgressIndicator();
                      // }
                      if (state is PendingOrderReportLoaded) {
                        var model = state.model;
                        if (model.result == 1 && model.data != null) {
                          if (filterList.isEmpty && !isFilter) {
                            filteredCases =
                                filterHiddenCases(newList, isHiddenCases);
                          } else {
                            filteredCases =
                                filterHiddenCases(filterList, isHiddenCases);
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
                                                  print("searchViewController");
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
                                            controller:
                                                _horizontalDateController,
                                            shrinkWrap: true,
                                            children: filterDates.map((e) {
                                              print(
                                                  "newDatesCourt ==> ${e.date}");
                                              return InkWell(
                                                onTap: () {
                                                  dateSelectCallback(
                                                    e.date!,
                                                  );
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      color: e.date ==
                                                              (filteredCases[
                                                                      listFirstVisibleIndex]
                                                                  .causeListDate!)
                                                          ? AppColor.primary
                                                          : AppColor.white,
                                                      border: Border.all(
                                                        color: AppColor.primary,
                                                      )),
                                                  margin: EdgeInsets.only(
                                                      right: 10),
                                                  alignment: Alignment.center,
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
                                                        (getddMMYYYY_with_splash(
                                                            e.date!)),
                                                        style: appTextStyle(
                                                          textColor: e.date ==
                                                                  (filteredCases[
                                                                          listFirstVisibleIndex]
                                                                      .causeListDate!)
                                                              ? AppColor.white
                                                              : AppColor
                                                                  .primary,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }).toList()),
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
                                                      print(
                                                          "filterViewController");
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
                                                scrollDirection:
                                                    Axis.horizontal,
                                                controller:
                                                    _horizontalDateController,
                                                shrinkWrap: true,
                                                children: filterDates.map((e) {
                                                  print(
                                                      "newDatesCourt ==> ${e.date}");
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
                                                            (getddMMYYYY_with_splash(
                                                                e.date!)),
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
                      if (state is PendingOrderReportLoading) {
                        setState(() {
                          isLoading = true;
                        });
                      }
                      if (state is PendingOrderReportLoaded) {
                        var model = state.model;
                        if (model.result == 1 &&
                            model.data != null &&
                            model.data!.caseList!.isNotEmpty) {
                          caseList = [];
                          caseList = model.data!.caseList;

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
                              casData.caseTitle = caseList![i].caseTitle;
                              casData.causeListDate =
                                  caseList![i].causeListDate;
                              casData.courtNo = caseList![i].courtNo;
                              casData.dateOfListinng =
                                  caseList![i].dateOfListinng;
                              casData.sno = caseList![i].sno;
                              casData.stage = caseList![i].stage;
                              casData.userDate = caseList![i].userDate;
                              casData.intrimStay = caseList![i].intrimStay;
                              casData.isDisposed = caseList![i].isDisposed;
                              casData.isHide = caseList![i].isHide;
                              casData.dateType = caseList![i].dateType;
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
                            cas.caseTitle = caseList![i].caseTitle;
                            cas.causeListDate = caseList![i].causeListDate;
                            cas.courtNo = caseList![i].courtNo;
                            cas.dateOfListinng = caseList![i].dateOfListinng;
                            cas.sno = caseList![i].sno;
                            cas.stage = caseList![i].stage;
                            cas.userDate = caseList![i].userDate;
                            cas.intrimStay = caseList![i].intrimStay;
                            cas.isDisposed = caseList![i].isDisposed;
                            cas.isHide = caseList![i].isHide;
                            cas.dateType = caseList![i].dateType;

                            // GlobalKey subListKey = GlobalKey();
                            // cas.subListgKey = subListKey;

                            cas.isdateChange = false;
                            newList.add(cas);
                            setState(() {
                              searchList = newList;
                            });
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
                          print("lastscrolledMap $lastscrolledMap");

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
                      if (state is PendingOrderReportError) {
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
                        fetchData();
                        toast(msg: deleteCommentList.msg.toString());
                        /* showDialog(
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
                  BlocConsumer<PendingOrderDownloadFileCubit,
                      PendingOrderDownloadFileState>(
                    builder: (context, state) {
                      return const SizedBox();
                    },
                    listener: (context, state) {
                      if (state is PendingOrderDownloadFileLoading) {
                        setState(() {
                          isLoading = true;
                        });
                      }
                      if (state is PendingOrderDownloadFileLoaded) {
                        var model = state.model;
                        if (model.result == 1) {
                          var dataDownload = model.data;
                          setState(() {
                            /// for download file only
                            if (dataDownload!.downloadFile != null &&
                                dataDownload.downloadFile! != "" &&
                                dataDownload.downloadFile!.isNotEmpty) {
                              toast(msg: "Downloading started");
                              DateTime now = DateTime.now();
                              var fileName =
                                  "Pending Order Report_${now.millisecondsSinceEpoch}.${dataDownload.downloadFile!.toString().split(".").last}";
                              downloadData(
                                  dataDownload.downloadFile!, fileName);
                            }
                            isLoading = false;
                          });
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      } else {
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          BlocConsumer<PendingOrderUpdateCubit, PendingOrderUpdateState>(
            builder: (context, state) {
              return const SizedBox();
            },
            listener: (context, state) {
              if (state is PendingOrderUpdateLoading) {
                setState(() {
                  isLoading = true;
                });
              }
              if (state is PendingOrderUpdateLoaded) {
                var hideListModel = state.model;
                setState(() {
                  showToast = false;
                  isLoading = false;
                });
                if (hideListModel.result == 1) {
                  toast(msg: hideListModel.msg.toString());
                } else {
                  print(hideListModel.result);
                  toast(msg: hideListModel.msg.toString());
                }
              }
              if (state is PendingOrderUpdateError) {
                var hideListModel = state.message;
                setState(() {
                  showToast = false;
                  isLoading = false;
                });
                toast(msg: hideListModel);
              }
            },
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
                //
                // dateSelectCallback("16/08/2023");
                showDialog(
                    context: context,
                    builder: (ctx) => CauseDateListCourtNo(newDatesCourt,
                        dateSelectCallback, datesCourtSelectCallback, true));
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
    DateTime causeDate = DateFormat("yyyy-MM-dd").parse(item.causeListDate!);
    bool isUserDate = false;
    DateTime now = DateTime.now();

    print("isdateChange ==> ${item.isdateChange}");

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
                  (getddMMYYYY_with_splash(item.causeListDate!)),
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
                color: item.isDisposed == true
                    ? AppColor.disposedColor
                    : item.isHide == 1 && isHiddenCases
                        ? AppColor.text_grey_color
                        : item.intrimStay.toString().toLowerCase() == "no stay"
                            ? AppColor.cases_nostay
                            : item.intrimStay.toString().toLowerCase() ==
                                    "interim stay"
                                ? AppColor.cases_intrimstay
                                : item.intrimStay.toString().toLowerCase() ==
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: RichText(
                              text: TextSpan(
                                  text: "Court No.:",
                                  style: mpHeadLine12(
                                      fontWeight: FontWeight.w600,
                                      textColor: item.isDisposed == true
                                          ? AppColor.white
                                          : AppColor.black),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: item.courtNo != null
                                            ? item.courtNo.toString()
                                            : "",
                                        style: mpHeadLine12(
                                            textColor: item.isDisposed == true
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
                                        textColor: item.isDisposed == true
                                            ? AppColor.white
                                            : AppColor.black),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: item.sno != null
                                              ? item.sno.toString()
                                              : "",
                                          style: mpHeadLine12(
                                              textColor: item.isDisposed == true
                                                  ? AppColor.white
                                                  : AppColor.black)),
                                    ]),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  var hideListData = {
                                    "case_id": item.caseId.toString(),
                                  };
                                  BlocProvider.of<PendingOrderUpdateCubit>(
                                          context)
                                      .fetchPendingOrderUpdate(hideListData);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 2),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      color: AppColor.accepted_color_text),
                                  child: Text("Update",
                                      style: appTextStyle(
                                          textColor: AppColor.white,
                                          fontSize: 11)),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (ctx) {
                                        return AlertDialog(
                                          // insetPadding: EdgeInsets.symmetric(vertical: 305),
                                          contentPadding: EdgeInsets.zero,
                                          content: SizedBox(
                                            // width: mediaQW(context) * 0.8,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20,
                                                          right: 20,
                                                          top: 25),
                                                  child: Text(
                                                    "Clicking on YES would not track if any order/judgement for ${item.caseNo.toString()}, on ${getddMMYYYY_with_splash(item.causeListDate.toString())} gets uploaded on HC website ",
                                                    textAlign: TextAlign.center,
                                                    style: mpHeadLine14(
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 25,
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: InkWell(
                                                        onTap: () {
                                                          var hideListData = {
                                                            "causeId": item
                                                                .caseNo
                                                                .toString(),
                                                            "causeDate": item
                                                                .causeListDate
                                                                .toString(),
                                                            "requestType":
                                                                "pending",
                                                          };
                                                          BlocProvider.of<
                                                                      HideCauseListCubit>(
                                                                  context)
                                                              .fetchHideCauseList(
                                                                  hideListData);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          height:
                                                              mediaQH(context) *
                                                                  0.05,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .only(
                                                                      bottomLeft:
                                                                          Radius.circular(
                                                                              5)),
                                                              border: Border.all(
                                                                  color: AppColor
                                                                      .primary)),
                                                          child: Text(
                                                            "Yes",
                                                            style: mpHeadLine16(
                                                                textColor:
                                                                    AppColor
                                                                        .primary),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: InkWell(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          height:
                                                              mediaQH(context) *
                                                                  0.05,
                                                          decoration:
                                                              const BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.only(
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            5)),
                                                            color: AppColor
                                                                .primary,
                                                          ),
                                                          child: Text(
                                                            "No",
                                                            style: mpHeadLine16(
                                                                textColor:
                                                                    AppColor
                                                                        .white),
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
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 2),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      color: AppColor.rejected_color_text),
                                  child: Text("Stop tracking",
                                      style: appTextStyle(
                                          textColor: AppColor.white,
                                          fontSize: 11)),
                                ),
                              ),

                              /*   SizedBox(
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
                                      }
                                      else {
                                        await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AddCaseCauseList(
                                                      getCaseNum: item.caseNo
                                                          .toString(),
                                                    ))).then((value) {
                                          if (value != null && value) {
                                            setState(() {
                                              lastscrolledMap['sno'] =
                                                  item.sno.toString();
                                              lastscrolledMap['courtno'] =
                                                  item.courtNo.toString();
                                              lastscrolledMap['date'] =
                                                  item.causeListDate.toString();
                                            });
                                            fetchData();
                                          }
                                        });
                                      }
                                    } else if (i == 2) {
                                      showDialog(
                                          context: context,
                                          builder: (ctx) {
                                            return AlertDialog(
                                              // insetPadding: EdgeInsets.symmetric(vertical: 305),
                                              contentPadding: EdgeInsets.zero,
                                              content: SizedBox(
                                                // width: mediaQW(context) * 0.8,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20,
                                                              right: 20,
                                                              top: 25),
                                                      child: Text(
                                                        "Are you sure you want to hide your cause ${item.caseNo.toString()}",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: mpHeadLine14(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 25,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: InkWell(
                                                            onTap: () {
                                                              var hideListData =
                                                                  {
                                                                "causeId": item
                                                                    .caseNo
                                                                    .toString(),
                                                                "causeDate": item
                                                                    .causeListDate
                                                                    .toString(),
                                                                "requestType":
                                                                    "pending",
                                                              };
                                                              BlocProvider.of<
                                                                          HideCauseListCubit>(
                                                                      context)
                                                                  .fetchHideCauseList(
                                                                      hideListData);
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              height: mediaQH(
                                                                      context) *
                                                                  0.05,
                                                              decoration: BoxDecoration(
                                                                  borderRadius: const BorderRadius
                                                                      .only(
                                                                      bottomLeft:
                                                                          Radius.circular(
                                                                              5)),
                                                                  border: Border.all(
                                                                      color: AppColor
                                                                          .primary)),
                                                              child: Text(
                                                                "Yes",
                                                                style: mpHeadLine16(
                                                                    textColor:
                                                                        AppColor
                                                                            .primary),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: InkWell(
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              height: mediaQH(
                                                                      context) *
                                                                  0.05,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                borderRadius: BorderRadius.only(
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            5)),
                                                                color: AppColor
                                                                    .primary,
                                                              ),
                                                              child: Text(
                                                                "No",
                                                                style: mpHeadLine16(
                                                                    textColor:
                                                                        AppColor
                                                                            .white),
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
                                    }
                                  },
                                  padding:
                                      const EdgeInsets.only(top: 0, bottom: 7),
                                  icon: Icon(
                                    Icons.more_vert_outlined,
                                    size: 20,
                                    color: item.isDisposed == true
                                        ? AppColor.white
                                        : AppColor.black,
                                  ),
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 2,
                                      child: Text("Hide"),
                                    ),
                                  ],
                                  color: Colors.white,
                                  elevation: 2,
                                ),
                              ),*/
                              causeDate.difference(now).inDays > -1
                                  ? InkWell(
                                      onTap: () {
                                        print(
                                            "dateToday ${item.causeListDate.toString()}");
                                        Map<String, String> summary = {
                                          "dateToday":
                                              item.causeListDate.toString(),
                                          "courtNo": item.courtNo.toString(),
                                          "benchName": item.benchName != null
                                              ? item.benchName.toString()
                                              : "",
                                        };
                                        showDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            builder: (BuildContext context) {
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
                              BlocConsumer<HideCauseListCubit,
                                  HideCauseListState>(
                                builder: (context, state) {
                                  return const SizedBox();
                                },
                                listener: (context, state) {
                                  if (state is HideCauseListLoaded) {
                                    var hideListModel =
                                        state.hideCauseListModel;
                                    if (hideListModel.result == 1) {
                                      fetchData();
                                    } else {
                                      print(hideListModel.result);
                                    }
                                  }
                                },
                              ),
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
                                textColor: item.isDisposed == true
                                    ? AppColor.white
                                    : AppColor.black),
                          ),
                          Flexible(
                            child: Text(
                                item.benchName != null
                                    ? item.benchName.toString()
                                    : "",
                                style: mpHeadLine12(
                                    textColor: item.isDisposed == true
                                        ? AppColor.white
                                        : AppColor.black)),
                          ),
                        ],
                      ),
                      /*  SizedBox(
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
                    : SizedBox(),*/
                      const SizedBox(
                        height: 10,
                      ),
                      RichText(
                        text: TextSpan(
                            text: "Stage:  ",
                            style: mpHeadLine12(
                                fontWeight: FontWeight.w600,
                                textColor: item.isDisposed == true
                                    ? AppColor.white
                                    : AppColor.black),
                            children: <TextSpan>[
                              TextSpan(
                                  text: item.stage != null
                                      ? item.stage.toString()
                                      : "",
                                  style: mpHeadLine12(
                                      textColor: item.isDisposed == true
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
                                      textColor: item.isDisposed == true
                                          ? AppColor.white
                                          : AppColor.black),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: item.caseNo != null
                                            ? item.caseNo.toString()
                                            : "",
                                        style: mpHeadLine12(
                                            textColor: item.isDisposed == true
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
                                    text: item.caseTitle != null
                                        ? item.caseTitle.toString()
                                        : "",
                                    style: mpHeadLine12(
                                        textColor: AppColor.primary)),
                              ]),
                        ),
                      ),
                      SizedBox(
                        height: item.caseId != null ? 10 : 0,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: item.userDate != null ? 10 : 0,
                      ),
                      item.userDate != null && isUserDate
                          ? RichText(
                              text: TextSpan(
                                  text: "Order Date (if populated): ",
                                  style: mpHeadLine12(
                                      fontWeight: FontWeight.w600,
                                      textColor: item.isDisposed == true
                                          ? AppColor.white
                                          : AppColor.black),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: item.userDate != null
                                            ? getDDMMMMYYYY(getCaseMMMMDYYYY(
                                                item.userDate.toString()))
                                            : "",
                                        style: mpHeadLine12(
                                            textColor: item.isDisposed == true
                                                ? AppColor.white
                                                : AppColor.black)),
                                  ]),
                            )
                          : SizedBox(),
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
      int index = newList.indexWhere((element) {
        print(
            "causeListDate ${element.causeListDate!}"); // Print element.causeListDate!
        return date == (element.causeListDate!);
      });

      //
      print("isFilter ${!isFilter}");
      print("filterList ${filterList.length}");
      print("filterList ${filterList}");
      print("dateSelectCallback index $index");

      if (index != -1) {
        listViewController.sliverController.jumpToIndex(index);
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

      print("isFilter ${!isFilter}");
      print("Date data  ${!isFilter}");
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

    listViewController.sliverController.jumpToIndex(index);
    setState(() {
      isLoading = false;
    });
    /*  SchedulerBinding.instance.addPostFrameCallback((_) {

    });*/
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

  List<String> sortDateStrings(List<String> dateStrings) {
    List<DateTime> dates = dateStrings
        .map((dateString) => DateFormat('dd/MM/yyyy').parse(dateString))
        .toList();

    dates.sort((a, b) => a.compareTo(b));

    List<String> sortedDateStrings =
        dates.map((date) => DateFormat('dd/MM/yyyy').format(date)).toList();

    return sortedDateStrings;
  }

  void searchFilterList(String searchText) {
    List<CaseList>? results = [];
    int index = -1;
    if (searchText.isEmpty) {
      setState(() {
        results = newList;
        index = -1;
      });
    } else {
      for (var item in newList) {
        if (item.caseTitle != null &&
                item.caseTitle!.toLowerCase().contains(searchText) ||
            item.caseNo != null &&
                item.caseNo!.toLowerCase().contains(searchText) ||
            item.sno != null && item.sno!.toLowerCase().contains(searchText) ||
            item.courtNo != null &&
                item.courtNo!.toLowerCase().contains(searchText) ||
            item.stage != null &&
                item.stage!.toLowerCase().contains(searchText)) {
          if (!results.contains(item)) {
            results.add(item);
          }
        }
      }
    }
    setState(() {
      searchList = results!;
    });

    if (searchList.isNotEmpty) {
      listViewController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  List<CaseList> filterHiddenCases(List<CaseList> cases, bool showHidden) {
    if (showHidden) {
      return cases;
    } else {
      return cases.where((caseItem) => caseItem.isHide == 0).toList();
    }
  }

  downloadData(String file, fileName) async {
    await downloadFiles(file, fileName);
  }
}
