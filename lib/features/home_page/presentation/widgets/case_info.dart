import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/constants.dart';
import 'package:haelo_flutter/core/utils/hightlight_text.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/causeslist/presentation/screen/causelist_page.dart';
import 'package:haelo_flutter/features/causeslist/presentation/screen/causelist_screen.dart';
import 'package:haelo_flutter/features/causeslist/presentation/screen/viewcauselist.dart';
import 'package:haelo_flutter/features/home_page/cubit/displayboard_summary_cubit.dart';
import 'package:haelo_flutter/features/home_page/data/model/displayboard_summary_model.dart';
import 'package:haelo_flutter/widgets/date_format.dart';
import 'package:haelo_flutter/widgets/error_widget.dart';
import 'package:haelo_flutter/widgets/progress_indicator.dart';
// import 'displayboard_summary_model.dart';
import '../../cubit/displayboard_summary_state.dart';

class CourtInfo extends StatefulWidget {
  // final displayData;
  final displayBoardSummary;
  // final selectedDate;

  const CourtInfo(this.displayBoardSummary, //this.selectedDate,
      {Key? key})
      : super(key: key);

  @override
  _CourtInfoState createState() => _CourtInfoState();
}

class _CourtInfoState extends State<CourtInfo> {
  //bool isInfoDetailOpen = false;
  List<Summary> sList=[];
  List<Summary> dList=[];

