import 'dart:core';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/constants.dart';
import 'package:haelo_flutter/core/utils/functions.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/cases/cubit/deletemycases_cubit.dart';
import 'package:haelo_flutter/features/cases/cubit/mycases_cubit.dart';
import 'package:haelo_flutter/features/cases/cubit/mycases_state.dart';
import 'package:haelo_flutter/features/cases/presentation/screens/casedetails.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/color_node.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/no_data_widget.dart';
import 'package:haelo_flutter/features/court_date_report/cubit/court_date_report_cubit.dart';
import 'package:haelo_flutter/features/court_date_report/cubit/court_date_report_state.dart';
import 'package:haelo_flutter/widgets/progress_indicator.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:haelo_flutter/locators.dart' as di;

class CourtDateReportScreen extends StatefulWidget {
  CourtDateReportScreen({Key? key}) : super(key: key);
  @override
  State<CourtDateReportScreen> createState() => _MyCasesState();
}

class _MyCasesState extends State<CourtDateReportScreen> {
  bool isLoading = true;
  bool isAlreadyLoadedData = false;
  String selectedFilter = "";
  late SharedPreferences pref;

  bool? isCheck = false;
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
    BlocProvider.of<CourtDateReportCubit>(context)
        .fetchCourtDateReport(myCasesList);
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
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new_sharp,
            size: 24,
          ),
        ),
        title: Row(
          children: [
            isSearch
                ? SizedBox()
                : Expanded(
                    child: Text(
                      "Court Date Report",
                      style: mpHeadLine18(
                          fontWeight: FontWeight.w500,
                          textColor: AppColor.bold_text_color_dark_blue),
                    ),
                  ),
            !isSearch
                ? Container(
                    margin: const EdgeInsets.only(right: 0, left: 5),
                    child: InkWell(
                        onTap: () => setState(() {
                              isSearch = true;
                              FocusScope.of(context).requestFocus(FocusNode());
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
            isSearch
                ? SizedBox()
                : GestureDetector(
                    onTap: () {
                      goToHomePage(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(right: 15, left: 15),
                      child: Icon(
                        Icons.home_outlined,
                        size: 30,
                      ),
                    ),
                  )
          ],
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            newList.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
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
                                    BlocProvider.of<CourtDateReportCubit>(
                                            context)
                                        .fetchCourtDateReport(myCasesList);
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Scrollbar(
                                          trackVisibility: true,
                                          thumbVisibility: true,
                                          // controller: itemScrollController
                                          //     .scrollController,
                                          interactive: true,
                                          thickness: 5,
                                          child: StickyGroupedListView<dynamic,
                                              String>(
                                            elements: newList,
                                            shrinkWrap: true,
                                            groupBy: (dynamic element) =>
                                                element.date.toString(),
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
                                            groupComparator:
                                                (dynamic e1, dynamic e2) {
                                              if (e1 != null &&
                                                  e2 != null &&
                                                  e1 != "Not Available" &&
                                                  e2 != "Not Available") {
                                                DateTime _dateTime =
                                                    DateFormat("dd/MM/yyyy")
                                                        .parse(e1);
                                                DateTime _dateTime1 =
                                                    DateFormat("dd/MM/yyyy")
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
                                            itemBuilder:
                                                (context, dynamic element) =>
                                                    caseCard(context, element),
                                            // itemComparator: (e1, e2) => e1.compareTo(e2['name']), // optional
                                            // elementIdentifier: (element) => element.name // optional - see below for usage
                                            itemScrollController:
                                                itemScrollController,
                                            // optional
                                            order: StickyGroupedListOrder
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
                                      //         var currentIndex = (newList.length/pred.metrics.maxScrollExtent) * pred.metrics.pixels;
                                      //         if (currentIndex.isNaN || currentIndex.isInfinite){
                                      //           currentIndex=0;
                                      //         }
                                      //         itemScrollController.scrollTo(
                                      //           index: currentIndex.round(),
                                      //           curve: Curves.easeInOutCubic,
                                      //           alignment: 0,
                                      //           duration: const Duration(milliseconds: 100),
                                      //         );
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
                              : searchList.isNotEmpty
                                  ? StickyGroupedListView<dynamic, String>(
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
                                              DateFormat("dd/MM/yyyy")
                                                  .parse(e1);
                                          DateTime _dateTime1 =
                                              DateFormat("dd/MM/yyyy")
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
                                      groupSeparatorBuilder: (value) => Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, bottom: 10, left: 0),
                                        child: Text("Date: ${value.date}",
                                            style: mpHeadLine16(
                                                fontWeight: FontWeight.w600),
                                            textAlign: TextAlign.center),
                                      ),
                                      itemBuilder: (context, dynamic element) =>
                                          caseCard(context, element),
                                      shrinkWrap: true,
                                      order: StickyGroupedListOrder.ASC,
                                    )
                                  : NoDataAvailable("Search data not found.")),
                    ],
                  )
                : isLoading
                    ? SizedBox()
                    : NoDataAvailable("Your Case will be shown here."),
            Visibility(
              visible: isLoading,
              child: const Center(child: AppProgressIndicator()),
            ),
            BlocConsumer<CourtDateReportCubit, CourtDateReportState>(
              builder: (context, state) {
                return const SizedBox();
              },
              listener: (context, state) {
                if (state is CourtDateReportLoading) {
                  setState(() {
                    isLoading = true;
                  });
                }
                if (state is CourtDateReportLoaded) {
                  var myCasesModelList = state.model;
                  if (myCasesModelList.result == 1) {
                    setState(() {
                      isLoading = false;
                      if (myCasesModelList.data != null &&
                          myCasesModelList.data!.isNotEmpty) {
                        print("ok");
                        isAlreadyLoadedData = true;

                        newList = [];

                        newList =
                            myCasesModelList.data!.map((user) => user).toList()
                              ..sort((a, b) {
                                //print("first date ${a.date} second ${b.date}");
                                if (a.date != null &&
                                    b.date != null &&
                                    a.date != "Not Available" &&
                                    b.date != "Not Available") {
                                  DateTime _dateTime =
                                      DateFormat("dd/MM/yyyy").parse(a.date!);
                                  DateTime _dateTime1 =
                                      DateFormat("dd/MM/yyyy").parse(b.date!);
                                  // _dateTime = DateTime.(_dateTime);
                                  //  print(_dateTime);
                                  return _dateTime!.compareTo(_dateTime1);
                                } else {
                                  return a.date!.compareTo(b.date!);
                                }
                              });
                        print("newListlength ${newList.length}");

                        Future.delayed(Duration(seconds: 2), () {
                          setState(() {
                            if (!isDrag) isDrag = true;
                          });
                        });
                      }
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
    );
  }

  Widget caseCard(context, element) {
    return Card(
      color: element.isDisposed == true
          ? AppColor.disposedColor
          : element.isHide == 1
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
            BlocProvider.of<CourtDateReportCubit>(context)
                .fetchCourtDateReport(myCasesList);
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
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
                            textColor: element.isDisposed == true
                                ? Colors.white
                                : AppColor.bold_text_color_dark_blue,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: element.caseName.toString(),
                              style: mpHeadLine14(
                                textColor: element.isDisposed == true
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
                                  textColor: element.isDisposed == true
                                      ? Colors.white
                                      : AppColor.bold_text_color_dark_blue,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: element.caseTitle.toString(),
                                    style: mpHeadLine14(
                                      textColor: element.isDisposed == true
                                          ? Colors.white
                                          : AppColor.bold_text_color_dark_blue,
                                    ),
                                  ),
                                ]),
                          )
                        : SizedBox(),
                    element.subCategory != null
                        ? Container(
                            margin: EdgeInsets.only(top: 5),
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: AppColor.primary),
                            child: Text(element.subCategory.toString(),
                                style: appTextStyle(
                                    textColor: AppColor.white, fontSize: 11)),
                          )
                        : SizedBox()
                  ],
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
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
                        BlocProvider.of<CourtDateReportCubit>(context)
                            .fetchCourtDateReport(myCasesList);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 20,
                        color: element.isDisposed == true
                            ? AppColor.white
                            : AppColor.hint_color_grey,
                      ),
                    ),
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
}
