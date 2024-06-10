import 'dart:core';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/constants.dart';
import 'package:haelo_flutter/core/utils/bottom_sheet_dialog.dart';
import 'package:haelo_flutter/core/utils/functions.dart';
import 'package:haelo_flutter/core/utils/save_file.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/cases/cubit/deletemycases_cubit.dart';
import 'package:haelo_flutter/features/cases/cubit/deletemycases_state.dart';
import 'package:haelo_flutter/features/cases/cubit/mycases_cubit.dart';
import 'package:haelo_flutter/features/cases/cubit/mycases_state.dart';
import 'package:haelo_flutter/features/cases/cubit/office_stage_state.dart';
import 'package:haelo_flutter/features/cases/presentation/screens/casedetails.dart';
import 'package:haelo_flutter/features/cases/presentation/screens/mycases_bottom_sheet.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/color_node.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/download_file_option.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/no_data_widget.dart';
import 'package:haelo_flutter/features/causeslist/cubit/showwatchlist_cubit.dart';
import 'package:haelo_flutter/features/causeslist/cubit/showwatchlist_state.dart';
import 'package:haelo_flutter/features/causeslist/presentation/widget/add_to_watchlist.dart';
import 'package:haelo_flutter/features/causeslist/presentation/widget/datelist_dialog.dart';
import 'package:haelo_flutter/features/causeslist/presentation/widget/lawyer_watchlist.dart';
import 'package:haelo_flutter/widgets/date_format.dart';
import 'package:haelo_flutter/widgets/go_prime.dart';
import 'package:haelo_flutter/widgets/progress_indicator.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

import '../../../court_date_report/presentation/screen/court_date_report_screen.dart';
import '../../../order_comment_history/presentation/screen/orderCommentHistory.dart';
import '../../../pending_order_report/presentation/screen/pendingOrderReport.dart';
import '../../cubit/office_stage_cubit.dart';
import '../../cubit/update_manually_cubit.dart';
import '../../cubit/update_manually_state.dart';
import '../../data/model/office_stage_model.dart';
import '../widgets/watchlist_and_manually_dialog.dart';
import 'addcase_mycases.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:haelo_flutter/locators.dart' as di;

class MyCases extends StatefulWidget {
  final selectedData;

  MyCases({this.selectedData = const {}, Key? key}) : super(key: key);

  @override
  State<MyCases> createState() => _MyCasesState();
}

class _MyCasesState extends State<MyCases> {
  bool isLoading = true;
  bool isAlreadyLoadedData = false;
  String selectedFilter = "";
  late SharedPreferences pref;

  bool? isCheck = false;
  List<int> selectedList = [];
  List watchlistSelectedList = [];
  List<String> officeStageList = [];
  List<String> caseNumberList = [];

  //for search only
  bool isSearch = false;
  bool isSearchFilter = false;
  TextEditingController search_textController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  List searchList = [];
  List newList = [];
  List dates = [];
  bool isNodata = false;
  List? displayWatchList;
  bool isSelectionChange = false;

  GroupedItemScrollController itemScrollController =
      GroupedItemScrollController();
  ScrollController controller = ScrollController();
  ScrollController scrollController = ScrollController();
  bool isDrag = false;
  bool isSearchLoading = false;
  bool isFirstTime = true;