  @override
  void initState() {
    BlocProvider.of<DisplayBoardSummaryCubit>(context)
        .fetchDisplayBoardSummary(widget.displayBoardSummary);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        BlocConsumer<DisplayBoardSummaryCubit, DisplayBoardSummaryState>(
          builder: (context, state) {
            if (state is DisplayBoardSummaryLoading) {
              return Container(
                // color: AppColor.white,
                  child: AppProgressIndicator());
            }
            if (state is DisplayBoardSummaryLoaded) {
              final displaySummaryModel = state.displayBoardSummaryModel;
              if (displaySummaryModel.result == 1 &&
                  displaySummaryModel.data != null) {

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
                    mainAxisAlignment: MainAxisAlignment.center,
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
                                  widget.displayBoardSummary['courtNo'].toString() +
                                  " Summary",
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
                            children: [
                              sList.isNotEmpty?
                              headerDataWidget(sList[0].benchName??"",
                                  sList[0]
                                  .judgeTime??"", sList[0]
                                  .judgeTime2??""):SizedBox(),
                              SizedBox(height: sList.isNotEmpty?10:0,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                child: Column(mainAxisSize: MainAxisSize.min,
                                  children: sList!.map((e) {
                                    int index =
                                    sList!.indexOf(e);
                                    List snoList1 = sList[index].sno!
                                        .split("-");

                                    List snoList=[];
                                    print("sno list ${snoList.length}");
                                    for(int i=0; i<snoList1.length; i++){
                                      if(!snoList.contains(snoList1[i])){
                                        if(i!=snoList1.length-1) {
                                          snoList.add(snoList1[i].toString()+" - ");
                                        }else{
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
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Sno. : ",
                                                style: mpHeadLine14(
                                                    fontWeight: FontWeight.w500),
                                              ),

                                              SingleChildScrollView(
                                                scrollDirection: Axis.horizontal,
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

                                                            String numberString = e.replaceAll(RegExp('[^0-9]'), '');
                                                            print("numberString $numberString");

                                                            Navigator.push(
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
                                                                            "courtNo":
                                                                            widget.displayBoardSummary['courtNo'].toString() ?? "",
                                                                            "sNo":numberString,
                                                                            "type":e.toString().contains("D")?"Daily":"Supplementary",},
                                                                          isFromHomepage:
                                                                          true,
                                                                          isScrollToSno:true,
                                                                          isFilter: false,)));
                                                          }
                                                        }
                                                      },
                                                      child: HighlightText(
                                                        "$e",
                                                        "(S)",
                                                        mpHeadLine14(
                                                            fontWeight:
                                                            FontWeight.w500,
                                                            textColor:
                                                            AppColor.black),
                                                        mpHeadLine14(
                                                            fontWeight:
                                                            FontWeight.w500,
                                                            textColor: Colors.red),
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
                                                  text: "Stage: ",
                                                  style: mpHeadLine14(
                                                      fontWeight: FontWeight.w500),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: sList != null
                                                          ? sList[index].stage
                                                          : "",
                                                      style: mpHeadLine14(
                                                          textColor: Colors.black,
                                                          fontWeight: FontWeight.w500),
                                                    )
                                                  ])),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                sList![index]
                                                    .isDropDownOpen =
                                                !sList[index]
                                                    .isDropDownOpen;
                                              });
                                            },
                                            child: Column(
                                              children: [
                                                const SizedBox(
                                                  height: 3,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text('Detail',
                                                        style: mpHeadLine14(
                                                            fontWeight:
                                                            FontWeight.w500)),
                                                    sList[index]
                                                        .isDropDownOpen
                                                        ? const Icon(
                                                      Icons
                                                          .keyboard_arrow_down_outlined,
                                                    )
                                                        : const Icon(
                                                      Icons
                                                          .keyboard_arrow_up_outlined,
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Visibility(
                                              visible: sList![index].isDropDownOpen,
                                              child: ListView.builder(
                                                itemCount: sList[index]
                                                    .sumamryDetail!
                                                    .length,
                                                shrinkWrap: true,
                                                physics:
                                                NeverScrollableScrollPhysics(),
                                                scrollDirection: Axis.vertical,
                                                itemBuilder: (context, i) {
                                                  List serNoList1 =
                                                  sList[index]
                                                      .sumamryDetail![i]
                                                      .sno
                                                      .toString()
                                                      .split("-");


                                                  List serNoList=[];
                                                  for(int j=0; j<serNoList1.length; j++){
                                                    if(!serNoList.contains(snoList[j])){
                                                      if(j!=serNoList1.length-1) {
                                                        serNoList.add(serNoList1[j].toString()+" - ");
                                                      }else{
                                                        serNoList.add(serNoList1[j]);
                                                      }
                                                    }
                                                  }
                                                  return Padding(
                                                    padding: const EdgeInsets.only(
                                                        top: 5),
                                                    child: Container(
                                                      decoration:
                                                      const BoxDecoration(
                                                        color: AppColor
                                                            .home_background,
                                                        shape: BoxShape.rectangle,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            RichText(
                                                              text: TextSpan(
                                                                  text:
                                                                  "Case Type: ",
                                                                  style: mpHeadLine12(
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                                  children: <
                                                                      TextSpan>[
                                                                    TextSpan(
                                                                        text: sList !=
                                                                            null
                                                                            ? sList![
                                                                        index]
                                                                            .sumamryDetail![
                                                                        i]
                                                                            .caseType
                                                                            : "",
                                                                        style: mpHeadLine12(
                                                                            fontWeight:
                                                                            FontWeight.w500)),
                                                                  ]),
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "Sno. : ",
                                                                  style: mpHeadLine14(
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                                ),
                                                                Flexible(
                                                                    child:
                                                                    SingleChildScrollView(
                                                                      scrollDirection:
                                                                      Axis.horizontal,
                                                                      child: Row(
                                                                        children:
                                                                        serNoList
                                                                            .map(
                                                                                (e) {
                                                                              return InkWell(
                                                                                onTap: () {
                                                                                  if (e !=
                                                                                      null &&
                                                                                      e.toString().isNotEmpty) {
                                                                                    print(
                                                                                        "e named $e");
                                                                                    if (!e
                                                                                        .toString()
                                                                                        .contains("W")) {
                                                                                      String numberString = e.replaceAll(RegExp('[^0-9]'), '');
                                                                                      print("numberString1 $numberString");
                                                                                      Navigator.push(
                                                                                          context,
                                                                                          MaterialPageRoute(
                                                                                              builder: (context) => ViewCauseListScreenNew(
                                                                                                  mainCauseListdata: {
                                                                                                    "dateFrom": getddMMYYYY_with_splash(widget.displayBoardSummary['dateToday'].toString()),
                                                                                                    //"dateTo": getDDMMYYYY(toDate.toString()),
                                                                                                    "courtNo": widget.displayBoardSummary['courtNo'].toString(),
                                                                                                    "sNo":numberString,
                                                                                                    "type":e.toString().contains("D")?"Daily":"Supplementary",},
                                                                                                  isFromHomepage: true,
                                                                                                  isScrollToSno:true,
                                                                                                  isFilter: false)));
                                                                                    }
                                                                                  }
                                                                                },
                                                                                child:
                                                                                HighlightText(
                                                                                  "$e",
                                                                                  "(S)",
                                                                                  mpHeadLine14(
                                                                                      fontWeight: FontWeight
                                                                                          .w500,
                                                                                      textColor:
                                                                                      AppColor.black),
                                                                                  mpHeadLine14(
                                                                                      fontWeight: FontWeight
                                                                                          .w500,
                                                                                      textColor:
                                                                                      Colors.red),
                                                                                ),
                                                                              );
                                                                            }).toList(),
                                                                      ),
                                                                    )

                                                                )
                                                              ],
                                                            ),

                                                            const SizedBox(
                                                              height: 3,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              )),

                                          sList.length - 1 ==
                                              index
                                              ? SizedBox()
                                              : const Divider(
                                            thickness: 0.51,
                                            color: AppColor.text_grey_color,
                                          )
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              SizedBox(height: sList.isNotEmpty?15:0,),
                              dList.isNotEmpty && sList.isNotEmpty?Divider(
                                thickness:  1.2,
                                color: AppColor.rejected_color_text,
                              ):SizedBox(),
                              // DottedBorder(
                              //   padding: EdgeInsets.zero,
                              //   borderType: BorderType.Rect,
                              //   color: Colors.redAccent,
                              //   strokeWidth: sList.isNotEmpty?4:0,
                              //   dashPattern: [8, 10],
                              //   child: SizedBox(
                              //     width: mediaQW(context),
                              //     height: 0.05,
                              //   ),
                              // ),
                              SizedBox(height: sList.isNotEmpty?15:0,),

                              dList.isNotEmpty?headerDataWidget(dList[0].benchName??"", dList[0]
                                  .judgeTime??"", dList[0]
                                  .judgeTime2??""):SizedBox(),

                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                child: Column(mainAxisSize: MainAxisSize.min,
                                  children: dList!.map((e) {
                                    int index =
                                    dList!.indexOf(e);
                                    List snoList1 = dList[index].sno!
                                        .split("-");

                                    List snoList=[];
                                    print("sno list ${snoList.length}");
                                    for(int i=0; i<snoList1.length; i++){
                                      if(!snoList.contains(snoList1[i])){
                                        if(i!=snoList1.length-1) {
                                          snoList.add(snoList1[i].toString()+" - ");
                                        }else{
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
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Sno. : ",
                                                style: mpHeadLine14(
                                                    fontWeight: FontWeight.w500),
                                              ),

                                              SingleChildScrollView(
                                                scrollDirection: Axis.horizontal,
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

                                                            String numberString = e.replaceAll(RegExp('[^0-9]'), '');
                                                            print("numberString $numberString");

                                                            Navigator.push(
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
                                                                            "courtNo":
                                                                            widget.displayBoardSummary['courtNo'].toString() ?? "",
                                                                            "sNo":numberString,
                                                                            "type":e.toString().contains("D")?"Daily":"Supplementary",},
                                                                          isFromHomepage:
                                                                          true,
                                                                          isScrollToSno:true,
                                                                          isFilter: false,)));
                                                          }
                                                        }
                                                      },
                                                      child: HighlightText(
                                                        "$e",
                                                        "(S)",
                                                        mpHeadLine14(
                                                            fontWeight:
                                                            FontWeight.w500,
                                                            textColor:
                                                            AppColor.black),
                                                        mpHeadLine14(
                                                            fontWeight:
                                                            FontWeight.w500,
                                                            textColor: Colors.red),
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
                                                  text: "Stage: ",
                                                  style: mpHeadLine14(
                                                      fontWeight: FontWeight.w500),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: dList != null
                                                          ? dList[index].stage
                                                          : "",
                                                      style: mpHeadLine14(
                                                          textColor: Colors.black,
                                                          fontWeight: FontWeight.w500),
                                                    )
                                                  ])),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                dList![index]
                                                    .isDropDownOpen =
                                                !dList[index]
                                                    .isDropDownOpen;
                                              });
                                            },
                                            child: Column(
                                              children: [
                                                const SizedBox(
                                                  height: 3,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text('Detail',
                                                        style: mpHeadLine14(
                                                            fontWeight:
                                                            FontWeight.w500)),
                                                    dList[index]
                                                        .isDropDownOpen
                                                        ? const Icon(
                                                      Icons
                                                          .keyboard_arrow_down_outlined,
                                                    )
                                                        : const Icon(
                                                      Icons
                                                          .keyboard_arrow_up_outlined,
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Visibility(
                                              visible: dList![index].isDropDownOpen,
                                              child: ListView.builder(
                                                itemCount: dList[index]
                                                    .sumamryDetail!
                                                    .length,
                                                shrinkWrap: true,
                                                physics:
                                                NeverScrollableScrollPhysics(),
                                                scrollDirection: Axis.vertical,
                                                itemBuilder: (context, i) {
                                                  List serNoList1 =
                                                  dList[index]
                                                      .sumamryDetail![i]
                                                      .sno
                                                      .toString()
                                                      .split("-");


                                                  List serNoList=[];
                                                  for(int j=0; j<serNoList1.length; j++){
                                                    if(!serNoList.contains(snoList[j])){
                                                      if(j!=serNoList1.length-1) {
                                                        serNoList.add(serNoList1[j].toString()+" - ");
                                                      }else{
                                                        serNoList.add(serNoList1[j]);
                                                      }
                                                    }
                                                  }
                                                  return Padding(
                                                    padding: const EdgeInsets.only(
                                                        top: 5),
                                                    child: Container(
                                                      decoration:
                                                      const BoxDecoration(
                                                        color: AppColor
                                                            .home_background,
                                                        shape: BoxShape.rectangle,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            RichText(
                                                              text: TextSpan(
                                                                  text:
                                                                  "Case Type: ",
                                                                  style: mpHeadLine12(
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                                  children: <
                                                                      TextSpan>[
                                                                    TextSpan(
                                                                        text: dList !=
                                                                            null
                                                                            ? dList![
                                                                        index]
                                                                            .sumamryDetail![
                                                                        i]
                                                                            .caseType
                                                                            : "",
                                                                        style: mpHeadLine12(
                                                                            fontWeight:
                                                                            FontWeight.w500)),
                                                                  ]),
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "Sno. : ",
                                                                  style: mpHeadLine14(
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                                ),
                                                                Flexible(
                                                                    child:
                                                                    SingleChildScrollView(
                                                                      scrollDirection:
                                                                      Axis.horizontal,
                                                                      child: Row(
                                                                        children:
                                                                        serNoList
                                                                            .map(
                                                                                (e) {
                                                                              return InkWell(
                                                                                onTap: () {
                                                                                  if (e !=
                                                                                      null &&
                                                                                      e.toString().isNotEmpty) {
                                                                                    print(
                                                                                        "e named $e");
                                                                                    if (!e
                                                                                        .toString()
                                                                                        .contains("W")) {
                                                                                      String numberString = e.replaceAll(RegExp('[^0-9]'), '');
                                                                                      print("numberString1 $numberString");
                                                                                      Navigator.push(
                                                                                          context,
                                                                                          MaterialPageRoute(
                                                                                              builder: (context) => ViewCauseListScreenNew(
                                                                                                  mainCauseListdata: {
                                                                                                    "dateFrom": getddMMYYYY_with_splash(widget.displayBoardSummary['dateToday'].toString()),
                                                                                                    //"dateTo": getDDMMYYYY(toDate.toString()),
                                                                                                    "courtNo": widget.displayBoardSummary['courtNo'].toString(),
                                                                                                    "sNo":numberString,
                                                                                                    "type":e.toString().contains("D")?"Daily":"Supplementary",},
                                                                                                  isFromHomepage: true,
                                                                                                  isScrollToSno:true,
                                                                                                  isFilter: false)));
                                                                                    }
                                                                                  }
                                                                                },
                                                                                child:
                                                                                HighlightText(
                                                                                  "$e",
                                                                                  "(S)",
                                                                                  mpHeadLine14(
                                                                                      fontWeight: FontWeight
                                                                                          .w500,
                                                                                      textColor:
                                                                                      AppColor.black),
                                                                                  mpHeadLine14(
                                                                                      fontWeight: FontWeight
                                                                                          .w500,
                                                                                      textColor:
                                                                                      Colors.red),
                                                                                ),
                                                                              );
                                                                            }).toList(),
                                                                      ),
                                                                    )

                                                                )
                                                              ],
                                                            ),

                                                            const SizedBox(
                                                              height: 3,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              )),

                                          dList.length - 1 ==
                                              index
                                              ? SizedBox()
                                              : const Divider(
                                            thickness: 0.51,
                                            color: AppColor.text_grey_color,
                                          )
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              SizedBox(height: 10,),
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
          listener: (context, state){
            if (state is DisplayBoardSummaryLoaded){
              final displaySummaryModel = state.displayBoardSummaryModel;
              if (displaySummaryModel.result == 1 &&
                  displaySummaryModel.data != null) {
                var displaySummaryData = displaySummaryModel.data;
               // print("displaySummaryData>> $displaySummaryData");

                for(int i=0; i<displaySummaryData!.summary!.length;i++){
                  if(displaySummaryData!.summary![i].sno!.contains("S")){
                    sList.add(displaySummaryData!.summary![i]);
                  }else{
                    dList.add(displaySummaryData!.summary![i]);
                  }
                }
              }
            }
          },
        ),
      ],
    );
  }


 Widget headerDataWidget(benchName,judgeTime, judgeTime2){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColor.primary)
      ),
      padding: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          RichText(
              text: TextSpan(
                  text: "Bench: ",
                  style: mpHeadLine14(
                      fontWeight: FontWeight.w500),
                  children: <TextSpan>[
                    TextSpan(
                      text: benchName,
                      style: mpHeadLine14(
                          textColor: Colors.black,
                          fontWeight: FontWeight.w500),
                    )
                  ])),
          SizedBox(
            height: judgeTime !=
                "" ||
                judgeTime2 !=
                    ""
                ? 8
                : 0,
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


  // Widget buildold(BuildContext context) {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     // crossAxisAlignment: CrossAxisAlignment.start,
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //       BlocBuilder<DisplayBoardSummaryCubit, DisplayBoardSummaryState>(
  //         builder: (context, state) {
  //           if (state is DisplayBoardSummaryLoading) {
  //             return Container(
  //                 // color: AppColor.white,
  //                 child: AppProgressIndicator());
  //           }
  //           if (state is DisplayBoardSummaryLoaded) {
  //             final displaySummaryModel = state.displayBoardSummaryModel;
  //             if (displaySummaryModel.result == 1 &&
  //                 displaySummaryModel.data != null) {
  //               var displaySummaryData = displaySummaryModel.data;
  //               return Container(
  //                 decoration: BoxDecoration(
  //                   color: AppColor.white,
  //                   borderRadius: BorderRadius.circular(10),
  //                 ),
  //                 margin: EdgeInsets.all(20),
  //                 constraints:
  //                     BoxConstraints(maxHeight: mediaQH(context) * 0.9),
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Container(
  //                       padding: EdgeInsets.zero,
  //                       height: mediaQH(context) * 0.06,
  //                       // width: mediaQW(context) * 0.9,
  //                       decoration: BoxDecoration(
  //                         color: AppColor.primary,
  //                         borderRadius: BorderRadius.only(
  //                             topLeft: Radius.circular(10),
  //                             topRight: Radius.circular(10)),
  //                       ),
  //
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: [
  //                           const Spacer(),
  //                           Text(
  //                             "Court No. " +
  //                                 widget.displayBoardSummary['courtNo'].toString() +
  //                                 " Summary",
  //                             style: mpHeadLine14(textColor: Colors.white),
  //                           ),
  //                           const Spacer(),
  //                           InkWell(
  //                             onTap: () {
  //                               Navigator.pop(context);
  //                             },
  //                             child: Padding(
  //                               padding: const EdgeInsets.only(right: 15),
  //                               child: Image.asset(
  //                                 ImageConstant.close,
  //                                 color: Colors.white,
  //                                 height: 15,
  //                                 width: 15,
  //                               ),
  //                             ),
  //                           )
  //                         ],
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       height: 10,
  //                     ),
  //                     Flexible(
  //                       child: SingleChildScrollView(
  //                         child: Padding(
  //                           padding: EdgeInsets.symmetric(
  //                               horizontal: 15, vertical: 1),
  //                           child: Column(
  //                             children: displaySummaryData!.summary!.map((e) {
  //                               int index =
  //                                   displaySummaryData.summary!.indexOf(e);
  //                               List snoList1 = displaySummaryData
  //                                   .summary![index].sno!
  //                                   .split("-");
  //
  //                               List snoList=[];
  //                               print("sno list ${snoList.length}");
  //                               for(int i=0; i<snoList1.length; i++){
  //                                 if(!snoList.contains(snoList1[i])){
  //                                   if(i!=snoList1.length-1) {
  //                                     snoList.add(snoList1[i].toString()+" - ");
  //                                   }else{
  //                                     snoList.add(snoList1[i]);
  //                                   }
  //                                 }
  //                               }
  //                               return SingleChildScrollView(
  //                                 physics: NeverScrollableScrollPhysics(),
  //                                 child: Column(
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.start,
  //                                   //mainAxisSize: MainAxisSize.min,
  //                                   children: [
  //                                     const SizedBox(
  //                                       height: 8,
  //                                     ),
  //                                     Row(
  //                                       children: [
  //                                         Text(
  //                                           "Sno. : ",
  //                                           style: mpHeadLine14(
  //                                               fontWeight: FontWeight.w500),
  //                                         ),
  //                                         Flexible(
  //                                             child: SingleChildScrollView(
  //                                           scrollDirection: Axis.horizontal,
  //                                           child: Row(
  //                                             children: snoList.map((e) {
  //                                               return InkWell(
  //                                                 onTap: () {
  //                                                   if (e != null &&
  //                                                       e
  //                                                           .toString()
  //                                                           .isNotEmpty) {
  //                                                     if (!e
  //                                                         .toString()
  //                                                         .contains("W")) {
  //                                                       var toDate =
  //                                                           DateTime.now();
  //
  //                                                       String numberString = e.replaceAll(RegExp('[^0-9]'), '');
  //                                                       print("numberString $numberString");
  //
  //                                                       Navigator.push(
  //                                                           context,
  //                                                           MaterialPageRoute(
  //                                                               builder:
  //                                                                   (context) =>
  //                                                                       ViewCauseListScreenNew(
  //                                                                         mainCauseListdata: {
  //                                                                           "dateFrom": getddMMYYYY_with_splash(widget.displayBoardSummary['dateToday'].toString()),
  //                                                                               // getddMMYYYY_with_splash(widget.selectedDate.toString()),
  //                                                                           // "dateTo":
  //                                                                           //     getDDMMYYYY(toDate.toString()),
  //                                                                           "courtNo":
  //                                                                           widget.displayBoardSummary['courtNo'].toString() ?? "",
  //                                                                         "sNo":numberString,
  //                                                                           "type":e.toString().contains("D")?"Daily":"Supplementary",},
  //                                                                         isFromHomepage:
  //                                                                             true,
  //                                                                       isScrollToSno:true,
  //                                                                       isFilter: false,)));
  //                                                     }
  //                                                   }
  //                                                 },
  //                                                 child: HighlightText(
  //                                                   "$e",
  //                                                   "(S)",
  //                                                   mpHeadLine14(
  //                                                       fontWeight:
  //                                                           FontWeight.w500,
  //                                                       textColor:
  //                                                           AppColor.black),
  //                                                   mpHeadLine14(
  //                                                       fontWeight:
  //                                                           FontWeight.w500,
  //                                                       textColor: Colors.red),
  //                                                 ),
  //                                               );
  //                                             }).toList(),
  //                                           ),
  //                                         )
  //                                             // HighlightText(
  //                                             //   displaySummaryData != null
  //                                             //       ? displaySummaryData
  //                                             //       .summary![index].sno!
  //                                             //       : "",
  //                                             //   "(S)",
  //                                             //   mpHeadLine14(
  //                                             //       fontWeight:
  //                                             //       FontWeight.w500),
  //                                             //   mpHeadLine14(
  //                                             //       fontWeight:
  //                                             //       FontWeight.w500,
  //                                             //       textColor: Colors.red),
  //                                             // ),
  //                                             )
  //                                       ],
  //                                     ),
  //
  //                                     // RichText(
  //                                     //     text: TextSpan(text: "Sno.: ", style: mpHeadLine14(fontWeight: FontWeight.w500), children: <TextSpan>[
  //                                     //       TextSpan(
  //                                     //         text: displaySummaryData != null ? displaySummaryData.summary![index].sno : "",
  //                                     //         style: mpHeadLine14(textColor: Colors.black, fontWeight: FontWeight.w500),
  //                                     //       )
  //                                     //     ])),
  //                                     const SizedBox(
  //                                       height: 8,
  //                                     ),
  //                                     RichText(
  //                                         text: TextSpan(
  //                                             text: "Stage: ",
  //                                             style: mpHeadLine14(
  //                                                 fontWeight: FontWeight.w500),
  //                                             children: <TextSpan>[
  //                                           TextSpan(
  //                                             text: displaySummaryData != null
  //                                                 ? displaySummaryData
  //                                                     .summary![index].stage
  //                                                 : "",
  //                                             style: mpHeadLine14(
  //                                                 textColor: Colors.black,
  //                                                 fontWeight: FontWeight.w500),
  //                                           )
  //                                         ])),
  //                                     const SizedBox(
  //                                       height: 8,
  //                                     ),
  //                                     RichText(
  //                                         text: TextSpan(
  //                                             text: "Bench: ",
  //                                             style: mpHeadLine14(
  //                                                 fontWeight: FontWeight.w500),
  //                                             children: <TextSpan>[
  //                                           TextSpan(
  //                                             text: displaySummaryData != null
  //                                                 ? displaySummaryData
  //                                                     .summary![index].benchName
  //                                                 : "",
  //                                             style: mpHeadLine14(
  //                                                 textColor: Colors.black,
  //                                                 fontWeight: FontWeight.w500),
  //                                           )
  //                                         ])),
  //                                     SizedBox(
  //                                       height: displaySummaryData!
  //                                                       .summary![index]
  //                                                       .judgeTime !=
  //                                                   "" ||
  //                                               displaySummaryData
  //                                                       .summary![index]
  //                                                       .judgeTime2 !=
  //                                                   ""
  //                                           ? 8
  //                                           : 0,
  //                                     ),
  //                                     Text(
  //                                       displaySummaryData!.summary![index].judgeTime != "" && displaySummaryData.summary![index].judgeTime2 != ""
  //                                           ? displaySummaryData.summary![index].judgeTime! + " & " + displaySummaryData!.summary![index].judgeTime2!
  //                                           : displaySummaryData.summary![index].judgeTime == "" && displaySummaryData.summary![index].judgeTime2 == ""
  //                                           ? ""
  //                                           : displaySummaryData!.summary![index].judgeTime != ""
  //                                           ? displaySummaryData!.summary![index].judgeTime!
  //                                           : displaySummaryData.summary![index].judgeTime2!,
  //                                       style: mpHeadLine14(fontWeight: FontWeight.w500),
  //                                     ),
  //
  //                                     InkWell(
  //                                       onTap: () {
  //                                         setState(() {
  //                                           displaySummaryData.summary![index]
  //                                                   .isDropDownOpen =
  //                                               !displaySummaryData
  //                                                   .summary![index]
  //                                                   .isDropDownOpen;
  //                                         });
  //                                       },
  //                                       child: Column(
  //                                         children: [
  //                                           const SizedBox(
  //                                             height: 8,
  //                                           ),
  //                                           Row(
  //                                             mainAxisAlignment:
  //                                                 MainAxisAlignment
  //                                                     .spaceBetween,
  //                                             children: [
  //                                               Text('Detail',
  //                                                   style: mpHeadLine14(
  //                                                       fontWeight:
  //                                                           FontWeight.w500)),
  //                                               displaySummaryData
  //                                                       .summary![index]
  //                                                       .isDropDownOpen
  //                                                   ? const Icon(
  //                                                       Icons
  //                                                           .keyboard_arrow_down_outlined,
  //                                                     )
  //                                                   : const Icon(
  //                                                       Icons
  //                                                           .keyboard_arrow_up_outlined,
  //                                                     )
  //                                             ],
  //                                           ),
  //                                         ],
  //                                       ),
  //                                     ),
  //                                     Visibility(
  //                                         visible: displaySummaryData
  //                                             .summary![index].isDropDownOpen,
  //                                         child: ListView.builder(
  //                                           itemCount: displaySummaryData
  //                                               .summary![index]
  //                                               .sumamryDetail!
  //                                               .length,
  //                                           shrinkWrap: true,
  //                                           physics:
  //                                               NeverScrollableScrollPhysics(),
  //                                           scrollDirection: Axis.vertical,
  //                                           itemBuilder: (context, i) {
  //                                             List serNoList1 =
  //                                                 displaySummaryData
  //                                                     .summary![index]
  //                                                     .sumamryDetail![i]
  //                                                     .sno
  //                                                     .toString()
  //                                                     .split("-");
  //
  //
  //                                             List serNoList=[];
  //                                             for(int j=0; j<serNoList1.length; j++){
  //                                               if(!serNoList.contains(snoList1[j])){
  //                                                 if(j!=serNoList1.length-1) {
  //                                                   serNoList.add(serNoList1[j].toString()+" - ");
  //                                                 }else{
  //                                                   serNoList.add(serNoList1[j]);
  //                                                 }
  //                                               }
  //                                             }
  //                                             return Padding(
  //                                               padding: const EdgeInsets.only(
  //                                                   top: 5),
  //                                               child: Container(
  //                                                 decoration:
  //                                                     const BoxDecoration(
  //                                                   color: AppColor
  //                                                       .home_background,
  //                                                   shape: BoxShape.rectangle,
  //                                                 ),
  //                                                 child: Padding(
  //                                                   padding:
  //                                                       const EdgeInsets.all(
  //                                                           5.0),
  //                                                   child: Column(
  //                                                     crossAxisAlignment:
  //                                                         CrossAxisAlignment
  //                                                             .start,
  //                                                     children: [
  //                                                       RichText(
  //                                                         text: TextSpan(
  //                                                             text:
  //                                                                 "Case Type: ",
  //                                                             style: mpHeadLine12(
  //                                                                 fontWeight:
  //                                                                     FontWeight
  //                                                                         .w500),
  //                                                             children: <
  //                                                                 TextSpan>[
  //                                                               TextSpan(
  //                                                                   text: displaySummaryData !=
  //                                                                           null
  //                                                                       ? displaySummaryData
  //                                                                           .summary![
  //                                                                               index]
  //                                                                           .sumamryDetail![
  //                                                                               i]
  //                                                                           .caseType
  //                                                                       : "",
  //                                                                   style: mpHeadLine12(
  //                                                                       fontWeight:
  //                                                                           FontWeight.w500)),
  //                                                             ]),
  //                                                       ),
  //                                                       const SizedBox(
  //                                                         height: 5,
  //                                                       ),
  //                                                       Row(
  //                                                         children: [
  //                                                           Text(
  //                                                             "Sno. : ",
  //                                                             style: mpHeadLine14(
  //                                                                 fontWeight:
  //                                                                     FontWeight
  //                                                                         .w500),
  //                                                           ),
  //                                                           Flexible(
  //                                                               child:
  //                                                                   SingleChildScrollView(
  //                                                             scrollDirection:
  //                                                                 Axis.horizontal,
  //                                                             child: Row(
  //                                                               children:
  //                                                                   serNoList
  //                                                                       .map(
  //                                                                           (e) {
  //                                                                 return InkWell(
  //                                                                   onTap: () {
  //                                                                     if (e !=
  //                                                                             null &&
  //                                                                         e.toString().isNotEmpty) {
  //                                                                       print(
  //                                                                           "e named $e");
  //                                                                       if (!e
  //                                                                           .toString()
  //                                                                           .contains("W")) {
  //                                                                         String numberString = e.replaceAll(RegExp('[^0-9]'), '');
  //                                                                         print("numberString1 $numberString");
  //                                                                         Navigator.push(
  //                                                                             context,
  //                                                                             MaterialPageRoute(
  //                                                                                 builder: (context) => ViewCauseListScreenNew(
  //                                                                                       mainCauseListdata: {
  //                                                                                         "dateFrom": getddMMYYYY_with_splash(widget.displayBoardSummary['dateToday'].toString()),
  //                                                                                         //"dateTo": getDDMMYYYY(toDate.toString()),
  //                                                                                         "courtNo": widget.displayBoardSummary['courtNo'].toString(),
  //                                                                                       "sNo":numberString,
  //                                                                                         "type":e.toString().contains("D")?"Daily":"Supplementary",},
  //                                                                                       isFromHomepage: true,
  //                                                                                 isScrollToSno:true,
  //                                                                                     isFilter: false)));
  //                                                                       }
  //                                                                     }
  //                                                                   },
  //                                                                   child:
  //                                                                       HighlightText(
  //                                                                     "$e",
  //                                                                     "(S)",
  //                                                                     mpHeadLine14(
  //                                                                         fontWeight: FontWeight
  //                                                                             .w500,
  //                                                                         textColor:
  //                                                                             AppColor.black),
  //                                                                     mpHeadLine14(
  //                                                                         fontWeight: FontWeight
  //                                                                             .w500,
  //                                                                         textColor:
  //                                                                             Colors.red),
  //                                                                   ),
  //                                                                 );
  //                                                               }).toList(),
  //                                                             ),
  //                                                           )
  //                                                               // HighlightText(
  //                                                               //   displaySummaryData !=
  //                                                               //       null
  //                                                               //       ? displaySummaryData
  //                                                               //       .summary![index]
  //                                                               //       .sumamryDetail![i]
  //                                                               //       .sno
  //                                                               //       .toString()
  //                                                               //       : "",
  //                                                               //   "(S)",
  //                                                               //   mpHeadLine14(
  //                                                               //       fontWeight:
  //                                                               //       FontWeight
  //                                                               //           .w500),
  //                                                               //   mpHeadLine14(
  //                                                               //       fontWeight:
  //                                                               //       FontWeight
  //                                                               //           .w500,
  //                                                               //       textColor: Colors
  //                                                               //           .red),
  //                                                               // ),
  //                                                               )
  //                                                         ],
  //                                                       ),
  //                                                       // RichText(
  //                                                       //   text: TextSpan(text: "Sno: ", style: mpHeadLine12(fontWeight: FontWeight.w500), children: <TextSpan>[
  //                                                       //     TextSpan(text: displaySummaryData != null ? displaySummaryData.summary![index].sumamryDetail![i].sno : "", style: mpHeadLine12(fontWeight: FontWeight.w500)),
  //                                                       //   ]),
  //                                                       // ),
  //                                                       const SizedBox(
  //                                                         height: 3,
  //                                                       ),
  //                                                     ],
  //                                                   ),
  //                                                 ),
  //                                               ),
  //                                             );
  //                                           },
  //                                         )),
  //                                     const SizedBox(
  //                                       height: 5,
  //                                     ),
  //                                     displaySummaryData!.summary!.length - 1 ==
  //                                             index
  //                                         ? SizedBox()
  //                                         : const Divider(
  //                                             thickness: 1,
  //                                             color: AppColor.grey_color,
  //                                           )
  //                                   ],
  //                                 ),
  //                               );
  //                             }).toList(),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               );
  //             }
  //             return AppMsgPopup(
  //               displaySummaryModel.msg,
  //             );
  //           }
  //           return const SizedBox();
  //         },
  //       ),
  //     ],
  //   );
  // }
}
