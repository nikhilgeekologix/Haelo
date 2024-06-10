import 'package:flutter/material.dart';
import 'package:haelo_flutter/constants.dart';
import 'package:haelo_flutter/core/utils/hightlight_text.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/causeslist/presentation/screen/causelist_page.dart';
import 'package:haelo_flutter/features/causeslist/presentation/screen/causelist_screen.dart';
import 'package:haelo_flutter/features/causeslist/presentation/screen/viewcauselist.dart';
import 'package:haelo_flutter/widgets/date_format.dart';

class CourtSummary extends StatelessWidget {
  final summaryData;
  final selectedDate;

  const CourtSummary(this.summaryData, this.selectedDate, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.all(20),
            constraints:
            BoxConstraints(maxHeight: mediaQH(context) * 0.8),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
              Container(
                padding: EdgeInsets.zero,
                height: mediaQH(context) * 0.06,
                // width: mediaQW(context) * 0.9,
                decoration: BoxDecoration(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Spacer(),
                    Text(
                      "Court Summary",
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
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 1),
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: summaryData.length,
                    itemBuilder: (context, index) {
                      List casesList1 =
                          summaryData[index].sno.toString().split("-");

                      List casesList = [];
                      for (int j = 0; j < casesList1.length; j++) {
                        if (!casesList.contains(casesList1[j])) {
                          if (j != casesList1.length - 1) {
                            casesList.add(casesList1[j].toString() + " - ");
                          } else {
                            casesList.add(casesList1[j]);
                          }
                        }
                      }

                      return Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            summaryData[index].courtNo ==
                                        "Before Dy. Registrar (Judicial)" ||
                                    summaryData[index].courtNo ==
                                        "Before Registrar (Admin.)"
                                ? SizedBox()
                                : summaryData[index].heading != null
                                    ? Text(
                                        summaryData[index].heading,
                                        style: mpHeadLine14(
                                            textColor: AppColor.primary,
                                            fontWeight: FontWeight.w400),
                                      )
                                    : Row(
                                        children: [
                                          Text(
                                            "Sno. : ",
                                            style: mpHeadLine14(
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Flexible(
                                              child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: casesList.map((e) {
                                                return InkWell(
                                                  onTap: () {
                                                    if (e != null &&
                                                        e.toString().isNotEmpty) {

                                                      if (!e
                                                          .toString()
                                                          .contains("W")) {

                                                        String numberString = e.replaceAll(RegExp('[^0-9]'), '');
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    ViewCauseListScreenNew(
                                                                      mainCauseListdata: {
                                                                        "dateFrom":
                                                                            getddMMYYYY_with_splash(
                                                                                selectedDate.toString()),
                                                                        // "dateTo": getDDMMYYYY(toDate.toString()),
                                                                        "courtNo": summaryData[index].courtNo ==
                                                                                    "Before Dy. Registrar (Judicial)" ||
                                                                                summaryData[index].courtNo ==
                                                                                    "Before Registrar (Admin.)"
                                                                            ? ""
                                                                            : summaryData[index]
                                                                                .courtNo,
                                                                        "sNo": numberString,
                                                                        "type": e
                                                                                .toString()
                                                                                .contains("D")
                                                                            ? "Daily"
                                                                            : "Supplementary",
                                                                        // 'judgeName':summaryData[index].benchName
                                                                      },
                                                                      isFromHomepage:
                                                                          true,
                                                                      isScrollToSno:
                                                                          true,
                                                                      isFilter: false,
                                                                    )));
                                                      }
                                                    }
                                                  },
                                                  child: HighlightText(
                                                    "$e",
                                                    "(S)",
                                                    mpHeadLine14(
                                                        fontWeight: FontWeight.w500,
                                                        textColor: AppColor.black),
                                                    mpHeadLine14(
                                                        fontWeight: FontWeight.w500,
                                                        textColor: Colors.red),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ))
                                        ],
                                      ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Sno. : ",
                                  style: mpHeadLine14(fontWeight: FontWeight.w500),
                                ),
                                Flexible(
                                    child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: casesList.map((e) {
                                      return InkWell(
                                        onTap: () {
                                          if (e != null &&
                                              e.toString().isNotEmpty) {

                                            if (!e.toString().contains("W")) {
                                              String numberString = e.replaceAll(RegExp('[^0-9]'), '');
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                              ViewCauseListScreenNew(
                                                                mainCauseListdata: {
                                                                  "dateFrom":
                                                                      getddMMYYYY_with_splash(
                                                                          selectedDate
                                                                              .toString()),
                                                                  //"dateTo": getDDMMYYYY(toDate.toString()),
                                                                  "courtNo": summaryData[index]
                                                                                  .courtNo ==
                                                                              "Before Dy. Registrar (Judicial)" ||
                                                                          summaryData[index]
                                                                                  .courtNo ==
                                                                              "Before Registrar (Admin.)"
                                                                      ? ""
                                                                      : summaryData[
                                                                              index]
                                                                          .courtNo,
                                                                  "sNo":numberString,
                                                                  "type": e
                                                                      .toString()
                                                                      .contains("D")
                                                                      ? "Daily"
                                                                      : "Supplementary",
                                                                  // 'judgeName':summaryData[index].benchName
                                                                },
                                                                isFromHomepage:
                                                                    true,
                                                                isScrollToSno:true,
                                                                isFilter: false,
                                                              )));
                                            }
                                          }
                                        },
                                        child: HighlightText(
                                          "$e",
                                          "(S)",
                                          mpHeadLine14(
                                              fontWeight: FontWeight.w500,
                                              textColor: AppColor.black),
                                          mpHeadLine14(
                                              fontWeight: FontWeight.w500,
                                              textColor: Colors.red),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ))
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            RichText(
                                text: TextSpan(
                                    text: "Court No.: ",
                                    style:
                                        mpHeadLine14(fontWeight: FontWeight.w500),
                                    children: <TextSpan>[
                                  TextSpan(
                                    text: summaryData[index].courtNo,
                                    style: mpHeadLine14(
                                        textColor: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  )
                                ])),
                            const SizedBox(
                              height: 8,
                            ),
                            RichText(
                                text: TextSpan(
                                    text: "Bench : ",
                                    style:
                                        mpHeadLine14(fontWeight: FontWeight.w500),
                                    children: <TextSpan>[
                                  TextSpan(
                                    text: summaryData[index].benchName,
                                    style: mpHeadLine14(
                                        textColor: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  )
                                ])),
                            summaryData[index].judgeTime.isNotEmpty ||
                                    summaryData[index].judgeTime1.isNotEmpty
                                ? Column(
                                    children: [
                                      Text(
                                        summaryData[index].judgeTime != "" &&
                                                summaryData[index].judgeTime1 != ""
                                            ? summaryData[index].judgeTime +
                                                " & " +
                                                summaryData[index].judgeTime1
                                            : summaryData[index].judgeTime != ""
                                                ? summaryData[index].judgeTime
                                                : summaryData[index].judgeTime1,
                                        style: mpHeadLine14(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                    ],
                                  )
                                : SizedBox(),
                            summaryData.length - 1 == index
                                ? SizedBox()
                                : const Divider(
                                    thickness: 1,
                                    color: AppColor.grey_color,
                                  )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ])),
      ],
    );
  }
}
