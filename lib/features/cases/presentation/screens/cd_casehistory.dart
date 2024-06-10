import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/constants.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:haelo_flutter/core/utils/save_file.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/cases/cubit/casehistory_cubit.dart';
import 'package:haelo_flutter/features/cases/cubit/casehistory_state.dart';
import 'package:haelo_flutter/features/cases/cubit/deletecomment_cubit.dart';
import 'package:haelo_flutter/features/cases/cubit/deletecomment_state.dart';
import 'package:haelo_flutter/features/cases/cubit/editcounsel_cubit.dart';
import 'package:haelo_flutter/features/cases/cubit/editcounsel_state.dart';
import 'package:haelo_flutter/features/cases/cubit/mycases_cubit.dart';
import 'package:haelo_flutter/features/cases/presentation/screens/updatecomment.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/office_stage_dropdown.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/custom_alertBox.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/no_data_widget.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/pdf_screen.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/stay_dropdown.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/tab_progress_indicator.dart';
import 'package:haelo_flutter/features/task/presentation/screens/createtask.dart';
import 'package:haelo_flutter/widgets/date_format.dart';
import 'package:haelo_flutter/widgets/error_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:haelo_flutter/locators.dart' as di;
import '../../../google_drive/g_drive_handler/gdrivehandler_function.dart';
import '../widgets/watchlist_and_manually_dialog.dart';
import 'addcomment.dart';

class CaseHistory extends StatefulWidget {
  final getCaseId;
  final getCaseName;
  final getDetails;
  final getUserDetail;
  final tabIndexChangeCallback;

  const CaseHistory(
      {Key? key,
      this.getCaseId,
      this.getCaseName,
      this.getDetails,
      this.tabIndexChangeCallback,
      this.getUserDetail})
      : super(key: key);

  @override
  State<CaseHistory> createState() => _CaseHistoryState();
}

class _CaseHistoryState extends State<CaseHistory> {
  String dropdownvalue = 'Not set';
  String dropdownOffice = '';
  bool seniorCounselEngaged = false;
  String filePdf = "";
  String fileName = "";
  // var items = ['Full Stay', 'Intrim Stay', 'No Stay'];
  var items = ['Not Set', 'No Stay', 'Interim Stay', 'Full Stay'];
  Map<String, dynamic> authMap = {};
  Map<String, dynamic> driveIdMap = {};
  // bool isCommentViewMore=false;
  // bool isTaskViewMore=false;
  late SharedPreferences pref;
  @override
  void initState() {
    pref = di.locator();
    // print("usermob ${pref.getString(Constants.MOB_NO)}");
    fetchData();
    print("getCaseId ==> ${widget.getCaseId}");
    super.initState();
  }

  gmailAuthenticate() async {
    authMap = await GoogleDriveHandler().gmailAuthenticate(context);
  }

  fetchData() {
    var caseIdDetails = {
      "caseId": widget.getCaseId.toString(),
    };
    BlocProvider.of<CaseHistoryCubit>(context).fetchCaseHistory(caseIdDetails);
  }

  showConfirmationDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CustomAlert(
          getCaseID: widget.getCaseId.toString(),
          seniorCounselEngaged: seniorCounselEngaged,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          BlocConsumer<EditCounselCubit, EditCounselState>(
              builder: (context, state) {
            return const SizedBox();
          }, listener: (context, state) {
            if (state is EditCounselLoaded) {
              var editCounselList = state.editCounselModel;
              if (editCounselList.result == 1) {
                toast(msg: editCounselList.msg.toString());
                fetchData();
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
            }
          }),
          BlocConsumer<CaseHistoryCubit, CaseHistoryState>(
              builder: (context, state) {
            if (state is CaseHistoryLoading) {
              return TabProgressIndicator();
            }
            if (state is CaseHistoryLoaded) {
              var caseHistoryList = state.caseHistoryModel;
              if (caseHistoryList.result == 1) {
                if (caseHistoryList.data != null) {
                  var caseHistoryData = caseHistoryList.data;
                  var officeStageData = caseHistoryData?.officeStages;
                  List<String> stageNames = officeStageData!
                      .map((stage) => stage.stageName.toString())
                      .toList();

                  print(stageNames);
                  seniorCounselEngaged =
                      caseHistoryData!.caseCounsel!.seniorCounselEngaged!;
                  print("seniorCounselEngaged ${seniorCounselEngaged}");

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 15,
                          right: 15,
                          top: 10,
                        ),
                        child: SizedBox(
                          width: mediaQW(context) * 0.9,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Stay:",
                                    style: mpHeadLine14(
                                        fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (pref.getString(Constants.USER_TYPE) !=
                                          "2") {
                                        showDialog(
                                            context: context,
                                            builder: (ctx) => StayDropDown(
                                                stayCallback, dropdownvalue));
                                      }
                                    },
                                    child: Container(
                                      height: 32,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColor.primary, width: 2),
                                      ),
                                      width: mediaQW(context) * 0.40,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 3),
                                      child: Row(
                                        children: [
                                          Expanded(child: Text(dropdownvalue)),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          const Icon(
                                            Icons.arrow_drop_down,
                                            color: AppColor.primary,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Office stage:",
                                    style: mpHeadLine14(
                                        fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (pref.getString(Constants.USER_TYPE) !=
                                          "2") {
                                        showDialog(
                                            context: context,
                                            builder: (ctx) =>
                                                OfficeStageDropDown(
                                                    officeStageCallback,
                                                    dropdownOffice,
                                                    stageNames));
                                      }
                                    },
                                    child: Container(
                                      height: 32,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColor.primary, width: 2),
                                      ),
                                      width: mediaQW(context) * 0.40,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 3),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Text(dropdownOffice == ""
                                                  ? stageNames.first
                                                  : dropdownOffice)),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          const Icon(
                                            Icons.arrow_drop_down,
                                            color: AppColor.primary,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 15,
                          right: 15,
                          top: 10,
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Senior Engaged:  ",
                              style: mpHeadLine12(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              caseHistoryData!
                                          .caseCounsel!.seniorCounselEngaged ==
                                      true
                                  ? "YES"
                                  : "NO",
                              style: mpHeadLine12(),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            InkWell(
                              onTap: () {
                                showConfirmationDialog(context);
                              },
                              child: const Icon(
                                Icons.edit,
                                size: 20,
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, bottom: 8, top: 10),
                        child: caseHistoryData.caseList!.isNotEmpty
                            ? ListView.builder(
                                itemCount: caseHistoryData.caseList!.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  return Card(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                                text: "Date of Listing:  ",
                                                style: mpHeadLine12(
                                                    fontWeight:
                                                        FontWeight.w600),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text: caseHistoryData
                                                          .caseList![index]
                                                          .dateOfListing
                                                          .toString(),
                                                      style: mpHeadLine12()),
                                                ]),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                    text: "Court No.:  ",
                                                    style: mpHeadLine12(
                                                        fontWeight:
                                                            FontWeight.w600),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                          text: caseHistoryData
                                                                      .caseList![
                                                                          index]
                                                                      .courtNo !=
                                                                  null
                                                              ? caseHistoryData
                                                                  .caseList![
                                                                      index]
                                                                  .courtNo
                                                                  .toString()
                                                              : "",
                                                          style:
                                                              mpHeadLine12()),
                                                    ]),
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                    text: "S.No.:  ",
                                                    style: mpHeadLine12(
                                                        fontWeight:
                                                            FontWeight.w600),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                          text: caseHistoryData
                                                                      .caseList![
                                                                          index]
                                                                      .sno !=
                                                                  null
                                                              ? caseHistoryData
                                                                  .caseList![
                                                                      index]
                                                                  .sno
                                                                  .toString()
                                                              : "",
                                                          style:
                                                              mpHeadLine12()),
                                                    ]),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          RichText(
                                            text: TextSpan(
                                                text: "Stage:  ",
                                                style: mpHeadLine12(
                                                    fontWeight:
                                                        FontWeight.w600),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text: caseHistoryData
                                                                  .caseList![
                                                                      index]
                                                                  .stage !=
                                                              null
                                                          ? caseHistoryData
                                                              .caseList![index]
                                                              .stage
                                                              .toString()
                                                          : "",
                                                      style: mpHeadLine12()),
                                                ]),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Judge(s) Name: ",
                                                style: mpHeadLine12(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Flexible(
                                                child: Text(
                                                    caseHistoryData
                                                                .caseList![
                                                                    index]
                                                                .benchName !=
                                                            null
                                                        ? caseHistoryData
                                                            .caseList![index]
                                                            .benchName
                                                            .toString()
                                                        : "",
                                                    style: mpHeadLine12()),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          caseHistoryData.caseList![index]
                                                          .orderFile !=
                                                      null &&
                                                  caseHistoryData
                                                      .caseList![index]
                                                      .orderFile!
                                                      .isNotEmpty
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Order Judgement:",
                                                          style: mpHeadLine12(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
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
                                                                    builder: (context) =>
                                                                        PDFScreen(
                                                                            path:
                                                                                "https://d6kpk9izjhild.cloudfront.net/${caseHistoryData.caseList![index].orderFile!}")));
                                                          },
                                                          child: Icon(
                                                            Icons
                                                                .remove_red_eye,
                                                            color: AppColor
                                                                .primary,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        InkWell(
                                                          onTap: () async {
                                                            DateTime now =
                                                                DateTime.now();
                                                            var fileName =
                                                                "Judgement Details_${now.hour}_${now.minute}_${now.second}.${caseHistoryData.caseList![index].orderFile!.toString().split(".").last}";
                                                            downloadData(
                                                                "https://d6kpk9izjhild.cloudfront.net/${caseHistoryData.caseList![index].orderFile!}",
                                                                fileName);
                                                          },
                                                          child: Icon(
                                                            Icons.download,
                                                            color: AppColor
                                                                .primary,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                )
                                              : SizedBox(),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "Comments:",
                                                    style: mpHeadLine14(
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                              caseHistoryData
                                                          .caseList![index]
                                                          .commentDetails!
                                                          .length <
                                                      5
                                                  ? Row(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            print(
                                                                "hello ${caseHistoryData.caseList![index].dateOfListing.toString()}");
                                                            // print(
                                                            //     "datea of listing ${caseHistoryData.caseList![index].dateOfListing.toString()}");
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        AddComment(
                                                                          getCaseIdd:
                                                                              widget.getCaseId,
                                                                          isCaseHistory:
                                                                              true,
                                                                          getDateOfListing: caseHistoryData
                                                                              .caseList![index]
                                                                              .dateOfListing
                                                                              .toString(),
                                                                        ))).then(
                                                                (value) {
                                                              if (value !=
                                                                      null &&
                                                                  value ==
                                                                      true) {
                                                                fetchData();
                                                              }
                                                            });
                                                          },
                                                          child: const Icon(
                                                            Icons.add,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : SizedBox(),
                                            ],
                                          ),
                                          ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: !caseHistoryData
                                                        .caseList![index]
                                                        .isCommentViewMore &&
                                                    caseHistoryData
                                                            .caseList![index]
                                                            .commentDetails!
                                                            .length >
                                                        1
                                                ? 1
                                                : caseHistoryData
                                                            .caseList![index]
                                                            .commentDetails!
                                                            .length <
                                                        5
                                                    ? caseHistoryData
                                                        .caseList![index]
                                                        .commentDetails!
                                                        .length
                                                    : 5,
                                            itemBuilder: (context, i) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 6, left: 6, right: 6),
                                                child: Card(
                                                  color:
                                                      AppColor.home_background,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text("By:",
                                                                style: mpHeadLine12(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    textColor:
                                                                        AppColor
                                                                            .bold_text_color_dark_blue)),
                                                            SizedBox(
                                                              width: mediaQW(
                                                                      context) *
                                                                  0.52,
                                                              child: Text(
                                                                  caseHistoryData
                                                                          .caseList![
                                                                              index]
                                                                          .commentDetails![
                                                                              i]
                                                                          .userName
                                                                          .toString() +
                                                                      "(${caseHistoryData.caseList![index].commentDetails![i].mobNo.toString()}"
                                                                          ")",
                                                                  style: mpHeadLine12(
                                                                      textColor:
                                                                          AppColor
                                                                              .bold_text_color_dark_blue)),
                                                            ),
                                                            // const SizedBox(
                                                            //   width: 45,
                                                            // ),
                                                            caseHistoryData
                                                                        .caseList![
                                                                            index]
                                                                        .commentDetails![
                                                                            i]
                                                                        .mobNo
                                                                        .toString() ==
                                                                    pref.getString(
                                                                        Constants
                                                                            .MOB_NO)
                                                                ? Row(
                                                                    children: [
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          showDialog(
                                                                              context: context,
                                                                              builder: (ctx) {
                                                                                return AlertDialog(
                                                                                  // insetPadding: EdgeInsets.symmetric(vertical: 305),
                                                                                  contentPadding: EdgeInsets.zero,
                                                                                  content: SizedBox(
                                                                                    height: mediaQH(context) * 0.18,
                                                                                    // width: mediaQW(context) * 0.8,
                                                                                    child: Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.only(left: 20, right: 20, top: 25),
                                                                                          child: Text(
                                                                                            "Are you sure, you want to delete this comment?",
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
                                                                                                  Navigator.pop(context);
                                                                                                  var deleteComment = {
                                                                                                    "commentId": caseHistoryData.caseList![index].commentDetails![i].commentId.toString(),
                                                                                                  };
                                                                                                  BlocProvider.of<DeleteCommentCubit>(context).fetchDeleteComment(deleteComment);
                                                                                                },
                                                                                                child: Container(
                                                                                                  alignment: Alignment.center,
                                                                                                  height: mediaQH(context) * 0.05,
                                                                                                  decoration: BoxDecoration(borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(5)), border: Border.all(color: AppColor.primary)),
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
                                                                                                  Navigator.pop(context);
                                                                                                },
                                                                                                child: Container(
                                                                                                  alignment: Alignment.center,
                                                                                                  height: mediaQH(context) * 0.05,
                                                                                                  decoration: const BoxDecoration(
                                                                                                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(5)),
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
                                                                              });
                                                                        },
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .delete,
                                                                          size:
                                                                              20,
                                                                          color: Colors
                                                                              .red
                                                                              .shade800,
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            15,
                                                                      ),
                                                                      GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (context) => EditComment(
                                                                                          getCaseIdd: widget.getCaseId,
                                                                                          commentId: caseHistoryData.caseList![index].commentDetails![i].commentId.toString(),
                                                                                          getComment: caseHistoryData.caseList![index].commentDetails![i].comment.toString(),
                                                                                          isCaseHistory: true,
                                                                                          getDateOfListing: caseHistoryData.caseList![index].dateOfListing,
                                                                                          // apiDateOfListing: caseHistoryData.dateOfListing,
                                                                                          courtDate: caseHistoryData.court_date,
                                                                                          dateType: caseHistoryData.date_type != null && caseHistoryData.date_type!.isNotEmpty ? caseHistoryData.date_type : "",
                                                                                          noOfWeek: caseHistoryData.no_of_weeks != null ? caseHistoryData.no_of_weeks.toString() : "",
                                                                                        ))).then((value) {
                                                                              if (value != null && value == true) {
                                                                                fetchData();
                                                                              }
                                                                            });
                                                                          },
                                                                          child: Icon(
                                                                              Icons.edit,
                                                                              size: 20,
                                                                              color: Colors.red.shade800))
                                                                    ],
                                                                  )
                                                                : GestureDetector(
                                                                    onTap: () {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => EditComment(
                                                                                    getCaseIdd: widget.getCaseId,
                                                                                    commentId: caseHistoryData.caseList![index].commentDetails![i].commentId.toString(),
                                                                                    getComment: caseHistoryData.caseList![index].commentDetails![i].comment.toString(),
                                                                                    isCaseHistory: true,
                                                                                    getDateOfListing: caseHistoryData.caseList![index].dateOfListing,
                                                                                    // apiDateOfListing: caseHistoryData.dateOfListing,
                                                                                    courtDate: caseHistoryData.court_date,
                                                                                    dateType: caseHistoryData.date_type != null && caseHistoryData.date_type!.isNotEmpty ? caseHistoryData.date_type : "",
                                                                                    noOfWeek: caseHistoryData.no_of_weeks != null ? caseHistoryData.no_of_weeks.toString() : "",
                                                                                  ))).then((value) {
                                                                        if (value !=
                                                                                null &&
                                                                            value ==
                                                                                true) {
                                                                          fetchData();
                                                                        }
                                                                      });
                                                                    },
                                                                    child: Icon(
                                                                        Icons
                                                                            .edit,
                                                                        size:
                                                                            20,
                                                                        color: Colors
                                                                            .red
                                                                            .shade800)),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              mediaQW(context) *
                                                                  0.8,
                                                          child: Text(
                                                              caseHistoryData
                                                                  .caseList![
                                                                      index]
                                                                  .commentDetails![
                                                                      i]
                                                                  .comment
                                                                  .toString(),
                                                              style: mpHeadLine12(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  textColor:
                                                                      AppColor
                                                                          .bold_text_color_dark_blue)),
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
                                                                caseHistoryData
                                                                            .caseList![
                                                                                index]
                                                                            .commentDetails![
                                                                                i]
                                                                            .timestamp !=
                                                                        null
                                                                    ? dateTimeMMMDDYYYY(caseHistoryData
                                                                        .caseList![
                                                                            index]
                                                                        .commentDetails![
                                                                            i]
                                                                        .timestamp
                                                                        .toString())
                                                                    : "",
                                                                style: mpHeadLine10(
                                                                    textColor:
                                                                        AppColor
                                                                            .bold_text_color_dark_blue)),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          caseHistoryData.caseList![index]
                                                      .commentDetails!.length >
                                                  1
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          caseHistoryData
                                                                  .caseList![index]
                                                                  .isCommentViewMore =
                                                              !caseHistoryData
                                                                  .caseList![
                                                                      index]
                                                                  .isCommentViewMore;
                                                        });
                                                      },
                                                      child: Text(
                                                        caseHistoryData
                                                                .caseList![
                                                                    index]
                                                                .isCommentViewMore
                                                            ? "View Less"
                                                            : "View More",
                                                        style: appTextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    )
                                                  ],
                                                )
                                              : SizedBox(),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: Divider(
                                              color: AppColor.hint_color_grey,
                                              thickness: 1,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "Tasks:",
                                                    style: mpHeadLine14(
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                              caseHistoryData.caseList![index]
                                                          .taskListing!.length <
                                                      5
                                                  ? Row(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            String caseTitle =
                                                                "";
                                                            if (widget
                                                                    .getDetails !=
                                                                null) {
                                                              if (widget
                                                                      .getDetails
                                                                      .petitioner !=
                                                                  null) {
                                                                caseTitle = widget
                                                                    .getDetails
                                                                    .petitioner!;
                                                              }
                                                              if (widget
                                                                      .getDetails
                                                                      .respondent !=
                                                                  null) {
                                                                caseTitle = caseTitle +
                                                                    ", " +
                                                                    widget
                                                                        .getDetails
                                                                        .respondent!;
                                                              }
                                                            }
                                                            // !=null? caseDetailData.caseDetail.petitioner!=null?caseDetailData.caseDetail.petitioner! + ", "+
                                                            // caseDetailData.caseDetail.respondent!=null?caseDetailData.caseDetail.respondent:"":"":""

                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        CreateTask(
                                                                  getTaskCaseId: widget
                                                                      .getCaseId
                                                                      .toString(),
                                                                  getCaseNoo: widget
                                                                      .getCaseName
                                                                      .toString(),
                                                                  getCaseTitle:
                                                                      caseTitle,
                                                                  dateOfListing: caseHistoryData
                                                                      .caseList![
                                                                          index]
                                                                      .dateOfListing
                                                                      .toString(),
                                                                ),
                                                              ),
                                                            ).then((value) {
                                                              if (value !=
                                                                      null &&
                                                                  value) {
                                                                fetchData();
                                                              }
                                                            });
                                                          },
                                                          child: const Icon(
                                                            Icons.add,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : SizedBox(),
                                            ],
                                          ),
                                          ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: !caseHistoryData
                                                        .caseList![index]
                                                        .isTaskViewMore &&
                                                    caseHistoryData
                                                            .caseList![index]
                                                            .taskListing!
                                                            .length >
                                                        1
                                                ? 1
                                                : caseHistoryData
                                                            .caseList![index]
                                                            .taskListing!
                                                            .length <
                                                        5
                                                    ? caseHistoryData
                                                        .caseList![index]
                                                        .taskListing!
                                                        .length
                                                    : 5,
                                            itemBuilder: (context, i) {
                                              return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10,
                                                          left: 10,
                                                          right: 10),
                                                  child: InkWell(
                                                    onTap: () {
                                                      widget
                                                          .tabIndexChangeCallback(
                                                              8);
                                                    },
                                                    child: Card(
                                                        color: AppColor
                                                            .home_background,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Column(
                                                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    // const SizedBox(
                                                                    //   width: 45,
                                                                    // ),
                                                                    SizedBox(
                                                                      width: mediaQW(
                                                                              context) *
                                                                          0.7,
                                                                      child: Text(
                                                                          caseHistoryData
                                                                              .caseList![
                                                                                  index]
                                                                              .taskListing![
                                                                                  i]
                                                                              .taskTitle
                                                                              .toString(),
                                                                          maxLines:
                                                                              2,
                                                                          style: mpHeadLine12(
                                                                              fontWeight: FontWeight.w500,
                                                                              textColor: AppColor.bold_text_color_dark_blue)),
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    // used Row in place of richtext so that card occupies appropriate space in page.
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Text(
                                                                            caseHistoryData.caseList![index].taskListing![i].taskDate
                                                                                .toString(),
                                                                            style:
                                                                                mpHeadLine10(textColor: AppColor.bold_text_color_dark_blue)),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ]),
                                                        )),
                                                  ));
                                            },
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          caseHistoryData.caseList![index]
                                                      .taskListing!.length >
                                                  1
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          caseHistoryData
                                                                  .caseList![index]
                                                                  .isTaskViewMore =
                                                              !caseHistoryData
                                                                  .caseList![
                                                                      index]
                                                                  .isTaskViewMore;
                                                        });
                                                      },
                                                      child: Text(
                                                        caseHistoryData
                                                                .caseList![
                                                                    index]
                                                                .isTaskViewMore
                                                            ? "View Less"
                                                            : "View More",
                                                        style: appTextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    )
                                                  ],
                                                )
                                              : SizedBox(),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : NoDataAvailable(
                                "Case History will be shown here."),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  );
                }
              }
              return NoDataAvailable("Case History will be shown here.");
            }
            return const SizedBox();
          }, listener: (context, state) {
            if (state is CaseHistoryLoaded) {
              var caseHistoryList = state.caseHistoryModel;
              if (caseHistoryList.result == 1) {
                if (caseHistoryList.data != null) {
                  var caseInterimCall =
                      caseHistoryList.data!.caseCounsel!.interimCol;
                  var caseOfficeCall =
                      caseHistoryList.data!.caseCounsel!.officeStage;
                  print("inetrim call $caseInterimCall");
                  if (caseInterimCall != null &&
                      caseInterimCall.isNotEmpty &&
                      caseInterimCall != "0") {
                    dropdownvalue = caseInterimCall;
                  } else {
                    dropdownvalue = "Not set";
                  }

                  if (caseOfficeCall != null &&
                      caseOfficeCall.isNotEmpty &&
                      caseOfficeCall != "0") {
                    dropdownOffice = caseOfficeCall;
                  } else {
                    dropdownOffice = "";
                  }
                  // == items[1].toString()
                  // ? items[1]
                  // : caseInterimCall == items[2].toString()
                  //     ? items[2]
                  //     : caseInterimCall == items[3].toString()
                  //         ? items[3]
                  //         : items[0];
                }
              }
            }
          }),
          BlocConsumer<DeleteCommentCubit, DeleteCommentState>(
              builder: (context, state) {
            return const SizedBox();
          }, listener: (context, state) {
            if (state is DeleteCommentLoaded) {
              var deleteCommentList = state.deleteCommentModel;
              if (deleteCommentList.result == 1) {
                fetchData();
                toast(msg: deleteCommentList.msg.toString());
                /*   showDialog(
                    context: context,
                    builder: (ctx) => AppMsgPopup(
                          deleteCommentList.msg.toString(),
                          isCloseIcon: false,
                          isError: false,
                          btnCallback: () {
                            Navigator.pop(context);
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
        ],
      ),
    );
  }

  // Future<void> _launchUrl(String url) async {
  //   if (!await launchUrl(Uri.parse(url))) {
  //     throw Exception('Could not launch $url');
  //   }
  // }

  void stayCallback(String selectedStayType) {
    if (dropdownvalue != selectedStayType) {
      setState(() {
        dropdownvalue = selectedStayType;
      });
      var editCounsel = {
        "caseId": widget.getCaseId.toString(),
        // "seniorCounsel": "0",
        "interimStay": dropdownvalue
      };
      print("dropdownvalue ==> $dropdownvalue");
      BlocProvider.of<EditCounselCubit>(context).fetchEditCounsel(editCounsel);
    }
  }

  void officeStageCallback(String selectedValue) {
    if (dropdownOffice != selectedValue) {
      setState(() {
        dropdownOffice = selectedValue;
      });

      print("dropdownOffice ==> $dropdownOffice");
      var editCounsel = {
        "caseId": widget.getCaseId.toString(),
        // "seniorCounsel": "0",
        "interimStay": dropdownvalue,
        "officeStage": dropdownOffice
      };
      BlocProvider.of<EditCounselCubit>(context).fetchEditCounsel(editCounsel);
    }
  }

  downloadData(String file, String filePdfName) async {
    setState(() {
      filePdf = file;
      fileName = filePdfName;
    });

    showDialog(
        context: context,
        builder: (ctx) => WatchListAndUpdatePopup(
              btnCallback: onClickDownloadShown,
              btnUpdateManuallyCallback: onClickGoogleDriveShown,
              heading1: 'Download',
              heading2: 'Save to Google Drive',
            ));
  }

  Future<void> onClickDownloadShown() async {
    toast(msg: "Downloading started");
    await downloadFiles(filePdf, fileName);
  }

  Future<void> createCaseFolderDrive() async {
    /*driveIdMap = await GoogleDriveHandler()
        .folderCreate(authMap["driveApi"], "Case History", "Order Judgement");*/
    driveIdMap = await GoogleDriveHandler().folderCreate(
        authMap["driveApi"],
        "My Cases",
        "Order_Judgement_${widget.getUserDetail!.userDetail!.caseNo.toString()}_${widget.getUserDetail!.userDetail!.caseYear.toString()}_${widget.getUserDetail!.userDetail!.caseType}_${widget.getUserDetail!.userDetail!.caseCategory.toString()}");
  }

  Future<void> onClickGoogleDriveShown() async {
    try {
      /*  setState(() {
        isLoa
      });*/

      await gmailAuthenticate();

      await createCaseFolderDrive();

      toast(msg: "Downloading started");

      await GoogleDriveHandler().fileUploadToDrivePdf(
          authMap["driveApi"], driveIdMap['sub_folder_id'], filePdf, fileName);

      toast(msg: "Downloading completed");
      print("All tasks completed successfully!");
    } catch (error) {
      // Handle errors
      print("An error occurred: $error");
    }
  }
}