  @override
  void initState() {
    pref = di.locator();
    var myCasesList = {
      "pageNo": "1",
      "watchlistId": "",
      "filterByDecision": "",
      "caseBySearch": "",
      "downloadFile": "",
    };
    BlocProvider.of<MyCasesCubit>(context).fetchMyCases(myCasesList);
    BlocProvider.of<OfficeStageCubit>(context).fetchOfficeStageData();

    if (widget.selectedData == null ||
        widget.selectedData['case_list'] == null) {
      BlocProvider.of<ShowWatchlistCubit>(context).fetchShowWatchlist();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.home_background,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          elevation: 0,
          titleSpacing: 0,
          automaticallyImplyLeading: true,
          title: Row(
            children: [
              InkWell(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Icon(Icons.menu),
                ),
              ),
              isSearch
                  ? SizedBox()
                  : Expanded(
                      child: Text(
                        "My Cases",
                        style: mpHeadLine18(
                            fontWeight: FontWeight.w500,
                            textColor: AppColor.bold_text_color_dark_blue),
                      ),
                    ),

              /*   isSearch
                  ? SizedBox()
                  : Expanded(
                      child: Text(
                        "Report",
                        style: mpHeadLine12(
                            fontWeight: FontWeight.w500,
                            textColor: AppColor.bold_text_color_dark_blue),
                      ),
                    ),*/

              watchlistSelectedList.isNotEmpty || newList.isEmpty || isSearch
                  ? SizedBox()
                  : InkWell(
                      onTap: () {
                        showMenu(
                          context: context,
                          position: const RelativeRect.fromLTRB(
                              50, 0, 0, 0), // Adjust the position as needed
                          items: [
                            const PopupMenuItem(
                              value: 1,
                              child: Text("Court Date Report"),
                            ),
                            const PopupMenuItem(
                              value: 2,
                              child: Text("Pending Order Report"),
                            ),
                          ],
                        ).then((value) {
                          if (value == 1) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CourtDateReportScreen()));
                          } else if (value == 2) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PendingCmtHistory()));
                          }
                        });
                      },
                      child: Text(
                        "Report",
                        style: mpHeadLine12(
                          fontWeight: FontWeight.w500,
                          textColor: AppColor.bold_text_color_dark_blue,
                        ),
                      ),
                    ),

              SizedBox(
                width: 10,
              ),

              watchlistSelectedList.isNotEmpty || newList.isEmpty || isSearch
                  ? SizedBox()
                  : InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (ctx) => DownloadFileOption());
                      },
                      child: const Icon(
                        Icons.download,
                        size: 25,
                        color: AppColor.bold_text_color_dark_blue,
                      ),
                    ),

              selectedList.isNotEmpty && isSelectionChange
                  ? InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (ctx) => WatchListAndUpdatePopup(
                                  btnCallback: onWatchListPressShown,
                                  btnUpdateManuallyCallback:
                                      onUpdateManullyClick,
                                  heading1: 'Add WatchList',
                                  heading2: 'Update Manually',
                                ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: const Icon(
                          Icons.add,
                          size: 30,
                        ),
                      ),
                    )
                  : SizedBox(),

              // watchlistSelectedList.isNotEmpty ||
              newList.isEmpty
                  ? SizedBox()
                  : !isSearch
                      ? Container(
                          margin: EdgeInsets.only(
                              right: watchlistSelectedList.isNotEmpty ? 10 : 0,
                              left: 5),
                          child: InkWell(
                              onTap: () => setState(() {
                                    isSearch = true;
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    _focusNode.requestFocus();
                                  }),
                              child: const Icon(
                                Icons.search,
                                color: Colors.black,
                              )),
                        )
                      : Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12),
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
                              focusNode: _focusNode,
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
              BlocConsumer<OfficeStageCubit, OfficeStageState>(
                builder: (context, state) {
                  return const SizedBox();
                },
                listener: (context, state) {
                  /* if (state is OfficeStageLoading) {
                    setState(() {
                      isLoading = true;
                    });
                  }*/
                  if (state is OfficeStageLoaded) {
                    var officeStage = state.model;
                    if (officeStage.result == 1) {
                      setState(() {
                        isLoading = false;
                        print("isAlreadyLoadedData $isAlreadyLoadedData");

                        List<String> stageNames = officeStage.data!.oficeStage!
                            .map((stage) => stage.stageName.toString())
                            .toList();

                        officeStageList = stageNames;
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
              watchlistSelectedList.isNotEmpty || newList.isEmpty || isSearch
                  ? SizedBox()
                  : Container(
                      margin: const EdgeInsets.only(left: 5),
                      child: InkWell(
                        onTap: () {
                          BottomSheetDialog(
                              context,
                              CasesBottomSheet(
                                filterList,
                                selectedFilter,
                                officeStageList,
                              )).showScreen();
                        },
                        child: Stack(
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
              // buildPopupMenuButton()
            ],
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              newList.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 10),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                ColorNode(AppColor.white, "Not set"),
                                ColorNode(AppColor.cases_nostay, "No stay"),
                                ColorNode(
                                    AppColor.cases_intrimstay, "Interim stay"),
                                ColorNode(AppColor.cases_fullstay, "Full stay"),
                                ColorNode(AppColor.disposedColor, "Disposed"),
                                ColorNode(AppColor.text_grey_color, "Hidden"),
                                // ColorNode(AppColor.disposedColor, "Disposed"),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                            child: searchList.isEmpty && !isSearchFilter
                                ? RefreshIndicator(
                                    onRefresh: () async {
                                      var myCasesList = {
                                        "pageNo": "1",
                                        "watchlistId": "",
                                        "filterByDecision": "",
                                        "caseBySearch": "",
                                        "downloadFile": "",
                                      };
                                      BlocProvider.of<MyCasesCubit>(context)
                                          .fetchMyCases(myCasesList);
                                    },
                                    child: watchlistSelectedList.isNotEmpty
                                        ? Row(
                                            children: [
                                              Expanded(
                                                child: Scrollbar(
                                                  trackVisibility: true,
                                                  thumbVisibility: true,
                                                  controller: scrollController,
                                                  interactive: true,
                                                  thickness: 10,
                                                  child: SingleChildScrollView(
                                                    physics:
                                                        AlwaysScrollableScrollPhysics(),
                                                    controller:
                                                        scrollController,
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        ListView.builder(
                                                            itemCount:
                                                                watchlistSelectedList
                                                                    .length,
                                                            shrinkWrap: true,
                                                            physics:
                                                                NeverScrollableScrollPhysics(),
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return caseCard(
                                                                  context,
                                                                  watchlistSelectedList[
                                                                      index]);
                                                            }),
                                                        StickyGroupedListView<
                                                            dynamic, String>(
                                                          elements: newList,
                                                          shrinkWrap: true,
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          groupBy: (dynamic
                                                                  element) =>
                                                              element.date
                                                                  .toString(),
                                                          groupSeparatorBuilder:
                                                              (value) =>
                                                                  Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 10,
                                                                    bottom: 10,
                                                                    left: 0),
                                                            child: Text(
                                                                "Date: ${value.date}",
                                                                style: mpHeadLine16(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center),
                                                          ),
                                                          groupComparator:
                                                              (dynamic e1,
                                                                  dynamic e2) {
                                                            if (e1 != null &&
                                                                e2 != null &&
                                                                e1 !=
                                                                    "Not Available" &&
                                                                e2 !=
                                                                    "Not Available") {
                                                              DateTime
                                                                  _dateTime =
                                                                  DateFormat(
                                                                          "dd-MM-yyyy")
                                                                      .parse(
                                                                          e1);
                                                              DateTime
                                                                  _dateTime1 =
                                                                  DateFormat(
                                                                          "dd-MM-yyyy")
                                                                      .parse(
                                                                          e2);
                                                              // _dateTime = DateTime.(_dateTime);
                                                              //  print(_dateTime);

                                                              return _dateTime!
                                                                  .compareTo(
                                                                      _dateTime1);
                                                            } else {
                                                              return e1
                                                                  .compareTo(
                                                                      e2);
                                                            }
                                                            //return e1.compareTo(e2);
                                                          },
                                                          itemBuilder: (context,
                                                                  dynamic
                                                                      element) =>
                                                              caseCard(context,
                                                                  element),
                                                          // itemComparator: (e1, e2) => e1.compareTo(e2['name']), // optional
                                                          // elementIdentifier: (element) => element.name // optional - see below for usage
                                                          itemScrollController:
                                                              itemScrollController,
                                                          // optional
                                                          order: StickyGroupedListOrder
                                                              .ASC, // optional
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        : Row(
                                            children: [
                                              Expanded(
                                                child: Scrollbar(
                                                  trackVisibility: true,
                                                  thumbVisibility: true,
                                                  // controller: itemScrollController.scrollController,
                                                  interactive: true,
                                                  thickness: 5,
                                                  child: StickyGroupedListView<
                                                      dynamic, String>(
                                                    elements: newList,
                                                    shrinkWrap: true,
                                                    groupBy:
                                                        (dynamic element) =>
                                                            element.date
                                                                .toString(),
                                                    groupSeparatorBuilder:
                                                        (value) => Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10,
                                                              bottom: 10,
                                                              left: 0),
                                                      child: Text(
                                                          "Date: ${value.date}",
                                                          style: mpHeadLine16(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                          textAlign:
                                                              TextAlign.center),
                                                    ),
                                                    groupComparator:
                                                        (dynamic e1,
                                                            dynamic e2) {
                                                      if (e1 != null &&
                                                          e2 != null &&
                                                          e1 !=
                                                              "Not Available" &&
                                                          e2 !=
                                                              "Not Available") {
                                                        DateTime _dateTime =
                                                            DateFormat(
                                                                    "dd-MM-yyyy")
                                                                .parse(e1);
                                                        DateTime _dateTime1 =
                                                            DateFormat(
                                                                    "dd-MM-yyyy")
                                                                .parse(e2);
                                                        // _dateTime = DateTime.(_dateTime);
                                                        //  print(_dateTime);

                                                        return _dateTime!
                                                            .compareTo(
                                                                _dateTime1);
                                                      } else {
                                                        return e1.compareTo(e2);
                                                      }
                                                      //return e1.compareTo(e2);
                                                    },
                                                    itemBuilder: (context,
                                                            dynamic element) =>
                                                        caseCard(
                                                            context, element),
                                                    // itemComparator: (e1, e2) => e1.compareTo(e2['name']), // optional
                                                    // elementIdentifier: (element) => element.name // optional - see below for usage
                                                    itemScrollController:
                                                        itemScrollController,
                                                    // optional
                                                    order:
                                                        StickyGroupedListOrder
                                                            .ASC, // optional
                                                  ),
                                                ),
                                              ),
                                              // newList.isNotEmpty && !isSearchFilter?
                                              // SizedBox(
                                              //   width: 10,
                                              //   height: mediaQH(context),
                                              //   // color: Colors.pinkAccent,
                                              //   child: Scrollbar(
                                              //     trackVisibility: true,
                                              //     thumbVisibility: true,
                                              //     controller: controller,
                                              //     interactive: true,
                                              //     thickness: 5,
                                              //     notificationPredicate: (pred){
                                              //       //print("list lenght ${newList.length}");
                                              //       if(isDrag){
                                              //       var currentIndex = (newList.length/pred.metrics.maxScrollExtent) * pred.metrics.pixels;
                                              //       if (currentIndex.isNaN || currentIndex.isInfinite){
                                              //         currentIndex=0;
                                              //       }
                                              //       itemScrollController.scrollTo(
                                              //         index: currentIndex.round(),
                                              //         curve: Curves.easeInOutCubic,
                                              //         alignment: 0,
                                              //         duration: const Duration(milliseconds: 100),
                                              //       );
                                              //       }
                                              //
                                              //       // print("CurrentIndex ${CurrentIndex.round()}");
                                              //       // print("ok notificaiton ${pred.metrics.maxScrollExtent}");
                                              //       return true;
                                              //     },
                                              //     child: ListView.builder(
                                              //         shrinkWrap: true,
                                              //         controller: controller,
                                              //         itemCount: newList.length,
                                              //         itemBuilder: (context,index){
                                              //           return Container(
                                              //             width: 10,
                                              //             height: 300,
                                              //             // color: Colors.orange,
                                              //           );
                                              //         }),
                                              //   ),
                                              // ):SizedBox()
                                            ],
                                          ),
                                  )
                                : searchList.isNotEmpty && isSearchLoading
                                    ? Center(child: CircularProgressIndicator())
                                    : searchList.isNotEmpty
                                        ? StickyGroupedListView<dynamic,
                                            String>(
                                            elements: searchList,
                                            initialScrollIndex: 0,
                                            groupBy: (dynamic element) =>
                                                element.date.toString(),
                                            groupComparator:
                                                (dynamic e1, dynamic e2) {
                                              if (e1 != null &&
                                                  e2 != null &&
                                                  e1 != "Not Available" &&
                                                  e2 != "Not Available") {
                                                DateTime _dateTime =
                                                    DateFormat("dd-MM-yyyy")
                                                        .parse(e1);
                                                DateTime _dateTime1 =
                                                    DateFormat("dd-MM-yyyy")
                                                        .parse(e2);
                                                // _dateTime = DateTime.(_dateTime);
                                                //  print(_dateTime);

                                                return _dateTime!
                                                    .compareTo(_dateTime1);
                                              } else {
                                                return e1.compareTo(e2);
                                              }
                                              //return e1.compareTo(e2);
                                            },
                                            groupSeparatorBuilder: (value) =>
                                                Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, bottom: 10, left: 0),
                                              child: Text("Date: ${value.date}",
                                                  style: mpHeadLine16(
                                                      fontWeight:
                                                          FontWeight.w600),
                                                  textAlign: TextAlign.center),
                                            ),
                                            itemBuilder:
                                                (context, dynamic element) =>
                                                    caseCard(context, element),
                                            shrinkWrap: true,
                                            order: StickyGroupedListOrder.ASC,
                                          )
                                        : NoDataAvailable(
                                            "Search data not found.")),
                      ],
                    )
                  : NoDataAvailable("No Data Found."),
              Visibility(
                visible: isLoading,
                child: const Center(child: AppProgressIndicator()),
              ),
              BlocConsumer<MyCasesCubit, MyCasesState>(
                builder: (context, state) {
                  return const SizedBox();
                },
                listener: (context, state) {
                  if (state is MyCasesLoading) {
                    setState(() {
                      isLoading = true;
                    });
                  }
                  if (state is MyCasesLoaded) {
                    var myCasesModelList = state.myCasesModel;
                    if (myCasesModelList.result == 1) {
                      setState(() {
                        print("isAlreadyLoadedData $isAlreadyLoadedData");
                        // if(!isAlreadyLoadedData){
                        if (myCasesModelList.data != null &&
                            myCasesModelList.data!.isNotEmpty) {
                          isAlreadyLoadedData = true;
                          watchlistSelectedList = [];
                          selectedList = [];
                          caseNumberList = [];
                          List checkedCases = [];
                          List selectedCase = [];
                          if (widget.selectedData != null &&
                              widget.selectedData['case_list'] != null) {
                            selectedCase = widget.selectedData['case_list'];
                          }
                          for (int i = 0; i < selectedCase.length; i++) {
                            var value =
                                selectedCase[i].toString().split(" ").last;
                            print("value $value");
                            var value1 = value.split("/").first;
                            print("value1 $value1");
                            checkedCases.add(int.parse(value1));
                          }

                          for (var element in myCasesModelList.data!) {
                            if (checkedCases.contains(element.caseNo)) {
                              selectedList.add(element.caseId!);
                              watchlistSelectedList.add(element);
                            }
                          }
                          for (var element in myCasesModelList.data!) {
                            if (checkedCases.contains(element.caseName)) {
                              caseNumberList.add(element.caseName!);
                            }
                          }
                          print(("caseNumberList $caseNumberList"));
                          print(
                              "watchlistSelectedList ${watchlistSelectedList.length}");
                          newList = [];
                          // newList=myCasesModelList.data!;
                          // for (var element in selectedList) {
                          //   var result =myCasesModelList.data!.indexWhere((e) => e.caseId==element);
                          //   print("result index $result");
                          //   if(result!=-1){
                          //     newList.add(myCasesModelList.data![result]);
                          //   }
                          // }

                          for (var element in myCasesModelList.data!) {
                            if (!selectedList.contains(element.caseId)) {
                              newList.add(element);
                            }
                          }

                          newList = newList.map((user) => user).toList()
                            ..sort((a, b) {
                              //print("first date ${a.date} second ${b.date}");
                              if (a.date != null &&
                                  b.date != null &&
                                  a.date != "Not Available" &&
                                  b.date != "Not Available") {
                                DateTime _dateTime =
                                    DateFormat("dd-MM-yyyy").parse(a.date!);
                                DateTime _dateTime1 =
                                    DateFormat("dd-MM-yyyy").parse(b.date!);
                                // _dateTime = DateTime.(_dateTime);
                                //  print(_dateTime);
                                return _dateTime!.compareTo(_dateTime1);
                              } else {
                                return a.date!.compareTo(b.date!);
                              }
                            });
                          setState(() {});

                          for (int i = 0; i < newList.length; i++) {
                            if (!dates.contains(newList![i].date)) {
                              dates.add(newList![i].date);
                            }
                          }
                          Future.delayed(Duration(seconds: 2), () {
                            setState(() {
                              if (!isDrag) isDrag = true;
                            });
                          });
                        }
                        // }

                        /// for download file only

                        if (myCasesModelList.downloadFileData != null &&
                            myCasesModelList.downloadFileData!.downloadFile !=
                                null &&
                            myCasesModelList
                                .downloadFileData!.downloadFile!.isNotEmpty) {
                          toast(msg: "Downloading started");
                          DateTime now = DateTime.now();
                          var fileName =
                              "My Case_${now.millisecondsSinceEpoch}.${myCasesModelList.downloadFileData!.downloadFile!.toString().split(".").last}";
                          downloadData(
                              myCasesModelList.downloadFileData!.downloadFile!,
                              fileName);
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
              BlocConsumer<DeleteMyCaseCubit, DeleteMyCaseState>(
                  builder: (context, state) {
                return const SizedBox();
              }, listener: (context, state) {
                if (state is DeleteMyCaseLoading) {
                  setState(() {
                    isLoading = true;
                  });
                }
                if (state is DeleteMyCaseLoaded) {
                  var deleteMyCaseList = state.deleteMyCaseModel;
                  if (deleteMyCaseList.result == 1) {
                    toast(msg: deleteMyCaseList.msg.toString());
                    var myCasesList = {
                      "pageNo": "1",
                      "watchlistId": "",
                      "filterByDecision": "",
                      "caseBySearch": "",
                      "downloadFile": "",
                    };
                    BlocProvider.of<MyCasesCubit>(context)
                        .fetchMyCases(myCasesList);
                    setState(() {
                      isLoading = false;
                    });
                  } else {
                    toast(msg: deleteMyCaseList.msg.toString());
                    setState(() {
                      isLoading = false;
                    });
                  }
                }
              }),
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
              BlocConsumer<UpdateManuallyCubit, UpdateManuallyState>(
                  builder: (context, state) {
                return const SizedBox();
              }, listener: (context, state) {
                if (state is UpdateManuallyLoading) {
                  setState(() {
                    isLoading = true;
                  });
                }
                if (state is UpdateManuallyLoaded) {
                  var showWatchList = state.addCommentModel;
                  if (showWatchList.result == 1) {
                    setState(() {
                      isLoading = false;
                    });
                    toast(msg: showWatchList.msg.toString());
                  } else {
                    setState(() {
                      isLoading = false;
                    });
                    toast(msg: showWatchList.msg.toString());
                  }
                  setState(() {
                    selectedList = [];
                  });
                }
                if (state is UpdateManuallyError) {
                  setState(() {
                    isLoading = false;
                  });
                }
              }),
            ],
          ),
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
        floatingActionButton: watchlistSelectedList.isNotEmpty
            ? SizedBox()
            : Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  isLoading || isSearch
                      ? SizedBox()
                      : dates.length > 1
                          ? InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (ctx) => CauseDateList(
                                        dates, dateSelectCallback));
                              },
                              child: Image.asset(
                                ImageConstant.scroll,
                                color: AppColor.primary,
                                height: 40,
                                width: 30,
                              ),
                            )
                          : SizedBox(),
                  FloatingActionButton(
                      // isExtended: true,
                      child: Icon(Icons.add),
                      backgroundColor: AppColor.primary,
                      onPressed: () {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddCaseMyCases()))
                            .then((value) {
                          // print("value $value");
                          if (value != null && value) {
                            var myCasesList = {
                              "pageNo": "1",
                              "watchlistId": "",
                              "filterByDecision": "",
                              "caseBySearch": "",
                              "downloadFile": "",
                            };
                            BlocProvider.of<MyCasesCubit>(context)
                                .fetchMyCases(myCasesList);
                          }
                        });
                      }),
                ],
              ));
  }

  Widget caseCard(context, element) {
    return Card(
      color: element.is_disposed == true
          ? AppColor.disposedColor
          : element.is_hide == 1
              ? AppColor.text_grey_color
              : element.interim.toString().toLowerCase() == "no stay"
                  ? AppColor.cases_nostay
                  : element.interim.toString().toLowerCase() == "interim stay"
                      ? AppColor.cases_intrimstay
                      : element.interim.toString().toLowerCase() == "full stay"
                          ? AppColor.cases_fullstay
                          : AppColor.white,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: InkWell(
        onTap: () {
          if (isPrime(pref) && (planName(pref) == Constants.silverPlan)) {
            FocusScope.of(context).requestFocus(FocusNode());
            showDialog(
                context: context,
                builder: (ctx) => SafeArea(
                      child: GoPrime(),
                    ));
            return;
          } else {
            if (selectedList.isEmpty) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CaseDetails(
                            caseId: element.caseId,
                            index: 2,
                            isReaded: element.isReaded == 1,
                          ))).then((value) {
                var myCasesList = {
                  "pageNo": "1",
                  "watchlistId": "",
                  "filterByDecision": "",
                  "caseBySearch": "",
                  "downloadFile": "",
                };
                BlocProvider.of<MyCasesCubit>(context)
                    .fetchMyCases(myCasesList);
              });
            }
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 26,
                height: 26,
                child: Checkbox(
                  checkColor: element.is_disposed == true
                      ? AppColor.primary
                      : AppColor.white,
                  // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  /*    fillColor: MaterialStateColor.resolveWith((states) =>
                      element.is_disposed == true
                          ? Colors.white
                          : AppColor.primary),*/
                  activeColor: AppColor.primary,
                  value: selectedList.contains(element.caseId),
                  onChanged: (value) {
                    setState(() {
                      isSelectionChange = true;
                      if (value!) {
                        selectedList.add(element.caseId!);
                        caseNumberList.add(element.caseName!);
                      } else {
                        selectedList.remove(element.caseId!);
                        caseNumberList.remove(element.caseName!);
                      }
                      // valuefirst =
                      // element.caseId!;
                    });
                  },
                ),
              ),
              SizedBox(
                width: element.isReaded == 0 ? 5 : 0,
              ),
              element.isReaded == 1
                  ? Icon(Icons.brightness_1,
                      color: AppColor.rejected_color_text, size: 7)
                  : SizedBox(),
              SizedBox(
                width: 7,
              ),
              Expanded(
                // width: mediaQW(context) * 0.55,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                          text: "Case Number: ",
                          style: mpHeadLine14(
                            textColor: element.is_disposed == true
                                ? Colors.white
                                : AppColor.bold_text_color_dark_blue,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: element.caseName.toString(),
                              style: mpHeadLine14(
                                textColor: element.is_disposed == true
                                    ? Colors.white
                                    : AppColor.bold_text_color_dark_blue,
                              ),
                            ),
                          ]),
                    ),
                    SizedBox(
                      height: element.caseTitle != null ? 5 : 0,
                    ),
                    element.caseTitle != null
                        ? RichText(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                                text: "Case Title: ",
                                style: mpHeadLine14(
                                  textColor: element.is_disposed == true
                                      ? Colors.white
                                      : AppColor.bold_text_color_dark_blue,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: element.caseTitle.toString(),
                                    style: mpHeadLine14(
                                      textColor: element.is_disposed == true
                                          ? Colors.white
                                          : AppColor.bold_text_color_dark_blue,
                                    ),
                                  ),
                                ]),
                          )
                        : SizedBox(),
                    SizedBox(
                      height: element.stage != null && element.stage!.isNotEmpty
                          ? 3
                          : 0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        element.subCategory != null
                            ? Container(
                                margin: EdgeInsets.only(top: 5),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 2),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    color: AppColor.primary),
                                child: Text(element.subCategory.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontFamily: "Roboto",
                                      fontSize: 10,
                                    )),
                              )
                            : SizedBox(),
                        SizedBox(
                          width: 2,
                        ),
                        element.lastCauselistDate != null
                            ? Container(
                                margin: EdgeInsets.only(top: 5),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 3, vertical: 2),
                                child: RichText(
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                      text: "Last Listing Date: ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: element.is_disposed == true
                                            ? Colors.white
                                            : AppColor
                                                .bold_text_color_dark_blue,
                                        fontFamily: "Roboto",
                                        fontSize: 10,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: getEEEddMMMyyyy(element
                                                .lastCauselistDate
                                                .toString()),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: element.is_disposed == true
                                                  ? Colors.white
                                                  : AppColor
                                                      .bold_text_color_dark_blue,
                                              fontFamily: "Roboto",
                                              fontSize: 9,
                                            )),
                                      ]),
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                    SizedBox(
                      height: element.stage != null && element.stage!.isNotEmpty
                          ? 3
                          : 0,
                    ),
                    element.stage != null && element.stage!.isNotEmpty
                        ? RichText(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                                text: "Stage @ last listing: ",
                                style: mpHeadLine12(
                                  fontWeight: FontWeight.w600,
                                  textColor: element.is_disposed == true
                                      ? Colors.white
                                      : AppColor.bold_text_color_dark_blue,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "${element.stage!}",
                                    style: TextStyle(
                                      color: element.is_disposed == true
                                          ? Colors.white
                                          : AppColor.bold_text_color_dark_blue,
                                      fontFamily: "Roboto",
                                      fontSize: 10,
                                    ),
                                  ),
                                ]),
                          )
                        : SizedBox(),
                    /*Text(
                            "Stage: ${element.stage!}",
                            style: appTextStyle(
                                textColor: AppColor.bold_text_color_dark_blue,
                                fontSize: 11),
                          )
                        : SizedBox(),*/
                    SizedBox(
                      height: 2,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  pref.getString(Constants.USER_TYPE) != "2"
                      ? InkWell(
                          onTap: () {
                            print("case id ${element.caseId.toString()}");
                            if (isPrime(pref) &&
                                (planName(pref) == Constants.silverPlan)) {
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
                                    // insetPadding: EdgeInsets.symmetric(vertical: 305),
                                    contentPadding: EdgeInsets.zero,
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Text(
                                            "Are you sure to delete ${element.caseName.toString()}?",
                                            textAlign: TextAlign.center,
                                            style: mpHeadLine14(
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            // BlocConsumer<
                                            //     DeleteMyCaseCubit,
                                            //     DeleteMyCaseState>(builder: (context, state) {
                                            //   return const SizedBox();
                                            // }, listener:
                                            //     (context,
                                            //         state) {
                                            //   if (state
                                            //       is DeleteMyCaseLoaded) {
                                            //     var deleteMyCaseList =
                                            //         state.deleteMyCaseModel;
                                            //     if (deleteMyCaseList.result ==
                                            //         1) {
                                            //       toast(msg: deleteMyCaseList.msg.toString());
                                            //       Navigator.pop(context);
                                            //     }
                                            //   }
                                            // }),
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  var deleteMyCase = {
                                                    "caseId": element.caseId
                                                        .toString(),
                                                  };
                                                  BlocProvider.of<
                                                              DeleteMyCaseCubit>(
                                                          context)
                                                      .fetchDeleteMyCase(
                                                          deleteMyCase);
                                                  Navigator.pop(context);
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
                                                                  .circular(5)),
                                                      border: Border.all(
                                                          color: AppColor
                                                              .primary)),
                                                  child: Text(
                                                    "YES",
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
                                  );
                                });
                          },
                          child: Icon(
                            Icons.delete,
                            color: Colors.red[800],
                            size: 22,
                          ),
                        )
                      : SizedBox(),
                  const SizedBox(
                    width: 4,
                  ),
                  InkWell(
                    onTap: () {
                      if (isPrime(pref) &&
                          (planName(pref) == Constants.silverPlan)) {
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
                                    isReaded: element.isReaded == 1,
                                  ))).then((value) {
                        var myCasesList = {
                          "pageNo": "1",
                          "watchlistId": "",
                          "filterByDecision": "",
                          "caseBySearch": "",
                          "downloadFile": "",
                        };
                        BlocProvider.of<MyCasesCubit>(context)
                            .fetchMyCases(myCasesList);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 20,
                        color: element.is_disposed == true
                            ? AppColor.white
                            : AppColor.hint_color_grey,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 0,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void searchFilterList(String searchKey) {
    setState(() {
      searchList = [];
    });

    if (watchlistSelectedList.isNotEmpty) {
      for (var item in watchlistSelectedList!) {
        if (item.caseName != null &&
                item.caseName!.toLowerCase().contains(searchKey) ||
            item.caseTitle != null &&
                item.caseTitle!.toLowerCase().contains(searchKey) ||
            item.itmo != null && item.itmo!.toLowerCase().contains(searchKey) ||
            item.subCategory != null &&
                item.subCategory!.toLowerCase().contains(searchKey)) {
          if (!searchList.contains(item)) {
            searchList.add(item);
          }
        }
      }
    }

    for (var item in newList!) {
      if (item.caseName != null &&
              item.caseName!.toLowerCase().contains(searchKey) ||
          item.caseTitle != null &&
              item.caseTitle!.toLowerCase().contains(searchKey) ||
          item.itmo != null && item.itmo!.toLowerCase().contains(searchKey) ||
          item.subCategory != null &&
              item.subCategory!.toLowerCase().contains(searchKey)) {
        if (!searchList.contains(item)) {
          searchList.add(item);
        }
      }
    }

    // print("searchlist length ${searchList.length}");
    isSearchFilter = true;
    setState(() {});
  }

  void dateSelectCallback(String date) {
    int index = newList.indexWhere((element) => date == element.date);
    itemScrollController.scrollTo(
      index: index,
      curve: Curves.easeInOutCubic,
      alignment: 0,
      duration: const Duration(milliseconds: 100),
    );
  }

  downloadData(String file, fileName) async {
    await downloadFiles(file, fileName);
  }

  void filterList(String filterType) {
    print("filter by $filterType");

    setState(() {
      searchList = [];
      isSearchFilter = false;
      selectedFilter = "";
      isSearchLoading = true;
      itemScrollController = GroupedItemScrollController();
    });
    print("filter by searchList $searchList");

    if (filterType.isNotEmpty) {
      for (int i = 0; i < newList.length; i++) {
        print("officeStage ==> ${newList[i].officeStage}");
        if (newList[i].officeStage != null &&
            newList[i]
                .officeStage!
                .toString()
                .toLowerCase()
                .contains(filterType.toLowerCase())) {
          searchList.add(newList[i]);
        }
      }
      selectedFilter = filterType;
      isSearchFilter = true;
    } else {
      searchList = [];
      isSearchFilter = false;
      selectedFilter = "";
    }
    Future.delayed(Duration(milliseconds: 100), () {
      isSearchLoading = false;
      setState(() {});
    });
  }

/*  Widget buildPopupMenuButton() {
    return PopupMenuButton(
      padding: const EdgeInsets.only(top: 0, bottom: 0, right: 8),
      icon: const Icon(
        Icons.more_vert_outlined,
        size: 25,
        color: AppColor.black,
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Text("Court Date Report"),
        ),
        PopupMenuItem(
          value: 2,
          child: Text("Pending Order Report"),
        ),
      ],
      onSelected: (i) async {
        if (i == 1) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CourtDateReportScreen()));
        } else if (i == 2) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PendingCmtHistory()));
        }
      },
    );
  }*/

  Future<void> onWatchListPressShown() async {
    print("selectedList $selectedList");
    FocusScope.of(context).requestFocus(FocusNode());
    if (watchlistSelectedList.isNotEmpty) {
      showDialog(
          context: context,
          builder: (ctx) => AddToWatchList(
                selectedList,
                "0",
                isUpdate: true,
                updateData: widget.selectedData,
              ));
    } else {
      if (displayWatchList != null && displayWatchList!.isNotEmpty) {
        showDialog(
            context: context,
            builder: (ctx) => LawyerWatchList(
                  displayWatchList,
                  selectedList,
                  "0",
                  btnCallback: callApiCase,
                ));
      } else {
        showDialog(
            context: context,
            builder: (ctx) => AddToWatchList(selectedList, "0"));
        // show_add_watchlist dialog
      }
    }
  }

  Future<void> callApiCase() async {
    var myCasesList = {
      "pageNo": "1",
      "watchlistId": "",
      "filterByDecision": "",
      "caseBySearch": "",
      "downloadFile": "",
    };
    BlocProvider.of<MyCasesCubit>(context).fetchMyCases(myCasesList);
  }

  Future<void> onUpdateManullyClick() async {
    print("caseNumberList  $caseNumberList");
    String stringList = caseNumberList.join(",");
    var body = {"case_no": stringList};
    print("caseNumberList  body $body");
    BlocProvider.of<UpdateManuallyCubit>(context).fetchUpdateManually(body);
  }
}
