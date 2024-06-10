import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/constants.dart';
import 'package:haelo_flutter/core/utils/functions.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/bottom_bar/presentation/screens/bottombar.dart';
import 'package:haelo_flutter/features/cases/cubit/casedetail_cubit.dart';
import 'package:haelo_flutter/features/cases/cubit/casedetail_state.dart';
import 'package:haelo_flutter/features/cases/data/model/mycases_model.dart';
import 'package:haelo_flutter/features/cases/presentation/screens/cd_drive_screen.dart';
import 'package:haelo_flutter/features/cases/presentation/screens/editaddcase.dart';

import 'cd_casedetails.dart';
import 'cd_casedetailsbyuser.dart';
import 'cd_casehistory.dart';
import 'cd_comments.dart';
import 'cd_connectedcases.dart';
import 'cd_connectedmatters.dart';
import 'cd_documents.dart';
import 'cd_expenses.dart';
import 'cd_fees.dart';
import 'cd_filingdetails.dart';
import 'cd_lowercourtdetails.dart';
import 'cd_paperdetails.dart';
import 'cd_tasks.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:haelo_flutter/locators.dart' as di;

class CaseDetails extends StatefulWidget {
  // final Data getCaseDetails;
  final index;
  final caseId;
  bool isReaded;
  CaseDetails(
      {Key? key, required this.caseId, this.index = 0, this.isReaded = false})
      : super(key: key);

  @override
  State<CaseDetails> createState() => _CaseDetailsState();
}

