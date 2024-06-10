// import 'package:dotted_border/dotted_border.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:haelo_flutter/constants.dart';
// import 'package:haelo_flutter/core/utils/functions.dart';
// import 'package:haelo_flutter/core/utils/hightlight_text.dart';
// import 'package:haelo_flutter/core/utils/save_file.dart';
// import 'package:haelo_flutter/core/utils/ui_helper.dart';
// import 'package:haelo_flutter/features/bottom_bar/presentation/screens/bottombar.dart';
// import 'package:haelo_flutter/features/cases/presentation/screens/casedetails.dart';
// import 'package:haelo_flutter/features/cases/presentation/widgets/color_node.dart';
// import 'package:haelo_flutter/features/cases/presentation/widgets/no_data_widget.dart';
// import 'package:haelo_flutter/features/causeslist/cubit/hidecauselist_cubit.dart';
// import 'package:haelo_flutter/features/causeslist/cubit/hidecauselist_state.dart';
// import 'package:haelo_flutter/features/causeslist/cubit/viewcauselist_cubit.dart';
// import 'package:haelo_flutter/features/causeslist/cubit/viewcauselist_state.dart';
// import 'package:haelo_flutter/features/causeslist/data/model/date_court_model.dart';
// import 'package:haelo_flutter/features/causeslist/data/model/viewcauselist_model.dart';
// import 'package:haelo_flutter/features/causeslist/presentation/screen/causelist_screen.dart';
// import 'package:haelo_flutter/features/causeslist/presentation/widget/causelist_heading%20name.dart';
// import 'package:haelo_flutter/features/causeslist/presentation/widget/court_list_dialog.dart';
// import 'package:haelo_flutter/features/causeslist/presentation/widget/customizetextfield.dart';
// import 'package:haelo_flutter/features/causeslist/presentation/widget/datelist_courtno_dialog.dart';
// import 'package:haelo_flutter/features/causeslist/presentation/widget/datelist_dialog.dart';
// import 'package:haelo_flutter/features/causeslist/presentation/widget/download_causlist.dart';
// import 'package:haelo_flutter/features/causeslist/presentation/widget/order_cmt_info_widget.dart';
// import 'package:haelo_flutter/features/home_page/presentation/widgets/case_info.dart';
// import 'package:haelo_flutter/features/order_comment_history/data/model/WatchlistDataType.dart';
// import 'package:haelo_flutter/widgets/customExpansionTile.dart';
// import 'package:haelo_flutter/widgets/date_format.dart';
// import 'package:haelo_flutter/widgets/date_widget.dart';
// import 'package:haelo_flutter/widgets/go_prime.dart';
// import 'package:haelo_flutter/widgets/progress_indicator.dart';
// import 'package:inview_notifier_list/inview_notifier_list.dart';
// import 'package:scroll_to_index/scroll_to_index.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:haelo_flutter/locators.dart' as di;
// import 'addcase_causelist.dart';
// import 'causelist_page.dart';
//
// /// first class
// class ViewCauseListScreen extends StatelessWidget {
//   final mainCauseListdata;
//   bool isFromHomepage;
//   bool isScrollToSno;
//   bool isDownloadOption;
//   bool isGotoCourt;
//   bool isFilter;
//   bool isQuickSearch;
//   String quickScrollDate;
//
//   ViewCauseListScreen(
//       {Key? key,
//         this.mainCauseListdata,
//         this.isFromHomepage = false,
//         this.isScrollToSno = false,
//         this.isDownloadOption = false,
//         this.isGotoCourt = false,
//         this.isFilter = true,
//         this.isQuickSearch = false,
//         this.quickScrollDate = ""})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<ViewCauseListCubit>(
//             create: (BuildContext context) => ViewCauseListCubit(di.locator())),
//       ],
//       child: Builder(builder: (context) {
//         print("google ${isQuickSearch}");
//         return ViewCauseListSecond(
//           mainCauseListdata: mainCauseListdata,
//           isFromHomepage: isFromHomepage,
//           isScrollToSno: isScrollToSno,
//           isDownloadOption: isDownloadOption,
//           isGotoCourt: isGotoCourt,
//           isFilter: isFilter,
//           isQuickSearch: isQuickSearch,
//           quickScrollDate: quickScrollDate,
//           ctx: context,
//         );
//       }),
//     );
//   }
// }
//
// /// second class
// class ViewCauseListSecond extends StatefulWidget {
//   final mainCauseListdata;
//   bool isFromHomepage;
//   bool isScrollToSno;
//   bool isDownloadOption;
//   bool isGotoCourt;
//   bool isFilter;
//   bool isQuickSearch;
//   String quickScrollDate;
//   BuildContext? ctx;
//
//   // Function? state;
//
//   ViewCauseListSecond({
//     Key? key,
//     this.mainCauseListdata,
//     this.isFromHomepage = false,
//     this.isScrollToSno = false,
//     this.isDownloadOption = false,
//     this.isGotoCourt = false,
//     this.isFilter = true,
//     this.isQuickSearch = false,
//     this.quickScrollDate = "",
//     this.ctx,
//     // this.state
//   }) : super(key: key);
//
//   @override
//   State<ViewCauseListSecond> createState() => _ViewCauseListSecondState();
// }
//
// class _ViewCauseListSecondState extends State<ViewCauseListSecond> {
//   @override
//   Widget build(BuildContext context) {
//     return ViewCauseListMain(
//       mainCauseListdata: widget.mainCauseListdata,
//       isFromHomepage: widget.isFromHomepage,
//       isScrollToSno: widget.isScrollToSno,
//       isDownloadOption: widget.isDownloadOption,
//       isGotoCourt: widget.isGotoCourt,
//       isFilter: widget.isFilter,
//       isQuickSearch: widget.isQuickSearch,
//       quickScrollDate: widget.quickScrollDate,
//       ctx: widget.ctx,
//     );
//   }
// }
//
// /// third class
// class ViewCauseListMain extends StatefulWidget {
//   final mainCauseListdata;
//   bool isFromHomepage;
//   bool isScrollToSno;
//   bool isDownloadOption;
//   bool isGotoCourt;
//   bool isFilter;
//   bool isQuickSearch;
//   String quickScrollDate;
//   BuildContext? ctx;
//
//   // var state;
//
//   ViewCauseListMain({
//     Key? key,
//     this.mainCauseListdata,
//     this.isFromHomepage = false,
//     this.isScrollToSno = false,
//     this.isDownloadOption = false,
//     this.isGotoCourt = false,
//     this.isFilter = true,
//     this.isQuickSearch = false,
//     this.quickScrollDate = "",
//     this.ctx,
//   }) : super(key: key);
//
//   @override
//   State<ViewCauseListMain> createState() => _ViewCauseListState();
// }
//
// class _ViewCauseListState extends State<ViewCauseListMain> {
//   int dateIndex = 0;
//
//   //both list used for filter only
//   List courtNumList = [];
//   List dates = [];
//   List<DatesCourtModel> newDatesCourt = [];
//   var caseId;
//
//   Data? viewCauseListData;
//
//   DateTime dateFrom = DateTime.now();
//
//   DateTime? dateTo;
//   bool isLoading = true;
//   bool isNodata = true;
//
//   //for search only
//   bool isSearch = false;
//   bool isSearchFilter = false;
//   TextEditingController search_textController = TextEditingController();
//   List<Causelist> searchList = [];
//   bool isToDateSelected = false;
//   List newList = [];
//
//   //new work
//
//   bool isSnoScroll = false;
//   bool isQuickSearchScroll = false;
//   bool isDrag = false;
//   late SharedPreferences pref;
//   int recursiveDateCall = 0;
//
//   int _firstVisibleIndex = 0;
//   int _searchFirstVisibleIndex = 0;
//   final AutoScrollController _outerScrollController = AutoScrollController();
//   bool isPartialLoading=false;
//   final ScrollController _horizontalDateController = ScrollController();
//
//   @override
//   void initState() {
//     pref = di.locator();
//     isSnoScroll = false;
//     isQuickSearchScroll = false;
//     Map<String, String> body = {};
//     if (!widget.isFromHomepage) {
//       body = {
//         "dateFrom": widget.mainCauseListdata["dateFrom"] != null
//             ? widget.mainCauseListdata["dateFrom"].toString()
//             : "",
//         "dateTo": widget.mainCauseListdata["dateTo"] != null
//             ? widget.mainCauseListdata["dateTo"].toString()
//             : "",
//         "lawyerName": widget.mainCauseListdata["lawyerName"] != null
//             ? widget.mainCauseListdata["lawyerName"].toString()
//             : "",
//         "courtNo": widget.mainCauseListdata["courtNo"] != null
//             ? widget.mainCauseListdata["courtNo"].toString()
//             : "",
//         "sNo": "",
//         "caseNo": widget.mainCauseListdata["caseNo"] != null
//             ? widget.mainCauseListdata["caseNo"].toString()
//             : "",
//         "benchName": widget.mainCauseListdata["judgeName"] != null
//             ? widget.mainCauseListdata["judgeName"].toString()
//             : "",
//         "causeListType": widget.mainCauseListdata["causeListType"] != null
//             ? widget.mainCauseListdata["causeListType"].toString()
//             : "",
//         "partyName": widget.mainCauseListdata["partyName"] != null
//             ? widget.mainCauseListdata["partyName"].toString()
//             : "",
//         "judgeTime": widget.mainCauseListdata["judgeTime"] != null
//             ? widget.mainCauseListdata["judgeTime"].toString()
//             : "",
//         "caveatName": widget.mainCauseListdata["caveatName"] != null
//             ? widget.mainCauseListdata["caveatName"].toString()
//             : "",
//       };
//     } else {
//       body = {
//         "dateFrom": widget.mainCauseListdata["dateFrom"].toString(),
//         "pageNo": "1",
//       };
//       if (widget.mainCauseListdata["lawyerName"] != null) {
//         body["lawyerName"] = widget.mainCauseListdata["lawyerName"].toString();
//       }
//       if (widget.mainCauseListdata["dateTo"] != null) {
//         body["dateTo"] = widget.mainCauseListdata["dateTo"].toString();
//       }
//       if (widget.mainCauseListdata["courtNo"] != null) {
//         body["courtNo"] = widget.mainCauseListdata["courtNo"].toString();
//       }
//       if (widget.mainCauseListdata["caseNo"] != null) {
//         body["caseNo"] = widget.mainCauseListdata["caseNo"].toString();
//       }
//       if (widget.mainCauseListdata["judgeName"] != null) {
//         body["benchName"] = widget.mainCauseListdata["judgeName"].toString();
//       }
//       if (widget.mainCauseListdata["caveatName"] != null) {
//         body["caveatName"] = widget.mainCauseListdata["caveatName"].toString();
//       }
//       if (widget.mainCauseListdata["partyName"] != null) {
//         body["partyName"] = widget.mainCauseListdata["partyName"].toString();
//       }
//       if (widget.mainCauseListdata["judgeTime"] != null) {
//         body["judgeTime"] = widget.mainCauseListdata["judgeTime"].toString();
//       }
//       if (widget.mainCauseListdata["causeListType"] != null) {
//         body["causeListType"] =
//             widget.mainCauseListdata["causeListType"].toString();
//       }
//       // if (widget.mainCauseListdata["sNo"] != null) {
//       //   body["sNo"] = widget.mainCauseListdata["sNo"].toString();
//       // }
//     }
//
//     dateFrom =
//         DateFormat("dd/MM/yyyy").parse(widget.mainCauseListdata["dateFrom"]);
//     if (widget.mainCauseListdata["dateTo"] != null &&
//         widget.mainCauseListdata["dateTo"].isNotEmpty) {
//       dateTo =
//           DateFormat("dd/MM/yyyy").parse(widget.mainCauseListdata["dateTo"]);
//     }
//
//     // print("init viewcause ${widget.isQuickSearch}");
//     BlocProvider.of<ViewCauseListCubit>(context)
//         .fetchViewCauseList(body, isQuickSearch: widget.isQuickSearch);
//     // scrollListener();
//     super.initState();
//   }
//
//   void setSelectedDate(dateSelected, isFrom) {
//     setState(() {
//       if (isFrom) {
//         dateFrom = dateSelected;
//       } else {
//         dateTo = dateSelected;
//       }
//     });
//   }
//
//   void todateClear(state) {
//     state(() {
//       dateTo = null;
//       isToDateSelected = false;
//     });
//   }
//
//   void _goToElement(int index) {
//     print("horizontalIndex $index");
//     _horizontalDateController.animateTo((100.0 * index),
//         // 100 is the height of container and index of 6th element is 5
//         duration: const Duration(milliseconds: 1000),
//         curve: Curves.easeOut);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     IsInViewPortCondition condition =
//         (double deltaTop, double deltaBottom, double vpHeight) {
//       return (deltaTop < 200.0 &&
//           deltaBottom > (0.5 * vpHeight) - 115.0);
//     };
//     return Scaffold(
//         backgroundColor: AppColor.home_background,
//         appBar: AppBar(
//           leading: isSearch
//               ? SizedBox()
//               : GestureDetector(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: const Icon(
//               Icons.arrow_back_ios_new_sharp,
//               size: 24,
//             ),
//           ),
//           backgroundColor: AppColor.white,
//           titleSpacing: -5,
//           title: Text(
//             "Cause List",
//             style: mpHeadLine16(
//                 fontWeight: FontWeight.w500,
//                 textColor: AppColor.bold_text_color_dark_blue),
//           ),
//           actions: [
//             isSearch
//                 ? SizedBox()
//                 : InkWell(
//               onTap: () {
//                 // print("isPrime(pref) ${isPrime(pref)}");
//                 // if (!isPrime(pref)) {
//                 //   FocusScope.of(context).requestFocus(FocusNode());
//                 //   showDialog(
//                 //       context: context,
//                 //       builder: (ctx) => SafeArea(
//                 //         child: GoPrime(),
//                 //       ));
//                 //   return;
//                 // }
//                 showDialog(
//                     context: context,
//                     builder: (ctx) {
//                       return AlertDialog(
//                         insetPadding:
//                         const EdgeInsets.symmetric(horizontal: 15),
//                         contentPadding: EdgeInsets.zero,
//                         content: StatefulBuilder(
//                           builder: (BuildContext context,
//                               void Function(void Function()) setState) {
//                             return SizedBox(
//                               // height: mediaQH(context) * 0.269,
//                               // width: mediaQW(context) * 0.98,
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Padding(
//                                     padding:
//                                     const EdgeInsets.only(top: 7),
//                                     child: Text(
//                                       "Select Date",
//                                       style: mpHeadLine12(
//                                           fontWeight: FontWeight.w500),
//                                     ),
//                                   ),
//                                   const Divider(
//                                     thickness: 1,
//                                     color: AppColor.grey_color,
//                                   ),
//                                   const SizedBox(
//                                     height: 20,
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 10),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                       crossAxisAlignment:
//                                       CrossAxisAlignment.start,
//                                       children: [
//                                         Column(
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                           children: [
//                                             const CauseListHeadingName(
//                                                 headingText: "From Date"),
//                                             const SizedBox(
//                                               height: 5,
//                                             ),
//                                             InkWell(
//                                               onTap: () {
//                                                 FocusScope.of(context)
//                                                     .requestFocus(
//                                                     FocusNode());
//                                                 DateTime fromDt = DateFormat(
//                                                     "dd/MM/yyyy")
//                                                     .parse(widget
//                                                     .mainCauseListdata[
//                                                 "dateFrom"]);
//                                                 print("fromDt $fromDt");
//
//                                                 AppDatePicker()
//                                                     .pickDate(
//                                                     context,
//                                                     fromDt,
//                                                     DateTime(2000),
//                                                     DateTime(2100))
//                                                     .then((value) {
//                                                   if (value != null) {
//                                                     setState(() {
//                                                       dateFrom = value;
//                                                       dateTo = null;
//                                                       isToDateSelected =
//                                                       false;
//                                                     });
//                                                   }
//                                                 });
//                                               },
//                                               child: CustomContainer(
//                                                 displayData:
//                                                 "${dateFrom.day}/${dateFrom.month}/${dateFrom.year}",
//                                                 width: mediaQW(context) *
//                                                     0.4,
//                                                 isDropDown: false,
//                                               ),
//                                             ),
//                                             // CauseListCalendar(
//                                             //   selectedDate: _seletedDate,
//                                             //   currentDate: dateFrom,
//                                             //   setDate: setSelectedDate,
//                                             //   smallWidth: true,
//                                             // ),
//                                           ],
//                                         ),
//                                         const SizedBox(
//                                           width: 10,
//                                         ),
//                                         Column(
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                           mainAxisAlignment:
//                                           MainAxisAlignment
//                                               .spaceBetween,
//                                           children: [
//                                             const CauseListHeadingName(
//                                                 headingText: "To Date"),
//                                             const SizedBox(
//                                               height: 5,
//                                             ),
//
//                                             InkWell(
//                                               onTap: () {
//                                                 FocusScope.of(context)
//                                                     .requestFocus(
//                                                     FocusNode());
//                                                 AppDatePicker()
//                                                     .pickDate(
//                                                     context,
//                                                     dateFrom,
//                                                     dateFrom,
//                                                     dateFrom.add(
//                                                         Duration(
//                                                             days:
//                                                             90)))
//                                                     .then((value) {
//                                                   if (value != null) {
//                                                     setState(() {
//                                                       dateTo = value;
//                                                       widget.mainCauseListdata[
//                                                       "dateTo"] =
//                                                           getDDMMYYYY(dateTo
//                                                               .toString());
//                                                       isToDateSelected =
//                                                       true;
//                                                     });
//                                                   }
//                                                 });
//                                               },
//                                               child: CustomContainer(
//                                                 displayData: dateTo !=
//                                                     null
//                                                     ? "${dateTo!.day}/${dateTo!.month}/${dateTo!.year}"
//                                                     : "DD/MM/YYYY",
//                                                 width: mediaQW(context) *
//                                                     0.4,
//                                                 isDropDown: false,
//                                                 isClose: dateTo != null
//                                                     ? true
//                                                     : false,
//                                                 closeIconCallback:
//                                                 todateClear,
//                                                 closeState: setState,
//                                               ),
//                                             ),
//                                             // CauseListCalendar(
//                                             //   selectedDate:
//                                             //       _selectedToDate,
//                                             //   currentDate: dateTo,
//                                             //   setDate: setSelectedDate,
//                                             //   isToDate: true,
//                                             //   smallWidth: true,
//                                             //   fromDateForDisable:
//                                             //       dateFrom,
//                                             // ),
//                                           ],
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     height: 20,
//                                   ),
//                                   Row(
//                                     children: [
//                                       Expanded(
//                                         child: InkWell(
//                                           onTap: () {
//                                             Navigator.pop(context);
//                                           },
//                                           child: Container(
//                                             alignment: Alignment.center,
//                                             height:
//                                             mediaQH(context) * 0.05,
//                                             decoration: BoxDecoration(
//                                               border: Border.all(
//                                                   color:
//                                                   AppColor.primary),
//                                               borderRadius:
//                                               const BorderRadius.only(
//                                                   bottomLeft:
//                                                   Radius.circular(
//                                                       5)),
//                                             ),
//                                             child: Text(
//                                               "Cancel",
//                                               style: mpHeadLine16(
//                                                   textColor:
//                                                   AppColor.primary),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       Expanded(
//                                         child: InkWell(
//                                           onTap: () {
//                                             // DateTime today=DateTime.now();
//                                             // if (!isToDateSelected &&
//                                             //     today.difference(dateFrom).inDays > 0) {
//                                             //   setState(() {
//                                             //     DateFormat format = DateFormat("dd/MM/yyyy");
//                                             //     print(format.parse(mainCauseListData.cause_date));
//                                             //     dateTo = format.parse(mainCauseListData.cause_date);
//                                             //     print("date $dateTo");
//                                             //   });
//                                             //   // toast(msg: "Please select To date");
//                                             //   // return;
//                                             // }else{
//                                             //   setState(() {
//                                             //     dateTo=null;
//                                             //   });
//                                             // }
//
//                                             var viewList = {
//                                               "dateFrom": getDDMMYYYY(
//                                                   dateFrom.toString()),
//                                               "dateTo": dateTo != null
//                                                   ? getDDMMYYYY(
//                                                   dateTo.toString())
//                                                   : "",
//                                               "lawyerName": widget
//                                                   .mainCauseListdata[
//                                               "lawyerName"] !=
//                                                   null
//                                                   ? widget
//                                                   .mainCauseListdata[
//                                               "lawyerName"]
//                                                   .toString()
//                                                   : "",
//                                               "courtNo":
//                                               widget.mainCauseListdata[
//                                               "courtNo"] !=
//                                                   null
//                                                   ? widget
//                                                   .mainCauseListdata[
//                                               "courtNo"]
//                                                   .toString()
//                                                   : "",
//                                               "sNo": "",
//                                               "caseNo":
//                                               widget.mainCauseListdata[
//                                               "caseNo"] !=
//                                                   null
//                                                   ? widget
//                                                   .mainCauseListdata[
//                                               "caseNo"]
//                                                   .toString()
//                                                   : "",
//                                               "benchName":
//                                               widget.mainCauseListdata[
//                                               "judgeName"] !=
//                                                   null
//                                                   ? widget
//                                                   .mainCauseListdata[
//                                               "judgeName"]
//                                                   .toString()
//                                                   : "",
//                                               "causeListType": widget
//                                                   .mainCauseListdata[
//                                               "causeListType"] !=
//                                                   null
//                                                   ? widget
//                                                   .mainCauseListdata[
//                                               "causeListType"]
//                                                   .toString()
//                                                   : "",
//                                               "partyName":
//                                               widget.mainCauseListdata[
//                                               "partyName"] !=
//                                                   null
//                                                   ? widget
//                                                   .mainCauseListdata[
//                                               "partyName"]
//                                                   .toString()
//                                                   : "",
//                                               "judgeTime":
//                                               widget.mainCauseListdata[
//                                               "judgeTime"] !=
//                                                   null
//                                                   ? widget
//                                                   .mainCauseListdata[
//                                               "judgeTime"]
//                                                   .toString()
//                                                   : "",
//                                             };
//
//                                             widget.mainCauseListdata[
//                                             "dateFrom"] =
//                                                 getDDMMYYYY(
//                                                     dateFrom.toString());
//                                             widget.mainCauseListdata[
//                                             "dateTo"] =
//                                             dateTo != null
//                                                 ? getDDMMYYYY(
//                                                 dateTo.toString())
//                                                 : "";
//                                             isQuickSearchScroll = true;
//                                             widget.ctx!
//                                                 .read<
//                                                 ViewCauseListCubit>()
//                                                 .fetchViewCauseList(
//                                               viewList,
//                                               // isQuickSearch: widget
//                                               //     .isQuickSearch
//                                             );
//                                             Navigator.pop(context);
//                                           },
//                                           child: Container(
//                                             alignment: Alignment.center,
//                                             height:
//                                             mediaQH(context) * 0.05,
//                                             decoration:
//                                             const BoxDecoration(
//                                               borderRadius:
//                                               BorderRadius.only(
//                                                   bottomRight:
//                                                   Radius.circular(
//                                                       5)),
//                                               color: AppColor.primary,
//                                             ),
//                                             child: Text(
//                                               "View",
//                                               style: mpHeadLine16(
//                                                   textColor:
//                                                   AppColor.white),
//                                             ),
//                                           ),
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                       );
//                     });
//               },
//               child: const Icon(
//                 Icons.calendar_today,
//                 size: 26,
//               ),
//             ),
//             SizedBox(
//               width: isSearch ? 0 : 16,
//             ),
//             viewCauseListData != null
//                 ? !isSearch
//                 ? SizedBox()
//                 : Container(
//               width: mediaQW(context) * 0.8,
//               height: 40,
//               decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(5)),
//               child: Center(
//                 child: TextField(
//                   onChanged: (value) {
//                     if (value.isNotEmpty) {
//                       searchFilterList(value.toLowerCase());
//                     } else {
//                       setState(() {
//                         isSearchFilter = false;
//                         searchList = [];
//                       });
//                     }
//                   },
//                   decoration: InputDecoration(
//                       suffixIcon: IconButton(
//                         icon: const Icon(
//                           Icons.clear,
//                           color: Colors.black,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             isSearch = false;
//                             isSearchFilter = false;
//                             searchList = [];
//                             print("iscroll to sno ${isSnoScroll}");
//                             if (isSnoScroll &&
//                                 viewCauseListData != null &&
//                                 viewCauseListData!.causelist !=
//                                     null) {
//                               sNoCallback(
//                                   widget.mainCauseListdata["sNo"]
//                                       .toString(),
//                                   widget.mainCauseListdata["type"]
//                                       .toString());
//                             }
//                             if (isQuickSearchScroll &&
//                                 viewCauseListData != null &&
//                                 viewCauseListData!.causelist !=
//                                     null) {
//                               dateSelectCallback(
//                                   getddMMYYYY_with_splash(widget
//                                       .quickScrollDate
//                                       .toString()));
//                             }
//                           });
//                           /* Clear the search field */
//                         },
//                       ),
//                       hintText: 'Search...',
//                       border: InputBorder.none),
//                 ),
//               ),
//             )
//                 : SizedBox(),
//             viewCauseListData != null
//                 ? isSearch
//                 ? SizedBox()
//                 : InkWell(
//               onTap: () {
//                 setState(() {
//                   isSearch = true;
//                 });
//               },
//               child: Icon(
//                 Icons.search,
//                 size: 28,
//               ),
//             )
//                 : SizedBox(),
//             SizedBox(
//               width: viewCauseListData == null ||
//                   isSearch ||
//                   !widget.isDownloadOption
//                   ? 0
//                   : 8,
//             ),
//             viewCauseListData == null || isSearch || !widget.isDownloadOption
//                 ? SizedBox()
//                 : InkWell(
//               onTap: () {
//                 // print("isPrime(pref) ${isPrime(pref)}");
//                 // if (!isPrime(pref)) {
//                 //   FocusScope.of(context).requestFocus(FocusNode());
//                 //   showDialog(
//                 //       context: context,
//                 //       builder: (ctx) => SafeArea(
//                 //         child: GoPrime(),
//                 //       ));
//                 //   return;
//                 // }
//                 DateTime firstDate = DateFormat("dd/MM/yyyy")
//                     .parse(widget.mainCauseListdata["dateFrom"]);
//
//                 DateTime? lastDate;
//                 print("date to ${widget.mainCauseListdata["dateTo"]}");
//                 if (widget.mainCauseListdata["dateTo"] != null &&
//                     widget.mainCauseListdata["dateTo"].isNotEmpty) {
//                   lastDate = DateFormat("dd/MM/yyyy")
//                       .parse(widget.mainCauseListdata["dateTo"]);
//                   print("hello ${lastDate.difference(firstDate).inDays}");
//                   if (lastDate.difference(firstDate).inDays > 30) {
//                     toast(
//                         msg:
//                         "You can not download more than 1 month data. Please select date accordingly.");
//                     return;
//                     // lastDate=firstDate.add(Duration(days: 30));
//                   }
//                   //print("lastDate ${lastDate!}");
//                 }
//
//                 showDialog(
//                     context: context,
//                     builder: (ctx) => DownloadCauseList({
//                       "dateFrom":
//                       widget.mainCauseListdata["dateFrom"] != null
//                           ? widget.mainCauseListdata["dateFrom"]
//                           .toString()
//                           : "",
//                       "dateTo": widget.mainCauseListdata["dateTo"] !=
//                           null &&
//                           widget.mainCauseListdata["dateTo"]
//                               .isNotEmpty
//                           ? getDDMMYYYY(lastDate.toString())
//                           : "",
//                       "lawyerName":
//                       widget.mainCauseListdata["lawyerName"] !=
//                           null
//                           ? widget.mainCauseListdata["lawyerName"]
//                           .toString()
//                           : "",
//                       "courtNo":
//                       widget.mainCauseListdata["courtNo"] != null
//                           ? widget.mainCauseListdata["courtNo"]
//                           .toString()
//                           : "",
//                       "sNo": "",
//                       "caseNo":
//                       widget.mainCauseListdata["caseNo"] != null
//                           ? widget.mainCauseListdata["caseNo"]
//                           .toString()
//                           : "",
//                       "benchName":
//                       widget.mainCauseListdata["judgeName"] !=
//                           null
//                           ? widget.mainCauseListdata["judgeName"]
//                           .toString()
//                           : "",
//                       "causeListType":
//                       widget.mainCauseListdata["causeListType"] !=
//                           null
//                           ? widget
//                           .mainCauseListdata["causeListType"]
//                           .toString()
//                           : "",
//                       "partyName":
//                       widget.mainCauseListdata["partyName"] !=
//                           null
//                           ? widget.mainCauseListdata["partyName"]
//                           .toString()
//                           : "",
//                       "judgeTime":
//                       widget.mainCauseListdata["judgeTime"] !=
//                           null
//                           ? widget.mainCauseListdata["judgeTime"]
//                           .toString()
//                           : "",
//                     }, widget.ctx!),
//                 barrierColor: Colors.black26
//                 );
//               },
//               child: const Icon(
//                 Icons.download,
//                 size: 25,
//                 color: AppColor.bold_text_color_dark_blue,
//               ),
//             ),
//             SizedBox(
//               width: isSearch ? 0 : 8,
//             ),
//             GestureDetector(
//               onTap: () {
//                 goToHomePage(context);
//               },
//               child: const Padding(
//                 padding: EdgeInsets.only(right: 15),
//                 child: Icon(
//                   Icons.home_outlined,
//                   size: 30,
//                 ),
//               ),
//             )
//           ],
//         ),
//         body: SafeArea(
//           child: Stack(
//             children: [
//               BlocConsumer<ViewCauseListCubit, ViewCauseListState>(
//                 builder: (context, state) {
//
//                   return SizedBox();
//                 },
//                 listener: (context, state) {
//                   if (state is ViewCauseListLoading) {
//                     setState(() {
//                       isLoading = true;
//                     });
//                   }
//                   if (state is ViewCauseListLoaded) {
//                     print("loaded");
//                     var viewCauseModel = state.viewCauseListModel;
//                     if (viewCauseModel.result == 1) {
//                       if (viewCauseModel.data != null) {
//                         if (state.viewCauseListModel!.data!.excel_url != null &&
//                             state.viewCauseListModel!.data!.excel_url!
//                                 .isNotEmpty) {
//                           toast(msg: "Downloading started");
//                           DateTime now = DateTime.now();
//                           var fileName =
//                               "HAeLo_File_causesList_${getYYYYMMDDownload(widget.mainCauseListdata["dateFrom"])}_${now.millisecondsSinceEpoch}.${state.viewCauseListModel!.data!.excel_url!.toString().split(".").last}";
//                           downloadData(
//                               state.viewCauseListModel!.data!.excel_url!,
//                               fileName);
//                           print("pauseloader 1");
//                           pauseLoader();
//                           setState(() {});
//                         } else {
//                           print("else part");
//                           // setState(() {
//                           viewCauseListData = viewCauseModel.data;
//                           // });
//                           if (viewCauseListData!.causelist != null &&
//                               viewCauseListData!.causelist!.isNotEmpty) {
//                             print(
//                                 "causlist  ${viewCauseListData!.causelist!.length}");
//                             List sortList = viewCauseListData!.causelist!;
//                             _firstVisibleIndex = 0;
//                             newList = [];
//
//                               //   .map((user) => user)
//                               //   .toList()
//                               // ..sort((a, b) {
//                               //   //print("first date ${a.date} second ${b.date}");
//                               //
//                               //   DateTime _dateTime = DateFormat("dd/MM/yyyy")
//                               //       .parse(a.causeListDate!);
//                               //   DateTime _dateTime1 = DateFormat("dd/MM/yyyy")
//                               //       .parse(b.causeListDate!);
//                               //
//                               //   int dt = _dateTime!.compareTo(_dateTime1);
//                               //   if (dt != 0) {
//                               //     return dt;
//                               //   }
//                               //
//                               //   if (a.courtNo == "Before Dy. Registrar (Judicial)" ||
//                               //       b.courtNo ==
//                               //           "Before Dy. Registrar (Judicial)" ||
//                               //       a.courtNo == "Before Registrar (Admin.)" ||
//                               //       b.courtNo == "Before Registrar (Admin.)") {
//                               //     return (a.courtNo!).compareTo((b.courtNo!));
//                               //   }
//                               //   // First, compare by name
//                               //   int courtComparison = int.parse(a.courtNo!)
//                               //       .compareTo(int.parse(b.courtNo!));
//                               //   if (courtComparison != 0) {
//                               //     return courtComparison;
//                               //   }
//                               //
//                               //   int sNoComparison = int.parse(
//                               //       a.sno.toString().replaceAll("With", ""))
//                               //       .compareTo(int.parse(b.sno
//                               //       .toString()
//                               //       .replaceAll("With", "")));
//                               //   if (sNoComparison != 0) {
//                               //     return sNoComparison;
//                               //   }
//                               //   return int.parse(a.courtNo!)
//                               //       .compareTo(int.parse(b.courtNo!));
//                               // });
//                             for(int i=0; i<sortList!.length; i++){
//                               //  print("in index $i>> ${newList.any((element) => element.causeListDate==caseList![i].causeListDate)}");
//                               if(!newList!.any((element) => element.causeListDate==sortList![i].causeListDate)){
//                                 Causelist casData=Causelist();
//                                 casData.benchName=sortList![i].benchName;
//                                 casData.bottomNo=sortList![i].bottomNo;
//                                 casData.caseId=sortList![i].caseId;
//                                 casData.caseNo=sortList![i].caseNo;
//                                 casData.causeListDate=sortList![i].causeListDate;
//                                 casData.causeListType=sortList![i].causeListType;
//
//                                 casData.courtNo=sortList![i].courtNo;
//                                 casData.intrimStay=sortList![i].intrimStay;
//                                 casData.partyName=sortList![i].partyName;
//                                 casData.petitioner=sortList![i].petitioner;
//                                 casData.respondent=sortList![i].respondent;
//                                 casData.sno=sortList![i].sno;
//                                 casData.snoWith=sortList![i].snoWith;
//                                 casData.stage=sortList![i].stage;
//                                 casData.is_disposed=sortList![i].is_disposed;
//                                 casData.is_hide=sortList![i].is_hide;
//                                 casData.bench_info=sortList![i].bench_info;
//                                 casData.isHideExpanded=sortList![i].isHideExpanded;
//                                 casData.isdateChange=true;
//                                 newList.add(casData);
//                               }
//
//                               Causelist cas=Causelist();
//                               cas.benchName=sortList![i].benchName;
//                               cas.bottomNo=sortList![i].bottomNo;
//                               cas.caseId=sortList![i].caseId;
//                               cas.caseNo=sortList![i].caseNo;
//                               cas.causeListDate=sortList![i].causeListDate;
//                               cas.causeListType=sortList![i].causeListType;
//                               cas.courtNo=sortList![i].courtNo;
//                               cas.intrimStay=sortList![i].intrimStay;
//                               cas.partyName=sortList![i].partyName;
//                               cas.petitioner=sortList![i].petitioner;
//                               cas.respondent=sortList![i].respondent;
//                               cas.sno=sortList![i].sno;
//                               cas.snoWith=sortList![i].snoWith;
//                               cas.stage=sortList![i].stage;
//                               cas.is_disposed=sortList![i].is_disposed;
//                               cas.is_hide=sortList![i].is_hide;
//                               cas.bench_info=sortList![i].bench_info;
//                               cas.isHideExpanded=sortList![i].isHideExpanded;
//                               cas.isdateChange=false;
//
//
//                               newList.add(cas);
//
//                             }
//
//                             for(int i=0; i<newList.length; i++){
//                               if(i==0 || newList[i].courtNo=="Before Registrar (Admin.)" ||
//                                   newList[i].courtNo=="Before Registrar (Admin.)" ||
//                                   newList[i].courtNo=="Before Dy. Registrar (Judicial)"){
//                                 newList[i].iscourtChange=false;
//                               }else{
//                                 if(newList[i-1].courtNo=="Before Registrar (Admin.)"){
//                                   newList[i].iscourtChange=true;
//                                 }else if(newList[i-1].courtNo=="Before Dy. Registrar (Judicial)"){
//                                   newList[i].iscourtChange=true;
//                                 }else
//                                 if(int.parse(newList[i].courtNo)!=int.parse(newList[i-1].courtNo)){
//                                   newList[i].iscourtChange=true;
//                                 }else{
//                                   newList[i].iscourtChange=false;
//                                 }
//                               }
//                             }
//
//
//                             //for when need court filter
//                             if (!widget.isFromHomepage) {
//                               courtNumList = [];
//                               for (int i = 0;
//                               i < viewCauseListData!.causelist!.length;
//                               i++) {
//                                 if (!courtNumList.contains(
//                                     viewCauseListData!.causelist![i].courtNo)) {
//                                   courtNumList.add(
//                                       viewCauseListData!.causelist![i].courtNo);
//                                 }
//                               }
//                             }
//                             else {
//                               //when need date filter
//                               dates = [];
//                               for (int i = 0;
//                               i < viewCauseListData!.causelist!.length;
//                               i++) {
//                                 // if(!newDatesCourt.any((element) => element.date==viewCauseListData!
//                                 //     .causelist![i].causeListDate)){
//                                 //   DatesCourtModel model=DatesCourtModel();
//                                 //   model.date=viewCauseListData!
//                                 //       .causelist![i].causeListDate!;
//                                 //   model.courtNo=[];
//                                 //   model.courtNo!.add(viewCauseListData!
//                                 //       .causelist![i].courtNo);
//                                 //   newDatesCourt.add(model);
//                                 // }else{
//                                 //   DatesCourtModel model=DatesCourtModel();
//                                 //   int index=newDatesCourt.indexWhere((element) => element.date==viewCauseListData!
//                                 //       .causelist![i].causeListDate);
//                                 //   //model.courtNo=[];
//                                 //   if(!newDatesCourt[index].courtNo!.contains(viewCauseListData!
//                                 //       .causelist![i].courtNo))
//                                 //     newDatesCourt[index].courtNo!.add(viewCauseListData!
//                                 //         .causelist![i].courtNo);
//                                 //   // newDatesCourt[index]=model;
//                                 // }
//
//
//                                 if (!dates.contains(viewCauseListData!
//                                     .causelist![i].causeListDate)) {
//                                   dates.add(viewCauseListData!
//                                       .causelist![i].causeListDate);
//                                 }
//                               }
//
//                               print("dates ${dates.length}");
//                             }
//                             newDatesCourt=[];
//                             for (int i = 0;
//                             i < viewCauseListData!.causelist!.length;
//                             i++) {
//                               if(!newDatesCourt.any((element) => element.date==viewCauseListData!
//                                   .causelist![i].causeListDate)){
//                                 DatesCourtModel model=DatesCourtModel();
//                                 model.date=viewCauseListData!
//                                     .causelist![i].causeListDate!;
//                                 model.courtNo=[];
//                                 model.courtNo!.add(viewCauseListData!
//                                     .causelist![i].courtNo);
//                                 newDatesCourt.add(model);
//                               }else{
//                                // DatesCourtModel model=DatesCourtModel();
//                                 int index=newDatesCourt.indexWhere((element) => element.date==viewCauseListData!
//                                     .causelist![i].causeListDate);
//                                 //model.courtNo=[];
//                                 if(!newDatesCourt[index].courtNo!.contains(viewCauseListData!
//                                     .causelist![i].courtNo))
//                                   newDatesCourt[index].courtNo!.add(viewCauseListData!
//                                       .causelist![i].courtNo);
//                                 // newDatesCourt[index]=model;
//                               }
//                             }
//                             print("newDatesCourt/// ${newDatesCourt.length}");
//                             // isQuickSearchScroll = false;
//                             isDrag = false;
//
//                             //  setState(() {});
//                             print("pauseloader 2");
//                             pauseLoader();
//                             // if(widget.isScrollToSno){
//                             //   sNoCallback(widget.mainCauseListdata["sNo"].toString());
//                             // }
//                           } //for download data
//                           else {
//                             setState(() {
//                               viewCauseListData = null;
//                               dateIndex = 0;
//
//                               //both list used for filter only
//                               courtNumList = [];
//                               dates = [];
//                             });
//                             print("pauseloader 3");
//                             pauseLoader();
//                           }
//                         }
//                       }
//                     } else {
//                       setState(() {
//                         viewCauseListData = null;
//                         dateIndex = 0;
//
//                         //both list used for filter only
//                         courtNumList = [];
//                         dates = [];
//                       });
//                       print("pauseloader 4");
//                       pauseLoader();
//                     }
//                   }
//                 },
//               ),
//               BlocConsumer<HideCauseListCubit, HideCauseListState>(
//                 builder: (context, state) {
//                   return const SizedBox();
//                 },
//                 listener: (context, state) {
//                   if (state is HideCauseListLoaded) {
//                     var hideListModel = state.hideCauseListModel;
//                     if (hideListModel.result == 1) {
//                       var viewList = {
//                         "dateFrom": widget.mainCauseListdata["dateFrom"] != null
//                             ? widget.mainCauseListdata["dateFrom"].toString()
//                             : "",
//                         "dateTo": widget.mainCauseListdata["dateTo"] != null
//                             ? widget.mainCauseListdata["dateTo"].toString()
//                             : "",
//                         "lawyerName": widget.mainCauseListdata["lawyerName"] !=
//                             null
//                             ? widget.mainCauseListdata["lawyerName"].toString()
//                             : "",
//                         "courtNo": widget.mainCauseListdata["courtNo"] != null
//                             ? widget.mainCauseListdata["courtNo"].toString()
//                             : "",
//                         "sNo": "",
//                         "caseNo": widget.mainCauseListdata["caseNo"] != null
//                             ? widget.mainCauseListdata["caseNo"].toString()
//                             : "",
//                         "benchName": widget.mainCauseListdata["judgeName"] !=
//                             null
//                             ? widget.mainCauseListdata["judgeName"].toString()
//                             : "",
//                         "causeListType":
//                         widget.mainCauseListdata["causeListType"] != null
//                             ? widget.mainCauseListdata["causeListType"]
//                             .toString()
//                             : "",
//                         "partyName": widget.mainCauseListdata["partyName"] !=
//                             null
//                             ? widget.mainCauseListdata["partyName"].toString()
//                             : "",
//                         "judgeTime": widget.mainCauseListdata["judgeTime"] !=
//                             null
//                             ? widget.mainCauseListdata["judgeTime"].toString()
//                             : "",
//                       };
//                       Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => ViewCauseListScreen(
//                                 mainCauseListdata: viewList,
//                                 isFromHomepage: widget.isFromHomepage,
//                                 isDownloadOption: widget.isDownloadOption,
//                                 isScrollToSno: true,
//                                 isFilter: widget.isFilter,
//                                 quickScrollDate: widget.quickScrollDate,
//                                 isQuickSearch: widget.isQuickSearch,
//                                 isGotoCourt: widget.isGotoCourt,
//                               )));
//                     }
//                   }
//                 },
//               ),
//               isLoading
//                   ? const Center(child: AppProgressIndicator())
//                   : viewCauseListData != null &&
//                   viewCauseListData!.causelist != null
//                   ? AbsorbPointer(
//                 absorbing: isPartialLoading,
//                 child: Opacity(
//                   opacity: !isPartialLoading ? 1.0 : 0.0,
//                       child: Column(
//                 children: [
//                       Padding(
//                         padding:
//                         const EdgeInsets.fromLTRB(10, 10, 20, 10),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Column( crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     ColorNode(AppColor.white, "Not set"),
//                                     SizedBox(height: 5,),
//                                     ColorNode(
//                                         AppColor.disposedColor, "Disposed"),
//                                   ],
//                                 ),
//                                 Column( crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     ColorNode(AppColor.cases_nostay, "No stay"),
//                                     SizedBox(height: 5,),
//                                     ColorNode(
//                                         AppColor.text_grey_color, "Hidden"),
//                                   ],
//                                 ),
//                                 Column( crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     ColorNode(AppColor.cases_intrimstay,
//                                         "Interim stay"),
//                                     SizedBox(height: 5,),
//                                     ColorNode(Colors.blueAccent, "Not created"),
//                                   ],
//                                 ),
//                                 ColorNode(
//                                     AppColor.cases_fullstay, "Full stay"),
//
//                               ],
//                             ),
//
//                           ],
//                         ),
//                       ),
//
//                       Expanded(
//                         child: searchList.isEmpty && !isSearchFilter
//                             ? Stack(alignment: Alignment.topCenter,
//                               children: [
//                                 Container(
//                           margin: EdgeInsets.only(top: 9),
//                                   child: Scrollbar(
//                           controller: _outerScrollController,
//                           thickness: 10,
//                           interactive: true,
//                           thumbVisibility: true,
//                           trackVisibility: true,
//                           radius: const Radius.circular(10),
//                           child: InViewNotifierList(
//                                     isInViewPortCondition: condition,
//                                     itemCount: newList.length+1,
//                                     shrinkWrap: true,
//                                     initialInViewIds: [],
//                                     throttleDuration: Duration.zero,
//                                     padding: EdgeInsets.only(right: 10),
//                                     controller: _outerScrollController,
//                                     builder: (context, int index) {
//                                       if(index==newList.length){
//                                         return  SizedBox(height: mediaQH(context)/2.8,);
//                                       }
//                                       var item = newList[index];
//                                       return InViewNotifierWidget(
//                                         id: '$index',
//                                         builder: (BuildContext context, bool isInView, Widget? child) {
//                                           if(_firstVisibleIndex!=index && isInView
//                                               && newList[_firstVisibleIndex].causeListDate!=newList[index].causeListDate
//                                           ) {
//                                             _firstVisibleIndex=index;
//
//                                             int idxx=newDatesCourt.indexWhere((element) =>
//                                             element.date==newList[_firstVisibleIndex].causeListDate);
//                                             _goToElement(idxx);
//                                             print("index $index");
//                                             WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
//                                           }
//                                           return AutoScrollTag(
//                                             key: ValueKey(index),
//                                             controller:_outerScrollController,
//                                             index: index,
//                                             child: (item.isdateChange!=null &&
//                                                 item.isdateChange==true)?
//                                             Row(
//                                               mainAxisSize: MainAxisSize.min,
//                                               mainAxisAlignment: MainAxisAlignment.center,
//                                               children: [
//                                                 Spacer(),
//                                                 Container(
//                                                   decoration: BoxDecoration(
//                                                     borderRadius:
//                                                     BorderRadius.circular(5),
//                                                     color: AppColor.primary,
//                                                   ),
//                                                   margin: EdgeInsets.only(right: 10),
//                                                   alignment: Alignment.center,
//                                                   padding: const EdgeInsets.symmetric(
//                                                       horizontal: 16, vertical: 5),
//                                                   child: Text(
//                                                     "${item.causeListDate}",
//                                                     style: appTextStyle(
//                                                       textColor: AppColor.white,
//                                                     ),
//                                                     textAlign: TextAlign.center,
//                                                   ),
//                                                 ),
//                                                 SizedBox(
//                                                   width: widget.isQuickSearch
//                                                       ? 20
//                                                       : 0,
//                                                 ),
//                                                 widget.isQuickSearch
//                                                     ? InkWell(
//                                                   onTap: () {
//                                                     // if (!isPrime(
//                                                     //     pref)) {
//                                                     //   FocusScope.of(
//                                                     //       context)
//                                                     //       .requestFocus(
//                                                     //       FocusNode());
//                                                     //   showDialog(
//                                                     //       context:
//                                                     //       context,
//                                                     //       builder: (ctx) =>
//                                                     //           SafeArea(
//                                                     //             child:
//                                                     //             GoPrime(),
//                                                     //           ));
//                                                     //   return;
//                                                     // }
//                                                     showDialog(
//                                                         context:
//                                                         context,
//                                                         builder: (ctx) =>
//                                                             DownloadCauseList(
//                                                                 {
//                                                                   "dateFrom":
//                                                                   item.causeListDate!,
//                                                                   "dateTo":
//                                                                   item.causeListDate!,
//                                                                   "lawyerName": widget.mainCauseListdata["lawyerName"] != null
//                                                                       ? widget.mainCauseListdata["lawyerName"].toString()
//                                                                       : "",
//                                                                   "courtNo": widget.mainCauseListdata["courtNo"] != null
//                                                                       ? widget.mainCauseListdata["courtNo"].toString()
//                                                                       : "",
//                                                                   "sNo":
//                                                                   "",
//                                                                   "caseNo": widget.mainCauseListdata["caseNo"] != null
//                                                                       ? widget.mainCauseListdata["caseNo"].toString()
//                                                                       : "",
//                                                                   "benchName": widget.mainCauseListdata["judgeName"] != null
//                                                                       ? widget.mainCauseListdata["judgeName"].toString()
//                                                                       : "",
//                                                                   "causeListType": widget.mainCauseListdata["causeListType"] != null
//                                                                       ? widget.mainCauseListdata["causeListType"].toString()
//                                                                       : "",
//                                                                   "partyName": widget.mainCauseListdata["partyName"] != null
//                                                                       ? widget.mainCauseListdata["partyName"].toString()
//                                                                       : "",
//                                                                   "judgeTime": widget.mainCauseListdata["judgeTime"] != null
//                                                                       ? widget.mainCauseListdata["judgeTime"].toString()
//                                                                       : "",
//                                                                 },
//                                                                 widget
//                                                                     .ctx!),
//                                                         barrierColor: Colors.black26
//                                                     );
//                                                   },
//                                                   child: Icon(
//                                                     Icons.download,
//                                                     size: 20,
//                                                     color: AppColor
//                                                         .primary,
//                                                   ),
//                                                 )
//                                                     : SizedBox(),
//                                                 Spacer(),
//                                               ],
//                                             ):
//                                             causeListCard(context,item)
//                                           );
//                                         },
//                                       );
//                                     }),
//                         ),
//                                 ),
//                                 Positioned(
//                                   top:0,left: 0,right: 0,
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(2),
//                                       color:  newDatesCourt.length>1?Colors.white:AppColor.home_background,
//                                       boxShadow: newDatesCourt.length>1?[
//                                         BoxShadow(
//                                           color: Colors.grey.withOpacity(0.5),
//                                           spreadRadius: 2,
//                                           blurRadius: 3,
//                                           offset: Offset(0, 3), // changes position of shadow
//                                         ),
//                                       ]:[],
//                                     ),
//                                     padding: EdgeInsets.symmetric(vertical: 1,horizontal: 3),
//                                     height: 35,
//                                     margin: EdgeInsets.only(right: 12),
//                                     alignment: Alignment.center,
//                                     child: ListView(
//                                         scrollDirection: Axis.horizontal,
//                                         controller: _horizontalDateController,
//                                       shrinkWrap: true,
//
//                                       children: newDatesCourt.map((e) {
//                                         return InkWell(
//                                           onTap: (){
//                                             dateSelectCallback(e.date!);
//                                           },
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                               borderRadius:
//                                               BorderRadius.circular(5),
//                                               color:  e.date==newList[_firstVisibleIndex].causeListDate?
//                                               AppColor.primary:AppColor.white,
//                                               border: Border.all(
//                                                 color: AppColor.primary,
//                                               )
//                                             ),
//                                             margin: EdgeInsets.only(right: 10),
//                                             alignment: Alignment.center,
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 16, vertical: 5),
//                                             child: Row( mainAxisSize: MainAxisSize.min,
//                                               mainAxisAlignment: MainAxisAlignment.center,
//                                               children: [
//                                                 Text(
//                                                   "${e.date}",
//                                                   style: appTextStyle(
//                                                     textColor:
//                                                     e.date==newList[_firstVisibleIndex].causeListDate?
//                                                     AppColor.white:AppColor.primary,
//                                                   ),
//                                                   textAlign: TextAlign.center,
//                                                 ),
//                                                 SizedBox(
//                                                   width: widget.isQuickSearch
//                                                       ? 10
//                                                       : 0,
//                                                 ),
//                                                 widget.isQuickSearch
//                                                     ? InkWell(
//                                                   onTap: () {
//                                                     // if (!isPrime(
//                                                     //     pref)) {
//                                                     //   FocusScope.of(
//                                                     //       context)
//                                                     //       .requestFocus(
//                                                     //       FocusNode());
//                                                     //   showDialog(
//                                                     //       context:
//                                                     //       context,
//                                                     //       builder: (ctx) =>
//                                                     //           SafeArea(
//                                                     //             child:
//                                                     //             GoPrime(),
//                                                     //           ));
//                                                     //   return;
//                                                     // }
//                                                     showDialog(
//                                                         context:
//                                                         context,
//                                                         builder: (ctx) =>
//                                                             DownloadCauseList(
//                                                                 {
//                                                                   "dateFrom":
//                                                                   "${e.date}",
//                                                                   "dateTo":
//                                                                   "${e.date}",
//                                                                   "lawyerName": widget.mainCauseListdata["lawyerName"] != null
//                                                                       ? widget.mainCauseListdata["lawyerName"].toString()
//                                                                       : "",
//                                                                   "courtNo": widget.mainCauseListdata["courtNo"] != null
//                                                                       ? widget.mainCauseListdata["courtNo"].toString()
//                                                                       : "",
//                                                                   "sNo":
//                                                                   "",
//                                                                   "caseNo": widget.mainCauseListdata["caseNo"] != null
//                                                                       ? widget.mainCauseListdata["caseNo"].toString()
//                                                                       : "",
//                                                                   "benchName": widget.mainCauseListdata["judgeName"] != null
//                                                                       ? widget.mainCauseListdata["judgeName"].toString()
//                                                                       : "",
//                                                                   "causeListType": widget.mainCauseListdata["causeListType"] != null
//                                                                       ? widget.mainCauseListdata["causeListType"].toString()
//                                                                       : "",
//                                                                   "partyName": widget.mainCauseListdata["partyName"] != null
//                                                                       ? widget.mainCauseListdata["partyName"].toString()
//                                                                       : "",
//                                                                   "judgeTime": widget.mainCauseListdata["judgeTime"] != null
//                                                                       ? widget.mainCauseListdata["judgeTime"].toString()
//                                                                       : "",
//                                                                 },
//                                                                 widget
//                                                                     .ctx!),
//                                                         barrierColor: Colors.black26);
//                                                   },
//                                                   child: Icon(
//                                                     Icons.download,
//                                                     size: 16,
//                                                     color: e.date==newList[_firstVisibleIndex].causeListDate?
//                                                     AppColor.white:AppColor.primary,
//                                                   ),
//                                                 )
//                                                     : SizedBox(),
//                                               ],
//                                             ),
//                                           ),
//                                         );
//                                       }).toList()
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             )
//                             : searchList.isNotEmpty
//                             ? Stack(
//                               children: [
//                                 Scrollbar(
//                           controller: _outerScrollController,
//                           thickness: 10,
//                           interactive: true,
//                           thumbVisibility: true,
//                           trackVisibility: true,
//                           radius: const Radius.circular(10),
//                           child: InViewNotifierList(
//                                   isInViewPortCondition: condition,
//                                   itemCount: searchList.length,
//                                   shrinkWrap: true,
//                                   padding: EdgeInsets.only(right: 10),
//                                   controller: _outerScrollController,
//                                   builder: (context, int index) {
//                                     var item = searchList[index];
//                                     return InViewNotifierWidget(
//                                       id: '$index',
//                                       builder: (BuildContext context, bool isInView, Widget? child) {
//                                         if(_searchFirstVisibleIndex!=index && isInView
//                                             && searchList[_searchFirstVisibleIndex].causeListDate!=searchList[index].causeListDate
//                                         ) {
//                                           _searchFirstVisibleIndex=index;
//                                           print("index $index");
//                                           WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
//                                         }
//                                         return AutoScrollTag(
//                                             key: ValueKey(index),
//                                             controller:_outerScrollController,
//                                             index: index,
//                                             child: (item.isdateChange!=null &&
//                                                 item.isdateChange==true)?
//                                             Row(
//                                               mainAxisSize: MainAxisSize.min,
//                                               mainAxisAlignment: MainAxisAlignment.center,
//                                               children: [
//                                                 Spacer(),
//                                                 Container(
//                                                   decoration: BoxDecoration(
//                                                     borderRadius:
//                                                     BorderRadius.circular(5),
//                                                     color: AppColor.primary,
//                                                   ),
//                                                   alignment: Alignment.center,
//                                                   padding: const EdgeInsets.symmetric(
//                                                       horizontal: 16, vertical: 5),
//                                                   child: Text(
//                                                     item.causeListDate!,
//                                                     style: appTextStyle(
//                                                       textColor: AppColor.white,
//                                                     ),
//                                                     textAlign: TextAlign.center,
//                                                   ),
//                                                 ),
//                                                 Spacer(),
//                                               ],
//                                             ):
//                                             causeListCard(context,item)
//                                         );
//                                       },
//                                     );
//                                   }),
//                         ),
//                                 Positioned(
//                                   top:0,left: 0,right: 10,
//                                   child: Container(
//                                     color:  AppColor.home_background,
//                                     padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
//                                     child: Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: [
//                                         Spacer(),
//                                         Container(
//                                           decoration: BoxDecoration(
//                                             borderRadius:
//                                             BorderRadius.circular(5),
//                                             color: AppColor.primary,
//                                           ),
//                                           margin: EdgeInsets.only(right: 10),
//                                           alignment: Alignment.center,
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 16, vertical: 5),
//                                           child: Text(
//                                             "${searchList[_searchFirstVisibleIndex].causeListDate}",
//                                             style: appTextStyle(
//                                               textColor: AppColor.white,
//                                             ),
//                                             textAlign: TextAlign.center,
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           width: widget.isQuickSearch
//                                               ? 20
//                                               : 0,
//                                         ),
//                                         widget.isQuickSearch
//                                             ? InkWell(
//                                           onTap: () {
//                                             // if (!isPrime(
//                                             //     pref)) {
//                                             //   FocusScope.of(
//                                             //       context)
//                                             //       .requestFocus(
//                                             //       FocusNode());
//                                             //   showDialog(
//                                             //       context:
//                                             //       context,
//                                             //       builder: (ctx) =>
//                                             //           SafeArea(
//                                             //             child:
//                                             //             GoPrime(),
//                                             //           ));
//                                             //   return;
//                                             // }
//                                             showDialog(
//                                                 context:
//                                                 context,
//                                                 builder: (ctx) =>
//                                                     DownloadCauseList(
//                                                         {
//                                                           "dateFrom":
//                                                           "${newList[_firstVisibleIndex].causeListDate}",
//                                                           "dateTo":
//                                                           "${newList[_firstVisibleIndex].causeListDate}",
//                                                           "lawyerName": widget.mainCauseListdata["lawyerName"] != null
//                                                               ? widget.mainCauseListdata["lawyerName"].toString()
//                                                               : "",
//                                                           "courtNo": widget.mainCauseListdata["courtNo"] != null
//                                                               ? widget.mainCauseListdata["courtNo"].toString()
//                                                               : "",
//                                                           "sNo":
//                                                           "",
//                                                           "caseNo": widget.mainCauseListdata["caseNo"] != null
//                                                               ? widget.mainCauseListdata["caseNo"].toString()
//                                                               : "",
//                                                           "benchName": widget.mainCauseListdata["judgeName"] != null
//                                                               ? widget.mainCauseListdata["judgeName"].toString()
//                                                               : "",
//                                                           "causeListType": widget.mainCauseListdata["causeListType"] != null
//                                                               ? widget.mainCauseListdata["causeListType"].toString()
//                                                               : "",
//                                                           "partyName": widget.mainCauseListdata["partyName"] != null
//                                                               ? widget.mainCauseListdata["partyName"].toString()
//                                                               : "",
//                                                           "judgeTime": widget.mainCauseListdata["judgeTime"] != null
//                                                               ? widget.mainCauseListdata["judgeTime"].toString()
//                                                               : "",
//                                                         },
//                                                         widget
//                                                             .ctx!),
//                                                 barrierColor: Colors.black26);
//                                           },
//                                           child: Icon(
//                                             Icons.download,
//                                             size: 20,
//                                             color: AppColor
//                                                 .primary,
//                                           ),
//                                         )
//                                             : SizedBox(),
//                                         Spacer(),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             )
//                             : Column(
//                           children: [
//                             SizedBox(
//                               height: 150,
//                             ),
//                             NoDataAvailable(
//                                 "Search data not found.",
//                                 isTopmMargin: false),
//                           ],
//                         ),
//                       ),
//
//                 ],
//               ),
//                     ),
//                   )
//                   : NoDataAvailable("Your Causes will be shown here."),
//               Visibility(
//                 visible: isPartialLoading,
//                 child: const Center(child: AppProgressIndicator()),
//               ),
//             ],
//           ),
//         ),
//         floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//         floatingActionButton: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             widget.isQuickSearch && !isLoading &&
//                 viewCauseListData != null &&
//                 viewCauseListData!.causelist != null?
//             InkWell(
//               onTap: (){
//                 WatchListDataType? selectedLawyer=WatchListDataType("lawyer");
//                 if (widget.mainCauseListdata["lawyerName"] != null) {
//                   selectedLawyer!.lawyerName = widget.mainCauseListdata["lawyerName"].toString();
//                 }
//                 if (widget.mainCauseListdata["caseNo"] != null) {
//                   if(selectedLawyer!.lawyerName!=null && selectedLawyer!.lawyerName!.isNotEmpty){
//                     selectedLawyer!.caseNo = widget.mainCauseListdata["caseNo"].toString();
//                   }else{
//                     selectedLawyer!.lawyerName = widget.mainCauseListdata["caseNo"].toString();
//                   }
//
//                 }
//                 print("selected lawyer ${selectedLawyer.lawyerName}");
//                 print("selected caseno ${selectedLawyer!.caseNo}");
//                 showDialog(
//                     context: context,
//                     builder: (ctx) => OrderCmtInfo(selectedLawyer: selectedLawyer,),
//                     barrierColor: Colors.black26);
//               },
//               child: Container(
//                   margin: EdgeInsets.only(left: 30),
//                   decoration: BoxDecoration(
//                       color: AppColor.primary.withOpacity(0.9),
//                       borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                         color: AppColor.primary.withOpacity(0.5),
//                         spreadRadius: 5,
//                         blurRadius: 7,
//                         offset: Offset(0, 3), // changes position of shadow
//                       ),
//                     ],
//                   ),
//                   padding: EdgeInsets.all(5),
//                   child: Icon(Icons.history_toggle_off_outlined,
//                   color: AppColor.white,)),
//             ):SizedBox(),
//             isLoading || !widget.isFilter
//                 ? SizedBox()
//                 : isSearch
//                 ? SizedBox()
//                 : !widget.isFromHomepage && courtNumList.length > 1
//                 ? FloatingActionButton(
//                 backgroundColor: Colors.transparent,
//                 focusElevation: 0,
//                 elevation: 0,
//                 // isExtended: true,
//                 child: Container(
//                   height: 40,
//                   width: 30,
//                   color: AppColor.white,
//                   child: Image.asset(
//                     ImageConstant.scroll,
//                     color: AppColor.primary,
//                     height: 40,
//                     width: 40,
//                   ),
//                 ),
//                 // backgroundColor: AppColor.primary,
//                 onPressed: () {
//                   if (!widget.isFromHomepage) {
//                     showDialog(
//                         context: context,
//                         builder: (ctx) => CauseCourtList(
//                             courtNumList, courtSelectCallback));
//                   } else {
//                     showDialog(
//                         context: context,
//                         builder: (ctx) =>
//                             CauseDateListCourtNo(newDatesCourt, dateSelectCallback,
//                                 datesCourtSelectCallback));
//                   }
//                 })
//                 : widget.isFromHomepage && dates.length > 1
//                 ? FloatingActionButton(
//                 backgroundColor: Colors.transparent,
//                 focusElevation: 0,
//                 elevation: 0,
//                 // isExtended: true,
//                 child: Container(
//                   height: 40,
//                   width: 30,
//                   color: AppColor.white,
//                   child: Image.asset(
//                     ImageConstant.scroll,
//                     color: AppColor.primary,
//                     height: 40,
//                     width: 40,
//                   ),
//                 ),
//                 // backgroundColor: AppColor.primary,
//                 onPressed: () {
//                   if (!widget.isFromHomepage) {
//                     showDialog(
//                         context: context,
//                         builder: (ctx) => CauseCourtList(
//                           courtNumList, courtSelectCallback,
//                         ));
//                   } else {
//                     showDialog(
//                         context: context,
//                         builder: (ctx) => CauseDateListCourtNo(
//                             newDatesCourt, dateSelectCallback,
//                             datesCourtSelectCallback));
//                   }
//                 })
//                 : SizedBox(),
//           ],
//         ));
//   }
//
//   Widget causeListCard(context, element) {
//     DateTime causeDate = DateFormat("dd/MM/yyyy").parse(element.causeListDate!);
//     DateTime now = DateTime.now();
//
//
//    // print("sno ${element.sno.toString()} and iscourtChange ${element.iscourtChange}\n");
//     return Container(
//       margin: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 5),
//       // color: AppColor.rejected_color_text,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           element.iscourtChange?
//            Column(mainAxisSize: MainAxisSize.min,
//             children: [
//               SizedBox(height: 3,),
//               // DottedBorder(
//               //   padding: EdgeInsets.zero,
//               //   borderType: BorderType.Rect,
//               //   color: Colors.redAccent,
//               //   strokeWidth: 2,
//               //   dashPattern: [8, 10],
//               //   child: SizedBox(
//               //     width: mediaQW(context),
//               //     height: 0.05,
//               //   ),
//               // ),
//               Container(
//                 height: 1,
//                 color: Colors.redAccent,
//                 width: mediaQW(context),
//               ),
//               SizedBox(height: 5,),
//             ],
//           ):SizedBox(),
//           element.snoWith.toString() == "with" ||
//               isWithContains(
//                   element.sno.toString(), element.snoWith.toString())
//               ? Container(
//             margin: const EdgeInsets.only(bottom: 5),
//             child: Text(
//               "With",
//               style:
//               appTextStyle(fontWeight: FontWeight.w600, fontSize: 16),
//             ),
//           )
//               : SizedBox(),
//               Card(
//             color: element.is_disposed == true
//                 ? AppColor.disposedColor
//                 : element.is_hide == 1
//                 ? AppColor.text_grey_color
//                 : element.intrimStay.toString().toLowerCase() == "no stay"
//                 ? AppColor.cases_nostay
//                 : element.intrimStay.toString().toLowerCase() ==
//                 "interim stay"
//                 ? AppColor.cases_intrimstay
//                 : element.intrimStay.toString().toLowerCase() ==
//                 "full stay"
//                 ? AppColor.cases_fullstay
//                 : AppColor.white,
//             shape: RoundedRectangleBorder(
//                 side: BorderSide(
//                     color: element.causeListType != null &&
//                         element.causeListType == "Daily"
//                         ? AppColor.white
//                         : AppColor.rejected_color_text)),
//             child: Container(
//               decoration: BoxDecoration(
//                   border: Border(
//                       left: BorderSide(
//                           color: element.caseId != null
//                               ? Colors.transparent
//                               : Colors.blueAccent,
//                           width: 4))),
//               padding: const EdgeInsets.all(10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         child: RichText(
//                           text: TextSpan(
//                               text: "(Court No. ${element.courtNo}) ",
//                               style: mpHeadLine12(
//                                   fontWeight: FontWeight.w600,
//                                   textColor: element.is_disposed == true
//                                       ? AppColor.white
//                                       : AppColor.black),
//                               children: <TextSpan>[
//                                 TextSpan(
//                                     text: element.benchName.toString(),
//                                     style: mpHeadLine12(
//                                         fontWeight: FontWeight.w600,
//                                         textColor: element.is_disposed == true
//                                             ? AppColor.white
//                                             : AppColor.black)),
//                               ]),
//                         ),
//                       ),
//                       InkWell(
//                         onTap: () {
//                           // if (!isPrime(pref)) {
//                           //   FocusScope.of(context).requestFocus(FocusNode());
//                           //   showDialog(
//                           //       context: context,
//                           //       builder: (ctx) => SafeArea(
//                           //         child: GoPrime(),
//                           //       ));
//                           //   return;
//                           // }
//                         },
//                         child: Container(
//                           height: 30,
//                           width: 30,
//                           child: PopupMenuButton<int>(
//                             onSelected: (i) async {
//                               if (i == 3) {
//                                 // if (isPrime(pref) &&
//                                 //     (planName(pref) == Constants.silverPlan)) {
//                                 //   FocusScope.of(context)
//                                 //       .requestFocus(FocusNode());
//                                 //   showDialog(
//                                 //       context: context,
//                                 //       builder: (ctx) => SafeArea(
//                                 //         child: GoPrime(),
//                                 //       ));
//                                 //   return;
//                                 // }
//                                 print("type ${element.causeListType}");
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => ViewCauseListScreen(
//                                           mainCauseListdata: {
//                                             "dateFrom":
//                                             widget.mainCauseListdata[
//                                             "dateFrom"] !=
//                                                 null
//                                                 ? widget
//                                                 .mainCauseListdata[
//                                             "dateFrom"]
//                                                 .toString()
//                                                 : "",
//                                             "dateTo": "",
//                                             "courtNo":
//                                             element.courtNo.toString(),
//                                             "sNo": element.sno,
//                                             "type":
//                                             element.causeListType ?? "",
//                                           },
//                                           isFromHomepage:
//                                           widget.isFromHomepage,
//                                           isDownloadOption:
//                                           widget.isDownloadOption,
//                                           isScrollToSno: true,
//                                           isFilter: widget.isFilter,
//                                         )));
//                               } else if (i == 2) {
//                                 // if (isPrime(pref) &&
//                                 //     (planName(pref) == Constants.silverPlan)) {
//                                 //   FocusScope.of(context)
//                                 //       .requestFocus(FocusNode());
//                                 //   showDialog(
//                                 //       context: context,
//                                 //       builder: (ctx) => SafeArea(
//                                 //         child: GoPrime(),
//                                 //       ));
//                                 //   return;
//                                 // }
//                                 if (element.caseId != null) {
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) => CaseDetails(
//                                             caseId: element.caseId,
//                                             index: 2,
//                                           )));
//                                 } else {
//                                   await Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) =>
//                                               AddCaseCauseList(
//                                                 getCaseNum:
//                                                 element.caseNo.toString(),
//                                               ))).then((value) {
//                                     if (value != null && value) {
//                                       var viewList = {
//                                         "dateFrom": widget.mainCauseListdata[
//                                         "dateFrom"] !=
//                                             null
//                                             ? widget
//                                             .mainCauseListdata["dateFrom"]
//                                             .toString()
//                                             : "",
//                                         "dateTo": widget.mainCauseListdata[
//                                         "dateTo"] !=
//                                             null
//                                             ? widget.mainCauseListdata["dateTo"]
//                                             .toString()
//                                             : "",
//                                         "lawyerName": widget.mainCauseListdata[
//                                         "lawyerName"] !=
//                                             null
//                                             ? widget
//                                             .mainCauseListdata["lawyerName"]
//                                             .toString()
//                                             : "",
//                                         "courtNo": widget.mainCauseListdata[
//                                         "courtNo"] !=
//                                             null
//                                             ? widget
//                                             .mainCauseListdata["courtNo"]
//                                             .toString()
//                                             : "",
//                                         "sNo": "",
//                                         "caseNo": widget.mainCauseListdata[
//                                         "caseNo"] !=
//                                             null
//                                             ? widget.mainCauseListdata["caseNo"]
//                                             .toString()
//                                             : "",
//                                         "benchName": widget.mainCauseListdata[
//                                         "judgeName"] !=
//                                             null
//                                             ? widget
//                                             .mainCauseListdata["judgeName"]
//                                             .toString()
//                                             : "",
//                                         "causeListType":
//                                         widget.mainCauseListdata[
//                                         "causeListType"] !=
//                                             null
//                                             ? widget.mainCauseListdata[
//                                         "causeListType"]
//                                             .toString()
//                                             : "",
//                                         "partyName": widget.mainCauseListdata[
//                                         "partyName"] !=
//                                             null
//                                             ? widget
//                                             .mainCauseListdata["partyName"]
//                                             .toString()
//                                             : "",
//                                         "judgeTime": widget.mainCauseListdata[
//                                         "judgeTime"] !=
//                                             null
//                                             ? widget
//                                             .mainCauseListdata["judgeTime"]
//                                             .toString()
//                                             : "",
//                                       };
//                                       isQuickSearchScroll = false;
//                                       widget.ctx!
//                                           .read<ViewCauseListCubit>()
//                                           .fetchViewCauseList(viewList,
//                                           isQuickSearch:
//                                           widget.isQuickSearch);
//                                     }
//                                   });
//                                 }
//                               } else if (i == 1) {
//                                 showDialog(
//                                     context: context,
//                                     builder: (ctx) {
//                                       return AlertDialog(
//                                         // insetPadding: EdgeInsets.symmetric(vertical: 305),
//                                         contentPadding: EdgeInsets.zero,
//                                         content: SizedBox(
//                                           // width: mediaQW(context) * 0.8,
//                                           child: Column(
//                                             crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                             mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                             mainAxisSize: MainAxisSize.min,
//                                             children: [
//                                               Padding(
//                                                 padding: const EdgeInsets.only(
//                                                     left: 20,
//                                                     right: 20,
//                                                     top: 25),
//                                                 child: Text(
//                                                   "Are you sure you want to hide your cause ${element.caseNo.toString()}",
//                                                   textAlign: TextAlign.center,
//                                                   style: mpHeadLine14(
//                                                       fontWeight:
//                                                       FontWeight.w600),
//                                                 ),
//                                               ),
//                                               const SizedBox(
//                                                 height: 25,
//                                               ),
//                                               Row(
//                                                 children: [
//                                                   Expanded(
//                                                     child: InkWell(
//                                                       onTap: () {
//                                                         var hideListData = {
//                                                           "causeId": element
//                                                               .caseNo
//                                                               .toString(),
//                                                           "causeDate": element
//                                                               .causeListDate
//                                                               .toString(),
//                                                         };
//                                                         BlocProvider.of<
//                                                             HideCauseListCubit>(
//                                                             context)
//                                                             .fetchHideCauseList(
//                                                             hideListData);
//                                                         Navigator.pop(context);
//                                                       },
//                                                       child: Container(
//                                                         alignment:
//                                                         Alignment.center,
//                                                         height:
//                                                         mediaQH(context) *
//                                                             0.05,
//                                                         decoration: BoxDecoration(
//                                                             borderRadius:
//                                                             const BorderRadius
//                                                                 .only(
//                                                                 bottomLeft:
//                                                                 Radius.circular(
//                                                                     5)),
//                                                             border: Border.all(
//                                                                 color: AppColor
//                                                                     .primary)),
//                                                         child: Text(
//                                                           "Yes",
//                                                           style: mpHeadLine16(
//                                                               textColor:
//                                                               AppColor
//                                                                   .primary),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   Expanded(
//                                                     child: InkWell(
//                                                       onTap: () {
//                                                         Navigator.pop(context);
//                                                       },
//                                                       child: Container(
//                                                         alignment:
//                                                         Alignment.center,
//                                                         height:
//                                                         mediaQH(context) *
//                                                             0.05,
//                                                         decoration:
//                                                         const BoxDecoration(
//                                                           borderRadius:
//                                                           BorderRadius.only(
//                                                               bottomRight: Radius
//                                                                   .circular(
//                                                                   5)),
//                                                           color:
//                                                           AppColor.primary,
//                                                         ),
//                                                         child: Text(
//                                                           "No",
//                                                           style: mpHeadLine16(
//                                                               textColor:
//                                                               AppColor
//                                                                   .white),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   )
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       );
//                                     });
//                               } else if (i == 0) {
//                                 showDialog(
//                                     context: context,
//                                     builder: (ctx) {
//                                       return AlertDialog(
//                                         // insetPadding: EdgeInsets.symmetric(vertical: 305),
//                                         contentPadding: EdgeInsets.zero,
//                                         content: SizedBox(
//                                           // width: mediaQW(context) * 0.8,
//                                           child: Column(
//                                             crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                             mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                             mainAxisSize: MainAxisSize.min,
//                                             children: [
//                                               Padding(
//                                                 padding: const EdgeInsets.only(
//                                                     left: 20,
//                                                     right: 20,
//                                                     top: 25),
//                                                 child: Text(
//                                                   "Are you sure you want to hide your cause ${element.caseNo.toString()} for today",
//                                                   textAlign: TextAlign.center,
//                                                   style: mpHeadLine14(
//                                                       fontWeight:
//                                                       FontWeight.w600),
//                                                 ),
//                                               ),
//                                               const SizedBox(
//                                                 height: 25,
//                                               ),
//                                               Row(
//                                                 children: [
//                                                   Expanded(
//                                                     child: InkWell(
//                                                       onTap: () {
//                                                         var hideListData = {
//                                                           "causeId": element
//                                                               .caseNo
//                                                               .toString(),
//                                                           "causeDate": element
//                                                               .causeListDate
//                                                               .toString(),
//                                                           "hideType": "1"
//                                                         };
//                                                         BlocProvider.of<
//                                                             HideCauseListCubit>(
//                                                             context)
//                                                             .fetchHideCauseList(
//                                                             hideListData);
//                                                         Navigator.pop(context);
//                                                       },
//                                                       child: Container(
//                                                         alignment:
//                                                         Alignment.center,
//                                                         height:
//                                                         mediaQH(context) *
//                                                             0.05,
//                                                         decoration: BoxDecoration(
//                                                             borderRadius:
//                                                             const BorderRadius
//                                                                 .only(
//                                                                 bottomLeft:
//                                                                 Radius.circular(
//                                                                     5)),
//                                                             border: Border.all(
//                                                                 color: AppColor
//                                                                     .primary)),
//                                                         child: Text(
//                                                           "Yes",
//                                                           style: mpHeadLine16(
//                                                               textColor:
//                                                               AppColor
//                                                                   .primary),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   Expanded(
//                                                     child: InkWell(
//                                                       onTap: () {
//                                                         Navigator.pop(context);
//                                                       },
//                                                       child: Container(
//                                                         alignment:
//                                                         Alignment.center,
//                                                         height:
//                                                         mediaQH(context) *
//                                                             0.05,
//                                                         decoration:
//                                                         const BoxDecoration(
//                                                           borderRadius:
//                                                           BorderRadius.only(
//                                                               bottomRight: Radius
//                                                                   .circular(
//                                                                   5)),
//                                                           color:
//                                                           AppColor.primary,
//                                                         ),
//                                                         child: Text(
//                                                           "No",
//                                                           style: mpHeadLine16(
//                                                               textColor:
//                                                               AppColor
//                                                                   .white),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   )
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       );
//                                     });
//                               }
//                             },
//                             padding: const EdgeInsets.all(10),
//                             icon: Icon(
//                               Icons.more_vert_outlined,
//                               size: 24,
//                               color: element.is_disposed == true
//                                   ? AppColor.white
//                                   : AppColor.black,
//                             ),
//                             itemBuilder: (context) =>
//                             // !isPrime(pref)
//                             //     ? []
//                             //     :
//                             [
//                               // popupmenu item 1
//                               if (element.is_hide != 1)
//                                 const PopupMenuItem(
//                                   value: 0,
//                                   child: Text(
//                                     "Hide notifications - (today only)",
//                                   ),
//                                 ),
//                               if (element.is_hide != 1)
//                                 const PopupMenuItem(
//                                   value: 1,
//                                   child: Text("Hide"),
//                                 ),
//                               // popupmenu item 2
//                               PopupMenuItem(
//                                 value: 2,
//                                 child: Text(element.caseId != null
//                                     ? "Case Details"
//                                     : "Create Case"),
//                               ),
//                               if (widget.isGotoCourt)
//                                 const PopupMenuItem(
//                                   value: 3,
//                                   child: Text("Go to court causelist"),
//                                 ),
//                             ],
//                             // enabled: isPrime(pref),
//                             color: Colors.white,
//                             elevation: 2,
//                           ),
//                         ),
//                       ),
//                       causeDate.difference(now).inDays > -1
//                           ? InkWell(
//                         onTap: () {
//                           Map<String, String> summary = {
//                             "dateToday": getYYYYMMDD(
//                                 element.causeListDate.toString()),
//                             "courtNo": element.courtNo.toString(),
//                             "benchName": element.benchName != null
//                                 ? element.benchName.toString()
//                                 : "",
//                           };
//                           showDialog(
//                               context: context,
//                               barrierDismissible: true,
//                               builder: (BuildContext context) {
//                                 return CourtInfo(summary);
//                               });
//                         },
//                         child: Container(
//                           height: 30,
//                           width: 30,
//                           alignment: Alignment.bottomCenter,
//                           child: Icon(
//                             Icons.info,
//                             color: AppColor.primary,
//                             size: 20,
//                           ),
//                         ),
//                       )
//                           : SizedBox(),
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 5,
//                   ),
//                   element.is_hide==1 ||  element.snoWith.toString() == "with" ||
//                       isWithContains(
//                           element.sno.toString(), element.snoWith.toString())?
//                   IgnorePointer(
//                     ignoring: element.is_hide!=1 &&
//                         ( element.snoWith.toString() != "with" &&
//                             !isWithContains(
//                                 element.sno.toString(), element.snoWith.toString())),
//                     ignoringSemantics: true,
//                     child: CustomExpansionTile(childrenPadding: EdgeInsets.zero,
//                       title: Row(
//                         children: [
//                           Text("Sr. No: " + element.sno.toString(),
//                               style: mpHeadLine12(
//                                   fontWeight: FontWeight.w600,
//                                   textColor: element.is_disposed == true
//                                       ? AppColor.white
//                                       : AppColor.black)),
//                           HighlightText(
//                             element.causeListType != null &&
//                                 element.causeListType == "Daily"
//                                 ? " (D)"
//                                 : " (S)",
//                             "(S)",
//                             mpHeadLine12(
//                                 fontWeight: FontWeight.w500,
//                                 textColor: element.is_disposed == true
//                                     ? AppColor.white
//                                     : AppColor.black),
//                             mpHeadLine12(
//                                 fontWeight: FontWeight.w500,
//                                 textColor: Colors.red),
//                           ),
//                           const SizedBox(
//                             width: 20,
//                           ),
//                           Flexible(
//                             child: Text(
//                               element.caseNo.toString(),
//                               style: mpHeadLine14(
//                                   fontWeight: FontWeight.bold,
//                                   textColor: element.is_disposed == true
//                                       ? AppColor.white
//                                       : AppColor.black),
//                             ),
//                           ),
//                         ],
//                       ),
//                       trailing: (element.is_hide!=1 &&
//                           ( element.snoWith.toString() != "with" &&
//                               !isWithContains(
//                                   element.sno.toString(), element.snoWith.toString())))
//                           ? const SizedBox()
//                           : Icon(
//                         element.isHideExpanded!=null && element.isHideExpanded
//                             ? Icons.keyboard_arrow_up
//                             : Icons.keyboard_arrow_down,
//                         color: Colors.black,
//                       ),
//                       tilePadding: EdgeInsets.zero,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.zero
//                       ),
//                       collapsedShape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.zero
//                       ),
//                       initiallyExpanded: element.is_hide!=1 &&
//                           ( element.snoWith.toString() != "with" &&
//                               !isWithContains(
//                                   element.sno.toString(), element.snoWith.toString())),
//                       maintainState: true,
//                       onExpansionChanged: (changeValue) {
//                         //print("changeValue $changeValue");
//                         if (element.is_hide==1 ||  element.snoWith.toString() == "with" ||
//                             isWithContains(
//                                 element.sno.toString(), element.snoWith.toString())) {
//                           setState(() {
//                             element.isHideExpanded = changeValue;
//                           });
//                         }
//                       },
//                       expandedCrossAxisAlignment: CrossAxisAlignment.start,
//                       children: [Container(
//                           margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
//                           child: expansionSubCard(element))],
//                     ),
//                   ):
//                   Column(
//                     children: [
//                       const SizedBox(
//                         height: 0,
//                       ),
//                       Row(
//                         children: [
//                           Text("Sr. No: " + element.sno.toString(),
//                               style: mpHeadLine12(
//                                   fontWeight: FontWeight.w600,
//                                   textColor: element.is_disposed == true
//                                       ? AppColor.white
//                                       : AppColor.black)),
//                           Flexible(
//                             child: HighlightText(
//                               element.causeListType != null &&
//                                   element.causeListType == "Daily"
//                                   ? " (D)"
//                                   : " (S)",
//                               "(S)",
//                               mpHeadLine12(
//                                   fontWeight: FontWeight.w500,
//                                   textColor: element.is_disposed == true
//                                       ? AppColor.white
//                                       : AppColor.black),
//                               mpHeadLine12(
//                                   fontWeight: FontWeight.w500,
//                                   textColor: Colors.red),
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 20,
//                           ),
//                           Text(
//                             element.caseNo.toString(),
//                             style: mpHeadLine14(
//                                 fontWeight: FontWeight.bold,
//                                 textColor: element.is_disposed == true
//                                     ? AppColor.white
//                                     : AppColor.black),
//                           ),
//                         ],
//                       ),
//                       expansionSubCard(element),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),
//           //newList.indexOf(element)!=0 &&
//
//         ],
//       ),
//     );
//   }
//
//
//   Widget expansionSubCard(element){
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//     children:  [
//       SizedBox(
//         height: element.bench_info != null &&
//             element.bench_info.isNotEmpty
//             ? 10
//             : 0,
//       ),
//       element.bench_info != null && element.bench_info.isNotEmpty
//           ? Row(
//         children: [
//           Text("Bunch Info: ",
//               style: mpHeadLine12(
//                   fontWeight: FontWeight.w600,
//                   textColor: Colors.red)),
//           Flexible(
//               child:
//               bunchInfoHighlight("${element.bench_info}")
//
//             // Text(
//             //   "${element.bench_info}",
//             //   style: mpHeadLine12(
//             //     fontWeight: FontWeight.w500,
//             //   ),
//             // ),
//           ),
//         ],
//       )
//           : SizedBox(),
//         const SizedBox(
//           height: 10,
//         ),
//         Text(
//           element.stage.toString(),
//           style: mpHeadLine12(
//               textColor: element.is_disposed == true
//                   ? AppColor.white
//                   : AppColor.black),
//         ),
//         const SizedBox(
//           height: 8,
//         ),
//         InkWell(
//           onTap: () {
//             //print("party name click ${element.caseId}");
//             if (element.caseId != null) {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => CaseDetails(
//                         caseId: element.caseId,
//                         index: 2,
//                       )));
//             }
//           },
//           child: Text(
//             element.partyName.toString(),
//             style: mpHeadLine12(
//                 fontWeight: FontWeight.w600,
//                 textColor: AppColor.primary),
//           ),
//         ),
//         const Divider(
//           thickness: 2,
//           color: AppColor.primary,
//         ),
//         const SizedBox(
//           height: 5,
//         ),
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Petitioner:",
//               style: mpHeadLine12(
//                   fontWeight: FontWeight.w500,
//                   textColor: element.is_disposed == true
//                       ? AppColor.white
//                       : AppColor.black),
//             ),
//             const SizedBox(
//               width: 2,
//             ),
//             Flexible(
//               child: Text(element.petitioner.toString(),
//                   style: mpHeadLine12(
//                       fontWeight: FontWeight.w400,
//                       textColor: element.is_disposed == true
//                           ? AppColor.white
//                           : AppColor.black)),
//             )
//           ],
//         ),
//         const SizedBox(
//           height: 8,
//         ),
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Respondent:",
//               style: mpHeadLine12(
//                   fontWeight: FontWeight.w500,
//                   textColor: element.is_disposed == true
//                       ? AppColor.white
//                       : AppColor.black),
//             ),
//             const SizedBox(
//               width: 2,
//             ),
//             Flexible(
//                 child: Text(element.respondent.toString(),
//                     style: mpHeadLine12(
//                         fontWeight: FontWeight.w400,
//                         textColor: element.is_disposed == true
//                             ? AppColor.white
//                             : AppColor.black)))
//           ],
//         ),
//         const SizedBox(
//           height: 8,
//         ),
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Flexible(
//                 child: Text(element.bottomNo.toString(),
//                     style: mpHeadLine12(
//                         fontWeight: FontWeight.w500,
//                         textColor: element.is_disposed == true
//                             ? AppColor.white
//                             : AppColor.black)))
//           ],
//         ),
//       ]
//     );
//   }
//
//   Text bunchInfoHighlight(String data) {
//     List<String> dataList = data.split(",");
//
//     int indx = dataList.indexWhere((element) => element.startsWith("1-"));
//     List<TextSpan> spans = [];
//     if (indx != -1) {
//       List first = dataList.sublist(0, indx);
//       List second = dataList.sublist(indx, dataList.length);
//       TextSpan span1 = TextSpan(
//         text: first.join(",") + ",",
//         style: mpHeadLine12(
//             fontWeight: FontWeight.w500,
//             textColor: AppColor.rejected_color_text),
//       );
//       TextSpan span2 = TextSpan(
//         text: second.join(","),
//         style: mpHeadLine12(
//             fontWeight: FontWeight.w500, textColor: AppColor.black),
//       );
//       spans.add(span1);
//       spans.add(span2);
//     } else {
//       TextSpan span = TextSpan(
//         text: data,
//         style: mpHeadLine12(
//             fontWeight: FontWeight.w500, textColor: AppColor.black),
//       );
//       spans.add(span);
//     }
//
//     return Text.rich(TextSpan(children: spans));
//   }
//
//   pauseLoader() {
//     Future.delayed(Duration(seconds: 1), () {
//       setState(() {
//         isLoading = false;
//       });
//       if (widget.isScrollToSno &&
//           viewCauseListData != null &&
//           viewCauseListData!.causelist != null) {
//         print("sno callback");
//         sNoCallback(widget.mainCauseListdata["sNo"].toString(),
//             widget.mainCauseListdata["type"].toString());
//         widget.isScrollToSno = false;
//         isSnoScroll = true;
//       }
//
//       if (widget.isQuickSearch &&
//           !isQuickSearchScroll &&
//           viewCauseListData != null &&
//           viewCauseListData!.causelist != null) {
//         print("widget.quickScrollDate ${widget.quickScrollDate}");
//         dateSelectCallback(
//             getddMMYYYY_with_splash(widget.quickScrollDate.toString()),
//             isNextDateScroll: true);
//
//         isQuickSearchScroll = true;
//       }
//     });
//   }
//
//   void dateSelectCallback(String date, {bool isNextDateScroll = false}) {
//     setState(() {
//       isPartialLoading=true;
//     });
//     print("isPartialLoading2304 $isPartialLoading");
//     print("dateSelectCallback $date");
//     int index = newList!
//         .indexWhere((element) => date == element.causeListDate);
//     print("dateSelectCallback index $index");
//
//     if (index == -1 && isNextDateScroll) {
//       recursiveDateScroll(date);
//     } else if (index != -1) {
//       print("inside else");
//       // SchedulerBinding.instance.addPostFrameCallback((_) {
//         print("schedule");
//
//
//         _outerScrollController!.scrollToIndex(index,
//             preferPosition: AutoScrollPosition.begin).then((value) {
//           print("ourcrollview");
//           setState(() {
//             print("outer setstate ");
//             isPartialLoading=false;
//           });
//         });
//       // });
//       print("isPartialLoading2321 $isPartialLoading");
//     }else{
//       setState(() {
//         isPartialLoading=false;
//       });
//     }
//   }
//
//   void recursiveDateScroll(String date) {
//     recursiveDateCall++;
//     DateFormat format = DateFormat("dd/MM/yyyy");
//     int index = newList.indexWhere((element) =>
//     element.causeListDate ==
//         getDDMMYYYY(format.parse(date).add(Duration(days: 1)).toString()));
//     print("isNextDateScroll index $index");
//     if (index != -1) {
//       SchedulerBinding.instance.addPostFrameCallback((_) {
//         _outerScrollController!.scrollToIndex(index, preferPosition: AutoScrollPosition.begin)
//         .then((value) {
//           setState(() {
//             isPartialLoading=false;
//           });
//         });
//
//       });
//     } else {
//       DateFormat format = DateFormat("dd/MM/yyyy");
//       print("calling recursive");
//       if (recursiveDateCall < 8) {
//         recursiveDateScroll(
//             getDDMMYYYY(format.parse(date).add(Duration(days: 1)).toString()));
//       }
//       else{
//         setState(() {
//           isPartialLoading=false;
//         });
//       }
//     }
//   }
//
//   void courtSelectCallback(String court) {
//     setState(() {
//       isPartialLoading=true;
//     });
//     print("courtSelectCallback $court");
//     int index = newList
//         .indexWhere((element) => court == element.courtNo);
//     print("index $index");
//     SchedulerBinding.instance.addPostFrameCallback((_) {
//       _outerScrollController!.scrollToIndex(index, preferPosition: AutoScrollPosition.begin) .then((value) {
//         setState(() {
//           isPartialLoading=false;
//         });
//       });
//
//     });
//   }
//
//   void datesCourtSelectCallback(String date, String courtNo) {
//     print("courtSelectCallback");
//     setState(() {
//       isPartialLoading=true;
//     });
//     int index = newList
//         .indexWhere((element) => date == element.causeListDate &&
//         courtNo== element.courtNo);
//
//     SchedulerBinding.instance.addPostFrameCallback((_) {
//       _outerScrollController!.scrollToIndex(index,
//         preferPosition: AutoScrollPosition.begin,
//         duration: Duration(milliseconds: 100)
//       ) .then((value) {
//         setState(() {
//           isPartialLoading=false;
//         });
//       });
//     });
//   }
//
//   void sNoCallback(String sno, String type) {
//     print("snocallback $sno  and type $type");
//     setState(() {
//       isPartialLoading=true;
//     });
//     if (newList.isNotEmpty) {
//       int index = newList.indexWhere((element) =>
//       element.sno!.contains(sno) && element.causeListType == type);
//       print("snocallback index $index");
//       if (index != -1) {
//         SchedulerBinding.instance.addPostFrameCallback((_) {
//           _outerScrollController!.scrollToIndex(index,
//               preferPosition: AutoScrollPosition.begin) .then((value) {
//             setState(() {
//               isPartialLoading=false;
//             });
//           });
//         });
//       }else{
//         setState(() {
//           isPartialLoading=false;
//         });
//       }
//     }
//   }
//
//   void searchFilterList(String searchKey) {
//     setState(() {
//       searchList = [];
//       _searchFirstVisibleIndex=0;
//     });
//     for (var item in viewCauseListData!.causelist!) {
//       if (item.courtNo!.toLowerCase().contains(searchKey) ||
//           item.petitioner!.toLowerCase().contains(searchKey) ||
//           item.benchName!.toLowerCase().contains(searchKey) ||
//           item.caseNo!.toLowerCase().contains(searchKey) ||
//           item.partyName!.toLowerCase().contains(searchKey) ||
//           item.respondent!.toLowerCase().contains(searchKey) ||
//           item.sno!.toLowerCase().contains(searchKey) ||
//           item.bottomNo!.toLowerCase().contains(searchKey) ||
//           item.stage!.toLowerCase().contains(searchKey) ||
//           item.causeListDate!.toLowerCase().contains(searchKey) ||
//           item.bench_info != null &&
//               item.bench_info!.toLowerCase().contains(searchKey)) {
//         if (!searchList.contains(item)) {
//           searchList.add(item);
//         }
//       }
//     }
//
//     for(int i=0; i<searchList.length; i++){
//       if(i==0 || searchList[i].courtNo=="Before Registrar (Admin.)" ||
//           searchList[i].courtNo=="Before Registrar (Admin.)" ||
//           searchList[i].courtNo=="Before Dy. Registrar (Judicial)"){
//         searchList[i].iscourtChange=false;
//       }else{
//         if(searchList[i-1].courtNo=="Before Registrar (Admin.)"){
//           searchList[i].iscourtChange=true;
//         }else if(searchList[i-1].courtNo=="Before Dy. Registrar (Judicial)"){
//           searchList[i].iscourtChange=true;
//         }else
//         if(int.parse(searchList[i].courtNo!)!=int.parse(searchList[i-1].courtNo!)){
//           searchList[i].iscourtChange=true;
//         }else{
//           searchList[i].iscourtChange=false;
//         }
//       }
//     }
//
//     //print("searchlist length ${searchList.length}");
//     isSearchFilter = true;
//     setState(() {});
//   }
//
//   downloadData(String file, String fileName) async {
//     await downloadFiles(file, fileName);
//   }
//
//   bool isWithContains(sno, snoWith) {
//     if (snoWith.isEmpty) {
//       if (sno.contains("With")) {
//         return true;
//       }
//     }
//     return false;
//   }
// }