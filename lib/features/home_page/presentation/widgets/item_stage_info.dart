import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/constants.dart';
import 'package:haelo_flutter/core/utils/functions.dart';
import 'package:haelo_flutter/core/utils/hightlight_text.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/home_page/cubit/displayboard_item_stage_cubit.dart';
import 'package:haelo_flutter/widgets/date_format.dart';
import 'package:haelo_flutter/widgets/error_widget.dart';
import 'package:haelo_flutter/widgets/progress_indicator.dart';
import '../../../cases/presentation/screens/casedetails.dart';
import '../../cubit/displayboard_item_stage_state.dart';
import '../../data/model/displayboard_item_stage_model.dart';

class ItemStageInfo extends StatefulWidget {
  // final displayData;
  final displayBoardSummary;

  // final selectedDate;

  const ItemStageInfo(this.displayBoardSummary, //this.selectedDate,
      {Key? key})
      : super(key: key);

  @override
  _ItemStageInfoState createState() => _ItemStageInfoState();
}

class _ItemStageInfoState extends State<ItemStageInfo> {
  //bool isInfoDetailOpen = false;
  List<StageListDict> sList = [];
  List<StageListDict> dList = [];
  List<String> hiddenCases = [];
  String commaSeparatedString = "";

  @override
  void initState() {
    print("displayBoardSummary ${widget.displayBoardSummary}");
    BlocProvider.of<DisplayBoardItemStageCubit>(context)
        .fetchDisplayBoardItemStage(widget.displayBoardSummary);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        BlocConsumer<DisplayBoardItemStageCubit, DisplayBoardItemStageState>(
          builder: (context, state) {
            if (state is DisplayBoardStageItemLoading) {
              return Container(
                  // color: AppColor.white,
                  child: AppProgressIndicator());
            }
            if (state is DisplayBoardStageItemLoaded) {
              final displaySummaryModel = state.displayBoardItemStageModel;
              if (displaySummaryModel.result == 1 &&
                  displaySummaryModel.data!.stageListDict != null) {
                return Container(
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.all(20),
                  constraints:
                      BoxConstraints(maxHeight: mediaQH(context) * 0.9),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.zero,
                        height: mediaQH(context) * 0.06,
                        // width: mediaQW(context) * 0.9,
                        decoration: BoxDecoration(
                          color: AppColor.primary,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                        ),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Spacer(),
                            Text(
                              "Court No. " +
                                  widget.displayBoardSummary['courtNo']
                                      .toString() +
                                  " Stage Details",
                              style: mpHeadLine14(textColor: Colors.white),
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: Image.asset(
                                  ImageConstant.close,
                                  color: Colors.white,
                                  height: 15,
                                  width: 15,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 8,
                              ),
                              sList.isNotEmpty
                                  ? headerDataWidget(
                                      sList[0].benchName ?? "", "", "")
                                  : SizedBox(),
                              SizedBox(
                                height: sList.isNotEmpty ? 10 : 0,
                              ),
                              SizedBox(
                                height: sList.isNotEmpty ? 10 : 0,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: sList.map((e) {
                                    int index = sList.indexOf(e);
                                    List snoList1 =
                                        sList[index].sNo!.split("-");

                                    List snoList = [];
                                    print("sno list ${snoList.length}");
                                    for (int i = 0; i < snoList1.length; i++) {
                                      if (!snoList.contains(snoList1[i])) {
                                        if (i != snoList1.length - 1) {
                                          snoList.add(
                                              snoList1[i].toString() + " - ");
                                        } else {
                                          snoList.add(snoList1[i]);
                                        }
                                      }
                                    }
                                    return SingleChildScrollView(
                                      physics: NeverScrollableScrollPhysics(),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            height: sList[index]
                                                    .commentDetails!
                                                    .isNotEmpty
                                                ? 20
                                                : 10,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Sno. : ",
                                                style: mpHeadLine14(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  children: snoList.map((e) {
                                                    return InkWell(
                                                      onTap: () {
                                                        if (e != null &&
                                                            e
                                                                .toString()
                                                                .isNotEmpty) {
                                                          if (!e
                                                              .toString()
                                                              .contains("W")) {
                                                            var toDate =
                                                                DateTime.now();

                                                            String
                                                                numberString =
                                                                e.replaceAll(
                                                                    RegExp(
                                                                        '[^0-9]'),
                                                                    '');
                                                            print(
                                                                "numberString $numberString");

                                                            /*          Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            ViewCauseListScreenNew(
                                                                              mainCauseListdata: {
                                                                                "dateFrom": getddMMYYYY_with_splash(widget.displayBoardSummary['dateToday'].toString()),
                                                                                // getddMMYYYY_with_splash(widget.selectedDate.toString()),
                                                                                // "dateTo":
                                                                                //     getDDMMYYYY(toDate.toString()),
                                                                                "courtNo": widget.displayBoardSummary['courtNo'].toString() ?? "",
                                                                                "sNo": numberString,
                                                                                "type": e.toString().contains("D") ? "Daily" : "Supplementary",
                                                                              },
                                                                              isFromHomepage: true,
                                                                              isScrollToSno: true,
                                                                              isFilter: false,
                                                                            )));*/
                                                          }
                                                        }
                                                      },
                                                      child: HighlightText(
                                                        "$e",
                                                        "(S)",
                                                        mpHeadLine12(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            textColor:
                                                                AppColor.black),
                                                        mpHeadLine12(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            textColor:
                                                                Colors.red),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          RichText(
                                              text: TextSpan(
                                                  text: "Case No: ",
                                                  style: mpHeadLine14(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  children: <TextSpan>[
                                                TextSpan(
                                                  text: sList[index].caseNo!,
                                                  style: mpHeadLine12(
                                                      textColor: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )
                                              ])),
                                          /*  Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Case No: ",
                                                style: mpHeadLine14(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Text(
                                                sList[index].caseNo!,
                                                style: mpHeadLine12(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),

                                              */
                                          /* SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Row(
                                                      children:
                                                          snoList.map((e) {
                                                        return Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.2,
                                                          */
                                          /* */ /*   constraints: BoxConstraints(
                                                            maxWidth: MediaQuery.of(context).size.width *0.5
                                                          ),*/ /* */ /*
                                                          child: HighlightText(
                                                            sList[index]
                                                                .caseNo!,
                                                            "",
                                                            mpHeadLine14(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                textColor:
                                                                    AppColor
                                                                        .black),
                                                            mpHeadLine14(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                textColor:
                                                                    Colors.red),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  )*/ /*
                                            ],
                                          ),*/
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          RichText(
                                              text: TextSpan(
                                                  text: "Stage: ",
                                                  style: mpHeadLine14(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  children: <TextSpan>[
                                                TextSpan(
                                                  text: sList != null
                                                      ? sList[index].stage
                                                      : "",
                                                  style: mpHeadLine12(
                                                      textColor: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )
                                              ])),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          sList[index].caseTitle != ""
                                              ? InkWell(
                                                  onTap: () async {
                                                    if (sList[index].caseNo !=
                                                        null &&
                                                        sList[index]
                                                            .caseId!=null) {
                                                      goToPage(context, CaseDetails(
                                                        caseId: sList[index]
                                                            .caseId,
                                                        index:
                                                        2,
                                                      ));
                                                    }

                                                    // if (sList[index].caseNo !=
                                                    //     null) {
                                                    //   Navigator.push(
                                                    //       context,
                                                    //       MaterialPageRoute(
                                                    //           builder:
                                                    //               (context) =>
                                                    //                   CaseDetails(
                                                    //                     caseId: sList[index]
                                                    //                         .commentDetails?[0]
                                                    //                         .caseId,
                                                    //                     index:
                                                    //                         2,
                                                    //                   )));
                                                    // }
                                                  },
                                                  child: RichText(
                                                    text: TextSpan(
                                                        text: "Case Title:  ",
                                                        style: mpHeadLine12(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            textColor: AppColor
                                                                .primary),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text: sList[index]
                                                                          .caseTitle !=
                                                                      null
                                                                  ? sList[index]
                                                                      .caseTitle
                                                                      .toString()
                                                                  : "",
                                                              style: mpHeadLine12(
                                                                  textColor:
                                                                      AppColor
                                                                          .primary)),
                                                        ]),
                                                  ),
                                                )
                                              : SizedBox(),
                                          sList[index]
                                                  .commentDetails!
                                                  .isNotEmpty
                                              ? ListView.builder(
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount: sList[index]
                                                      .commentDetails!
                                                      .length,
                                                  itemBuilder: (context, i) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 6,
                                                              left: 6,
                                                              right: 6),
                                                      child: Card(
                                                        color: AppColor
                                                            .home_background,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(12.0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text("By:",
                                                                      style: mpHeadLine12(
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          textColor:
                                                                              AppColor.bold_text_color_dark_blue)),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  SizedBox(
                                                                    width: mediaQW(
                                                                            context) *
                                                                        0.52,
                                                                    child: Text(
                                                                        "${sList[index].commentDetails![i].userName}(${sList[index].commentDetails![i].mobNo.toString()})",
                                                                        style: mpHeadLine12(
                                                                            textColor:
                                                                                AppColor.bold_text_color_dark_blue)),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              SizedBox(
                                                                width: mediaQW(
                                                                        context) *
                                                                    0.8,
                                                                child: Text(
                                                                    sList[index]
                                                                        .commentDetails![
                                                                            i]
                                                                        .comment
                                                                        .toString(),
                                                                    style: mpHeadLine12(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        textColor:
                                                                            AppColor.bold_text_color_dark_blue)),
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              // used Row in place of richtext so that card occupies appropriate space in page.
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Text(
                                                                      sList[index].commentDetails![i].timestamp !=
                                                                              null
                                                                          ? formatTimestampToDate(sList[index]
                                                                              .commentDetails![
                                                                                  i]
                                                                              .timestamp
                                                                              .toString())
                                                                          : "",
                                                                      style: mpHeadLine10(
                                                                          textColor:
                                                                              AppColor.bold_text_color_dark_blue)),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                )
                                              : SizedBox(),
                                          sList.length - 1 == index
                                              ? SizedBox()
                                              : const Divider(
                                                  thickness: 0.51,
                                                  color:
                                                      AppColor.text_grey_color,
                                                )
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              SizedBox(
                                height: sList.isNotEmpty ? 15 : 0,
                              ),
                              dList.isNotEmpty && sList.isNotEmpty
                                  ? Divider(
                                      thickness: 1.2,
                                      color: AppColor.rejected_color_text,
                                    )
                                  : SizedBox(),
                              SizedBox(
                                height: sList.isNotEmpty ? 15 : 0,
                              ),
                              dList.isNotEmpty
                                  ? headerDataWidget(
                                      dList[0].benchName ?? "", "", "")
                                  : SizedBox(),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: dList.map((e) {
                                    int index = dList.indexOf(e);
                                    List snoList1 =
                                        dList[index].sNo!.split("-");

                                    List snoList = [];
                                    print("sno list ${snoList.length}");
                                    for (int i = 0; i < snoList1.length; i++) {
                                      if (!snoList.contains(snoList1[i])) {
                                        if (i != snoList1.length - 1) {
                                          snoList.add(
                                              snoList1[i].toString() + " - ");
                                        } else {
                                          snoList.add(snoList1[i]);
                                        }
                                      }
                                    }
                                    return SingleChildScrollView(
                                      physics: NeverScrollableScrollPhysics(),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            height: dList[index]
                                                    .commentDetails!
                                                    .isNotEmpty
                                                ? 20
                                                : 10,
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Sno. : ",
                                                style: mpHeadLine14(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  children: snoList.map((e) {
                                                    return InkWell(
                                                      onTap: () {
                                                        if (e != null &&
                                                            e
                                                                .toString()
                                                                .isNotEmpty) {
                                                          if (!e
                                                              .toString()
                                                              .contains("W")) {
                                                            var toDate =
                                                                DateTime.now();

                                                            String
                                                                numberString =
                                                                e.replaceAll(
                                                                    RegExp(
                                                                        '[^0-9]'),
                                                                    '');
                                                            print(
                                                                "numberString $numberString");

                                                            /*  Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                ViewCauseListScreenNew(
                                                                                  mainCauseListdata: {
                                                                                    "dateFrom": getddMMYYYY_with_splash(widget.displayBoardSummary['dateToday'].toString()),
                                                                                    // getddMMYYYY_with_splash(widget.selectedDate.toString()),
                                                                                    // "dateTo":
                                                                                    //     getDDMMYYYY(toDate.toString()),
                                                                                    "courtNo": widget.displayBoardSummary['courtNo'].toString() ?? "",
                                                                                    "sNo": numberString,
                                                                                    "type": e.toString().contains("D") ? "Daily" : "Supplementary",
                                                                                  },
                                                                                  isFromHomepage: true,
                                                                                  isScrollToSno: true,
                                                                                  isFilter: false,
                                                                                )));*/
                                                          }
                                                        }
                                                      },
                                                      child: HighlightText(
                                                        "$e",
                                                        "(S)",
                                                        mpHeadLine12(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            textColor:
                                                                AppColor.black),
                                                        mpHeadLine12(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            textColor:
                                                                Colors.red),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          RichText(
                                              text: TextSpan(
                                                  text: "Case No: ",
                                                  style: mpHeadLine14(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  children: <TextSpan>[
                                                TextSpan(
                                                  text: dList[index].caseNo!,
                                                  style: mpHeadLine12(
                                                      textColor: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )
                                              ])),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          RichText(
                                              text: TextSpan(
                                                  text: "Stage: ",
                                                  style: mpHeadLine14(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  children: <TextSpan>[
                                                TextSpan(
                                                  text: dList != null
                                                      ? dList[index].stage
                                                      : "",
                                                  style: mpHeadLine12(
                                                      textColor: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )
                                              ])),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          dList[index].caseTitle != ""
                                              ? InkWell(
                                                  onTap: () async {
                                                    if (dList[index].caseNo !=
                                                        null &&
                                                        dList[index]
                                                            .caseId!=null) {
                                                      goToPage(context, CaseDetails(
                                                        caseId: dList[index]
                                                            .caseId,
                                                        index:
                                                        2,
                                                      ));
                                                    }

                                                  },
                                                  child: RichText(
                                                    text: TextSpan(
                                                        text: "Case Title:  ",
                                                        style: mpHeadLine12(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            textColor: AppColor
                                                                .primary),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text: dList[index]
                                                                          .caseTitle !=
                                                                      null
                                                                  ? dList[index]
                                                                      .caseTitle
                                                                      .toString()
                                                                  : "",
                                                              style: mpHeadLine12(
                                                                  textColor:
                                                                      AppColor
                                                                          .primary)),
                                                        ]),
                                                  ),
                                                )
                                              : SizedBox(),
                                          dList[index]
                                                  .commentDetails!
                                                  .isNotEmpty
                                              ? ListView.builder(
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount: dList[index]
                                                      .commentDetails!
                                                      .length,
                                                  itemBuilder: (context, i) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 6,
                                                              left: 6,
                                                              right: 6),
                                                      child: Card(
                                                        color: AppColor
                                                            .home_background,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(12.0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text("By:",
                                                                      style: mpHeadLine12(
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          textColor:
                                                                              AppColor.bold_text_color_dark_blue)),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  SizedBox(
                                                                    width: mediaQW(
                                                                            context) *
                                                                        0.52,
                                                                    child: Text(
                                                                        "${dList[index].commentDetails![i].userName}(${dList[index].commentDetails![i].mobNo.toString()})",
                                                                        style: mpHeadLine12(
                                                                            textColor:
                                                                                AppColor.bold_text_color_dark_blue)),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              SizedBox(
                                                                width: mediaQW(
                                                                        context) *
                                                                    0.8,
                                                                child: Text(
                                                                    dList[index]
                                                                        .commentDetails![
                                                                            i]
                                                                        .comment
                                                                        .toString(),
                                                                    style: mpHeadLine12(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        textColor:
                                                                            AppColor.bold_text_color_dark_blue)),
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              // used Row in place of richtext so that card occupies appropriate space in page.
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Text(
                                                                      dList[index].commentDetails![i].timestamp !=
                                                                              null
                                                                          ? formatTimestampToDate(dList[index]
                                                                              .commentDetails![
                                                                                  i]
                                                                              .timestamp
                                                                              .toString())
                                                                          : "",
                                                                      style: mpHeadLine10(
                                                                          textColor:
                                                                              AppColor.bold_text_color_dark_blue)),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                )
                                              : SizedBox(),
                                          dList.length - 1 == index
                                              ? SizedBox()
                                              : const Divider(
                                                  thickness: 0.51,
                                                  color:
                                                      AppColor.text_grey_color,
                                                )
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return AppMsgPopup(
                displaySummaryModel.msg,
              );
            }
            return const SizedBox();
          },
          listener: (context, state) {
            if (state is DisplayBoardStageItemLoaded) {
              final displayStageModel = state.displayBoardItemStageModel;
              if (displayStageModel.result == 1 &&
                  displayStageModel.data!.stageListDict != null) {
                commaSeparatedString = hiddenCases.join(', ');
                print("hiddenCases ==> $commaSeparatedString");
                var displayStageData = displayStageModel.data!.stageListDict;
                // print("displaySummaryData>> $displaySummaryData");

                for (int i = 0; i < displayStageData!.length; i++) {
                  if (displayStageData[i].sNo!.contains("S")) {
                    sList.add(displayStageData[i]);
                  } else {
                    dList.add(displayStageData[i]);
                  }
                }
                for(var item in dList){
                  print("item ${item.commentDetails}");
                }
              }
            }
          },
        ),
      ],
    );
  }

  Widget headerDataWidget(benchName, judgeTime, judgeTime2) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColor.primary)),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          RichText(
              text: TextSpan(
                  text: "Bench: ",
                  style: mpHeadLine14(fontWeight: FontWeight.w500),
                  children: <TextSpan>[
                TextSpan(
                  text: benchName,
                  style: mpHeadLine14(
                      textColor: Colors.black, fontWeight: FontWeight.w500),
                )
              ])),
          SizedBox(
            height: judgeTime != "" || judgeTime2 != "" ? 8 : 0,
          ),
          Text(
            judgeTime != "" && judgeTime2 != ""
                ? judgeTime! + " & " + judgeTime2!
                : judgeTime == "" && judgeTime2 == ""
                    ? ""
                    : judgeTime != ""
                        ? judgeTime!
                        : judgeTime2!,
            style: mpHeadLine14(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget headerHideCaseWidget(hideCase) {
    return Center(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColor.primary)),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    "Comments added for these Cases",
                    style: mpHeadLine14(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    hideCase,
                    style: mpHeadLine14(
                        textColor: AppColor.hint_color_grey,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
