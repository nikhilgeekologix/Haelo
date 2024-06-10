// import 'package:dotted_border/dotted_border.dart';
// import 'package:inview_notifier_list/inview_notifier_list.dart';
// import 'package:scroll_to_index/scroll_to_index.dart';
// import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
// import 'package:scrollview_observer/scrollview_observer.dart';
// // import 'package:sticky_grouped_list/sticky_grouped_list.dart';
// import 'package:sticky_headers/sticky_headers.dart';
// import 'package:flutter/material.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:haelo_flutter/constants.dart';
// import 'package:haelo_flutter/core/utils/functions.dart';
// import 'package:haelo_flutter/core/utils/save_file.dart';
// import 'package:haelo_flutter/core/utils/ui_helper.dart';
// import 'package:haelo_flutter/features/alert/cubit/my_alert_cubit.dart';
// import 'package:haelo_flutter/features/alert/cubit/my_alert_state.dart';
// import 'package:haelo_flutter/features/bottom_bar/presentation/screens/bottombar.dart';
// import 'package:haelo_flutter/features/cases/cubit/deletecomment_state.dart';
// import 'package:haelo_flutter/features/cases/presentation/screens/addcomment.dart';
// import 'package:haelo_flutter/features/cases/presentation/screens/casedetails.dart';
// import 'package:haelo_flutter/features/cases/presentation/screens/updatecomment.dart';
// import 'package:haelo_flutter/features/cases/presentation/widgets/color_node.dart';
// import 'package:haelo_flutter/features/cases/presentation/widgets/no_data_widget.dart';
// import 'package:haelo_flutter/features/cases/presentation/widgets/pdf_screen.dart';
// import 'package:haelo_flutter/features/causeslist/presentation/screen/addcase_causelist.dart';
// import 'package:haelo_flutter/features/causeslist/presentation/widget/datelist_dialog.dart';
// import 'package:haelo_flutter/features/home_page/presentation/screens/quicksearch_homepage.dart';
// import 'package:haelo_flutter/features/home_page/presentation/widgets/case_info.dart';
// import 'package:haelo_flutter/features/order_comment_history/cubit/order_comment_history_cubit.dart';
// import 'package:haelo_flutter/features/order_comment_history/cubit/office_stage_state.dart';
// import 'package:haelo_flutter/features/order_comment_history/data/model/WatchlistDataType.dart';
// import 'package:haelo_flutter/widgets/date_format.dart';
// import 'package:haelo_flutter/widgets/error_widget.dart';
// import 'package:haelo_flutter/widgets/progress_indicator.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:haelo_flutter/locators.dart' as di;
// import '../../../cases/cubit/deletecomment_cubit.dart';
// import 'package:haelo_flutter/features/alert/data/model/my_alert_model.dart';
// import 'package:haelo_flutter/features/order_comment_history/data/model/order_comment_history_model.dart';
// import 'package:collection/collection.dart';
//
// class OrderCmtHistory2 extends StatefulWidget {
//   WatchListDataType? selectedLawyer;
//
//   OrderCmtHistory2({this.selectedLawyer});
//
//   @override
//   State<OrderCmtHistory2> createState() => _OrderCmtHistoryState();
// }
//
// class _OrderCmtHistoryState extends State<OrderCmtHistory2> {
//   WatchListDataType? selectedLawyer;
//   bool isLoading = true;
//
//   List causeList = [];
//   List<Lawyerlist> lawyerList = [];
//   List<Watchlist> watchList = [];
//   List dates = [];
//   List<CaseList>? caseList = [];
//
//   int recursiveDateCall = 0;
//   late SharedPreferences pref;
//   List<WatchListDataType>? dropDownList = [];
//   bool isDrag = false;
//
//   BuildContext? builderContext;
//   List<int> staticHeightList = [];
//
//   List<CaseList> newList = [];
//   double _firstVisibleIndex = 0;
//   int _horizontalDateIndex = 0;
//
//
//   final ScrollController _horizontalDateController = ScrollController();
//    ScrollController tempScrlollController = ScrollController();
//   ScrollOffsetListener scrollOffsetListener = ScrollOffsetListener.create();
//   final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
//
//   ItemScrollController itemScrollController =
//   ItemScrollController();
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
//   void initState() {
//     pref = di.locator();
//     BlocProvider.of<MyAlertCubit>(context).fetchMyAlert();
//
//     // print("scrollOffsetListener.changes.first ${scrollOffsetListener.changes.first}");
//
//     itemPositionsListener!.itemPositions.addListener(() {
//       // print("ok ${itemPositionsListener.itemPositions.value.first}");
//       if (_firstVisibleIndex !=
//           itemPositionsListener!.itemPositions.value.first.index) {
//         WidgetsBinding.instance!.addPostFrameCallback(
//               (_) {
//             setState(() {
//               _firstVisibleIndex =
//                   itemPositionsListener!.itemPositions.value.first.index.toDouble();
//             });
//             // print("_firstVisibleIndex ${_firstVisibleIndex}");
//             // print("_firstVisibleIndex date ${newList[_firstVisibleIndex.floor()].causeListDate!}");
//             // print("_firstVisibleIndex caselist ${caseList![_firstVisibleIndex.floor()].causeListDate!}");
//             int idxx = dates.indexWhere((element) =>
//             element ==
//                 getddMMYYYY_with_splash(
//                     newList[_firstVisibleIndex.floor()].causeListDate!));
//             if (_horizontalDateIndex != idxx) {
//               _horizontalDateIndex = idxx;
//               print("_horizontalDateIndex; $_horizontalDateIndex");
//               _goToElement(idxx);
//             }
//           },
//         );
//       }
//     });
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     // WidgetsBinding.instance!.removeObserver(this);
//     super.dispose();
//   }
//
//   void fetchData() {
//     isDrag = false;
//     var body = {"lawyerName": selectedLawyer!.lawyerName.toString()};
//     BlocProvider.of<OrderCommentHistoryCubit>(context)
//         .fetchOrderCmtHistory(body);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.home_background,
//       appBar: AppBar(
//         leading: GestureDetector(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           child: const Icon(
//             Icons.arrow_back_ios_new_sharp,
//             size: 24,
//           ),
//         ),
//         backgroundColor: AppColor.white,
//         titleSpacing: 0,
//         centerTitle: false,
//         title: Text(
//           "Order Comment History2",
//           style: mpHeadLine16(
//               fontWeight: FontWeight.w500,
//               textColor: AppColor.bold_text_color_dark_blue),
//         ),
//         actions: [
//           GestureDetector(
//             onTap: () {
//               goToHomePage(context);
//             },
//             child: const Padding(
//               padding: EdgeInsets.only(right: 15),
//               child: Icon(
//                 Icons.home_outlined,
//                 size: 30,
//               ),
//             ),
//           )
//         ],
//       ),
//       body: Stack(
//         children: [
//           BlocConsumer<MyAlertCubit, MyAlertState>(
//             builder: (context, state) {
//               return const SizedBox();
//             },
//             listener: (context, state) {
//               if (state is MyAlertLoading) {
//                 setState(() {
//                   isLoading = true;
//                   isDrag = false;
//                 });
//               }
//               if (state is MyAlertLoaded) {
//                 var alertModel = state.myAlertModel;
//                 if (alertModel.result == 1) {
//                   isDrag = false;
//                   setState(() {
//                     caseList = [];
//                     newList = [];
//                     _firstVisibleIndex = 0;
//                     causeList = alertModel.data!.causeWatchlist ?? [];
//                     lawyerList = alertModel.data!.lawyerlist ?? [];
//                     watchList = alertModel.data!.watchlist ?? [];
//                     dropDownList = [];
//
//                     for (int i = 0; i < causeList!.length; i++) {
//                       if (causeList[i].watchlistName != null &&
//                           causeList[i].watchlistName!.isNotEmpty) {
//                         dropDownList!.add(
//                           WatchListDataType(
//                             "causelist",
//                             lawyerName: causeList[i].lawyerlist != null
//                                 ? causeList[i].lawyerlist
//                                 : "",
//                             watchlistName: causeList[i].watchlistName,
//                           ),
//                         );
//                       }
//                     }
//
//                     for (int j = 0; j < lawyerList!.length; j++) {
//                       dropDownList!.add(WatchListDataType("lawyer",
//                           lawyerName: lawyerList[j].lawyerName != null &&
//                                   lawyerList[j]
//                                       .lawyerName!
//                                       .toString()
//                                       .isNotEmpty
//                               ? lawyerList[j].lawyerName!
//                               : lawyerList[j].selectedCaseNo ?? ""));
//                     }
//
//                     for (int k = 0; k < watchList!.length; k++) {
//                       if (watchList[k].watchlistName != null &&
//                           watchList[k].watchlistName!.isNotEmpty) {
//                         dropDownList!.add(
//                           WatchListDataType(
//                             "watchlist",
//                             watchlistName: watchList[k].watchlistName,
//                             lawyerName: watchList[k].caselist!.join(","),
//                           ),
//                         );
//                       }
//                     }
//                     //SHARAD KOTHARI,LALIT PAREEK   new
//                     //SHARAD KOTHARI,LALIT PAREEK   new
//
//                     if (dropDownList!.isNotEmpty) {
//                       if (widget.selectedLawyer != null) {
//                         print("previous data");
//                         print("previous ${widget.selectedLawyer!.lawyerName}");
//                         int idx = dropDownList!.indexWhere((element) =>
//                             element.lawyerName ==
//                             widget.selectedLawyer!.lawyerName);
//                         print("idx $idx");
//                         if (idx != -1) {
//                           selectedLawyer = dropDownList![idx];
//                         } else {
//                           int inx = dropDownList!.indexWhere((element) =>
//                               element.caseNo == widget.selectedLawyer!.caseNo);
//                           print("inx $inx");
//                           if (inx != -1) {
//                             selectedLawyer = dropDownList![inx];
//                           } else {
//                             selectedLawyer = dropDownList![0];
//                           }
//                         }
//                         // selectedLawyer = widget.selectedLawyer;
//                       } else {
//                         selectedLawyer = dropDownList![0];
//                         print("new data");
//                         print("new ${selectedLawyer!.lawyerName}");
//                       }
//                       fetchData();
//                     }
//                     isLoading = false;
//                   });
//                 } else {
//                   setState(() {
//                     causeList = [];
//                     lawyerList = [];
//                     watchList = [];
//                     isLoading = false;
//                     isDrag = false;
//                   });
//                 }
//               }
//             },
//           ),
//           AbsorbPointer(
//             absorbing: isLoading,
//             child: Opacity(
//               opacity: !isLoading ? 1.0 : 0.0,
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Row(
//                         children: [
//                           ColorNode(AppColor.white, "Not set"),
//                           ColorNode(AppColor.cases_nostay, "No stay"),
//                           ColorNode(AppColor.cases_intrimstay, "Interim stay"),
//                           ColorNode(AppColor.cases_fullstay, "Full stay"),
//                           ColorNode(AppColor.disposedColor, "Disposed"),
//                           ColorNode(AppColor.text_grey_color, "Hidden"),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         "Note: History will be for last 7 days rolling.",
//                         style: mpHeadLine12(textColor: Colors.red.shade800),
//                         textAlign: TextAlign.start,
//                       ),
//                     ),
//                   ),
//                   dropDownList!.isNotEmpty
//                       ? Container(
//                           height: 35,
//                           width: mediaQW(context),
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.black54, width: 1),
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                           margin:
//                               EdgeInsets.symmetric(vertical: 5, horizontal: 15),
//                           padding: EdgeInsets.symmetric(horizontal: 10),
//                           child: DropdownButton<WatchListDataType>(
//                             value: selectedLawyer!,
//                             underline: SizedBox(),
//                             isExpanded: true,
//                             onChanged: (WatchListDataType? newValue) {
//                               setState(() {
//                                 if (newValue != selectedLawyer) {
//                                   _firstVisibleIndex=0;
//                                   selectedLawyer = newValue!;
//                                   fetchData();
//                                 }
//                               });
//                             },
//                             items: dropDownList!
//                                 .map<DropdownMenuItem<WatchListDataType>>(
//                                     (value) {
//                               return DropdownMenuItem<WatchListDataType>(
//                                 value: value,
//                                 child: Text(
//                                   value.type == "causelist" ||
//                                           value.type == "watchlist"
//                                       ? value.watchlistName!
//                                       : value.lawyerName!,
//                                   style:
//                                       mpHeadLine16(textColor: AppColor.black),
//                                 ),
//                                 // value: value.lawyerName != null &&
//                                 //         value.lawyerName!.isNotEmpty
//                                 //     ? value.lawyerName
//                                 //     : value.selectedCaseNo,
//                                 // child: Text(value.lawyerName != null &&
//                                 //         value.lawyerName!.isNotEmpty
//                                 //     ? value.lawyerName!
//                                 //     : value.selectedCaseNo!),
//                               );
//                             }).toList(),
//                           ),
//                         )
//                       : isLoading
//                           ? SizedBox()
//                           : NoDataAvailable("Data not found."),
//                   Expanded(
//                     child: BlocConsumer<OrderCommentHistoryCubit,
//                         OrderCommentHistoryState>(builder: (context, state) {
//                       if (state is OrderCommentHistoryLoaded) {
//                         var model = state.model;
//                         if (model.result == 1 && model.data != null) {
//                           return Stack(
//                             children: [
//                               Container(
//                           margin: EdgeInsets.only(top: 20),
//                                 child: Scrollbar(
//                                   // trackVisibility: true,
//                                   // thumbVisibility: true,
//                                   controller: itemScrollController.scrollController,
//                                   interactive: true,
//                                   thickness: 15,
//                                   radius: Radius.circular(5),
//                                   // notificationPredicate: (pred){
//                                   //   _firstVisibleIndex = (((newList.length/pred.metrics.maxScrollExtent)
//                                   //       * pred.metrics.pixels));
//                                   //         // if (_firstVisibleIndex.isNaN || _firstVisibleIndex.isInfinite){
//                                   //         //   _firstVisibleIndex=0;
//                                   //         // }
//                                   //         print("currentIndex $_firstVisibleIndex");
//                                   //   WidgetsBinding.instance!.addPostFrameCallback(
//                                   //                 (_) {
//                                   //         setState(() {
//                                   //         });
//                                   //         });
//                                   //         return true;
//                                   // },
//                                   child: ScrollablePositionedList.builder(
//                                     itemCount: newList.length,
//                                     itemBuilder: (context, index) => historyCard(newList[index]),
//                                     itemScrollController: itemScrollController,
//                                     shrinkWrap: true,
//                                      scrollController: itemScrollController.scrollController,
//                                     // scrollOffsetController: scrollOffsetController,
//                                     itemPositionsListener: itemPositionsListener,
//                                      scrollOffsetListener: scrollOffsetListener,
//                                   )
//                                 ),
//                               ),
//                               newList.isNotEmpty
//                                   ? Positioned(
//                                 top: 0,
//                                 left: 10,
//                                 right: 20,
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     borderRadius:
//                                     BorderRadius.circular(5),
//                                     color: Colors.white,
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color:
//                                         Colors.grey.withOpacity(0.5),
//                                         spreadRadius: 2,
//                                         blurRadius: 3,
//                                         offset: Offset(0,
//                                             3), // changes position of shadow
//                                       ),
//                                     ],
//                                   ),
//                                   alignment: Alignment.center,
//                                   padding: EdgeInsets.symmetric(
//                                       vertical: 1, horizontal: 10),
//                                   height: 35,
//                                   width: mediaQW(context),
//                                   child: ListView(
//                                       scrollDirection: Axis.horizontal,
//                                       controller:
//                                       _horizontalDateController,
//                                       shrinkWrap: true,
//                                       children: dates.map((e) {
//                                         return InkWell(
//                                           onTap: (){
//                                             dateSelectCallback(e);
//                                           },
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                                 borderRadius:
//                                                 BorderRadius.circular(
//                                                     5),
//                                                 color: e ==
//                                                     getddMMYYYY_with_splash(
//                                                         newList[_firstVisibleIndex.floor()]
//                                                             .causeListDate!)
//                                                     ? AppColor.primary
//                                                     : AppColor.white,
//                                                 border: Border.all(
//                                                   color: AppColor.primary,
//                                                 )),
//                                             margin:
//                                             EdgeInsets.only(right: 10),
//                                             alignment: Alignment.center,
//                                             padding:
//                                             const EdgeInsets.symmetric(
//                                                 horizontal: 16,
//                                                 vertical: 5),
//                                             child: Row(
//                                               mainAxisSize:
//                                               MainAxisSize.min,
//                                               mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                               children: [
//                                                 Text(
//                                                   "${e}",
//                                                   style: appTextStyle(
//                                                     textColor: e ==
//                                                         getddMMYYYY_with_splash(
//                                                             newList[_firstVisibleIndex.floor()]
//                                                                 .causeListDate!)
//                                                         ? AppColor.white
//                                                         : AppColor.primary,
//                                                   ),
//                                                   textAlign:
//                                                   TextAlign.center,
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         );
//                                       }).toList()),
//                                 ),
//                               )
//                                   : SizedBox(),
//                             ],
//                           );
//                         } else {
//                           return NoDataAvailable("Data not found.");
//                         }
//                       }
//                       return SizedBox();
//                     }, listener: (context, state) {
//                       if (state is OrderCommentHistoryLoading) {
//                         setState(() {
//                           isLoading = true;
//                         });
//                       }
//                       if (state is OrderCommentHistoryLoaded) {
//                         var model = state.model;
//                         if (model.result == 1 &&
//                             model.data != null &&
//                             model.data!.caseList!.isNotEmpty) {
//                           caseList = [];
//                           caseList = model.data!.caseList!;
//
//                           print("caseList ${caseList!.length}");
//
//                           // _innerScrollControllers.addAll(List.generate(
//                           //     caseList!.length, (_) => AutoScrollController()));
//
//                           _firstVisibleIndex = 0;
//                           newList = [];
//                           // newList = caseList!
//                           //     .map((user) => user)
//                           //     .toList()
//                           //   ..sort((a, b) {
//                           //     //print("first date ${a.date} second ${b.date}");
//                           //     if (a.causeListDate != null &&
//                           //         b.causeListDate != null &&
//                           //         a.causeListDate != "Not Available" &&
//                           //         b.causeListDate != "Not Available") {
//                           //       DateTime _dateTime =
//                           //       DateFormat("yyyy-MM-dd").parse(a.causeListDate!);
//                           //       DateTime _dateTime1 =
//                           //       DateFormat("yyyy-MM-dd").parse(b.causeListDate!);
//                           //       // _dateTime = DateTime.(_dateTime);
//                           //       //  print(_dateTime);
//                           //       return _dateTime!.compareTo(_dateTime1);
//                           //     } else {
//                           //       return a.causeListDate!.compareTo(b.causeListDate!);
//                           //     }
//                           //   });
//
//                           for (int i = 0; i < caseList!.length; i++) {
//                             //  print("in index $i>> ${newList.any((element) => element.causeListDate==caseList![i].causeListDate)}");
//                             if (!newList!.any((element) =>
//                                 element.causeListDate ==
//                                 caseList![i].causeListDate)) {
//                               CaseList casData = CaseList();
//                               casData.benchName = caseList![i].benchName;
//                               casData.caseId = caseList![i].caseId;
//                               casData.caseNo = caseList![i].caseNo;
//                               casData.case_title = caseList![i].case_title;
//                               casData.causeListDate =
//                                   caseList![i].causeListDate;
//                               casData.commentDetails =
//                                   caseList![i].commentDetails;
//                               casData.courtNo = caseList![i].courtNo;
//                               casData.dateOfListinng =
//                                   caseList![i].dateOfListinng;
//                               casData.orderFile = caseList![i].orderFile;
//                               casData.sno = caseList![i].sno;
//                               casData.stage = caseList![i].stage;
//                               casData.userDate = caseList![i].userDate;
//                               casData.intrim_stay = caseList![i].intrim_stay;
//                               casData.is_disposed = caseList![i].is_disposed;
//                               casData.is_hide = caseList![i].is_hide;
//                               casData.is_hide = caseList![i].is_hide;
//                               casData.commentUpdateDate =
//                                   caseList![i].commentUpdateDate;
//                               GlobalKey subListKey = GlobalKey();
//                               casData.subListgKey = subListKey;
//                               // cas=caseList![i];
//                               casData.isdateChange = true;
//                               newList.add(casData);
//                             }
//                             // else {
//                               CaseList cas = CaseList();
//                               cas.benchName = caseList![i].benchName;
//                               cas.caseId = caseList![i].caseId;
//                               cas.caseNo = caseList![i].caseNo;
//                               cas.case_title = caseList![i].case_title;
//                               cas.causeListDate = caseList![i].causeListDate;
//                               cas.commentDetails = caseList![i].commentDetails;
//                               cas.courtNo = caseList![i].courtNo;
//                               cas.dateOfListinng = caseList![i].dateOfListinng;
//                               cas.orderFile = caseList![i].orderFile;
//                               cas.sno = caseList![i].sno;
//                               cas.stage = caseList![i].stage;
//                               cas.userDate = caseList![i].userDate;
//                               cas.intrim_stay = caseList![i].intrim_stay;
//                               cas.is_disposed = caseList![i].is_disposed;
//                               cas.is_hide = caseList![i].is_hide;
//                               cas.is_hide = caseList![i].is_hide;
//                               cas.commentUpdateDate =
//                                   caseList![i].commentUpdateDate;
//
//                               GlobalKey subListKey = GlobalKey();
//                               cas.subListgKey = subListKey;
//
//                               cas.isdateChange = false;
//                               newList.add(cas);
//                             // }
//                           }
//
//                           print("hellonewList ${newList.length}");
//                           print("hellocaseLisst ${caseList!.length}");
//
//                           for (int i = 0; i < newList.length; i++) {
//                             if (i == 0 ||
//                                 newList[i].courtNo ==
//                                     "Before Registrar (Admin.)" ||
//                                 newList[i].courtNo ==
//                                     "Before Dy. Registrar (Judicial)") {
//                               newList[i].iscourtChange = false;
//                             } else {
//                               if (newList[i - 1].courtNo ==
//                                   "Before Registrar (Admin.)") {
//                                 newList[i].iscourtChange = true;
//                               } else if (newList[i - 1].courtNo ==
//                                   "Before Dy. Registrar (Judicial)") {
//                                 newList[i].iscourtChange = true;
//                               } else if (int.parse(newList[i].courtNo!) !=
//                                   int.parse(newList[i - 1].courtNo!)) {
//                                 newList[i].iscourtChange = true;
//                               } else {
//                                 newList[i].iscourtChange = false;
//                               }
//                             }
//                           }
//
//
//                           // for(int i=0; i<newList.length; i++){
//                           //   print("ggod");
//                           //   print("not ok ${newList[i].isdateChange}");
//                           // }
//
//                           // Map<String, List<CaseList>> groups = {};
//                           //
//                           // for (var item in caseList!) {
//                           //   var header = item.causeListDate;
//                           //   if (groups.containsKey(header)) {
//                           //     groups[header]!.add(item);
//                           //   } else {
//                           //     groups[header!] = [item];
//                           //   }
//                           // }
//                           //
//                           // groups.forEach((key, value) {
//                           //   groupModels.add(GroupModel(key, value));
//                           // });
//
//                           // for (int i = 0; i < caseList!.length; i++) {
//                           //   var item = caseList![i];
//                           //
//                           //   GlobalKey subListKey = GlobalKey();
//                           //   item.subListgKey = subListKey;
//                           //   item.index = i;
//                           //
//                           //   double cardHeight = 0;
//                           //   cardHeight = cardHeight + 40; //card margin padding
//                           //   cardHeight = cardHeight + 30; //upcomingdate
//                           //   if (item.userDate != null) {
//                           //     cardHeight = cardHeight + 17; //userdate
//                           //   }
//                           //   cardHeight = cardHeight + 10;
//                           //   cardHeight = cardHeight + 22; // courtno
//                           //
//                           //   if (item.benchName!.length < 38) {
//                           //     cardHeight = cardHeight + 12; // judgename 1 line
//                           //   }
//                           //   if (item.benchName!.length >= 38 &&
//                           //       item.benchName!.length < 75) {
//                           //     cardHeight = cardHeight + 24; // judgename 2 line
//                           //   }
//                           //   if (item.benchName!.length >= 75 &&
//                           //       item.benchName!.length < 110) {
//                           //     cardHeight = cardHeight + 36; // judgename 3 line
//                           //   }
//                           //   if (item.benchName!.length >= 110 &&
//                           //       item.benchName!.length < 147) {
//                           //     cardHeight = cardHeight + 48; // judgename 4 line
//                           //   }
//                           //   if (item.orderFile != null &&
//                           //       item.orderFile!.isNotEmpty) {
//                           //     cardHeight = cardHeight + 34;
//                           //   }
//                           //   cardHeight = cardHeight + 10; //stage sized
//                           //
//                           //   if (item.stage!.length < 44) {
//                           //     cardHeight = cardHeight + 12; // stagge 1 line
//                           //   }
//                           //   if (item.benchName!.length >= 44 &&
//                           //       item.benchName!.length < 88) {
//                           //     cardHeight = cardHeight + 24; // stage 2 line
//                           //   }
//                           //
//                           //   cardHeight = cardHeight + 10; //stage sized
//                           //   if (item.caseNo != null) {
//                           //     cardHeight = cardHeight + 12;
//                           //   }
//                           //   cardHeight = cardHeight + 22; //case title
//                           //   if (item.caseId != null) {
//                           //     cardHeight = cardHeight + 30; //comment title
//                           //     cardHeight =
//                           //         cardHeight + 10; //comment title Sizedbox
//                           //
//                           //     var commentsHeight = 0;
//                           //     for (int j = 0;
//                           //         j < item.commentDetails!.length;
//                           //         j++) {
//                           //       commentsHeight = commentsHeight + 6;
//                           //       commentsHeight = commentsHeight + 24;
//                           //       commentsHeight = commentsHeight + 20;
//                           //       commentsHeight = commentsHeight + 10;
//                           //       commentsHeight = commentsHeight + 12;
//                           //       commentsHeight = commentsHeight + 20;
//                           //     }
//                           //     cardHeight = cardHeight + commentsHeight;
//                           //   }
//                           //   item.cardHeight = cardHeight + 0;
//                           // }
//
//                           // itemKeys = List.generate(
//                           //   newList!.length,
//                           //   (index) => GlobalKey(),
//                           // );
//
//                           if (dates.isNotEmpty) {
//                             dates.clear();
//                           }
//
//                           setState(() {
//                             for (int i = 0; i < newList!.length; i++) {
//                               if (!dates.contains(getddMMYYYY_with_splash(
//                                   newList![i].causeListDate!))) {
//                                 dates.add(getddMMYYYY_with_splash(
//                                     newList![i].causeListDate!));
//                               }
//                             }
//                             isLoading = false;
//                             // DateTime now = DateTime.now();
//                             //
//                             // dateSelectCallback(
//                             //     getddMMYYYY_with_splash((now.toString())),
//                             //     isNextDateScroll: true);
//                             Future.delayed(Duration(seconds: 2), () {
//                               setState(() {
//                                 if (!isDrag) isDrag = true;
//                               });
//                             });
//                           });
//                         } else {
//                           setState(() {
//                             isLoading = false;
//                             caseList = [];
//                             _firstVisibleIndex = 0;
//                             newList = [];
//                           });
//                         }
//                       }
//                       if (state is OrderCommentHistoryError) {
//                         if (state.message == "InternetFailure()") {
//                           toast(msg: "Please check internet connection");
//                         } else {
//                           toast(msg: "Something went wrong");
//                         }
//                       }
//                     }),
//                   ),
//                   BlocConsumer<DeleteCommentCubit, DeleteCommentState>(
//                       builder: (context, state) {
//                     return const SizedBox();
//                   }, listener: (context, state) {
//                     if (state is DeleteCommentLoaded) {
//                       var deleteCommentList = state.deleteCommentModel;
//                       if (deleteCommentList.result == 1) {
//                         showDialog(
//                             context: context,
//                             builder: (ctx) => AppMsgPopup(
//                                   deleteCommentList.msg.toString(),
//                                   isCloseIcon: false,
//                                   isError: false,
//                                   btnCallback: () {
//                                     Navigator.pop(context);
//                                     fetchData();
//                                   },
//                                 ));
//                       } else {
//                         showDialog(
//                             context: context,
//                             builder: (ctx) => AppMsgPopup(
//                                   deleteCommentList.msg.toString(),
//                                 ));
//                       }
//                     }
//                   }),
//                 ],
//               ),
//             ),
//           ),
//           Visibility(
//             visible: isLoading,
//             child: const Center(child: AppProgressIndicator()),
//           ),
//         ],
//       ),
//       floatingActionButton: !isLoading && dates.length > 1
//           ? InkWell(
//               onTap: () {
//                 // dateSelectCallback("16/08/2023");
//                 showDialog(
//                     context: context,
//                     builder: (ctx) => CauseDateList(dates, dateSelectCallback));
//               },
//               child: Image.asset(
//                 ImageConstant.scroll,
//                 color: AppColor.primary,
//                 height: 40,
//                 width: 30,
//               ),
//             )
//           : SizedBox(),
//     );
//   }
//
//   Widget historyCard(item){
//     DateTime causeDate =
//     DateFormat("yyyy-MM-dd")
//         .parse(item.causeListDate!);
//     DateTime now = DateTime.now();
//     return (item.isdateChange != null &&
//         item.isdateChange ==
//             true)
//         ? Row(
//       mainAxisSize:
//       MainAxisSize.min,
//       mainAxisAlignment:
//       MainAxisAlignment
//           .center,
//       children: [
//         Spacer(),
//         Container(
//           decoration:
//           BoxDecoration(
//             borderRadius:
//             BorderRadius
//                 .circular(
//                 5),
//             color: AppColor
//                 .primary,
//           ),
//           alignment: Alignment
//               .center,
//           padding:
//           const EdgeInsets
//               .symmetric(
//               horizontal:
//               16,
//               vertical:
//               5),
//           child: Text(
//             getddMMYYYY_with_splash(
//                 item.causeListDate!),
//             style:
//             appTextStyle(
//               textColor:
//               AppColor
//                   .white,
//             ),
//             textAlign:
//             TextAlign
//                 .center,
//           ),
//         ),
//         Spacer(),
//       ],
//     )
//         :
//       Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           item.iscourtChange!=null
//               && item.iscourtChange==true?
//           Column(mainAxisSize: MainAxisSize.min,
//             children: [
//               SizedBox(height: 3,),
//               Container(
//                 height: 1,
//                 color: Colors.redAccent,
//                 width: mediaQW(context),
//               ),
//               SizedBox(height: 5,),
//             ],
//           ):SizedBox(),
//           Card(
//             elevation: 4,
//             key: item.subListgKey,
//             color: item.is_disposed == true
//                 ? AppColor.disposedColor
//                 : item.is_hide == 1
//                 ? AppColor.text_grey_color
//                 : item.intrim_stay
//                 .toString()
//                 .toLowerCase() ==
//                 "no stay"
//                 ? AppColor
//                 .cases_nostay
//                 : item.intrim_stay
//                 .toString()
//                 .toLowerCase() ==
//                 "interim stay"
//                 ? AppColor
//                 .cases_intrimstay
//                 : item.intrim_stay
//                 .toString()
//                 .toLowerCase() ==
//                 "full stay"
//                 ? AppColor
//                 .cases_fullstay
//                 : AppColor
//                 .white,
//             shape: RoundedRectangleBorder(
//                 side: BorderSide(
//                     color: item.sno != null &&
//                         item.sno
//                             .toString()
//                             .contains("D")
//                         ? AppColor.white
//                         : AppColor
//                         .rejected_color_text)),
//             margin: EdgeInsets.symmetric(
//                 vertical: 10, horizontal: 10),
//             child: Padding(
//               padding:
//               const EdgeInsets.all(10),
//               child: Column(
//                 crossAxisAlignment:
//                 CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment:
//                     MainAxisAlignment
//                         .spaceBetween,
//                     crossAxisAlignment:
//                     CrossAxisAlignment
//                         .start,
//                     children: [
//                       Expanded(
//                         child: Padding(
//                           padding:
//                           const EdgeInsets
//                               .only(
//                               top: 0,
//                               bottom: 7),
//                           child: RichText(
//                             text: TextSpan(
//                                 text:
//                                 "Upcoming Date of Listing (HC website): ",
//                                 style: mpHeadLine12(
//                                     fontWeight:
//                                     FontWeight
//                                         .w600,
//                                     textColor: item.is_disposed ==
//                                         true
//                                         ? AppColor
//                                         .white
//                                         : AppColor
//                                         .black),
//                                 children: <TextSpan>[
//                                   TextSpan(
//                                       text: getddMMYYYY_with_splash(item
//                                           .causeListDate
//                                           .toString()),
//                                       style: mpHeadLine12(
//                                           textColor: item.is_disposed == true
//                                               ? AppColor.white
//                                               : AppColor.black)),
//                                 ]),
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 20,
//                         width: 30,
//                         child:
//                         PopupMenuButton<
//                             int>(
//                           onSelected:
//                               (i) async {
//                             if (i == 1) {
//                               if (item.caseId !=
//                                   null) {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => CaseDetails(
//                                           caseId: item.caseId,
//                                           index: 2,
//                                         )));
//                               } else {
//                                 await Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => AddCaseCauseList(
//                                           getCaseNum: item.caseNo.toString(),
//                                         ))).then((value) {
//                                   if (value !=
//                                       null &&
//                                       value) {
//                                     fetchData();
//                                   }
//                                 });
//                               }
//                             }
//                           },
//                           padding:
//                           const EdgeInsets
//                               .only(
//                               top: 0,
//                               bottom: 7),
//                           icon: Icon(
//                             Icons
//                                 .more_vert_outlined,
//                             size: 20,
//                             color:
//                             item.is_disposed ==
//                                 true
//                                 ? AppColor
//                                 .white
//                                 : AppColor
//                                 .black,
//                           ),
//                           itemBuilder:
//                               (context) => [
//                             PopupMenuItem(
//                               value: 1,
//                               child: Text(item
//                                   .caseId !=
//                                   null
//                                   ? "Case Details"
//                                   : "Create Case"),
//                             ),
//                             // if(item.caseId!=null) const PopupMenuItem(
//                             //   value: 2,
//                             //   child:  Text(
//                             //       "Add Comment"),
//                             // ),
//                           ],
//                           color: Colors.white,
//                           elevation: 2,
//                         ),
//                       ),
//                       causeDate
//                           .difference(
//                           now)
//                           .inDays >
//                           -1
//                           ? InkWell(
//                         onTap: () {
//                           Map<String,
//                               String>
//                           summary =
//                           {
//                             "dateToday": item
//                                 .causeListDate
//                                 .toString(),
//                             "courtNo": item
//                                 .courtNo
//                                 .toString(),
//                             "benchName": item.benchName !=
//                                 null
//                                 ? item
//                                 .benchName
//                                 .toString()
//                                 : "",
//                           };
//                           showDialog(
//                               context:
//                               context,
//                               barrierDismissible:
//                               true,
//                               builder:
//                                   (BuildContext
//                               context) {
//                                 return CourtInfo(
//                                     summary);
//                               });
//                         },
//                         child:
//                         Container(
//                           height: 30,
//                           width: 30,
//                           alignment:
//                           Alignment
//                               .topCenter,
//                           child: Icon(
//                             Icons.info,
//                             color: AppColor
//                                 .primary,
//                             size: 20,
//                           ),
//                         ),
//                       )
//                           : SizedBox(),
//                     ],
//                   ),
//                   SizedBox(
//                     height:
//                     item.userDate != null
//                         ? 5
//                         : 0,
//                   ),
//                   item.userDate != null
//                       ? RichText(
//                     text: TextSpan(
//                         text:
//                         "User Comment Date (if populated): ",
//                         style: mpHeadLine12(
//                             fontWeight:
//                             FontWeight
//                                 .w600,
//                             textColor: item.is_disposed ==
//                                 true
//                                 ? AppColor
//                                 .white
//                                 : AppColor
//                                 .black),
//                         children: <TextSpan>[
//                           TextSpan(
//                               text: item.userDate !=
//                                   null
//                                   ? getDDMMMMYYYY(getCaseMMMMDYYYY(item
//                                   .userDate
//                                   .toString()))
//                                   : "",
//                               style: mpHeadLine12(
//                                   textColor: item.is_disposed == true
//                                       ? AppColor.white
//                                       : AppColor.black)),
//                         ]),
//                   )
//                       : SizedBox(),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Row(
//                     mainAxisAlignment:
//                     MainAxisAlignment
//                         .spaceBetween,
//                     children: [
//                       RichText(
//                         text: TextSpan(
//                             text:
//                             "Court No.:  ",
//                             style: mpHeadLine12(
//                                 fontWeight:
//                                 FontWeight
//                                     .w600,
//                                 textColor: item
//                                     .is_disposed ==
//                                     true
//                                     ? AppColor
//                                     .white
//                                     : AppColor
//                                     .black),
//                             children: <TextSpan>[
//                               TextSpan(
//                                   text: item.courtNo !=
//                                       null
//                                       ? item
//                                       .courtNo
//                                       .toString()
//                                       : "",
//                                   style: mpHeadLine12(
//                                       textColor: item.is_disposed ==
//                                           true
//                                           ? AppColor.white
//                                           : AppColor.black)),
//                             ]),
//                       ),
//                       RichText(
//                         text: TextSpan(
//                             text: "S.No.:  ",
//                             style: mpHeadLine12(
//                                 fontWeight:
//                                 FontWeight
//                                     .w600,
//                                 textColor: item
//                                     .is_disposed ==
//                                     true
//                                     ? AppColor
//                                     .white
//                                     : AppColor
//                                     .black),
//                             children: <TextSpan>[
//                               TextSpan(
//                                   text: item.sno !=
//                                       null
//                                       ? item
//                                       .sno
//                                       .toString()
//                                       : "",
//                                   style: mpHeadLine12(
//                                       textColor: item.is_disposed ==
//                                           true
//                                           ? AppColor.white
//                                           : AppColor.black)),
//                             ]),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Row(
//                     crossAxisAlignment:
//                     CrossAxisAlignment
//                         .start,
//                     children: [
//                       Text(
//                         "Judge(s) Name: ",
//                         style: mpHeadLine12(
//                             fontWeight:
//                             FontWeight
//                                 .w600,
//                             textColor: item
//                                 .is_disposed ==
//                                 true
//                                 ? AppColor
//                                 .white
//                                 : AppColor
//                                 .black),
//                       ),
//                       Flexible(
//                         child: Text(
//                             item.benchName !=
//                                 null
//                                 ? item
//                                 .benchName
//                                 .toString()
//                                 : "",
//                             style: mpHeadLine12(
//                                 textColor: item
//                                     .is_disposed ==
//                                     true
//                                     ? AppColor
//                                     .white
//                                     : AppColor
//                                     .black)),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: item.orderFile !=
//                         null &&
//                         item.orderFile!
//                             .isNotEmpty
//                         ? 10
//                         : 0,
//                   ),
//                   item.orderFile != null &&
//                       item.orderFile!
//                           .isNotEmpty
//                       ? Row(
//                     mainAxisAlignment:
//                     MainAxisAlignment
//                         .spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           Text(
//                             "Order Judgement:",
//                             style: mpHeadLine12(
//                                 fontWeight:
//                                 FontWeight.w600),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           InkWell(
//                             onTap: () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => PDFScreen(path: "https://d6kpk9izjhild.cloudfront.net/${item.orderFile!}")));
//                             },
//                             child: Icon(
//                               Icons
//                                   .remove_red_eye,
//                               color: AppColor
//                                   .primary,
//                             ),
//                           ),
//                           SizedBox(
//                             width: 10,
//                           ),
//                           InkWell(
//                             onTap:
//                                 () async {
//                               DateTime
//                               now =
//                               DateTime
//                                   .now();
//                               var fileName =
//                                   "${now.millisecondsSinceEpoch}_Judgement Details.${item.orderFile!.toString().split(".").last}";
//                               await downloadFiles(
//                                   "https://d6kpk9izjhild.cloudfront.net/${item.orderFile!}",
//                                   fileName);
//                             },
//                             child: Icon(
//                               Icons
//                                   .download,
//                               color: AppColor
//                                   .primary,
//                             ),
//                           ),
//                         ],
//                       )
//                     ],
//                   )
//                       : SizedBox(),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   RichText(
//                     text: TextSpan(
//                         text: "Stage:  ",
//                         style: mpHeadLine12(
//                             fontWeight:
//                             FontWeight
//                                 .w600,
//                             textColor: item
//                                 .is_disposed ==
//                                 true
//                                 ? AppColor
//                                 .white
//                                 : AppColor
//                                 .black),
//                         children: <TextSpan>[
//                           TextSpan(
//                               text: item.stage !=
//                                   null
//                                   ? item.stage
//                                   .toString()
//                                   : "",
//                               style: mpHeadLine12(
//                                   textColor: item.is_disposed ==
//                                       true
//                                       ? AppColor
//                                       .white
//                                       : AppColor
//                                       .black)),
//                         ]),
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   item.caseNo != null
//                       ? RichText(
//                     text: TextSpan(
//                         text:
//                         "Case No:  ",
//                         style: mpHeadLine12(
//                             fontWeight:
//                             FontWeight
//                                 .w600,
//                             textColor: item.is_disposed ==
//                                 true
//                                 ? AppColor
//                                 .white
//                                 : AppColor
//                                 .black),
//                         children: <TextSpan>[
//                           TextSpan(
//                               text: item.caseNo !=
//                                   null
//                                   ? item
//                                   .caseNo
//                                   .toString()
//                                   : "",
//                               style: mpHeadLine12(
//                                   textColor: item.is_disposed == true
//                                       ? AppColor.white
//                                       : AppColor.black)),
//                         ]),
//                   )
//                       : SizedBox(),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   InkWell(
//                     onTap: () async {
//                       if (item.caseId !=
//                           null) {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder:
//                                     (context) =>
//                                     CaseDetails(
//                                       caseId:
//                                       item.caseId,
//                                       index:
//                                       2,
//                                     )));
//                       }
//                     },
//                     child: RichText(
//                       text: TextSpan(
//                           text:
//                           "Case Title:  ",
//                           style: mpHeadLine12(
//                               fontWeight:
//                               FontWeight
//                                   .w600,
//                               textColor:
//                               AppColor
//                                   .primary),
//                           children: <TextSpan>[
//                             TextSpan(
//                                 text: item.case_title !=
//                                     null
//                                     ? item
//                                     .case_title
//                                     .toString()
//                                     : "",
//                                 style: mpHeadLine12(
//                                     textColor:
//                                     AppColor
//                                         .primary)),
//                           ]),
//                     ),
//                   ),
//                   SizedBox(
//                     height:
//                     item.caseId != null
//                         ? 10
//                         : 0,
//                   ),
//                   item.caseId != null
//                       ? Row(
//                     mainAxisAlignment:
//                     MainAxisAlignment
//                         .spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           Text(
//                             "Comments:",
//                             style: mpHeadLine14(
//                                 fontWeight:
//                                 FontWeight
//                                     .w600,
//                                 textColor: item.is_disposed ==
//                                     true
//                                     ? AppColor.white
//                                     : AppColor.black),
//                           ),
//                         ],
//                       ),
//                       InkWell(
//                         onTap: () {
//                           if (item.caseId !=
//                               null) {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => AddComment(
//                                       getCaseIdd: item.caseId,
//                                       isCaseHistory: true,
//                                       getDateOfListing: item.causeListDate != null ? getddMMYYYY_with_splash(item.causeListDate!) : "",
//                                     ))).then((value) {
//                               if (value !=
//                                   null &&
//                                   value ==
//                                       true) {
//                                 fetchData();
//                               }
//                             });
//                           }
//                         },
//                         child:
//                         const Icon(
//                           Icons.add,
//                           size: 20,
//                         ),
//                       )
//                     ],
//                   )
//                       : SizedBox(),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   ListView.builder(
//                     scrollDirection:
//                     Axis.vertical,
//                     physics:
//                     const NeverScrollableScrollPhysics(),
//                     shrinkWrap: true,
//                     itemCount: item
//                         .commentDetails!
//                         .length,
//                     itemBuilder:
//                         (context, i) {
//                       return Padding(
//                         padding:
//                         const EdgeInsets
//                             .only(
//                             top: 6,
//                             left: 6,
//                             right: 6),
//                         child: Card(
//                           color: AppColor
//                               .home_background,
//                           child: Padding(
//                             padding:
//                             const EdgeInsets
//                                 .all(
//                                 12.0),
//                             child: Column(
//                               crossAxisAlignment:
//                               CrossAxisAlignment
//                                   .start,
//                               children: [
//                                 Row(
//                                   crossAxisAlignment:
//                                   CrossAxisAlignment
//                                       .start,
//                                   mainAxisAlignment:
//                                   MainAxisAlignment
//                                       .spaceBetween,
//                                   children: [
//                                     Text(
//                                         "By:",
//                                         style: mpHeadLine12(
//                                             fontWeight: FontWeight.w600,
//                                             textColor: item.is_disposed == true ? AppColor.white : AppColor.bold_text_color_dark_blue)),
//                                     SizedBox(
//                                       width: mediaQW(context) *
//                                           0.52,
//                                       child: Text(
//                                           item.commentDetails![i].userName.toString() +
//                                               "(${item.commentDetails![i].mobNo.toString()}"
//                                                   ")",
//                                           style: mpHeadLine12(textColor: item.is_disposed == true ? AppColor.white : AppColor.bold_text_color_dark_blue)),
//                                     ),
//                                     // const SizedBox(
//                                     //   width: 45,
//                                     // ),
//                                     item.commentDetails![i].mobNo.toString() ==
//                                         pref.getString(Constants.MOB_NO)
//                                         ? Row(
//                                       children: [
//                                         InkWell(
//                                           onTap: () {
//                                             showDialog(
//                                                 context: context,
//                                                 builder: (ctx) {
//                                                   return AlertDialog(
//                                                     // insetPadding: EdgeInsets.symmetric(vertical: 305),
//                                                     contentPadding: EdgeInsets.zero,
//                                                     content: SizedBox(
//                                                       height: mediaQH(context) * 0.18,
//                                                       // width: mediaQW(context) * 0.8,
//                                                       child: Column(
//                                                         crossAxisAlignment: CrossAxisAlignment.center,
//                                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                         children: [
//                                                           Padding(
//                                                             padding: const EdgeInsets.only(left: 20, right: 20, top: 25),
//                                                             child: Text(
//                                                               "Are you sure, you want to delete this comment?",
//                                                               textAlign: TextAlign.center,
//                                                               style: mpHeadLine14(fontWeight: FontWeight.w600),
//                                                             ),
//                                                           ),
//                                                           const SizedBox(
//                                                             height: 25,
//                                                           ),
//                                                           Row(
//                                                             children: [
//                                                               Expanded(
//                                                                 child: InkWell(
//                                                                   onTap: () {
//                                                                     Navigator.pop(context);
//                                                                     var deleteComment = {
//                                                                       "commentId": item.commentDetails![i].commentId.toString(),
//                                                                     };
//                                                                     BlocProvider.of<DeleteCommentCubit>(context).fetchDeleteComment(deleteComment);
//                                                                   },
//                                                                   child: Container(
//                                                                     alignment: Alignment.center,
//                                                                     height: mediaQH(context) * 0.05,
//                                                                     decoration: BoxDecoration(borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(5)), border: Border.all(color: AppColor.primary)),
//                                                                     child: Text(
//                                                                       "Yes",
//                                                                       style: mpHeadLine16(textColor: AppColor.primary),
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                               Expanded(
//                                                                 child: InkWell(
//                                                                   onTap: () {
//                                                                     Navigator.pop(context);
//                                                                   },
//                                                                   child: Container(
//                                                                     alignment: Alignment.center,
//                                                                     height: mediaQH(context) * 0.05,
//                                                                     decoration: const BoxDecoration(
//                                                                       borderRadius: BorderRadius.only(bottomRight: Radius.circular(5)),
//                                                                       color: AppColor.primary,
//                                                                     ),
//                                                                     child: Text(
//                                                                       "No",
//                                                                       style: mpHeadLine16(textColor: AppColor.white),
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               )
//                                                             ],
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   );
//                                                 });
//                                           },
//                                           child: Icon(
//                                             Icons.delete,
//                                             size: 20,
//                                             color: Colors.red.shade800,
//                                           ),
//                                         ),
//                                         const SizedBox(
//                                           width: 15,
//                                         ),
//                                         GestureDetector(
//                                             onTap: () {
//                                               // Navigator.push(
//                                               //     context,
//                                               //     MaterialPageRoute(
//                                               //         builder: (context) => EditComment(
//                                               //           getCaseIdd: item.caseId,
//                                               //           commentId: item.commentDetails![i].commentId.toString(),
//                                               //           getComment: item.commentDetails![i].comment.toString(),
//                                               //           isCaseHistory: true,
//                                               //           getDateOfListing: item.causeListDate != null ? getddMMYYYY_with_splash(item.causeListDate!) : "",
//                                               //           apiDateOfListing: item.commentUpdateDate,
//                                               //         ))).then((value) {
//                                               //   if (value != null && value == true) {
//                                               //     fetchData();
//                                               //   }
//                                               // });
//                                             },
//                                             child: Icon(Icons.edit, size: 20, color: Colors.red.shade800))
//                                       ],
//                                     )
//                                         : SizedBox(),
//                                   ],
//                                 ),
//                                 const SizedBox(
//                                   height: 10,
//                                 ),
//                                 SizedBox(
//                                   width: mediaQW(
//                                       context) *
//                                       0.8,
//                                   child: Text(
//                                       item
//                                           .commentDetails![
//                                       i]
//                                           .comment
//                                           .toString(),
//                                       style: mpHeadLine12(
//                                           fontWeight: FontWeight
//                                               .w500,
//                                           textColor: item.is_disposed == true
//                                               ? AppColor.white
//                                               : AppColor.bold_text_color_dark_blue)),
//                                 ),
//                                 const SizedBox(
//                                   height: 10,
//                                 ),
//                                 // used Row in place of richtext so that card occupies appropriate space in page.
//                                 Row(
//                                   mainAxisAlignment:
//                                   MainAxisAlignment
//                                       .end,
//                                   children: [
//                                     Text(
//                                         item.commentDetails![i].timestamp != null
//                                             ? dateTimeMMMDDYYYY(item.commentDetails![i].timestamp
//                                             .toString())
//                                             : "",
//                                         style:
//                                         mpHeadLine10(textColor: item.is_disposed == true ? AppColor.white : AppColor.bold_text_color_dark_blue)),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       );
//   }
//
//   void dateSelectCallback(String date, {bool isNextDateScroll = false}) {
//     setState(() {
//       isLoading = true;
//     });
//     print("dateSelectCallback $date");
//     int index = newList!.indexWhere(
//         (element) => date == getddMMYYYY_with_splash(element.causeListDate!));
//     //
//     print("dateSelectCallback index $index");
//     // print("dateSelectCallback sno ${caseList![index].sno}");
//     // int index = 4;
//
//     if (index != -1) {
//       itemScrollController.jumpTo(index: index);
//       setState(() {
//         isLoading = false;
//       });
//     } else {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
// }
//
// class GroupModel {
//   String header;
//   List<CaseList> valueList;
//
//   GroupModel(this.header, this.valueList);
//
//   @override
//   String toString() {
//     return 'GroupModel{header: $header, valueList: $valueList}';
//   }
// }