class _CaseDetailsState extends State<CaseDetails>
    with SingleTickerProviderStateMixin {
  TabController? controller;
  late SharedPreferences pref;
  @override
  void initState() {
    pref = di.locator();
    controller =
        TabController(length: 14, vsync: this, initialIndex: widget.index);
    var caseIdDetails = {
      "caseId": widget.caseId.toString(),
    };

    caseIdDetails['requestType'] = widget.isReaded ? "isReaded" : "";

    BlocProvider.of<CaseDetailCubit>(context).fetchCaseDetail(caseIdDetails);
    super.initState();
  }

  var caseDetailData;

  @override
  void dispose() {
    if (controller != null) controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 14,
      initialIndex: widget.index,
      child: Scaffold(
        backgroundColor: AppColor.home_background,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios_new_sharp,
              size: 24,
            ),
          ),
          titleSpacing: -5,
          title: Text(
            "Case Details",
            style: mpHeadLine16(
                fontWeight: FontWeight.w500,
                textColor: AppColor.bold_text_color_dark_blue),
          ),
          actions: [
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
          bottom: TabBar(
            isScrollable: true,
            labelColor: AppColor.primary,
            unselectedLabelColor: AppColor.bold_text_color_dark_blue,
            indicatorColor: AppColor.primary,
            controller: controller!,
            tabs: [
              Tab(text: "CASE DETAILS BY USER"),
              Tab(text: "CASE DETAILS"),
              Tab(text: "CASE HISTORY"),
              Tab(text: "PAPER DETAILS"),
              Tab(text: "FILING DETAILS"),
              Tab(text: "CONNECTED CASES"),
              Tab(text: "CONNECTED MATTERS"),
              Tab(text: "LOWER COURT DETAILS"),
              Tab(text: "TASKS"),
              Tab(text: "DOCUMENTS"),
              Tab(text: "COMMENTS"),
              Tab(text: "EXPENSES"),
              Tab(text: "FEES"),
              Tab(text: "Google Drive Data"),
            ],
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
                  child: Row(
                    children: [
                      Text(
                        "For HC website link - go to Case Details section",
                        style: mpHeadLine12(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "ITMO: ",
                          style: mpHeadLine12(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Flexible(
                          child: Text(
                            caseDetailData != null &&
                                    caseDetailData!.userDetail!.itmo != null
                                ? caseDetailData!.userDetail!.itmo.toString()
                                : "",
                            style: mpHeadLine12(),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        pref.getString(Constants.USER_TYPE) != "2"
                            ? InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditAddCase(
                                                getCaseIdBack: widget.caseId,
                                                itmo: caseDetailData != null &&
                                                        caseDetailData!
                                                                .userDetail!
                                                                .itmo !=
                                                            null
                                                    ? caseDetailData!
                                                        .userDetail!.itmo
                                                        .toString()
                                                    : "",
                                                email: caseDetailData != null &&
                                                        caseDetailData!
                                                                .userDetail!
                                                                .email !=
                                                            null
                                                    ? caseDetailData!
                                                        .userDetail!.email
                                                        .toString()
                                                    : "",
                                                mobileNo:
                                                    caseDetailData != null &&
                                                            caseDetailData!
                                                                    .userDetail!
                                                                    .mobNo !=
                                                                null
                                                        ? caseDetailData!
                                                            .userDetail!.mobNo
                                                            .toString()
                                                        : "",
                                              ))).then((value) {
                                    if (value != null && value) {
                                      var caseIdDetails = {
                                        "caseId": widget.caseId.toString(),
                                      };
                                      BlocProvider.of<CaseDetailCubit>(context)
                                          .fetchCaseDetail(caseIdDetails);
                                    }
                                  });
                                },
                                child: const Icon(
                                  Icons.edit,
                                  size: 18,
                                ),
                              )
                            : SizedBox()
                      ],
                    )),
                BlocConsumer<CaseDetailCubit, CaseDetailState>(
                    builder: (context, state) {
                  return caseDetailData != null
                      ? Container(
                          // color: Colors.red,
                          height: mediaQH(context) * 0.8,
                          child: TabBarView(
                            controller: controller,
                            children: [
                              CaseDetailsByUser(
                                  getUserDetail: caseDetailData,
                                  caseId: widget.caseId),
                              CaseDetails_tab(getCaseData: caseDetailData),
                              CaseHistory(
                                  getCaseId: widget.caseId,
                                  // getCaseName: widget.getCaseDetails.caseName,
                                  // getTitle: widget.getCaseDetails.caseTitle,
                                  getCaseName:
                                      caseDetailData.caseDetail.regDetails,
                                  getUserDetail: caseDetailData,
                                  getDetails: caseDetailData.caseDetail,
                                  tabIndexChangeCallback: changeTabIndex),
                              PaperDetails(getCaseId: widget.caseId),
                              FilingDetails(getFilingData: caseDetailData),
                              ConnectedCases(getConnectedCases: caseDetailData),
                              ConnectedMatters(
                                  getConnectedMatters: caseDetailData),
                              LowerCourtDetails(getLowerCourt: caseDetailData),
                              Tasks(getCaseId: widget.caseId),
                              Documents(getCaseId: widget.caseId),
                              Comments(getCaseId: widget.caseId),
                              Expenses(getCaseId: widget.caseId),
                              Fees(getCaseId: widget.caseId),
                              CaseDetailsDrivePage(
                                  caseDetailData,
                                  caseDetailData.drivePath ?? "",
                                  widget.caseId),
                            ],
                          ),
                        )
                      : SizedBox();
                }, listener: (context, state) {
                  if (state is CaseDetailLoaded) {
                    var myCaseDetailModel = state.caseDetailModel;
                    if (myCaseDetailModel.result == 1) {
                      if (myCaseDetailModel.data != null) {
                        setState(() {
                          caseDetailData = myCaseDetailModel.data;
                          print("drivepath ${caseDetailData.drivePath}");
                        });
                        // caseDetailData = myCaseDetailModel.data!.userDetail!.email;
                      }
                    } else {
                      toast(msg: myCaseDetailModel.msg.toString());
                    }
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void changeTabIndex(int ind) {
    print("chaning value $ind");
    setState(() {
      controller!.animateTo(ind);
    });
  }
}
