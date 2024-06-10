import 'dart:convert';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_list_view/flutter_list_view.dart';
import 'package:haelo_flutter/constants.dart';
import 'package:haelo_flutter/core/utils/functions.dart';
import 'package:haelo_flutter/core/utils/hightlight_text.dart';
import 'package:haelo_flutter/core/utils/save_file.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/bottom_bar/presentation/screens/bottombar.dart';
import 'package:haelo_flutter/features/cases/presentation/screens/casedetails.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/color_node.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/no_data_widget.dart';
import 'package:haelo_flutter/features/causeslist/cubit/hidecauselist_cubit.dart';
import 'package:haelo_flutter/features/causeslist/cubit/hidecauselist_state.dart';
import 'package:haelo_flutter/features/causeslist/cubit/viewcauselist_cubit.dart';
import 'package:haelo_flutter/features/causeslist/cubit/viewcauselist_state.dart';
import 'package:haelo_flutter/features/causeslist/data/model/date_court_model.dart';
import 'package:haelo_flutter/features/causeslist/data/model/viewcauselist_model.dart';
import 'package:haelo_flutter/features/causeslist/presentation/screen/causelist_screen.dart';
import 'package:haelo_flutter/features/causeslist/presentation/widget/causelist_heading%20name.dart';
import 'package:haelo_flutter/features/causeslist/presentation/widget/court_list_dialog.dart';
import 'package:haelo_flutter/features/causeslist/presentation/widget/customizetextfield.dart';
import 'package:haelo_flutter/features/causeslist/presentation/widget/datelist_courtno_dialog.dart';
import 'package:haelo_flutter/features/causeslist/presentation/widget/datelist_dialog.dart';
import 'package:haelo_flutter/features/causeslist/presentation/widget/download_causlist.dart';
import 'package:haelo_flutter/features/causeslist/presentation/widget/order_cmt_info_widget.dart';
import 'package:haelo_flutter/features/home_page/presentation/widgets/case_info.dart';
import 'package:haelo_flutter/features/order_comment_history/data/model/WatchlistDataType.dart';
import 'package:haelo_flutter/widgets/customExpansionTile.dart';
import 'package:haelo_flutter/widgets/date_format.dart';
import 'package:haelo_flutter/widgets/date_widget.dart';
import 'package:haelo_flutter/widgets/error_widget.dart';
import 'package:haelo_flutter/widgets/go_prime.dart';
import 'package:haelo_flutter/widgets/progress_indicator.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:haelo_flutter/locators.dart' as di;
import '../../../cases/presentation/widgets/watchlist_and_manually_dialog.dart';
import '../../../drawer_content/cubit/hidden_causelist_cubit.dart';
import '../../../drawer_content/cubit/unhide_causelist_cubit.dart';
import '../../../drawer_content/cubit/unhide_causelist_state.dart';
import '../../../google_drive/g_drive_handler/gdrivehandler_function.dart';
import '../../cubit/showwatchlist_cubit.dart';
import '../../cubit/showwatchlist_state.dart';
import '../../cubit/viewandsave_cubit.dart';
import '../../cubit/viewandsave_state.dart';
import '../widget/add_to_watchlist.dart';
import '../widget/lawyer_watchlist.dart';
import 'addcase_causelist.dart';
import 'causelist_page.dart';

/// first class
class ViewCauseListScreenNew extends StatelessWidget {
  final mainCauseListdata;
  bool isFromHomepage;
  bool isScrollToSno;
  bool isDownloadOption;
  bool isGotoCourt;
  bool isFilter;
  bool isQuickSearch;
  String quickScrollDate;
  bool isFromCmt = false;

  ViewCauseListScreenNew(
      {Key? key,
      this.mainCauseListdata,
      this.isFromHomepage = false,
      this.isScrollToSno = false,
      this.isDownloadOption = false,
      this.isGotoCourt = false,
      this.isFilter = true,
      this.isQuickSearch = false,
      this.quickScrollDate = "",
      this.isFromCmt = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ViewCauseListCubit>(
            create: (BuildContext context) => ViewCauseListCubit(di.locator())),
      ],
      child: Builder(builder: (context) {
        print("google ${isQuickSearch}");
        return ViewCauseListSecond(
          mainCauseListdata: mainCauseListdata,
          isFromHomepage: isFromHomepage,
          isScrollToSno: isScrollToSno,
          isDownloadOption: isDownloadOption,
          isGotoCourt: isGotoCourt,
          isFilter: isFilter,
          isQuickSearch: isQuickSearch,
          quickScrollDate: quickScrollDate,
          ctx: context,
          isFromCmt: isFromCmt,
        );
      }),
    );
  }
}

/// second class
class ViewCauseListSecond extends StatefulWidget {
  final mainCauseListdata;
  bool isFromHomepage;
  bool isScrollToSno;
  bool isDownloadOption;
  bool isGotoCourt;
  bool isFilter;
  bool isQuickSearch;
  String quickScrollDate;
  BuildContext? ctx;
  bool isFromCmt = false;

  // Function? state;

  ViewCauseListSecond(
      {Key? key,
      this.mainCauseListdata,
      this.isFromHomepage = false,
      this.isScrollToSno = false,
      this.isDownloadOption = false,
      this.isGotoCourt = false,
      this.isFilter = true,
      this.isQuickSearch = false,
      this.quickScrollDate = "",
      this.ctx,
      this.isFromCmt = false
      // this.state
      })
      : super(key: key);

  @override
  State<ViewCauseListSecond> createState() => _ViewCauseListSecondState();
}

class _ViewCauseListSecondState extends State<ViewCauseListSecond> {
  @override
  Widget build(BuildContext context) {
    return ViewCauseListMain(
      mainCauseListdata: widget.mainCauseListdata,
      isFromHomepage: widget.isFromHomepage,
      isScrollToSno: widget.isScrollToSno,
      isDownloadOption: widget.isDownloadOption,
      isGotoCourt: widget.isGotoCourt,
      isFilter: widget.isFilter,
      isQuickSearch: widget.isQuickSearch,
      quickScrollDate: widget.quickScrollDate,
      ctx: widget.ctx,
      isFromCmt: widget.isFromCmt,
    );
  }
}

/// third class
class ViewCauseListMain extends StatefulWidget {
  final mainCauseListdata;
  bool isFromHomepage;
  bool isScrollToSno;
  bool isDownloadOption;
  bool isGotoCourt;
  bool isFilter;
  bool isQuickSearch;
  String quickScrollDate;
  BuildContext? ctx;
  bool isFromCmt = false;

  // var state;

  ViewCauseListMain(
      {Key? key,
      this.mainCauseListdata,
      this.isFromHomepage = false,
      this.isScrollToSno = false,
      this.isDownloadOption = false,
      this.isGotoCourt = false,
      this.isFilter = true,
      this.isQuickSearch = false,
      this.quickScrollDate = "",
      this.ctx,
      this.isFromCmt = false})
      : super(key: key);

  @override
  State<ViewCauseListMain> createState() => _ViewCauseListState();
}

class _ViewCauseListState extends State<ViewCauseListMain> {
  int dateIndex = 0;
  String filePdf = "";
  String fileName = "";

  //both list used for filter only
  List courtNumList = [];
  List dates = [];
  List<DatesCourtModel> newDatesCourt = [];
  List<DatesCourtModel> searchDatesCourt = [];
  var caseId;
  List watchlistSelectedList = [];
  List<int> selectedList = [];
  List? displayWatchList;
  Data? viewCauseListData;

  DateTime dateFrom = DateTime.now();

  DateTime? dateTo;
  bool isLoading = true;
  bool isNodata = true;

  //for search only
  bool isSearch = false;
  bool isSearchFilter = false;
  TextEditingController search_textController = TextEditingController();
  List<Causelist> searchList = [];
  bool isToDateSelected = false;
  List newList = [];
  List filteredCases = [];

  //new work

  bool isSnoScroll = false;
  bool isQuickSearchScroll = false;
  bool isDrag = false;
  late SharedPreferences pref;
  int recursiveDateCall = 0;
  String selectedCaseNumber = "";
  String selectedFileType = "";

  // int _firstVisibleIndex = 0;
  // int _searchFirstVisibleIndex = 0;
  // final AutoScrollController _outerScrollController = AutoScrollController();
  bool isPartialLoading = true;
  bool isHiddenCases = true;
  final ScrollController _horizontalDateController = ScrollController();

  //14-9
  FlutterListViewController listViewController = FlutterListViewController();
  FlutterListViewController searchViewController = FlutterListViewController();
  int listFirstVisibleIndex = 0;
  int searchFirstVisibleIndex = 0;
  int _horizontalDateIndex = 0;
  WatchListDataType? selectedLawyer = WatchListDataType("lawyer");
  Map<String, dynamic> authMap = {};
  Map<String, dynamic> driveIdMap = {};

  @override
  void initState() {
    pref = di.locator();
    isSnoScroll = false;
    isQuickSearchScroll = false;
    Map<String, String> body = {};
    if (!widget.isFromHomepage) {
      body = {
        "dateFrom": widget.mainCauseListdata["dateFrom"] != null
            ? widget.mainCauseListdata["dateFrom"].toString()
            : "",
        "dateTo": widget.mainCauseListdata["dateTo"] != null
            ? widget.mainCauseListdata["dateTo"].toString()
            : "",
        "lawyerName": widget.mainCauseListdata["lawyerName"] != null
            ? widget.mainCauseListdata["lawyerName"].toString()
            : "",
        "courtNo": widget.mainCauseListdata["courtNo"] != null
            ? widget.mainCauseListdata["courtNo"].toString()
            : "",
        "sNo": "",
        "caseNo": widget.mainCauseListdata["caseNo"] != null
            ? widget.mainCauseListdata["caseNo"].toString()
            : "",
        "benchName": widget.mainCauseListdata["judgeName"] != null
            ? widget.mainCauseListdata["judgeName"].toString()
            : "",
        "causeListType": widget.mainCauseListdata["causeListType"] != null
            ? widget.mainCauseListdata["causeListType"].toString()
            : "",
        "partyName": widget.mainCauseListdata["partyName"] != null
            ? widget.mainCauseListdata["partyName"].toString()
            : "",
        "judgeTime": widget.mainCauseListdata["judgeTime"] != null
            ? widget.mainCauseListdata["judgeTime"].toString()
            : "",
        "caveatName": widget.mainCauseListdata["caveatName"] != null
            ? widget.mainCauseListdata["caveatName"].toString()
            : "",
      };
    } else {
      String lawyerName = "${widget.mainCauseListdata["lawyerName"]}";
      String cleanedLawyerName = lawyerName.replaceAll(RegExp(r'[{}]+'), '');
      body = {
        "dateFrom": widget.mainCauseListdata["dateFrom"].toString(),
        "pageNo": "1",
      };
      if (widget.mainCauseListdata["lawyerName"] != null) {
        body["lawyerName"] = cleanedLawyerName;
      }
      if (widget.mainCauseListdata["dateTo"] != null) {
        body["dateTo"] = widget.mainCauseListdata["dateTo"].toString();
      }
      if (widget.mainCauseListdata["courtNo"] != null) {
        body["courtNo"] = widget.mainCauseListdata["courtNo"].toString();
      }
      if (widget.mainCauseListdata["caseNo"] != null) {
        body["caseNo"] = widget.mainCauseListdata["caseNo"].toString();
      }
      if (widget.mainCauseListdata["judgeName"] != null) {
        body["benchName"] = widget.mainCauseListdata["judgeName"].toString();
      }
      if (widget.mainCauseListdata["caveatName"] != null) {
        body["caveatName"] = widget.mainCauseListdata["caveatName"].toString();
      }
      if (widget.mainCauseListdata["partyName"] != null) {
        body["partyName"] = widget.mainCauseListdata["partyName"].toString();
      }
      if (widget.mainCauseListdata["judgeTime"] != null) {
        body["judgeTime"] = widget.mainCauseListdata["judgeTime"].toString();
      }
      if (widget.mainCauseListdata["causeListType"] != null) {
        body["causeListType"] =
            widget.mainCauseListdata["causeListType"].toString();
      }
      // if (widget.mainCauseListdata["sNo"] != null) {
      //   body["sNo"] = widget.mainCauseListdata["sNo"].toString();
      // }
    }
    print("init:: ${widget.mainCauseListdata["lawyerName"]}");
    print("init:: ${widget.mainCauseListdata["caseNo"]}");

    dateFrom =
        DateFormat("dd/MM/yyyy").parse(widget.mainCauseListdata["dateFrom"]);
    if (widget.mainCauseListdata["dateTo"] != null &&
        widget.mainCauseListdata["dateTo"].isNotEmpty) {
      dateTo =
          DateFormat("dd/MM/yyyy").parse(widget.mainCauseListdata["dateTo"]);
    }
    BlocProvider.of<ViewCauseListCubit>(context)
        .fetchViewCauseList(body, "3.0", isQuickSearch: widget.isQuickSearch);
    BlocProvider.of<ShowWatchlistCubit>(context).fetchShowWatchlist();
    scrollListener();
    super.initState();
  }

  gmailAuthenticate() async {
    authMap = await GoogleDriveHandler().gmailAuthenticate(context);
  }

  void scrollListener() {
    listViewController.addListener(() {
      setMainListIndex();
    });

    listViewController.sliverController.stickyIndex.addListener(() {
      setMainListIndex();
    });

    searchViewController.addListener(() {
      setFilterListIndex();
    });

    searchViewController.sliverController.stickyIndex.addListener(() {
      setFilterListIndex();
    });
  }

