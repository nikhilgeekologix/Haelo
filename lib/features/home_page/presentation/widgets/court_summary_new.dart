import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:haelo_flutter/constants.dart';
import 'package:haelo_flutter/core/utils/hightlight_text.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/causeslist/presentation/screen/causelist_page.dart';
import 'package:haelo_flutter/features/home_page/data/model/CourtSummaryNewModel.dart';
import 'package:haelo_flutter/widgets/date_format.dart';

class CourtSummaryNew extends StatefulWidget {
  final summaryDataNew;
  final causeListDates;

  CourtSummaryNew(this.summaryDataNew, this.causeListDates, {Key? key})
      : super(key: key);

  @override
  State<CourtSummaryNew> createState() => _CourtSummaryNewState();
}

class _CourtSummaryNewState extends State<CourtSummaryNew> {
  CarouselController carouselController = CarouselController();
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    print("causeListDates length: ${widget.causeListDates.length}");

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.all(20),
          constraints: BoxConstraints(maxHeight: mediaQH(context) * 0.8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.zero,
                height: mediaQH(context) * 0.06,
                decoration: const BoxDecoration(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Spacer(),
                    Text(
                      "Quick Update",
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
              Expanded(
                child: CarouselSlider(
                  carouselController: carouselController,
                  items: widget.causeListDates.map<Widget>((causeDate) {
                    var filterData = widget.summaryDataNew
                        .where((data) =>
                            getEEEddMMMyyyy(data.causeListDate) ==
                            getEEEddMMMyyyy(causeDate))
                        .toList();

                    int dateLength = widget.causeListDates.length;
                    print("causeListDates dateLength: ${dateLength}");
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: MergeableView(
                        causeDate: causeDate,
                        filterData: filterData,
                        carouselController: carouselController,
                        currentPageIndex: currentPageIndex,
                        dateLength: dateLength,
                        causeListDates: widget.causeListDates,
                      ),
                    );
                  }).toList(),
                  options: CarouselOptions(
                      height: MediaQuery.of(context).size.height,
                      viewportFraction: 1.0,
                      initialPage: 0,
                      enableInfiniteScroll: false,
                      reverse: false,
                      autoPlay: false,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: false,
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (index, reason) {
                        setState(() {
                          currentPageIndex = index;
                          print("currentPageIndex $currentPageIndex");
                        });
                      }),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class MergeableView extends StatefulWidget {
  final String causeDate;
  final int currentPageIndex;
  final int dateLength;
  final List<Data> filterData;
  final CarouselController carouselController;
  final causeListDates;

  MergeableView({
    required this.causeDate,
    required this.filterData,
    required this.carouselController,
    required this.currentPageIndex,
    required this.dateLength,
    required this.causeListDates,
  });

  @override
  State<MergeableView> createState() => _MergeableViewState();
}

class _MergeableViewState extends State<MergeableView> {
  ScrollController controller = ScrollController();

  @override
  void initState() {
    print("causeDate dateLength ==>${widget.dateLength}");
    print("causeDate causeListDates ==>${widget.causeListDates}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: widget.currentPageIndex != 0
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            widget.currentPageIndex != 0
                ? IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      widget.carouselController.previousPage();
                    },
                  )
                : const SizedBox(
                    width: 30,
                  ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppColor.primary,
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: Text(
                getEEEddMMMyyyy(widget.causeDate),
                style: appTextStyle(
                  textColor: AppColor.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            widget.currentPageIndex != widget.dateLength - 1
                ? IconButton(
                    onPressed: () {
                      widget.carouselController.nextPage();
                    },
                    icon: Icon(Icons.arrow_forward),
                  )
                : const SizedBox(
                    width: 30,
                  ),
          ],
        ),
        Expanded(
          child: Scrollbar(
            trackVisibility: true,
            thumbVisibility: true,
            controller: controller,
            interactive: true,
            thickness: 10,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: widget.filterData.length,
              controller: controller,
              itemBuilder: (context, index) {
                List casesList1 =
                    widget.filterData[index].sno.toString().split("-");
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
                print(
                    "filterData currentPageIndex ==>${widget.currentPageIndex}");
                print("causeDate length ==>${widget.causeDate.length}");
                return Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 5,
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
                                    if (e != null && e.toString().isNotEmpty) {
                                      if (!e.toString().contains("W")) {
                                        String numberString =
                                            e.replaceAll(RegExp('[^0-9]'), '');
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ViewCauseListScreenNew(
                                                      mainCauseListdata: {
                                                        "courtNo": widget
                                                                        .filterData[
                                                                            index]
                                                                        .courtNo ==
                                                                    "Before Dy. Registrar (Judicial)" ||
                                                                widget
                                                                        .filterData[
                                                                            index]
                                                                        .courtNo ==
                                                                    "Before Registrar (Admin.)"
                                                            ? ""
                                                            : widget
                                                                .filterData[
                                                                    index]
                                                                .courtNo,
                                                        "sNo": numberString,
                                                        "type": e
                                                                .toString()
                                                                .contains("D")
                                                            ? "Daily"
                                                            : "Supplementary",
                                                        // 'judgeName':filterData[index].benchName
                                                      },
                                                      isFromHomepage: true,
                                                      isScrollToSno: true,
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
                              style: mpHeadLine14(fontWeight: FontWeight.w500),
                              children: <TextSpan>[
                            TextSpan(
                              text: widget.filterData[index].courtNo,
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
                              text: "Count: ",
                              style: mpHeadLine14(fontWeight: FontWeight.w500),
                              children: <TextSpan>[
                            TextSpan(
                              text: widget.filterData[index].count.toString(),
                              style: mpHeadLine14(
                                  textColor: Colors.black,
                                  fontWeight: FontWeight.w500),
                            )
                          ])),
                      const SizedBox(
                        height: 8,
                      ),
                      Visibility(
                        visible: widget.filterData[index].benchName != ""
                            ? true
                            : false,
                        child: RichText(
                            text: TextSpan(
                                text: "Bench : ",
                                style:
                                    mpHeadLine14(fontWeight: FontWeight.w500),
                                children: <TextSpan>[
                              TextSpan(
                                text: widget.filterData[index].benchName,
                                style: mpHeadLine14(
                                    textColor: Colors.black,
                                    fontWeight: FontWeight.w500),
                              )
                            ])),
                      ),
                      widget.filterData.length - 1 == index
                          ? SizedBox()
                          : const Divider(
                              thickness: 1,
                              color: AppColor.grey_color,
                            ),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
