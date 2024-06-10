import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/cases/cubit/casedetail_cubit.dart';
import 'package:haelo_flutter/features/cases/cubit/casedetail_state.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/no_data_widget.dart';
import 'package:haelo_flutter/features/userboard/presentation/widgets/html_content.dart';

class CaseDetails_tab extends StatefulWidget {
  final getCaseData;
  const CaseDetails_tab({Key? key, required this.getCaseData}) : super(key: key);

  @override
  State<CaseDetails_tab> createState() => _CaseDetails_tabState();
}

class _CaseDetails_tabState extends State<CaseDetails_tab> {
  // void initState() {
  //   var caseIdDetails = {
  //     "caseId": widget.getCaseId.toString(),
  //   };
  //   BlocProvider.of<CaseDetailCubit>(context).fetchCaseDetail(caseIdDetails);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return widget.getCaseData!=null && widget.getCaseData!.caseDetail!=null?
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // BlocConsumer<CaseDetailCubit, CaseDetailState>(
        //     builder: (context, state) {
        //       if (state is CaseDetailLoaded) {
        //         var myCaseDetailModel = state.caseDetailModel;
        //         if (myCaseDetailModel.result == 1) {
        //           if (myCaseDetailModel.data != null) {
        //             var caseDetailData = myCaseDetailModel.data;
        //           }
        //         } else {
        //           toast(msg: myCaseDetailModel.msg.toString());
        //         }
        //       }
        //       return const SizedBox();
        //     },
        //     listener: (context, state) {}),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      widget.getCaseData!.caseDetail!.decision??"",
                      style: mpHeadLine12(fontWeight: FontWeight.w600, textColor: Colors.red.shade800),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  RichText(
                    text: TextSpan(
                        text: "Date of Listing: ",
                        style: mpHeadLine12(fontWeight: FontWeight.w600,
                        textColor: AppColor.primary),
                        children: <TextSpan>[
                          TextSpan(text: widget.getCaseData!.caseDetail!.dateOfListing??"", style: mpHeadLine12()),
                        ]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RichText(
                    text: TextSpan(
                        text: "Reg. Details: ",
                        style: mpHeadLine12(fontWeight: FontWeight.w600),
                        children: <TextSpan>[
                          TextSpan(text: widget.getCaseData!.caseDetail!.regDetails??"", style: mpHeadLine12()),
                        ]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RichText(
                    text: TextSpan(
                        text: "Filed on: ",
                        style: mpHeadLine12(fontWeight: FontWeight.w600),
                        children: <TextSpan>[
                          TextSpan(text: widget.getCaseData!.caseDetail!.filedOn??"", style: mpHeadLine12()),
                        ]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RichText(
                    text: TextSpan(
                        text: "Filling Details: ",
                        style: mpHeadLine12(fontWeight: FontWeight.w600),
                        children: <TextSpan>[
                          TextSpan(text: widget.getCaseData!.caseDetail!.filingDetails??"", style: mpHeadLine12()),
                        ]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RichText(
                    text: TextSpan(
                        text: "Registration on: ",
                        style: mpHeadLine12(fontWeight: FontWeight.w600),
                        children: <TextSpan>[
                          TextSpan(text: widget.getCaseData!.caseDetail!.registeredOn??"", style: mpHeadLine12()),
                        ]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RichText(
                    text: TextSpan(
                        text: "Registration Type: ",
                        style: mpHeadLine12(fontWeight: FontWeight.w600),
                        children: <TextSpan>[
                          TextSpan(text: widget.getCaseData!.caseDetail!.registrationType??"", style: mpHeadLine12()),
                        ]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RichText(
                    text: TextSpan(
                        text: "Bench: ",
                        style: mpHeadLine12(fontWeight: FontWeight.w600),
                        children: <TextSpan>[
                          TextSpan(text: widget.getCaseData!.caseDetail!.bench??"", style: mpHeadLine12()),
                        ]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RichText(
                    text: TextSpan(
                        text: "Stage: ",
                        style: mpHeadLine12(fontWeight: FontWeight.w600),
                        children: <TextSpan>[
                          TextSpan(text: widget.getCaseData!.caseDetail!.stage??"", style: mpHeadLine12()),
                        ]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RichText(
                    text: TextSpan(
                        text: "Court Fees: ",
                        style: mpHeadLine12(fontWeight: FontWeight.w600),
                        children: <TextSpan>[
                          TextSpan(text: widget.getCaseData!.caseDetail!.courtFees??"", style: mpHeadLine12()),
                        ]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RichText(
                    text: TextSpan(
                        text: "Petitioner: ",
                        style: mpHeadLine12(fontWeight: FontWeight.w600),
                        children: <TextSpan>[
                          TextSpan(text: widget.getCaseData!.caseDetail!.petitioner??"", style: mpHeadLine12()),
                        ]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RichText(
                    text: TextSpan(
                        text: "Petitioner Advocate: ",
                        style: mpHeadLine12(fontWeight: FontWeight.w600),
                        children: <TextSpan>[
                          TextSpan(text: widget.getCaseData!.caseDetail!.petitionerAdvocate??"", style: mpHeadLine12()),
                        ]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RichText(
                    text: TextSpan(
                        text: "Respondent: ",
                        style: mpHeadLine12(fontWeight: FontWeight.w600),
                        children: <TextSpan>[
                          TextSpan(text: widget.getCaseData!.caseDetail!.respondent??"", style: mpHeadLine12()),
                        ]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RichText(
                    text: TextSpan(
                        text: "Respondent Advocate: ",
                        style: mpHeadLine12(fontWeight: FontWeight.w600),
                        children: <TextSpan>[
                          TextSpan(text: widget.getCaseData!.caseDetail!.respondentAdvocate??"", style: mpHeadLine12()),
                        ]),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  widget.getCaseData != null ?
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "CNR No.:",
                        style: mpHeadLine12(fontWeight: FontWeight.w600,
                        textColor: AppColor.primary),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Flexible(
                          child:  widget.getCaseData != null && widget.getCaseData!.caseDetail!.cNR != null?
                          Text(
                            "${widget.getCaseData!.caseDetail!.cNR}",
                            style: mpHeadLine12(),
                            // maxLines: 3,
                          ):SizedBox()
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      widget.getCaseData != null && widget.getCaseData!.caseDetail!.cNR != null?InkWell(
                          onTap: (){
                            toast(msg: "CNR No. Copied");
                            Clipboard.setData(ClipboardData(
                                text: widget.getCaseData!.caseDetail!.cNR.toString()));},
                          child: Icon(Icons.copy_rounded, size: 18,)):SizedBox()

                    ],
                  ):SizedBox(),
                  SizedBox(height: 12,),
                  Text("Raj High Court website link",
                    style: appTextStyle(fontWeight: FontWeight.w600,
                        fontSize: 14),),
                  SizedBox(height: 10,),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MyWebView(
                        "https://hcraj.nic.in/cishcraj-jdp/",
                        "RJ HighCourt",
                      )));
                    },
                    child: Text("https://hcraj.nic.in/cishcraj-jdp/",
                      style: appTextStyle(fontWeight: FontWeight.w600,
                          fontSize: 14, textColor: AppColor.primary),),
                  ),
                  SizedBox(height: 10,),
                  Text("Copy the CNR number, through copy link above and then click on link - to view case details on the High Court website",
                    style: appTextStyle(fontWeight: FontWeight.w400,
                        textColor: AppColor.black.withOpacity(0.9),
                        fontSize: 12),)
                ],
              ),
            ),
          ),
        ),
      ],
    ): NoDataAvailable("Case Details will be shown here.");
  }
}