  void setMainListIndex() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (listViewController.sliverController.stickyIndex.value != null &&
            listFirstVisibleIndex !=
                listViewController.sliverController.stickyIndex.value!) {
          listFirstVisibleIndex =
              listViewController.sliverController.stickyIndex.value!;
          int idxx = newDatesCourt.indexWhere((element) =>
              element.date == (newList[listFirstVisibleIndex].causeListDate!));
          if (_horizontalDateIndex != idxx) {
            _horizontalDateIndex = idxx;
            // print("_horizontalDateIndex; $_horizontalDateIndex");
            _goToElement(idxx);
          }
        }
      });
    });
  }

  void setFilterListIndex() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (searchViewController.sliverController.stickyIndex.value != null &&
            searchFirstVisibleIndex !=
                searchViewController.sliverController.stickyIndex.value!) {
          searchFirstVisibleIndex =
              searchViewController.sliverController.stickyIndex.value!;
          if (searchFirstVisibleIndex < searchList.length) {
            int idxx = searchDatesCourt.indexWhere((element) =>
                element.date ==
                (searchList[searchFirstVisibleIndex].causeListDate!));
            if (_horizontalDateIndex != idxx) {
              _horizontalDateIndex = idxx;
              // print("_horizontalDateIndex; $_horizontalDateIndex");
              _goToElement(idxx);
            }
          } else {
            searchFirstVisibleIndex = 0;
          }
        }
      });
    });
  }

  void setSelectedDate(dateSelected, isFrom) {
    setState(() {
      if (isFrom) {
        dateFrom = dateSelected;
      } else {
        dateTo = dateSelected;
      }
    });
  }

  void todateClear(state) {
    state(() {
      dateTo = null;
      isToDateSelected = false;
    });
  }

  void _goToElement(int index) {
    // print("horizontalIndex $index");
    _horizontalDateController.animateTo((100.0 * index),
        // 100 is the height of container and index of 6th element is 5
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeOut);
  }

  @override
  void dispose() {
    //listViewController.removeListener(() { });
    // di.locator.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.home_background,
        appBar: AppBar(
          leading: isSearch
              ? SizedBox()
              : GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back_ios_new_sharp,
                    size: 24,
                  ),
                ),
          backgroundColor: AppColor.white,
          titleSpacing: -5,
          title: Text(
            "Cause List",
            style: mpHeadLine16(
                fontWeight: FontWeight.w500,
                textColor: AppColor.bold_text_color_dark_blue),
          ),
          actions: [
            viewCauseListData != null
                ? isSearch
                    ? SizedBox()
                    : InkWell(
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
                            ? const Icon(
                                Icons.remove_red_eye_outlined,
                                size: 26,
                              )
                            : const Icon(
                                Icons.remove_red_eye,
                                size: 26,
                              ),
                      )
                : SizedBox(),
            SizedBox(
              width: isSearch ? 0 : 8,
            ),
            isSearch
                ? SizedBox()
                : InkWell(
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
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              insetPadding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              contentPadding: EdgeInsets.zero,
                              content: StatefulBuilder(
                                builder: (BuildContext context,
                                    void Function(void Function()) setState) {
                                  return SizedBox(
                                    // height: mediaQH(context) * 0.269,
                                    // width: mediaQW(context) * 0.98,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 7),
                                          child: Text(
                                            "Select Date",
                                            style: mpHeadLine12(
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        const Divider(
                                          thickness: 1,
                                          color: AppColor.grey_color,
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const CauseListHeadingName(
                                                      headingText: "From Date"),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              FocusNode());
                                                      DateTime fromDt = DateFormat(
                                                              "dd/MM/yyyy")
                                                          .parse(widget
                                                                  .mainCauseListdata[
                                                              "dateFrom"]);

                                                      AppDatePicker()
                                                          .pickDate(
                                                              context,
                                                              fromDt,
                                                              DateTime(2000),
                                                              DateTime(2100))
                                                          .then((value) {
                                                        if (value != null) {
                                                          setState(() {
                                                            dateFrom = value;
                                                            dateTo = null;
                                                            isToDateSelected =
                                                                false;
                                                          });
                                                        }
                                                      });
                                                    },
                                                    child: CustomContainer(
                                                      displayData:
                                                          "${dateFrom.day}/${dateFrom.month}/${dateFrom.year}",
                                                      width: mediaQW(context) *
                                                          0.4,
                                                      isDropDown: false,
                                                    ),
                                                  ),
                                                  // CauseListCalendar(
                                                  //   selectedDate: _seletedDate,
                                                  //   currentDate: dateFrom,
                                                  //   setDate: setSelectedDate,
                                                  //   smallWidth: true,
                                                  // ),
                                                ],
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const CauseListHeadingName(
                                                      headingText: "To Date"),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),

                                                  InkWell(
                                                    onTap: () {
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              FocusNode());
                                                      AppDatePicker()
                                                          .pickDate(
                                                              context,
                                                              dateFrom,
                                                              dateFrom,
                                                              dateFrom.add(
                                                                  Duration(
                                                                      days:
                                                                          90)))
                                                          .then((value) {
                                                        if (value != null) {
                                                          setState(() {
                                                            dateTo = value;
                                                            widget.mainCauseListdata[
                                                                    "dateTo"] =
                                                                getDDMMYYYY(dateTo
                                                                    .toString());
                                                            isToDateSelected =
                                                                true;
                                                          });
                                                        }
                                                      });
                                                    },
                                                    child: CustomContainer(
                                                      displayData: dateTo !=
                                                              null
                                                          ? "${dateTo!.day}/${dateTo!.month}/${dateTo!.year}"
                                                          : "DD/MM/YYYY",
                                                      width: mediaQW(context) *
                                                          0.4,
                                                      isDropDown: false,
                                                      isClose: dateTo != null
                                                          ? true
                                                          : false,
                                                      closeIconCallback:
                                                          todateClear,
                                                      closeState: setState,
                                                    ),
                                                  ),
                                                  // CauseListCalendar(
                                                  //   selectedDate:
                                                  //       _selectedToDate,
                                                  //   currentDate: dateTo,
                                                  //   setDate: setSelectedDate,
                                                  //   isToDate: true,
                                                  //   smallWidth: true,
                                                  //   fromDateForDisable:
                                                  //       dateFrom,
                                                  // ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height:
                                                      mediaQH(context) * 0.05,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color:
                                                            AppColor.primary),
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    5)),
                                                  ),
                                                  child: Text(
                                                    "Cancel",
                                                    style: mpHeadLine16(
                                                        textColor:
                                                            AppColor.primary),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  // DateTime today=DateTime.now();
                                                  // if (!isToDateSelected &&
                                                  //     today.difference(dateFrom).inDays > 0) {
                                                  //   setState(() {
                                                  //     DateFormat format = DateFormat("dd/MM/yyyy");
                                                  //     print(format.parse(mainCauseListData.cause_date));
                                                  //     dateTo = format.parse(mainCauseListData.cause_date);
                                                  //     print("date $dateTo");
                                                  //   });
                                                  //   // toast(msg: "Please select To date");
                                                  //   // return;
                                                  // }else{
                                                  //   setState(() {
                                                  //     dateTo=null;
                                                  //   });
                                                  // }
                                                  String lawyerName =
                                                      "${widget.mainCauseListdata["lawyerName"]}";
                                                  String cleanedLawyerName =
                                                      lawyerName.replaceAll(
                                                          RegExp(r'[{}]+'), '');
                                                  var viewList = {
                                                    "dateFrom": getDDMMYYYY(
                                                        dateFrom.toString()),
                                                    "dateTo": dateTo != null
                                                        ? getDDMMYYYY(
                                                            dateTo.toString())
                                                        : "",
                                                    "lawyerName":
                                                        widget.mainCauseListdata[
                                                                    "lawyerName"] !=
                                                                null
                                                            ? cleanedLawyerName
                                                            : "",
                                                    "courtNo":
                                                        widget.mainCauseListdata[
                                                                    "courtNo"] !=
                                                                null
                                                            ? widget
                                                                .mainCauseListdata[
                                                                    "courtNo"]
                                                                .toString()
                                                            : "",
                                                    "sNo": "",
                                                    "caseNo":
                                                        widget.mainCauseListdata[
                                                                    "caseNo"] !=
                                                                null
                                                            ? widget
                                                                .mainCauseListdata[
                                                                    "caseNo"]
                                                                .toString()
                                                            : "",
                                                    "benchName":
                                                        widget.mainCauseListdata[
                                                                    "judgeName"] !=
                                                                null
                                                            ? widget
                                                                .mainCauseListdata[
                                                                    "judgeName"]
                                                                .toString()
                                                            : "",
                                                    "causeListType": widget
                                                                    .mainCauseListdata[
                                                                "causeListType"] !=
                                                            null
                                                        ? widget
                                                            .mainCauseListdata[
                                                                "causeListType"]
                                                            .toString()
                                                        : "",
                                                    "partyName":
                                                        widget.mainCauseListdata[
                                                                    "partyName"] !=
                                                                null
                                                            ? widget
                                                                .mainCauseListdata[
                                                                    "partyName"]
                                                                .toString()
                                                            : "",
                                                    "judgeTime":
                                                        widget.mainCauseListdata[
                                                                    "judgeTime"] !=
                                                                null
                                                            ? widget
                                                                .mainCauseListdata[
                                                                    "judgeTime"]
                                                                .toString()
                                                            : "",
                                                  };

                                                  widget.mainCauseListdata[
                                                          "dateFrom"] =
                                                      getDDMMYYYY(
                                                          dateFrom.toString());
                                                  widget.mainCauseListdata[
                                                          "dateTo"] =
                                                      dateTo != null
                                                          ? getDDMMYYYY(
                                                              dateTo.toString())
                                                          : "";
                                                  isQuickSearchScroll = true;
                                                  widget.ctx!
                                                      .read<
                                                          ViewCauseListCubit>()
                                                      .fetchViewCauseList(
                                                          viewList, "3.0"
                                                          // isQuickSearch: widget
                                                          //     .isQuickSearch
                                                          );
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
                                                                Radius.circular(
                                                                    5)),
                                                    color: AppColor.primary,
                                                  ),
                                                  child: Text(
                                                    "View",
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
                                  );
                                },
                              ),
                            );
                          });
                    },
                    child: const Icon(
                      Icons.calendar_today,
                      size: 26,
                    ),
                  ),
            SizedBox(
              width: isSearch ? 0 : 16,
            ),
            viewCauseListData != null
                ? !isSearch
                    ? SizedBox()
                    : Container(
                        width: mediaQW(context) * 0.8,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(
                          child: TextField(
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                searchFilterList(value.toLowerCase());
                              } else {
                                setState(() {
                                  isSearchFilter = false;
                                  searchList = [];
                                });
                              }
                            },
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: const Icon(
                                    Icons.clear,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isSearch = false;
                                      isSearchFilter = false;
                                      searchList = [];
                                      // print("iscroll to sno ${isSnoScroll}");
                                      if (isSnoScroll &&
                                          viewCauseListData != null &&
                                          viewCauseListData!.causelist !=
                                              null) {
                                        sNoCallback(
                                            widget.mainCauseListdata["sNo"]
                                                .toString(),
                                            widget.mainCauseListdata["type"]
                                                .toString());
                                      }
                                      if (isQuickSearchScroll &&
                                          viewCauseListData != null &&
                                          viewCauseListData!.causelist !=
                                              null) {
                                        dateSelectCallback(
                                            getddMMYYYY_with_splash(widget
                                                .quickScrollDate
                                                .toString()));
                                      }
                                    });
                                    /* Clear the search field */
                                  },
                                ),
                                hintText: 'Search...',
                                border: InputBorder.none),
                          ),
                        ),
                      )
                : SizedBox(),
            viewCauseListData != null
                ? isSearch
                    ? SizedBox()
                    : InkWell(
                        onTap: () {
                          setState(() {
                            isSearch = true;
                          });
                        },
                        child: Icon(
                          Icons.search,
                          size: 28,
                        ),
                      )
                : SizedBox(),
            SizedBox(
              width: viewCauseListData == null ||
                      isSearch ||
                      !widget.isDownloadOption
                  ? 0
                  : 8,
            ),
            viewCauseListData == null || isSearch || !widget.isDownloadOption
                ? SizedBox()
                : InkWell(
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
                      DateTime firstDate = DateFormat("dd/MM/yyyy")
                          .parse(widget.mainCauseListdata["dateFrom"]);

                      DateTime? lastDate;
                      // print("date to ${widget.mainCauseListdata["dateTo"]}");
                      if (widget.mainCauseListdata["dateTo"] != null &&
                          widget.mainCauseListdata["dateTo"].isNotEmpty) {
                        lastDate = DateFormat("dd/MM/yyyy")
                            .parse(widget.mainCauseListdata["dateTo"]);
                        // print("hello ${lastDate.difference(firstDate).inDays}");
                        if (lastDate.difference(firstDate).inDays > 30) {
                          toast(
                              msg:
                                  "You can not download more than 1 month data. Please select date accordingly.");
                          return;
                          // lastDate=firstDate.add(Duration(days: 30));
                        }
                        //print("lastDate ${lastDate!}");
                      }

                      ///
                      showDialog(
                          context: context,
                          builder: (ctx) => DownloadCauseList(
                                {
                                  "dateFrom":
                                      widget.mainCauseListdata["dateFrom"] !=
                                              null
                                          ? widget.mainCauseListdata["dateFrom"]
                                              .toString()
                                          : "",
                                  "dateTo":
                                      widget.mainCauseListdata["dateTo"] !=
                                                  null &&
                                              widget.mainCauseListdata["dateTo"]
                                                  .isNotEmpty
                                          ? getDDMMYYYY(lastDate.toString())
                                          : "",
                                  "lawyerName":
                                      widget.mainCauseListdata["lawyerName"] !=
                                              null
                                          ? widget
                                              .mainCauseListdata["lawyerName"]
                                              .toString()
                                          : "",
                                  "courtNo":
                                      widget.mainCauseListdata["courtNo"] !=
                                              null
                                          ? widget.mainCauseListdata["courtNo"]
                                              .toString()
                                          : "",
                                  "sNo": "",
                                  "caseNo":
                                      widget.mainCauseListdata["caseNo"] != null
                                          ? widget.mainCauseListdata["caseNo"]
                                              .toString()
                                          : "",
                                  "benchName": widget
                                              .mainCauseListdata["judgeName"] !=
                                          null
                                      ? widget.mainCauseListdata["judgeName"]
                                          .toString()
                                      : "",
                                  "causeListType": widget.mainCauseListdata[
                                              "causeListType"] !=
                                          null
                                      ? widget
                                          .mainCauseListdata["causeListType"]
                                          .toString()
                                      : "",
                                  "partyName": widget
                                              .mainCauseListdata["partyName"] !=
                                          null
                                      ? widget.mainCauseListdata["partyName"]
                                          .toString()
                                      : "",
                                  "judgeTime": widget
                                              .mainCauseListdata["judgeTime"] !=
                                          null
                                      ? widget.mainCauseListdata["judgeTime"]
                                          .toString()
                                      : "",
                                },
                                widget.ctx!,
                                onPDFPressed: () {
                                  selectedFileType = "PDF";
                                  print("PDF button pressed!");
                                  showPdfOptionDialog("", "");
                                },
                                onGoogleDrivePressed: () {
                                  selectedFileType = "Drive";
                                  print("Google Drive button pressed!");
                                  showPdfOptionDialog("", "");
                                },
                                onExcelPressed: () {
                                  selectedFileType = "Excel";
                                  downloadExcelFile("", "");
                                },
                              ),
                          barrierColor: Colors.black26);
                    },
                    child: const Icon(
                      Icons.download,
                      size: 25,
                      color: AppColor.bold_text_color_dark_blue,
                    ),
                  ),
            SizedBox(
              width: isSearch ? 0 : 8,
            ),
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
          child: Stack(
            children: [
              BlocConsumer<ViewCauseListCubit, ViewCauseListState>(
                builder: (context, state) {
                  if (state is ViewCauseListLoaded) {
                    if (searchList.isEmpty && !isSearchFilter) {
                      filteredCases = filterHiddenCases(newList, isHiddenCases);
                    } else {
                      filteredCases =
                          filterHiddenCases(searchList, isHiddenCases);
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

                    return isPartialLoading
                        ? const Center(child: AppProgressIndicator())
                        : viewCauseListData != null &&
                                viewCauseListData!.causelist != null
                            ? AbsorbPointer(
                                absorbing: isPartialLoading,
                                child: Opacity(
                                  opacity: !isPartialLoading ? 1.0 : 0.7,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 10, 20, 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ColorNode(AppColor.white,
                                                        "Not set"),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    ColorNode(
                                                        AppColor.disposedColor,
                                                        "Disposed"),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ColorNode(
                                                        AppColor.cases_nostay,
                                                        "No stay"),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    ColorNode(
                                                        AppColor
                                                            .text_grey_color,
                                                        "Hidden"),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ColorNode(
                                                        AppColor
                                                            .cases_intrimstay,
                                                        "Interim stay"),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    ColorNode(Colors.blueAccent,
                                                        "Not created"),
                                                  ],
                                                ),
                                                ColorNode(
                                                    AppColor.cases_fullstay,
                                                    "Full stay"),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child:
                                            searchList.isEmpty &&
                                                    !isSearchFilter
                                                ? Stack(
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: 10),
                                                        child: Scrollbar(
                                                            controller:
                                                                listViewController,
                                                            interactive: true,
                                                            thickness: 8,
                                                            radius: const Radius
                                                                .circular(10),
                                                            child:
                                                                FlutterListView(
                                                                    reverse:
                                                                        false,
                                                                    shrinkWrap:
                                                                        true,
                                                                    anchor: 1,
                                                                    delegate:
                                                                        FlutterListViewDelegate(
                                                                      (BuildContext
                                                                              context,
                                                                          int index) {
                                                                        print(
                                                                            "causeListCard filteredCases  ==> ${filteredCases.length}");
                                                                        return causeListCard(
                                                                            context,
                                                                            filteredCases[index]);
                                                                      },
                                                                      childCount:
                                                                          filteredCases
                                                                              .length,
                                                                      onItemSticky: (index) =>
                                                                          filteredCases[index].isdateChange !=
                                                                              null &&
                                                                          filteredCases[index].isdateChange ==
                                                                              true,
                                                                      stickyAtTailer:
                                                                          false,
                                                                    ),
                                                                    controller:
                                                                        listViewController)),
                                                      ),
                                                      Positioned(
                                                        top: 0,
                                                        left: 0,
                                                        right: 0,
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        2),
                                                            color: filterDates
                                                                        .length >
                                                                    1
                                                                ? Colors.white
                                                                : AppColor
                                                                    .home_background,
                                                            boxShadow: filterDates
                                                                        .length >
                                                                    1
                                                                ? [
                                                                    BoxShadow(
                                                                      color: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.5),
                                                                      spreadRadius:
                                                                          2,
                                                                      blurRadius:
                                                                          3,
                                                                      offset: Offset(
                                                                          0,
                                                                          3), // changes position of shadow
                                                                    ),
                                                                  ]
                                                                : [],
                                                          ),
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 1,
                                                                  horizontal:
                                                                      3),
                                                          height: 35,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 12),
                                                          alignment:
                                                              Alignment.center,
                                                          child: ListView(
                                                              scrollDirection:
                                                                  Axis
                                                                      .horizontal,
                                                              controller:
                                                                  _horizontalDateController,
                                                              shrinkWrap: true,
                                                              children:
                                                                  filterDates
                                                                      .map((e) {
                                                                return InkWell(
                                                                  onTap: () {
                                                                    dateSelectCallback(
                                                                        e.date!);
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(5),
                                                                        color: e.date == filteredCases[listFirstVisibleIndex].causeListDate ? AppColor.primary : AppColor.white,
                                                                        border: Border.all(
                                                                          color:
                                                                              AppColor.primary,
                                                                        )),
                                                                    margin: EdgeInsets.only(
                                                                        right:
                                                                            10),
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            16,
                                                                        vertical:
                                                                            5),
                                                                    child: Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                          "${e.date}",
                                                                          style:
                                                                              appTextStyle(
                                                                            textColor: e.date == filteredCases[listFirstVisibleIndex].causeListDate
                                                                                ? AppColor.white
                                                                                : AppColor.primary,
                                                                          ),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                        ),
                                                                        SizedBox(
                                                                          width: widget.isQuickSearch
                                                                              ? 10
                                                                              : 0,
                                                                        ),
                                                                        widget.isQuickSearch
                                                                            ? InkWell(
                                                                                onTap: () {
                                                                                  if (!isPrime(pref)) {
                                                                                    FocusScope.of(context).requestFocus(FocusNode());
                                                                                    showDialog(
                                                                                        context: context,
                                                                                        builder: (ctx) => SafeArea(
                                                                                              child: GoPrime(),
                                                                                            ));
                                                                                    return;
                                                                                  }
                                                                                  showDialog(
                                                                                      context: context,
                                                                                      builder: (ctx) => DownloadCauseList(
                                                                                            {
                                                                                              "dateFrom": "${e.date}",
                                                                                              "dateTo": "${e.date}",
                                                                                              "lawyerName": widget.mainCauseListdata["lawyerName"] != null ? widget.mainCauseListdata["lawyerName"].toString() : "",
                                                                                              "courtNo": widget.mainCauseListdata["courtNo"] != null ? widget.mainCauseListdata["courtNo"].toString() : "",
                                                                                              "sNo": "",
                                                                                              "caseNo": widget.mainCauseListdata["caseNo"] != null ? widget.mainCauseListdata["caseNo"].toString() : "",
                                                                                              "benchName": widget.mainCauseListdata["judgeName"] != null ? widget.mainCauseListdata["judgeName"].toString() : "",
                                                                                              "causeListType": widget.mainCauseListdata["causeListType"] != null ? widget.mainCauseListdata["causeListType"].toString() : "",
                                                                                              "partyName": widget.mainCauseListdata["partyName"] != null ? widget.mainCauseListdata["partyName"].toString() : "",
                                                                                              "judgeTime": widget.mainCauseListdata["judgeTime"] != null ? widget.mainCauseListdata["judgeTime"].toString() : "",
                                                                                            },
                                                                                            widget.ctx!,
                                                                                            onPDFPressed: () {
                                                                                              selectedFileType = "PDF";
                                                                                              print("PDF button pressed!");
                                                                                              showPdfOptionDialog(e.date.toString(), e.date.toString());
                                                                                            },
                                                                                            onGoogleDrivePressed: () {
                                                                                              selectedFileType = "Drive";
                                                                                              print("Google Drive button pressed!");
                                                                                              showPdfOptionDialog(e.date.toString(), e.date.toString());
                                                                                            },
                                                                                            onExcelPressed: () {
                                                                                              selectedFileType = "Excel";
                                                                                              downloadExcelFile(e.date.toString(), e.date.toString());
                                                                                            },
                                                                                          ),
                                                                                      barrierColor: Colors.black26);
                                                                                },
                                                                                child: Icon(
                                                                                  Icons.download,
                                                                                  size: 16,
                                                                                  color: e.date == filteredCases[listFirstVisibleIndex].causeListDate ? AppColor.white : AppColor.primary,
                                                                                ),
                                                                              )
                                                                            : SizedBox(),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              }).toList()),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : searchList.isNotEmpty
                                                    ? Stack(
                                                        children: [
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 40),
                                                            child: Scrollbar(
                                                                controller:
                                                                    searchViewController,
                                                                interactive:
                                                                    true,
                                                                thickness: 8,
                                                                radius:
                                                                    const Radius
                                                                        .circular(
                                                                        10),
                                                                child:
                                                                    FlutterListView(
                                                                        reverse:
                                                                            false,
                                                                        shrinkWrap:
                                                                            true,
                                                                        anchor:
                                                                            1,
                                                                        delegate:
                                                                            FlutterListViewDelegate(
                                                                          (BuildContext context,
                                                                              int index) {
                                                                            print("searchList filteredCases  ==> ${filteredCases[index]}");
                                                                            return causeListCard(context,
                                                                                filteredCases[index]);
                                                                          },
                                                                          childCount:
                                                                              filteredCases.length,
                                                                          onItemSticky: (index) =>
                                                                              filteredCases[index].isdateChange != null &&
                                                                              filteredCases[index].isdateChange == true,
                                                                          stickyAtTailer:
                                                                              false,
                                                                        ),
                                                                        controller:
                                                                            searchViewController)),
                                                          ),
                                                          Positioned(
                                                            top: 0,
                                                            left: 0,
                                                            right: 0,
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            2),
                                                                color: filterDates
                                                                            .length >
                                                                        1
                                                                    ? Colors
                                                                        .white
                                                                    : AppColor
                                                                        .home_background,
                                                                boxShadow:
                                                                    filterDates.length >
                                                                            1
                                                                        ? [
                                                                            BoxShadow(
                                                                              color: Colors.grey.withOpacity(0.5),
                                                                              spreadRadius: 2,
                                                                              blurRadius: 3,
                                                                              offset: Offset(0, 3), // changes position of shadow
                                                                            ),
                                                                          ]
                                                                        : [],
                                                              ),
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          1,
                                                                      horizontal:
                                                                          3),
                                                              height: 35,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          12),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: ListView(
                                                                  scrollDirection:
                                                                      Axis
                                                                          .horizontal,
                                                                  controller:
                                                                      _horizontalDateController,
                                                                  shrinkWrap:
                                                                      true,
                                                                  children:
                                                                      filterDates
                                                                          .map(
                                                                              (e) {
                                                                    return InkWell(
                                                                      onTap:
                                                                          () {
                                                                        dateSelectCallback(
                                                                            e.date!,
                                                                            isFilter: true);
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(5),
                                                                            color: e.date == filteredCases[searchFirstVisibleIndex].causeListDate ? AppColor.primary : AppColor.white,
                                                                            border: Border.all(
                                                                              color: AppColor.primary,
                                                                            )),
                                                                        margin: EdgeInsets.only(
                                                                            right:
                                                                                10),
                                                                        alignment:
                                                                            Alignment.center,
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            horizontal:
                                                                                16,
                                                                            vertical:
                                                                                5),
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Text(
                                                                              "${e.date}",
                                                                              style: appTextStyle(
                                                                                textColor: e.date == filteredCases[searchFirstVisibleIndex].causeListDate ? AppColor.white : AppColor.primary,
                                                                              ),
                                                                              textAlign: TextAlign.center,
                                                                            ),
                                                                            SizedBox(
                                                                              width: widget.isQuickSearch ? 10 : 0,
                                                                            ),
                                                                            widget.isQuickSearch
                                                                                ? InkWell(
                                                                                    onTap: () {
                                                                                      if (!isPrime(pref)) {
                                                                                        FocusScope.of(context).requestFocus(FocusNode());
                                                                                        showDialog(
                                                                                            context: context,
                                                                                            builder: (ctx) => SafeArea(
                                                                                                  child: GoPrime(),
                                                                                                ));
                                                                                        return;
                                                                                      }
                                                                                      showDialog(
                                                                                          context: context,
                                                                                          builder: (ctx) => DownloadCauseList(
                                                                                                {
                                                                                                  "dateFrom": "${e.date}",
                                                                                                  "dateTo": "${e.date}",
                                                                                                  "lawyerName": widget.mainCauseListdata["lawyerName"] != null ? widget.mainCauseListdata["lawyerName"].toString() : "",
                                                                                                  "courtNo": widget.mainCauseListdata["courtNo"] != null ? widget.mainCauseListdata["courtNo"].toString() : "",
                                                                                                  "sNo": "",
                                                                                                  "caseNo": widget.mainCauseListdata["caseNo"] != null ? widget.mainCauseListdata["caseNo"].toString() : "",
                                                                                                  "benchName": widget.mainCauseListdata["judgeName"] != null ? widget.mainCauseListdata["judgeName"].toString() : "",
                                                                                                  "causeListType": widget.mainCauseListdata["causeListType"] != null ? widget.mainCauseListdata["causeListType"].toString() : "",
                                                                                                  "partyName": widget.mainCauseListdata["partyName"] != null ? widget.mainCauseListdata["partyName"].toString() : "",
                                                                                                  "judgeTime": widget.mainCauseListdata["judgeTime"] != null ? widget.mainCauseListdata["judgeTime"].toString() : "",
                                                                                                },
                                                                                                widget.ctx!,
                                                                                              ),
                                                                                          barrierColor: Colors.black26);
                                                                                    },
                                                                                    child: Icon(
                                                                                      Icons.download,
                                                                                      size: 16,
                                                                                      color: e.date == filteredCases[searchFirstVisibleIndex].causeListDate ? AppColor.white : AppColor.primary,
                                                                                    ),
                                                                                  )
                                                                                : SizedBox(),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }).toList()),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 150,
                                                          ),
                                                          NoDataAvailable(
                                                              "Search data not found.",
                                                              isTopmMargin:
                                                                  false),
                                                        ],
                                                      ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : NoDataAvailable("No Data Found.");
                  }
                  return SizedBox();
                },
                listener: (context, state) {
                  if (state is ViewCauseListLoading) {
                    setState(() {
                      // isLoading = true;
                      isPartialLoading = true;
                    });
                  }
                  if (state is ViewCauseListLoaded) {
                    // print("loaded");
                    var viewCauseModel = state.viewCauseListModel;
                    if (viewCauseModel.result == 1) {
                      if (viewCauseModel.data != null) {
                        if (state.viewCauseListModel!.data!.excel_url != null &&
                            state.viewCauseListModel.data!.excel_url!
                                .isNotEmpty) {
                          DateTime now = DateTime.now();
                          var fileName =
                              "HAeLo_File_causesList_${getYYYYMMDDownload(widget.mainCauseListdata["dateFrom"])}_${now.millisecondsSinceEpoch}.${state.viewCauseListModel!.data!.excel_url!.toString().split(".").last}";
                          downloadData(
                              state.viewCauseListModel.data!.excel_url!,
                              fileName);
                          // print("pauseloader 1");
                          pauseLoader();
                          setState(() {});
                        } else {
                          isPartialLoading = true;
                          // setState(() {
                          viewCauseListData = viewCauseModel.data;
                          // });
                          if (viewCauseListData!.causelist != null &&
                              viewCauseListData!.causelist!.isNotEmpty) {
                            List sortList = viewCauseListData!.causelist!;
                            listFirstVisibleIndex = 0;
                            newList = [];

                            for (int i = 0; i < sortList!.length; i++) {
                              //  print("in index $i>> ${newList.any((element) => element.causeListDate==caseList![i].causeListDate)}");
                              if (!newList!.any((element) =>
                                  element.causeListDate ==
                                  sortList![i].causeListDate)) {
                                Causelist casData = Causelist();
                                casData.benchName = sortList![i].benchName;
                                casData.bottomNo = sortList![i].bottomNo;
                                casData.caseId = sortList![i].caseId;
                                casData.caseNo = sortList![i].caseNo;
                                casData.causeListDate =
                                    sortList![i].causeListDate;
                                casData.causeListType =
                                    sortList![i].causeListType;

                                casData.courtNo = sortList![i].courtNo;
                                casData.intrimStay = sortList![i].intrimStay;
                                casData.partyName = sortList![i].partyName;
                                casData.petitioner = sortList![i].petitioner;
                                casData.respondent = sortList![i].respondent;
                                casData.sno = sortList![i].sno;
                                casData.snoWith = sortList![i].snoWith;
                                casData.stage = sortList![i].stage;
                                casData.is_disposed = sortList![i].is_disposed;
                                casData.is_hide = sortList![i].is_hide;
                                casData.bench_info = sortList![i].bench_info;
                                casData.isHideExpanded =
                                    sortList![i].isHideExpanded;
                                casData.isHideExpandedForBlue =
                                    sortList![i].isHideExpandedForBlue;
                                casData.isdateChange = true;
                                newList.add(casData);
                              }

                              Causelist cas = Causelist();
                              cas.benchName = sortList![i].benchName;
                              cas.bottomNo = sortList![i].bottomNo;
                              cas.caseId = sortList![i].caseId;
                              cas.caseNo = sortList![i].caseNo;
                              cas.causeListDate = sortList![i].causeListDate;
                              cas.causeListType = sortList![i].causeListType;
                              cas.courtNo = sortList![i].courtNo;
                              cas.intrimStay = sortList![i].intrimStay;
                              cas.partyName = sortList![i].partyName;
                              cas.petitioner = sortList![i].petitioner;
                              cas.respondent = sortList![i].respondent;
                              cas.sno = sortList![i].sno;
                              cas.snoWith = sortList![i].snoWith;
                              cas.stage = sortList![i].stage;
                              cas.is_disposed = sortList![i].is_disposed;
                              cas.is_hide = sortList![i].is_hide;
                              cas.bench_info = sortList![i].bench_info;
                              cas.isHideExpanded = sortList![i].isHideExpanded;
                              cas.isHideExpandedForBlue =
                                  sortList![i].isHideExpandedForBlue;
                              cas.isdateChange = false;

                              newList.add(cas);
                            }

                            print("newList> ${newList.length}");

                            for (int i = 0; i < newList.length; i++) {
                              if (i == 0 ||
                                  newList[i].courtNo ==
                                      "Before Registrar (Admin.)" ||
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
                                } else if (int.parse(newList[i].courtNo) !=
                                    int.parse(newList[i - 1].courtNo)) {
                                  newList[i].iscourtChange = true;
                                } else {
                                  newList[i].iscourtChange = false;
                                }
                              }
                            }

                            //for when need court filter
                            if (!widget.isFromHomepage) {
                              courtNumList = [];
                              for (int i = 0;
                                  i < viewCauseListData!.causelist!.length;
                                  i++) {
                                if (!courtNumList.contains(
                                    viewCauseListData!.causelist![i].courtNo)) {
                                  courtNumList.add(
                                      viewCauseListData!.causelist![i].courtNo);
                                }
                              }
                            } else {
                              //when need date filter
                              dates = [];
                              for (int i = 0;
                                  i < viewCauseListData!.causelist!.length;
                                  i++) {
                                if (!dates.contains(viewCauseListData!
                                    .causelist![i].causeListDate)) {
                                  dates.add(viewCauseListData!
                                      .causelist![i].causeListDate);
                                }
                              }

                              print("dates ${dates.length}");
                            }
                            newDatesCourt = [];
                            for (int i = 0;
                                i < viewCauseListData!.causelist!.length;
                                i++) {
                              if (!newDatesCourt.any((element) =>
                                  element.date ==
                                  viewCauseListData!
                                      .causelist![i].causeListDate)) {
                                DatesCourtModel model = DatesCourtModel();
                                model.date = viewCauseListData!
                                    .causelist![i].causeListDate!;
                                model.courtNo = [];
                                model.courtNo!.add(
                                    viewCauseListData!.causelist![i].courtNo);
                                newDatesCourt.add(model);
                              } else {
                                // DatesCourtModel model=DatesCourtModel();
                                int index = newDatesCourt.indexWhere(
                                    (element) =>
                                        element.date ==
                                        viewCauseListData!
                                            .causelist![i].causeListDate);
                                //model.courtNo=[];
                                if (!newDatesCourt[index].courtNo!.contains(
                                    viewCauseListData!.causelist![i].courtNo))
                                  newDatesCourt[index].courtNo!.add(
                                      viewCauseListData!.causelist![i].courtNo);
                                // newDatesCourt[index]=model;
                              }
                            }
                            // print("newDatesCourt/// ${newDatesCourt.length}");
                            // isQuickSearchScroll = false;
                            isDrag = false;
                            //  setState(() {});
                            print("pauseloader 2");
                            pauseLoader();
                            // if(widget.isScrollToSno){
                            //   sNoCallback(widget.mainCauseListdata["sNo"].toString());
                            // }
                          } else {
                            setState(() {
                              viewCauseListData = null;
                              dateIndex = 0;

                              //both list used for filter only
                              courtNumList = [];
                              dates = [];
                            });
                            print("pauseloader 3");
                            pauseLoader();
                          }
                        }
                      }
                    } else {
                      setState(() {
                        viewCauseListData = null;
                        dateIndex = 0;

                        //both list used for filter only
                        courtNumList = [];
                        dates = [];
                      });

                      pauseLoader();
                    }
                  }
                },
              ),
              BlocConsumer<HideCauseListCubit, HideCauseListState>(
                builder: (context, state) {
                  return const SizedBox();
                },
                listener: (context, state) {
                  if (state is HideCauseListLoaded) {
                    var hideListModel = state.hideCauseListModel;
                    if (hideListModel.result == 1) {
                      var viewList = {
                        "dateFrom": widget.mainCauseListdata["dateFrom"] != null
                            ? widget.mainCauseListdata["dateFrom"].toString()
                            : "",
                        "dateTo": widget.mainCauseListdata["dateTo"] != null
                            ? widget.mainCauseListdata["dateTo"].toString()
                            : "",
                        "lawyerName": widget.mainCauseListdata["lawyerName"] !=
                                null
                            ? widget.mainCauseListdata["lawyerName"].toString()
                            : "",
                        "courtNo": widget.mainCauseListdata["courtNo"] != null
                            ? widget.mainCauseListdata["courtNo"].toString()
                            : "",
                        "sNo": "",
                        "caseNo": widget.mainCauseListdata["caseNo"] != null
                            ? widget.mainCauseListdata["caseNo"].toString()
                            : "",
                        "benchName": widget.mainCauseListdata["judgeName"] !=
                                null
                            ? widget.mainCauseListdata["judgeName"].toString()
                            : "",
                        "causeListType":
                            widget.mainCauseListdata["causeListType"] != null
                                ? widget.mainCauseListdata["causeListType"]
                                    .toString()
                                : "",
                        "partyName": widget.mainCauseListdata["partyName"] !=
                                null
                            ? widget.mainCauseListdata["partyName"].toString()
                            : "",
                        "judgeTime": widget.mainCauseListdata["judgeTime"] !=
                                null
                            ? widget.mainCauseListdata["judgeTime"].toString()
                            : "",
                      };
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewCauseListScreenNew(
                                    mainCauseListdata: viewList,
                                    isFromHomepage: widget.isFromHomepage,
                                    isDownloadOption: widget.isDownloadOption,
                                    isScrollToSno: true,
                                    isFilter: widget.isFilter,
                                    quickScrollDate: widget.quickScrollDate,
                                    isQuickSearch: widget.isQuickSearch,
                                    isGotoCourt: widget.isGotoCourt,
                                  )));
                    }
                  }
                },
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
                    // mainCauseListData.lawyer_count++;
                    toast(msg: viewSaveList.msg.toString());
                  } else {
                    toast(msg: viewSaveList.msg.toString());
                  }
                }
              }),
              BlocConsumer<UnHideCauseListCubit, UnHideCauseListState>(
                builder: (context, state) {
                  return const SizedBox();
                },
                listener: (context, state) {
                  if (state is UnHideCauseListLoading) {
                    setState(() {
                      isLoading = true;
                    });
                  }
                  if (state is UnHideCauseListLoaded) {
                    var unhideCauseList = state.unHideCauseListModel;
                    if (unhideCauseList.result == 1) {
                      var viewList = {
                        "dateFrom": widget.mainCauseListdata["dateFrom"] != null
                            ? widget.mainCauseListdata["dateFrom"].toString()
                            : "",
                        "dateTo": widget.mainCauseListdata["dateTo"] != null
                            ? widget.mainCauseListdata["dateTo"].toString()
                            : "",
                        "lawyerName": widget.mainCauseListdata["lawyerName"] !=
                                null
                            ? widget.mainCauseListdata["lawyerName"].toString()
                            : "",
                        "courtNo": widget.mainCauseListdata["courtNo"] != null
                            ? widget.mainCauseListdata["courtNo"].toString()
                            : "",
                        "sNo": "",
                        "caseNo": widget.mainCauseListdata["caseNo"] != null
                            ? widget.mainCauseListdata["caseNo"].toString()
                            : "",
                        "benchName": widget.mainCauseListdata["judgeName"] !=
                                null
                            ? widget.mainCauseListdata["judgeName"].toString()
                            : "",
                        "causeListType":
                            widget.mainCauseListdata["causeListType"] != null
                                ? widget.mainCauseListdata["causeListType"]
                                    .toString()
                                : "",
                        "partyName": widget.mainCauseListdata["partyName"] !=
                                null
                            ? widget.mainCauseListdata["partyName"].toString()
                            : "",
                        "judgeTime": widget.mainCauseListdata["judgeTime"] !=
                                null
                            ? widget.mainCauseListdata["judgeTime"].toString()
                            : "",
                      };
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewCauseListScreenNew(
                                    mainCauseListdata: viewList,
                                    isFromHomepage: widget.isFromHomepage,
                                    isDownloadOption: widget.isDownloadOption,
                                    isScrollToSno: true,
                                    isFilter: widget.isFilter,
                                    quickScrollDate: widget.quickScrollDate,
                                    isQuickSearch: widget.isQuickSearch,
                                    isGotoCourt: widget.isGotoCourt,
                                  )));
                    } else {
                      toast(msg: unhideCauseList.msg.toString());
                    }
                    setState(() {
                      isLoading = false;
                    });
                  }
                },
              ),
              BlocConsumer<ShowWatchlistCubit, ShowWatchlistState>(
                  builder: (context, state) {
                return const SizedBox();
              }, listener: (context, state) {
                if (state is ShowWatchlistLoaded) {
                  var showWatchList = state.showWatchlistModel;
                  if (showWatchList.result == 1) {
                    if (showWatchList.data != null) {
                      var showWatchListData = showWatchList.data;
                      displayWatchList = showWatchListData!.watchlist;
                    }
                    // else{
                    //   toast(msg: showWatchList.msg.toString());
                    // }
                  }
                  // else{
                  //   toast(msg: showWatchList.msg.toString());
                  // }
                  setState(() {
                    selectedList = [];
                  });
                }
              }),
              Visibility(
                visible: isPartialLoading,
                child: const Center(child: AppProgressIndicator()),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.isQuickSearch &&
                    !isPartialLoading &&
                    viewCauseListData != null &&
                    viewCauseListData!.causelist != null
                ? InkWell(
                    onTap: () {
                      print(
                          "before order cmt hostory Lawyer ${widget.mainCauseListdata["lawyerName"]}");
                      print(
                          "before order cmt hostory case ${widget.mainCauseListdata["caseNo"]}");

                      // selectedLawyer=WatchListDataType("lawyer");

                      selectedLawyer!.lawyerName = null;
                      selectedLawyer!.caseNo = null;
                      if (widget.mainCauseListdata["lawyerName"] != null) {
                        print("in lawyer if");

                        selectedLawyer!.lawyerName =
                            widget.mainCauseListdata["lawyerName"].toString();
                      }
                      if (widget.mainCauseListdata["caseNo"] != null) {
                        print("in case if");
                        if (selectedLawyer!.lawyerName != null &&
                            selectedLawyer!.lawyerName!.isNotEmpty) {
                          selectedLawyer!.caseNo =
                              widget.mainCauseListdata["caseNo"].toString();
                        } else {
                          print("in case else");
                          selectedLawyer!.lawyerName =
                              widget.mainCauseListdata["caseNo"].toString();
                        }
                      }

                      print(
                          " selectedLawyer!.lawyerName ${selectedLawyer!.lawyerName}");
                      showDialog(
                          context: context,
                          builder: (ctx) => OrderCmtInfo(
                              selectedLawyer: selectedLawyer,
                              isFromCmt: widget.isFromCmt),
                          barrierColor: Colors.black26);
                    },
                    child: Container(
                        margin: EdgeInsets.only(left: 30),
                        decoration: BoxDecoration(
                          color: AppColor.primary.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.primary.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(5),
                        child: Icon(
                          Icons.history_toggle_off_outlined,
                          color: AppColor.white,
                        )),
                  )
                : SizedBox(),
            isPartialLoading || !widget.isFilter
                ? SizedBox()
                : isSearch
                    ? SizedBox()
                    : !widget.isFromHomepage && courtNumList.length > 1
                        ? FloatingActionButton(
                            backgroundColor: Colors.transparent,
                            focusElevation: 0,
                            elevation: 0,
                            // isExtended: true,
                            child: Container(
                              height: 40,
                              width: 30,
                              color: AppColor.white,
                              child: Image.asset(
                                ImageConstant.scroll,
                                color: AppColor.primary,
                                height: 40,
                                width: 40,
                              ),
                            ),
                            // backgroundColor: AppColor.primary,
                            onPressed: () {
                              if (!widget.isFromHomepage) {
                                showDialog(
                                    context: context,
                                    builder: (ctx) => CauseCourtList(
                                        courtNumList, courtSelectCallback));
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (ctx) => CauseDateListCourtNo(
                                        newDatesCourt,
                                        dateSelectCallback,
                                        datesCourtSelectCallback,
                                        false));
                              }
                            })
                        : widget.isFromHomepage && dates.length > 1
                            ? FloatingActionButton(
                                backgroundColor: Colors.transparent,
                                focusElevation: 0,
                                elevation: 0,
                                // isExtended: true,
                                child: Container(
                                  height: 40,
                                  width: 30,
                                  color: AppColor.white,
                                  child: Image.asset(
                                    ImageConstant.scroll,
                                    color: AppColor.primary,
                                    height: 40,
                                    width: 40,
                                  ),
                                ),
                                // backgroundColor: AppColor.primary,
                                onPressed: () {
                                  if (!widget.isFromHomepage) {
                                    showDialog(
                                        context: context,
                                        builder: (ctx) => CauseCourtList(
                                              courtNumList,
                                              courtSelectCallback,
                                            ));
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (ctx) => CauseDateListCourtNo(
                                            newDatesCourt,
                                            dateSelectCallback,
                                            datesCourtSelectCallback,
                                            false));
                                  }
                                })
                            : SizedBox(),
          ],
        ));
  }

  Widget causeListCard(context, element) {
    DateTime causeDate = DateFormat("dd/MM/yyyy").parse(element.causeListDate!);
    DateTime now = DateTime.now();

    // print("sno ${element.sno.toString()} and iscourtChange ${element.iscourtChange}\n");
    return (element.isdateChange != null && element.isdateChange == true)
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
                  (element.causeListDate!),
                  style: appTextStyle(
                    textColor: AppColor.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Spacer(),
            ],
          )
        : Container(
            margin:
                const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 5),
            // color: AppColor.rejected_color_text,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                element.iscourtChange
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
                element.snoWith.toString() == "with" ||
                        isWithContains(
                            element.sno.toString(), element.snoWith.toString())
                    ? Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        child: Text(
                          "With",
                          style: appTextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                      )
                    : SizedBox(),
                Card(
                  color: element.is_disposed == true
                      ? AppColor.disposedColor
                      : element.is_hide == 1 && isHiddenCases
                          ? AppColor.text_grey_color
                          : element.intrimStay.toString().toLowerCase() ==
                                  "no stay"
                              ? AppColor.cases_nostay
                              : element.intrimStay.toString().toLowerCase() ==
                                      "interim stay"
                                  ? AppColor.cases_intrimstay
                                  : element.intrimStay
                                              .toString()
                                              .toLowerCase() ==
                                          "full stay"
                                      ? AppColor.cases_fullstay
                                      : AppColor.white,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: element.causeListType != null &&
                                  element.causeListType == "Daily"
                              ? AppColor.white
                              : AppColor.rejected_color_text)),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            left: BorderSide(
                                color: element.caseId != null
                                    ? Colors.transparent
                                    : Colors.blueAccent,
                                width: 4))),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                    text: "(Court No. ${element.courtNo}) ",
                                    style: mpHeadLine12(
                                        fontWeight: FontWeight.w600,
                                        textColor: element.is_disposed == true
                                            ? AppColor.white
                                            : AppColor.black),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: element.benchName.toString(),
                                          style: mpHeadLine12(
                                              fontWeight: FontWeight.w600,
                                              textColor:
                                                  element.is_disposed == true
                                                      ? AppColor.white
                                                      : AppColor.black)),
                                    ]),
                              ),
                            ),
                            InkWell(
                              onTap: () {
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
                              },
                              child: Container(
                                height: 30,
                                width: 30,
                                child: PopupMenuButton<int>(
                                  onSelected: (i) async {
                                    if (i == 3) {
                                      if (isPrime(pref) &&
                                          (planName(pref) ==
                                              Constants.silverPlan)) {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        showDialog(
                                            context: context,
                                            builder: (ctx) => SafeArea(
                                                  child: GoPrime(),
                                                ));
                                        return;
                                      }

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ViewCauseListScreenNew(
                                                    mainCauseListdata: {
                                                      "dateFrom": widget
                                                                      .mainCauseListdata[
                                                                  "dateFrom"] !=
                                                              null
                                                          ? widget
                                                              .mainCauseListdata[
                                                                  "dateFrom"]
                                                              .toString()
                                                          : "",
                                                      "dateTo": "",
                                                      "courtNo": element.courtNo
                                                          .toString(),
                                                      "sNo": element.sno,
                                                      "type": element
                                                              .causeListType ??
                                                          "",
                                                    },
                                                    isFromHomepage:
                                                        widget.isFromHomepage,
                                                    isDownloadOption:
                                                        widget.isDownloadOption,
                                                    isScrollToSno: true,
                                                    isFilter: widget.isFilter,
                                                  )));
                                    } else if (i == 2) {
                                      print("element.caseId ${element.caseId}");
                                      print("element.plan ${planName(pref)}");
                                      // if(!isPrime(pref)){
                                      //   FocusScope.of(context)
                                      //       .requestFocus(FocusNode());
                                      //   showDialog(
                                      //       context: context,
                                      //       builder: (ctx) => SafeArea(
                                      //         child: GoPrime(),
                                      //       ));
                                      //   return;
                                      // }else{
                                      if (isPrime(pref) &&
                                          planName(pref) ==
                                              Constants.silverPlan) {
                                        if (element.caseId != null) {
                                          //upgrade with gold
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          showDialog(
                                              context: context,
                                              builder: (ctx) => SafeArea(
                                                    child: GoPrime(),
                                                  ));
                                          return;
                                        } else {
                                          print(
                                              "lawyerName ==> ${widget.mainCauseListdata["lawyerName"]}");
                                          Set<String> selectedLawyerName =
                                              Set<String>.from(widget
                                                  .mainCauseListdata[
                                                      "lawyerName"]
                                                  .split(',')
                                                  .map((name) => name.trim()));
                                          await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddCaseCauseList(
                                                        getCaseNum: element
                                                            .caseNo
                                                            .toString(),
                                                        mainCauseListdata: widget
                                                            .mainCauseListdata,
                                                        selectedNames:
                                                            selectedLawyerName,
                                                        caseNumber: widget
                                                                .mainCauseListdata[
                                                            "caseNo"],
                                                      ))).then((value) {
                                            if (value != null && value) {
                                              String lawyerName =
                                                  "${widget.mainCauseListdata["lawyerName"]}";
                                              String cleanedLawyerName =
                                                  lawyerName.replaceAll(
                                                      RegExp(r'[{}]+'), '');
                                              var viewList = {
                                                "dateFrom":
                                                    widget.mainCauseListdata[
                                                                "dateFrom"] !=
                                                            null
                                                        ? widget
                                                            .mainCauseListdata[
                                                                "dateFrom"]
                                                            .toString()
                                                        : "",
                                                "dateTo":
                                                    widget.mainCauseListdata[
                                                                "dateTo"] !=
                                                            null
                                                        ? widget
                                                            .mainCauseListdata[
                                                                "dateTo"]
                                                            .toString()
                                                        : "",
                                                "lawyerName":
                                                    widget.mainCauseListdata[
                                                                "lawyerName"] !=
                                                            null
                                                        ? cleanedLawyerName
                                                        : "",
                                                "courtNo":
                                                    widget.mainCauseListdata[
                                                                "courtNo"] !=
                                                            null
                                                        ? widget
                                                            .mainCauseListdata[
                                                                "courtNo"]
                                                            .toString()
                                                        : "",
                                                "sNo": "",
                                                "caseNo":
                                                    widget.mainCauseListdata[
                                                                "caseNo"] !=
                                                            null
                                                        ? widget
                                                            .mainCauseListdata[
                                                                "caseNo"]
                                                            .toString()
                                                        : "",
                                                "benchName":
                                                    widget.mainCauseListdata[
                                                                "judgeName"] !=
                                                            null
                                                        ? widget
                                                            .mainCauseListdata[
                                                                "judgeName"]
                                                            .toString()
                                                        : "",
                                                "causeListType": widget
                                                                .mainCauseListdata[
                                                            "causeListType"] !=
                                                        null
                                                    ? widget.mainCauseListdata[
                                                            "causeListType"]
                                                        .toString()
                                                    : "",
                                                "partyName":
                                                    widget.mainCauseListdata[
                                                                "partyName"] !=
                                                            null
                                                        ? widget
                                                            .mainCauseListdata[
                                                                "partyName"]
                                                            .toString()
                                                        : "",
                                                "judgeTime":
                                                    widget.mainCauseListdata[
                                                                "judgeTime"] !=
                                                            null
                                                        ? widget
                                                            .mainCauseListdata[
                                                                "judgeTime"]
                                                            .toString()
                                                        : "",
                                              };
                                              isQuickSearchScroll = false;
                                              widget.ctx!
                                                  .read<ViewCauseListCubit>()
                                                  .fetchViewCauseList(
                                                      viewList, "3.0",
                                                      isQuickSearch:
                                                          widget.isQuickSearch);
                                            }
                                          });
                                        }
                                      } else {
                                        if (element.caseId != null) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CaseDetails(
                                                        caseId: element.caseId,
                                                        index: 2,
                                                      )));
                                        } else {
                                          await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddCaseCauseList(
                                                        getCaseNum: element
                                                            .caseNo
                                                            .toString(),
                                                        mainCauseListdata: widget
                                                            .mainCauseListdata,
                                                        caseNumber: widget
                                                                .mainCauseListdata[
                                                            "caseNo"],
                                                      ))).then((value) {
                                            if (value != null && value) {
                                              String lawyerName =
                                                  "${widget.mainCauseListdata["lawyerName"]}";
                                              String cleanedLawyerName =
                                                  lawyerName.replaceAll(
                                                      RegExp(r'[{}]+'), '');
                                              var viewList = {
                                                "dateFrom":
                                                    widget.mainCauseListdata[
                                                                "dateFrom"] !=
                                                            null
                                                        ? widget
                                                            .mainCauseListdata[
                                                                "dateFrom"]
                                                            .toString()
                                                        : "",
                                                "dateTo":
                                                    widget.mainCauseListdata[
                                                                "dateTo"] !=
                                                            null
                                                        ? widget
                                                            .mainCauseListdata[
                                                                "dateTo"]
                                                            .toString()
                                                        : "",
                                                "lawyerName":
                                                    widget.mainCauseListdata[
                                                                "lawyerName"] !=
                                                            null
                                                        ? cleanedLawyerName
                                                        : "",
                                                "courtNo":
                                                    widget.mainCauseListdata[
                                                                "courtNo"] !=
                                                            null
                                                        ? widget
                                                            .mainCauseListdata[
                                                                "courtNo"]
                                                            .toString()
                                                        : "",
                                                "sNo": "",
                                                "caseNo":
                                                    widget.mainCauseListdata[
                                                                "caseNo"] !=
                                                            null
                                                        ? widget
                                                            .mainCauseListdata[
                                                                "caseNo"]
                                                            .toString()
                                                        : "",
                                                "benchName":
                                                    widget.mainCauseListdata[
                                                                "judgeName"] !=
                                                            null
                                                        ? widget
                                                            .mainCauseListdata[
                                                                "judgeName"]
                                                            .toString()
                                                        : "",
                                                "causeListType": widget
                                                                .mainCauseListdata[
                                                            "causeListType"] !=
                                                        null
                                                    ? widget.mainCauseListdata[
                                                            "causeListType"]
                                                        .toString()
                                                    : "",
                                                "partyName":
                                                    widget.mainCauseListdata[
                                                                "partyName"] !=
                                                            null
                                                        ? widget
                                                            .mainCauseListdata[
                                                                "partyName"]
                                                            .toString()
                                                        : "",
                                                "judgeTime":
                                                    widget.mainCauseListdata[
                                                                "judgeTime"] !=
                                                            null
                                                        ? widget
                                                            .mainCauseListdata[
                                                                "judgeTime"]
                                                            .toString()
                                                        : "",
                                              };
                                              isQuickSearchScroll = false;
                                              widget.ctx!
                                                  .read<ViewCauseListCubit>()
                                                  .fetchViewCauseList(
                                                      viewList, "3.0",
                                                      isQuickSearch:
                                                          widget.isQuickSearch);
                                            }
                                          });
                                        }
                                      }
                                      // }
                                    } else if (i == 1) {
                                      if (element.is_hide != 1) {
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
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 20,
                                                                right: 20,
                                                                top: 25),
                                                        child: Text(
                                                          "Are you sure you want to hide your cause ${element.caseNo.toString()}",
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
                                                                  "causeId": element
                                                                      .caseNo
                                                                      .toString(),
                                                                  "causeDate": element
                                                                      .causeListDate
                                                                      .toString(),
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
                                                                  borderRadius:
                                                                      BorderRadius.only(
                                                                          bottomRight:
                                                                              Radius.circular(5)),
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
                                      } else {
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
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 20,
                                                                right: 20,
                                                                top: 25),
                                                        child: Text(
                                                          "Are you sure you want to unhide your cause ${element.caseNo.toString()}",
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
                                                                var unhideList =
                                                                    {
                                                                  "requestType":
                                                                      "caseNo",
                                                                  "Case_no": element
                                                                      .caseNo
                                                                      .toString(),
                                                                };
                                                                BlocProvider.of<
                                                                            UnHideCauseListCubit>(
                                                                        context)
                                                                    .fetchUnHideCauseList(
                                                                        unhideList);
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
                                                                  borderRadius:
                                                                      BorderRadius.only(
                                                                          bottomRight:
                                                                              Radius.circular(5)),
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
                                    } else if (i == 0) {
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
                                                        "Are you sure you want to hide your cause ${element.caseNo.toString()} for today",
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
                                                                "causeId": element
                                                                    .caseNo
                                                                    .toString(),
                                                                "causeDate": element
                                                                    .causeListDate
                                                                    .toString(),
                                                                "hideType": "1"
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
                                    } else if (i == 4) {
                                      print("element.caseId ${element.caseId}");
                                      print("element.plan ${planName(pref)}");

                                      if (isPrime(pref) &&
                                          planName(pref) ==
                                              Constants.silverPlan) {
                                        if (element.caseId != null) {
                                          //upgrade with gold
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          showDialog(
                                              context: context,
                                              builder: (ctx) => SafeArea(
                                                    child: GoPrime(),
                                                  ));
                                          return;
                                        } else {
                                          await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddCaseCauseList(
                                                        getCaseNum: element
                                                            .caseNo
                                                            .toString(),
                                                        mainCauseListdata: widget
                                                            .mainCauseListdata,
                                                        selectedNames: widget
                                                                .mainCauseListdata[
                                                            "lawyerName"],
                                                        caseNumber: widget
                                                                .mainCauseListdata[
                                                            "caseNo"],
                                                      ))).then((value) {
                                            if (value != null && value) {
                                              String lawyerName =
                                                  "${widget.mainCauseListdata["lawyerName"]}";
                                              String cleanedLawyerName =
                                                  lawyerName.replaceAll(
                                                      RegExp(r'[{}]+'), '');
                                              var viewList = {
                                                "dateFrom":
                                                    widget.mainCauseListdata[
                                                                "dateFrom"] !=
                                                            null
                                                        ? widget
                                                            .mainCauseListdata[
                                                                "dateFrom"]
                                                            .toString()
                                                        : "",
                                                "dateTo":
                                                    widget.mainCauseListdata[
                                                                "dateTo"] !=
                                                            null
                                                        ? widget
                                                            .mainCauseListdata[
                                                                "dateTo"]
                                                            .toString()
                                                        : "",
                                                "lawyerName":
                                                    widget.mainCauseListdata[
                                                                "lawyerName"] !=
                                                            null
                                                        ? cleanedLawyerName
                                                        : "",
                                                "courtNo":
                                                    widget.mainCauseListdata[
                                                                "courtNo"] !=
                                                            null
                                                        ? widget
                                                            .mainCauseListdata[
                                                                "courtNo"]
                                                            .toString()
                                                        : "",
                                                "sNo": "",
                                                "caseNo":
                                                    widget.mainCauseListdata[
                                                                "caseNo"] !=
                                                            null
                                                        ? widget
                                                            .mainCauseListdata[
                                                                "caseNo"]
                                                            .toString()
                                                        : "",
                                                "benchName":
                                                    widget.mainCauseListdata[
                                                                "judgeName"] !=
                                                            null
                                                        ? widget
                                                            .mainCauseListdata[
                                                                "judgeName"]
                                                            .toString()
                                                        : "",
                                                "causeListType": widget
                                                                .mainCauseListdata[
                                                            "causeListType"] !=
                                                        null
                                                    ? widget.mainCauseListdata[
                                                            "causeListType"]
                                                        .toString()
                                                    : "",
                                                "partyName":
                                                    widget.mainCauseListdata[
                                                                "partyName"] !=
                                                            null
                                                        ? widget
                                                            .mainCauseListdata[
                                                                "partyName"]
                                                            .toString()
                                                        : "",
                                                "judgeTime":
                                                    widget.mainCauseListdata[
                                                                "judgeTime"] !=
                                                            null
                                                        ? widget
                                                            .mainCauseListdata[
                                                                "judgeTime"]
                                                            .toString()
                                                        : "",
                                              };
                                              isQuickSearchScroll = false;
                                              widget.ctx!
                                                  .read<ViewCauseListCubit>()
                                                  .fetchViewCauseList(
                                                      viewList, "3.0",
                                                      isQuickSearch:
                                                          widget.isQuickSearch);
                                            }
                                          });
                                        }
                                      } else {
                                        if (element.caseId != null) {
                                          openWatchListDialog(
                                              element.caseId.toString());
                                          /*   await showDialog(
                                            context: context,
                                            builder: (ctx) => AddToWatchList(
                                              "",
                                              "0",
                                              caseId: element.caseId.toString(),
                                              isFromCauseListAdd: true,
                                            ),
                                          );*/
                                        } else {
                                          await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddCaseCauseList(
                                                        getCaseNum: element
                                                            .caseNo
                                                            .toString(),
                                                        mainCauseListdata: widget
                                                            .mainCauseListdata,
                                                        caseNumber: widget
                                                                .mainCauseListdata[
                                                            "caseNo"],
                                                        isFromCreateCase: true,
                                                      ))).then((value) {
                                            if (value != null && value) {
                                              String lawyerName =
                                                  "${widget.mainCauseListdata["lawyerName"]}";
                                              String cleanedLawyerName =
                                                  lawyerName.replaceAll(
                                                      RegExp(r'[{}]+'), '');
                                              var viewList = {
                                                "dateFrom":
                                                    widget.mainCauseListdata[
                                                                "dateFrom"] !=
                                                            null
                                                        ? widget
                                                            .mainCauseListdata[
                                                                "dateFrom"]
                                                            .toString()
                                                        : "",
                                                "dateTo":
                                                    widget.mainCauseListdata[
                                                                "dateTo"] !=
                                                            null
                                                        ? widget
                                                            .mainCauseListdata[
                                                                "dateTo"]
                                                            .toString()
                                                        : "",
                                                "lawyerName":
                                                    widget.mainCauseListdata[
                                                                "lawyerName"] !=
                                                            null
                                                        ? cleanedLawyerName
                                                        : "",
                                                "courtNo":
                                                    widget.mainCauseListdata[
                                                                "courtNo"] !=
                                                            null
                                                        ? widget
                                                            .mainCauseListdata[
                                                                "courtNo"]
                                                            .toString()
                                                        : "",
                                                "sNo": "",
                                                "caseNo":
                                                    widget.mainCauseListdata[
                                                                "caseNo"] !=
                                                            null
                                                        ? widget
                                                            .mainCauseListdata[
                                                                "caseNo"]
                                                            .toString()
                                                        : "",
                                                "benchName":
                                                    widget.mainCauseListdata[
                                                                "judgeName"] !=
                                                            null
                                                        ? widget
                                                            .mainCauseListdata[
                                                                "judgeName"]
                                                            .toString()
                                                        : "",
                                                "causeListType": widget
                                                                .mainCauseListdata[
                                                            "causeListType"] !=
                                                        null
                                                    ? widget.mainCauseListdata[
                                                            "causeListType"]
                                                        .toString()
                                                    : "",
                                                "partyName":
                                                    widget.mainCauseListdata[
                                                                "partyName"] !=
                                                            null
                                                        ? widget
                                                            .mainCauseListdata[
                                                                "partyName"]
                                                            .toString()
                                                        : "",
                                                "judgeTime":
                                                    widget.mainCauseListdata[
                                                                "judgeTime"] !=
                                                            null
                                                        ? widget
                                                            .mainCauseListdata[
                                                                "judgeTime"]
                                                            .toString()
                                                        : "",
                                              };
                                              isQuickSearchScroll = false;
                                              widget.ctx!
                                                  .read<ViewCauseListCubit>()
                                                  .fetchViewCauseList(
                                                      viewList, "3.0",
                                                      isQuickSearch:
                                                          widget.isQuickSearch);
                                            }
                                          });
                                        }
                                      }
                                    } else if (i == 5) {
                                      viewAndSaveAlertApi(
                                          element.caseNo.toString());
                                    }
                                  },
                                  padding: const EdgeInsets.all(10),
                                  icon: Icon(
                                    Icons.more_vert_outlined,
                                    size: 24,
                                    color: element.is_disposed == true
                                        ? AppColor.white
                                        : AppColor.black,
                                  ),
                                  itemBuilder: (context) => !isPrime(pref)
                                      ? []
                                      : [
                                          // popupmenu item 1
                                          if (element.is_hide != 1)
                                            const PopupMenuItem(
                                              value: 0,
                                              child: Text(
                                                "Hide notifications - (today only)",
                                              ),
                                            ),
                                          element.is_hide != 1
                                              ? PopupMenuItem(
                                                  value: 1,
                                                  child: Text("Hide"),
                                                )
                                              : PopupMenuItem(
                                                  value: 1,
                                                  child: Text("Unhide"),
                                                ),
                                          // popupmenu item 2
                                          PopupMenuItem(
                                            value: 2,
                                            child: Text(element.caseId != null
                                                ? "Case Details"
                                                : "Create Case"),
                                          ),
                                          PopupMenuItem(
                                            value: 4,
                                            child: Text("Add to WatchList"),
                                          ),
                                          const PopupMenuItem(
                                            value: 5,
                                            child: Text(
                                                "Add to quick search (individually)"),
                                          ),
                                          if (widget.isGotoCourt)
                                            const PopupMenuItem(
                                              value: 3,
                                              child:
                                                  Text("Go to court causelist"),
                                            ),
                                        ],
                                  enabled: isPrime(pref),
                                  color: Colors.white,
                                  elevation: 2,
                                ),
                              ),
                            ),
                            causeDate.difference(now).inDays > -1
                                ? InkWell(
                                    onTap: () {
                                      Map<String, String> summary = {
                                        "dateToday": getYYYYMMDD(
                                            element.causeListDate.toString()),
                                        "courtNo": element.courtNo.toString(),
                                        "benchName": element.benchName != null
                                            ? element.benchName.toString()
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
                                      alignment: Alignment.bottomCenter,
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
                        const SizedBox(
                          height: 5,
                        ),
                        isHiddenCases && element.is_hide == 1 ||
                                element.snoWith.toString() == "with" ||
                                isWithContains(element.sno.toString(),
                                    element.snoWith.toString())
                            ? IgnorePointer(
                                ignoring: element.is_hide != 1 &&
                                    (element.snoWith.toString() != "with" &&
                                        !isWithContains(element.sno.toString(),
                                            element.snoWith.toString())),
                                ignoringSemantics: true,
                                child: CustomExpansionTile(
                                  childrenPadding: EdgeInsets.zero,
                                  title: Row(
                                    children: [
                                      Text("Sr. No: " + element.sno.toString(),
                                          style: mpHeadLine12(
                                              fontWeight: FontWeight.w600,
                                              textColor:
                                                  element.is_disposed == true
                                                      ? AppColor.white
                                                      : AppColor.black)),
                                      HighlightText(
                                        element.causeListType != null &&
                                                element.causeListType == "Daily"
                                            ? " (D)"
                                            : " (S)",
                                        "(S)",
                                        mpHeadLine12(
                                            fontWeight: FontWeight.w500,
                                            textColor:
                                                element.is_disposed == true
                                                    ? AppColor.white
                                                    : AppColor.black),
                                        mpHeadLine12(
                                            fontWeight: FontWeight.w500,
                                            textColor: Colors.red),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Flexible(
                                        child: Text(
                                          element.caseNo.toString(),
                                          style: mpHeadLine14(
                                              fontWeight: FontWeight.bold,
                                              textColor:
                                                  element.is_disposed == true
                                                      ? AppColor.white
                                                      : AppColor.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: (element.is_hide != 1 &&
                                          (element.snoWith.toString() !=
                                                  "with" &&
                                              !isWithContains(
                                                  element.sno.toString(),
                                                  element.snoWith.toString())))
                                      ? const SizedBox()
                                      : Icon(
                                          element.isHideExpanded != null &&
                                                  element.isHideExpanded
                                              ? Icons.keyboard_arrow_up
                                              : Icons.keyboard_arrow_down,
                                          color: Colors.black,
                                        ),
                                  tilePadding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero),
                                  collapsedShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero),
                                  initiallyExpanded: element.is_hide != 1 &&
                                      (element.snoWith.toString() != "with" &&
                                          !isWithContains(
                                              element.sno.toString(),
                                              element.snoWith.toString())),
                                  maintainState: true,
                                  onExpansionChanged: (changeValue) {
                                    //print("changeValue $changeValue");
                                    if (element.is_hide == 1 ||
                                        element.snoWith.toString() == "with" ||
                                        isWithContains(element.sno.toString(),
                                            element.snoWith.toString())) {
                                      setState(() {
                                        element.isHideExpanded = changeValue;
                                      });
                                    }
                                  },
                                  expandedCrossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 0),
                                        child: expansionSubCard(element))
                                  ],
                                ),
                              )
                            : Column(
                                children: [
                                  const SizedBox(
                                    height: 0,
                                  ),
                                  Row(
                                    children: [
                                      Text("Sr. No: " + element.sno.toString(),
                                          style: mpHeadLine12(
                                              fontWeight: FontWeight.w600,
                                              textColor:
                                                  element.is_disposed == true
                                                      ? AppColor.white
                                                      : AppColor.black)),
                                      Flexible(
                                        child: HighlightText(
                                          element.causeListType != null &&
                                                  element.causeListType ==
                                                      "Daily"
                                              ? " (D)"
                                              : " (S)",
                                          "(S)",
                                          mpHeadLine12(
                                              fontWeight: FontWeight.w500,
                                              textColor:
                                                  element.is_disposed == true
                                                      ? AppColor.white
                                                      : AppColor.black),
                                          mpHeadLine12(
                                              fontWeight: FontWeight.w500,
                                              textColor: Colors.red),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        element.caseNo.toString(),
                                        style: mpHeadLine14(
                                            fontWeight: FontWeight.bold,
                                            textColor:
                                                element.is_disposed == true
                                                    ? AppColor.white
                                                    : AppColor.black),
                                      ),
                                    ],
                                  ),
                                  expansionSubCard(element),
                                ],
                              )
                      ],
                    ),
                  ),
                ),
                //newList.indexOf(element)!=0 &&
              ],
            ),
          );
  }

  Widget expansionSubCard(element) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        height: element.bench_info != null && element.bench_info.isNotEmpty
            ? 10
            : 0,
      ),
      element.bench_info != null && element.bench_info.isNotEmpty
          ? Row(
              children: [
                Text("Bunch Info: ",
                    style: mpHeadLine12(
                        fontWeight: FontWeight.w600, textColor: Colors.red)),
                Flexible(child: bunchInfoHighlight("${element.bench_info}")

                    // Text(
                    //   "${element.bench_info}",
                    //   style: mpHeadLine12(
                    //     fontWeight: FontWeight.w500,
                    //   ),
                    // ),
                    ),
              ],
            )
          : SizedBox(),
      const SizedBox(
        height: 10,
      ),
      Text(
        element.stage.toString(),
        style: mpHeadLine12(
            textColor:
                element.is_disposed == true ? AppColor.white : AppColor.black),
      ),
      const SizedBox(
        height: 8,
      ),
      /*InkWell(
        onTap: () {
          print("party name click ${element.caseId}");

          if (isPrime(pref) && element.caseId != null) {
            if (planName(pref) == Constants.silverPlan) {
              FocusScope.of(context).requestFocus(FocusNode());
              showDialog(
                  context: context,
                  builder: (ctx) => SafeArea(
                        child: GoPrime(),
                      ));
              return;
            }
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CaseDetails(
                          caseId: element.caseId,
                          index: 2,
                        )));
          }
        },
        child: Text(
          element.partyName.toString(),
          style: mpHeadLine12(
              fontWeight: FontWeight.w600, textColor: AppColor.primary),
        ),
      ),*/
      /*  const Divider(
        thickness: 2,
        color: AppColor.primary,
      ),*/
      CustomExpansionTile(
        childrenPadding: EdgeInsets.zero,
        title: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  print("party name click ${element.caseId}");

                  if (isPrime(pref) && element.caseId != null) {
                    if (planName(pref) == Constants.silverPlan) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      showDialog(
                          context: context,
                          builder: (ctx) => SafeArea(
                                child: GoPrime(),
                              ));
                      return;
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CaseDetails(
                                  caseId: element.caseId,
                                  index: 2,
                                )));
                  }
                },
                child: Text(
                  element.partyName.toString(),
                  style: mpHeadLine12(
                      fontWeight: FontWeight.w600, textColor: AppColor.primary),
                ),
              ),
            ),
          ],
        ),
        trailing: Icon(
          element.isHideExpandedForBlue != null && element.isHideExpandedForBlue
              ? Icons.keyboard_arrow_up
              : Icons.keyboard_arrow_down,
          color: Colors.black,
        ),
        tilePadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        maintainState: true,
        onExpansionChanged: (changeValue) {
          setState(() {
            element.isHideExpandedForBlue = changeValue;
          });
        },
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 8,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Petitioner:",
                style: mpHeadLine12(
                    fontWeight: FontWeight.w500,
                    textColor: element.is_disposed == true
                        ? AppColor.white
                        : AppColor.black),
              ),
              const SizedBox(
                width: 2,
              ),
              Flexible(
                child: Text(element.petitioner.toString(),
                    style: mpHeadLine12(
                        fontWeight: FontWeight.w400,
                        textColor: element.is_disposed == true
                            ? AppColor.white
                            : AppColor.black)),
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Respondent:",
                style: mpHeadLine12(
                    fontWeight: FontWeight.w500,
                    textColor: element.is_disposed == true
                        ? AppColor.white
                        : AppColor.black),
              ),
              const SizedBox(
                width: 2,
              ),
              Flexible(
                  child: Text(element.respondent.toString(),
                      style: mpHeadLine12(
                          fontWeight: FontWeight.w400,
                          textColor: element.is_disposed == true
                              ? AppColor.white
                              : AppColor.black)))
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                  child: Text(element.bottomNo.toString(),
                      style: mpHeadLine12(
                          fontWeight: FontWeight.w500,
                          textColor: element.is_disposed == true
                              ? AppColor.white
                              : AppColor.black)))
            ],
          ),
        ],
      ),
      /* const SizedBox(
        height: 5,
      ),*/
      /*   Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Petitioner:",
            style: mpHeadLine12(
                fontWeight: FontWeight.w500,
                textColor: element.is_disposed == true
                    ? AppColor.white
                    : AppColor.black),
          ),
          const SizedBox(
            width: 2,
          ),
          Flexible(
            child: Text(element.petitioner.toString(),
                style: mpHeadLine12(
                    fontWeight: FontWeight.w400,
                    textColor: element.is_disposed == true
                        ? AppColor.white
                        : AppColor.black)),
          )
        ],
      ),
      const SizedBox(
        height: 8,
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Respondent:",
            style: mpHeadLine12(
                fontWeight: FontWeight.w500,
                textColor: element.is_disposed == true
                    ? AppColor.white
                    : AppColor.black),
          ),
          const SizedBox(
            width: 2,
          ),
          Flexible(
              child: Text(element.respondent.toString(),
                  style: mpHeadLine12(
                      fontWeight: FontWeight.w400,
                      textColor: element.is_disposed == true
                          ? AppColor.white
                          : AppColor.black)))
        ],
      ),
      const SizedBox(
        height: 8,
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
              child: Text(element.bottomNo.toString(),
                  style: mpHeadLine12(
                      fontWeight: FontWeight.w500,
                      textColor: element.is_disposed == true
                          ? AppColor.white
                          : AppColor.black)))
        ],
      ),*/
    ]);
  }

  Text bunchInfoHighlight(String data) {
    List<String> dataList = data.split(",");

    int indx = dataList.indexWhere((element) => element.startsWith("1-"));
    List<TextSpan> spans = [];
    if (indx != -1) {
      List first = dataList.sublist(0, indx);
      List second = dataList.sublist(indx, dataList.length);
      TextSpan span1 = TextSpan(
        text: first.join(",") + ",",
        style: mpHeadLine12(
            fontWeight: FontWeight.w500,
            textColor: AppColor.rejected_color_text),
      );
      TextSpan span2 = TextSpan(
        text: second.join(","),
        style: mpHeadLine12(
            fontWeight: FontWeight.w500, textColor: AppColor.black),
      );
      spans.add(span1);
      spans.add(span2);
    } else {
      TextSpan span = TextSpan(
        text: data,
        style: mpHeadLine12(
            fontWeight: FontWeight.w500, textColor: AppColor.black),
      );
      spans.add(span);
    }

    return Text.rich(TextSpan(children: spans));
  }

  pauseLoader() {
    Future.delayed(Duration(seconds: 1), () {
      // setState(() {
      //   isLoading = false;
      // });
      if (widget.isScrollToSno &&
          viewCauseListData != null &&
          viewCauseListData!.causelist != null) {
        print("sno callback");
        // Future.delayed(Duration(seconds: 5), () {
        //   print("sno call after 5 sec");
        sNoCallback(widget.mainCauseListdata["sNo"].toString(),
            widget.mainCauseListdata["type"].toString());
        // });

        widget.isScrollToSno = false;
        isSnoScroll = true;
        isPartialLoading = false;
      } else if (widget.isQuickSearch &&
          !isQuickSearchScroll &&
          viewCauseListData != null &&
          viewCauseListData!.causelist != null) {
        print("widget.quickScrollDate ${widget.quickScrollDate}");
        Future.delayed(Duration(seconds: 1), () {
          dateSelectCallback(
              getddMMYYYY_with_splash(widget.quickScrollDate.toString()),
              isNextDateScroll: true);
        });

        isQuickSearchScroll = true;
      } else {
        setState(() {
          isPartialLoading = false;
        });
      }
    });
  }

  void dateSelectCallback(String date,
      {bool isNextDateScroll = false, bool isFilter = false}) {
    setState(() {
      isPartialLoading = true;
    });
    print("isPartialLoading2304 $isPartialLoading");
    print("dateSelectCallback $date");
    if (!isFilter) {
      int index =
          newList!.indexWhere((element) => date == element.causeListDate);
      print("dateSelectCallback index $index");

      if (index == -1 && isNextDateScroll) {
        recursiveDateScroll(date);
      } else if (index != -1) {
        print("inside else");
        // SchedulerBinding.instance.addPostFrameCallback((_) {
        print("schedule");

        Future.delayed(Duration(milliseconds: 100), () {
          listViewController.sliverController.jumpToIndex(index);
        });
        // _outerScrollController!.scrollToIndex(index,
        //     preferPosition: AutoScrollPosition.begin).then((value) {

        setState(() {
          isPartialLoading = false;
        });
        // });
        // });
        print("isPartialLoading2321 $isPartialLoading");
      } else {
        setState(() {
          isPartialLoading = false;
        });
      }
    } else {
      int index =
          searchList!.indexWhere((element) => date == (element.causeListDate!));
      //
      print("dateSelectCallback index $index");
      // print("dateSelectCallback sno ${caseList![index].sno}");
      // int index = 4;

      if (index != -1) {
        searchViewController.sliverController.jumpToIndex(index);

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

  void recursiveDateScroll(String date) {
    recursiveDateCall++;
    DateFormat format = DateFormat("dd/MM/yyyy");
    int index = newList.indexWhere((element) =>
        element.causeListDate ==
        getDDMMYYYY(format.parse(date).add(Duration(days: 1)).toString()));
    print("isNextDateScroll index $index");
    if (index != -1) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        listViewController.sliverController.jumpToIndex(index);
        // _outerScrollController!.scrollToIndex(index, preferPosition: AutoScrollPosition.begin)
        //     .then((value) {
        setState(() {
          isPartialLoading = false;
        });
        // });
      });
    } else {
      DateFormat format = DateFormat("dd/MM/yyyy");
      print("calling recursive");
      if (recursiveDateCall < 8) {
        recursiveDateScroll(
            getDDMMYYYY(format.parse(date).add(Duration(days: 1)).toString()));
      } else {
        setState(() {
          isPartialLoading = false;
        });
      }
    }
  }

  void courtSelectCallback(String court) {
    setState(() {
      isPartialLoading = true;
    });
    print("courtSelectCallback $court");
    int index = newList.indexWhere((element) => court == element.courtNo);
    print("index $index");
    listViewController.sliverController.jumpToIndex(index);
    // _outerScrollController!.scrollToIndex(index, preferPosition: AutoScrollPosition.begin) .then((value) {
    setState(() {
      isPartialLoading = false;
    });
    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //   listViewController.sliverController.jumpToIndex(index);
    //   // _outerScrollController!.scrollToIndex(index, preferPosition: AutoScrollPosition.begin) .then((value) {
    //   setState(() {
    //     isPartialLoading = false;
    //   });
    //   // });
    // });
  }

  void datesCourtSelectCallback(String date, String courtNo) {
    print("datescourtSelectCallback");
    setState(() {
      isPartialLoading = true;
    });
    int index = newList.indexWhere((element) =>
        date == element.causeListDate && courtNo == element.courtNo);
    print("datescourtSelectCallback $index");

    // SchedulerBinding.instance.addPostFrameCallback((_) {
    listViewController.sliverController.jumpToIndex(index);
    // _outerScrollController!.scrollToIndex(index,
    //     preferPosition: AutoScrollPosition.begin,
    //     duration: Duration(milliseconds: 100)
    // ) .then((value) {
    setState(() {
      isPartialLoading = false;
    });
    // });
    // });
  }

  void sNoCallback(String sno, String type) {
    print("sNoCallback sno> ${sno} and type $type");
    setState(() {
      isPartialLoading = false;
    });
    if (newList.isNotEmpty) {
      int index = newList.indexWhere((element) =>
          element.sno!.contains(sno) && element.causeListType == type);
      print("index $index");

      if (index != -1) {
        // SchedulerBinding.instance.addPostFrameCallback((_) {

        Future.delayed(Duration(milliseconds: 100), () {
          listViewController.sliverController.jumpToIndex(index);
          setState(() {
            isPartialLoading = false;
          });
        });
        // });

        // _outerScrollController!.scrollToIndex(index,
        //     preferPosition: AutoScrollPosition.begin) .then((value) {

        // });
        // });
      }
      // else{
      //   setState(() {
      //     isPartialLoading=false;
      //   });
      // }
    }
  }

  void searchFilterList(String searchKey) {
    setState(() {
      searchList = [];
      searchFirstVisibleIndex = 0;
    });
    for (var item in viewCauseListData!.causelist!) {
      if (item.courtNo!.toLowerCase().contains(searchKey) ||
          item.petitioner!.toLowerCase().contains(searchKey) ||
          item.benchName!.toLowerCase().contains(searchKey) ||
          item.caseNo!.toLowerCase().contains(searchKey) ||
          item.partyName!.toLowerCase().contains(searchKey) ||
          item.respondent!.toLowerCase().contains(searchKey) ||
          item.sno!.toLowerCase().contains(searchKey) ||
          item.bottomNo!.toLowerCase().contains(searchKey) ||
          item.stage!.toLowerCase().contains(searchKey) ||
          item.causeListDate!.toLowerCase().contains(searchKey) ||
          item.bench_info != null &&
              item.bench_info!.toLowerCase().contains(searchKey)) {
        if (!searchList.contains(item)) {
          searchList.add(item);
        }
      }
    }

    for (int i = 0; i < searchList.length; i++) {
      if (i == 0 ||
          searchList[i].courtNo == "Before Registrar (Admin.)" ||
          searchList[i].courtNo == "Before Registrar (Admin.)" ||
          searchList[i].courtNo == "Before Dy. Registrar (Judicial)") {
        searchList[i].iscourtChange = false;
      } else {
        if (searchList[i - 1].courtNo == "Before Registrar (Admin.)") {
          searchList[i].iscourtChange = true;
        } else if (searchList[i - 1].courtNo ==
            "Before Dy. Registrar (Judicial)") {
          searchList[i].iscourtChange = true;
        } else if (int.parse(searchList[i].courtNo!) !=
            int.parse(searchList[i - 1].courtNo!)) {
          searchList[i].iscourtChange = true;
        } else {
          searchList[i].iscourtChange = false;
        }
      }
    }

    searchDatesCourt = [];
    for (int i = 0; i < searchList.length; i++) {
      if (!searchDatesCourt
          .any((element) => element.date == searchList[i].causeListDate)) {
        DatesCourtModel model = DatesCourtModel();
        model.date = searchList[i].causeListDate!;
        model.courtNo = [];
        model.courtNo!.add(searchList[i].courtNo);
        searchDatesCourt.add(model);
      } else {
        // DatesCourtModel model=DatesCourtModel();
        int index = searchDatesCourt.indexWhere(
            (element) => element.date == searchList[i].causeListDate);
        //model.courtNo=[];
        if (!searchDatesCourt[index].courtNo!.contains(searchList[i].courtNo)) {
          searchDatesCourt[index].courtNo!.add(searchList[i].courtNo);
        }
      }
    }
    print("searchDatesCourt/// ${searchDatesCourt.length}");

    //print("searchlist length ${searchList.length}");
    isSearchFilter = true;
    setState(() {});
  }

  // await downloadFiles(file, fileName);
  downloadData(String file, String filePdfName) async {
    setState(() {
      filePdf = file;
      fileName = filePdfName;
    });

    print("selectedFileType ==>  $selectedFileType");
    if (selectedFileType == "PDF") {
      toast(msg: "Downloading started");
      await downloadFiles(filePdf, fileName);
    } else if (selectedFileType == "Excel") {
      await downloadFiles(file, fileName);
    } else {
      try {
        await gmailAuthenticate();

        await createCaseFolderDrive();

        await GoogleDriveHandler().fileUploadToDrivePdf(authMap["driveApi"],
            driveIdMap['sub_folder_id'], filePdf, fileName);

        // All three tasks completed successfully
        toast(msg: "Downloading completed");
        print("All tasks completed successfully!");
      } catch (error) {
        // Handle errors
        print("An error occurred: $error");
      }
    }

    /* showDialog(
        context: context,
        builder: (ctx) => WatchListAndUpdatePopup(
              btnCallback: onClickDownloadShown,
              btnUpdateManuallyCallback: onClickGoogleDriveShown,
              heading1: 'Download',
              heading2: 'Save to Google Drive',
            ));*/
  }

/*
  createCaseFolderDrive() async {
    driveIdMap = await GoogleDriveHandler()
        .folderCreate(authMap["driveApi"], "Cause", "Cause List");
  }
*/

  createCaseFolderDrive() async {
    driveIdMap = await GoogleDriveHandler()
        .folderCreateWithoutSub(authMap["driveApi"], "HAeLO", "Cause List");
  }

  bool isWithContains(sno, snoWith) {
    if (snoWith.isEmpty) {
      if (sno.contains("With")) {
        return true;
      }
    }
    return false;
  }

  viewAndSaveAlertApi(String caseNumber) {
    print("lawyerName ==>${widget.mainCauseListdata["lawyerName"]}");
    print("viewAndSaveAlertApi selectedCaseNumber ==>$caseNumber");
    String lawyerName = "${widget.mainCauseListdata["lawyerName"]}";
    String cleanedLawyerName = lawyerName.replaceAll(RegExp(r'[{}]+'), '');

    print("lawyerName  cleanedLawyerName ==> $cleanedLawyerName");
    print(
        "viewAndSaveAlertApi  caseNo ==> ${widget.mainCauseListdata["caseNo"].toString()}");

    var viewValueList = {
      "lawyer": "",
      "FROM_DATE": widget.mainCauseListdata["dateFrom"].toString() != ""
          ? widget.mainCauseListdata["dateFrom"].toString()
          : "",
      "TO_DATE": "",
      "COURT_NUMBER": "",
      "SELECTED_JUDGES_NAME": "",
      "SELECTED_CAUSE_TYPE": "",
      "SELECTED_CASE_NUMBER": caseNumber,
      "SELECTED_LAWYER_NAME": "",
      "SELECTED_PARTY_NAME": "",
      "alert_id": "",
    };
    var viewList = {"filter": jsonEncode(viewValueList)};
    BlocProvider.of<ViewSaveCubit>(context).fetchViewSave(viewList);
  }

  List filterHiddenCases(List cases, bool showHidden) {
    if (showHidden) {
      return cases;
    } else {
      return cases.where((caseItem) => caseItem.is_hide == 0).toList();
    }
  }

  Future<void> openWatchListDialog(String caseId) async {
    print("caseId $caseId");
    FocusScope.of(context).requestFocus(FocusNode());
    if (displayWatchList != null && displayWatchList!.isNotEmpty) {
      showDialog(
          context: context,
          builder: (ctx) => LawyerWatchList(
                displayWatchList,
                caseId,
                "0",
                isFromCauseListAdd: true,
              ));
    } else {
      await showDialog(
        context: context,
        builder: (ctx) => AddToWatchList(
          "",
          "0",
          caseId: caseId,
          isFromCauseListAdd: true,
        ),
      );
    }
  }

  void showPdfOptionDialog(String dateFrom, String dateTo) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            // insetPadding: EdgeInsets.symmetric(vertical: 305),
            contentPadding: EdgeInsets.zero,
            content: SizedBox(
              // height: mediaQH(context) * 0.16,
              // width: mediaQW(context) * 0.8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 25),
                    child: Text(
                      "You want to download PDF without lawyer names?",
                      textAlign: TextAlign.center,
                      style: mpHeadLine14(fontWeight: FontWeight.w600),
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
                            Map<String, String> param = {};
                            print("ok");
                            String lawyerName =
                                "${widget.mainCauseListdata["lawyerName"]}";
                            String cleanedLawyerName =
                                lawyerName.replaceAll(RegExp(r'[{}]+'), '');
                            param = {
                              "dateFrom": dateFrom != ""
                                  ? dateFrom
                                  : widget.mainCauseListdata["dateFrom"]
                                      .toString(),
                              "pageNo": "1",
                            };
                            if (widget.mainCauseListdata["lawyerName"] !=
                                null) {
                              param["lawyerName"] = cleanedLawyerName;
                            }
                            if (dateTo != "" &&
                                widget.mainCauseListdata["dateTo"].toString() !=
                                    "") {
                              param["dateTo"] = dateTo != ""
                                  ? dateTo
                                  : widget.mainCauseListdata["dateTo"]
                                      .toString();
                            }

                            if (widget.mainCauseListdata["courtNo"] != null) {
                              param["courtNo"] = widget
                                  .mainCauseListdata["courtNo"]
                                  .toString();
                            }
                            if (widget.mainCauseListdata["caseNo"] != null) {
                              param["caseNo"] =
                                  widget.mainCauseListdata["caseNo"].toString();
                            }
                            if (widget.mainCauseListdata["judgeName"] != null) {
                              param["benchName"] = widget
                                  .mainCauseListdata["judgeName"]
                                  .toString();
                            }
                            if (widget.mainCauseListdata["caveatName"] !=
                                null) {
                              param["caveatName"] = widget
                                  .mainCauseListdata["caveatName"]
                                  .toString();
                            }
                            if (widget.mainCauseListdata["partyName"] != null) {
                              param["partyName"] = widget
                                  .mainCauseListdata["partyName"]
                                  .toString();
                            }
                            if (widget.mainCauseListdata["judgeTime"] != null) {
                              param["judgeTime"] = widget
                                  .mainCauseListdata["judgeTime"]
                                  .toString();
                            }
                            if (widget.mainCauseListdata["causeListType"] !=
                                null) {
                              param["causeListType"] = widget
                                  .mainCauseListdata["causeListType"]
                                  .toString();
                            }
                            param['downloadFile'] = "pdf";
                            param['isLawyer'] = "False";

                            // Navigator.pop(context);
                            Navigator.pop(ctx);
                            if (selectedFileType == "Drive") {
                              toast(msg: "Downloading started");
                            }
                            context
                                .read<ViewCauseListCubit>()
                                .fetchViewCauseList(param, "3.2");
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
                            Map<String, String> param = {};
                            String lawyerName =
                                "${widget.mainCauseListdata["lawyerName"]}";
                            String cleanedLawyerName =
                                lawyerName.replaceAll(RegExp(r'[{}]+'), '');
                            param = {
                              "dateFrom": dateFrom != ""
                                  ? dateFrom
                                  : widget.mainCauseListdata["dateFrom"]
                                      .toString(),
                              "pageNo": "1",
                            };
                            if (widget.mainCauseListdata["lawyerName"] !=
                                null) {
                              param["lawyerName"] = cleanedLawyerName;
                            }
                            if (dateTo != "" &&
                                widget.mainCauseListdata["dateTo"].toString() !=
                                    "") {
                              param["dateTo"] = dateTo != ""
                                  ? dateTo
                                  : widget.mainCauseListdata["dateTo"]
                                      .toString();
                            }
                            if (widget.mainCauseListdata["courtNo"] != null) {
                              param["courtNo"] = widget
                                  .mainCauseListdata["courtNo"]
                                  .toString();
                            }
                            if (widget.mainCauseListdata["caseNo"] != null) {
                              param["caseNo"] =
                                  widget.mainCauseListdata["caseNo"].toString();
                            }
                            if (widget.mainCauseListdata["judgeName"] != null) {
                              param["benchName"] = widget
                                  .mainCauseListdata["judgeName"]
                                  .toString();
                            }
                            if (widget.mainCauseListdata["caveatName"] !=
                                null) {
                              param["caveatName"] = widget
                                  .mainCauseListdata["caveatName"]
                                  .toString();
                            }
                            if (widget.mainCauseListdata["partyName"] != null) {
                              param["partyName"] = widget
                                  .mainCauseListdata["partyName"]
                                  .toString();
                            }
                            if (widget.mainCauseListdata["judgeTime"] != null) {
                              param["judgeTime"] = widget
                                  .mainCauseListdata["judgeTime"]
                                  .toString();
                            }
                            if (widget.mainCauseListdata["causeListType"] !=
                                null) {
                              param["causeListType"] = widget
                                  .mainCauseListdata["causeListType"]
                                  .toString();
                            }
                            param['downloadFile'] = "pdf";
                            // Navigator.pop(context);
                            Navigator.pop(ctx);
                            if (selectedFileType == "Drive") {
                              toast(msg: "Downloading started");
                            }
                            context
                                .read<ViewCauseListCubit>()
                                .fetchViewCauseList(param, "3.2");
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: mediaQH(context) * 0.05,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(5)),
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
        }).then((value) {
      if (value != null) {
        print("Type value: $value");
      }
    });
  }

  void downloadExcelFile(String dateFrom, String dateTo) {
    Map<String, String> param = {};
    print("ok");
    String lawyerName = "${widget.mainCauseListdata["lawyerName"]}";
    String cleanedLawyerName = lawyerName.replaceAll(RegExp(r'[{}]+'), '');
    param = {
      "dateFrom": dateFrom != ""
          ? dateFrom
          : widget.mainCauseListdata["dateFrom"].toString(),
      "pageNo": "1",
    };
    if (widget.mainCauseListdata["lawyerName"] != null) {
      param["lawyerName"] = cleanedLawyerName;
    }

    if (dateTo != "" && widget.mainCauseListdata["dateTo"].toString() != "") {
      param["dateTo"] =
          dateTo != "" ? dateTo : widget.mainCauseListdata["dateTo"].toString();
    }

    if (widget.mainCauseListdata["courtNo"] != null) {
      param["courtNo"] = widget.mainCauseListdata["courtNo"].toString();
    }
    if (widget.mainCauseListdata["caseNo"] != null) {
      param["caseNo"] = widget.mainCauseListdata["caseNo"].toString();
    }
    if (widget.mainCauseListdata["judgeName"] != null) {
      param["benchName"] = widget.mainCauseListdata["judgeName"].toString();
    }
    if (widget.mainCauseListdata["caveatName"] != null) {
      param["caveatName"] = widget.mainCauseListdata["caveatName"].toString();
    }
    if (widget.mainCauseListdata["partyName"] != null) {
      param["partyName"] = widget.mainCauseListdata["partyName"].toString();
    }
    if (widget.mainCauseListdata["judgeTime"] != null) {
      param["judgeTime"] = widget.mainCauseListdata["judgeTime"].toString();
    }
    if (widget.mainCauseListdata["causeListType"] != null) {
      param["causeListType"] =
          widget.mainCauseListdata["causeListType"].toString();
    }
    param['downloadFile'] = "excel";
    context.read<ViewCauseListCubit>().fetchViewCauseList(param, "3.2");
  }
}
