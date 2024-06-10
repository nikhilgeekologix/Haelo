import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/constants.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/no_data_widget.dart';
import 'package:haelo_flutter/features/userboard/presentation/widgets/html_content.dart';

import '../../cubit/casedetail_cubit.dart';
import 'editaddcase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:haelo_flutter/locators.dart' as di;

class CaseDetailsByUser extends StatefulWidget {
  final getUserDetail;
  final caseId;
  const CaseDetailsByUser({Key? key, this.getUserDetail, this.caseId}) : super(key: key);

  @override
  State<CaseDetailsByUser> createState() => _CaseDetailsByUserState();
}

class _CaseDetailsByUserState extends State<CaseDetailsByUser> {

  late SharedPreferences pref;
  @override
  void initState() {
    pref = di.locator();
  }


  @override
  Widget build(BuildContext context) {
    return widget.getUserDetail!=null?
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                        text: "Category: ",
                        style: mpHeadLine12(fontWeight: FontWeight.w600),
                        children: <TextSpan>[
                          TextSpan(
                              text:
                                  widget.getUserDetail != null && widget.getUserDetail!.userDetail!.caseCategory != null
                                      ? widget.getUserDetail!.userDetail!.caseCategory.toString()
                                      : "",
                              style: mpHeadLine12()),
                        ]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RichText(
                    text: TextSpan(
                        text: "Case Type: ",
                        style: mpHeadLine12(fontWeight: FontWeight.w600),
                        children: <TextSpan>[
                          TextSpan(
                              text: widget.getUserDetail != null && widget.getUserDetail!.userDetail!.caseType != null
                                  ? widget.getUserDetail!.userDetail!.caseType
                                  : "",
                              style: mpHeadLine12()),
                        ]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RichText(
                    text: TextSpan(
                        text: "Case Number: ",
                        style: mpHeadLine12(fontWeight: FontWeight.w600),
                        children: <TextSpan>[
                          TextSpan(
                              text: widget.getUserDetail != null && widget.getUserDetail!.userDetail!.caseNo != null
                                  ? widget.getUserDetail!.userDetail!.caseNo.toString()
                                  : "",
                              style: mpHeadLine12()),
                        ]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RichText(
                    text: TextSpan(
                        text: "Case Year: ",
                        style: mpHeadLine12(fontWeight: FontWeight.w600),
                        children: <TextSpan>[
                          TextSpan(
                              text: widget.getUserDetail != null && widget.getUserDetail!.userDetail!.caseYear != null
                                  ? widget.getUserDetail!.userDetail!.caseYear.toString()
                                  : "",
                              style: mpHeadLine12()),
                        ]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RichText(
                    text: TextSpan(
                        text: "Filling no.: ",
                        style: mpHeadLine12(fontWeight: FontWeight.w600),
                        children: <TextSpan>[
                          TextSpan(
                              text:
                                  widget.getUserDetail != null && widget.getUserDetail!.userDetail!.caseFilingNo != null
                                      ? widget.getUserDetail!.userDetail!.caseFilingNo.toString()
                                      : "",
                              style: mpHeadLine12()),
                        ]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  Row(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mobile:",
                        style: mpHeadLine12(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Flexible(
                          child:  widget.getUserDetail != null && widget.getUserDetail!.userDetail!.mobNo != null
                              ?Wrap(
                            children: widget.getUserDetail!.userDetail!.mobNo.toString().split(",").
                            map((e) {
                              return Text(
                                "$e"+ "${widget.getUserDetail!.userDetail!.mobNo.toString().split(",").indexOf(e)!=
                                    widget.getUserDetail!.userDetail!.mobNo.toString().split(",").length-1?", ":""}",
                                style: mpHeadLine12(),
                                // maxLines: 3,
                              );
                            }).toList(),
                          ):SizedBox()
                      ),
                      // Flexible(
                      //   child: Text(
                      //     widget.getUserDetail != null && widget.getUserDetail!.userDetail!.mobNo != null
                      //         ? widget.getUserDetail!.userDetail!.mobNo.toString()
                      //         : "",
                      //     style: mpHeadLine12(),
                      //     // maxLines: 1,
                      //   ),
                      // ),
                      const SizedBox(
                        width: 15,
                      ),
                      pref.getString(Constants.USER_TYPE)!="2"?editIcon(context):SizedBox()
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email:",
                        style: mpHeadLine12(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Flexible(
                        child:  widget.getUserDetail != null && widget.getUserDetail!.userDetail!.email != null
                            ?Wrap(
                          children: widget.getUserDetail!.userDetail!.email.toString().split(",").
                          map((e) {
                            return Text(
                              "$e"+ "${widget.getUserDetail!.userDetail!.email.toString().split(",").indexOf(e)!=
                                  widget.getUserDetail!.userDetail!.email.toString().split(",").length-1?", ":""}",
                              style: mpHeadLine12(),
                              // maxLines: 3,
                            );
                          }).toList(),
                        ):SizedBox()
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      pref.getString(Constants.USER_TYPE)!="2"?editIcon(context):SizedBox()
                    ],
                  ),


                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // Row(crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Text(
                  //       "ITMO: ",
                  //       style: mpHeadLine12(fontWeight: FontWeight.w600),
                  //     ),
                  //     const SizedBox(
                  //       width: 2,
                  //     ),
                  //     Text(
                  //       widget.getUserDetail != null && widget.getUserDetail!.userDetail!.itmo != null
                  //           ? widget.getUserDetail!.userDetail!.itmo.toString()
                  //           : "",
                  //       style: mpHeadLine12(),
                  //     ),
                  //     const SizedBox(
                  //       width: 15,
                  //     ),
                  //     editIcon(context)
                  //   ],
                  // ),

                ],
              ),
            ),
          ),
        ),
      ],
    ): NoDataAvailable("Case Details by User will be shown here.");
  }

  Widget editIcon(context){
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditAddCase(
                  getCaseIdBack: widget.caseId,
                  itmo: widget.getUserDetail != null && widget.getUserDetail!.userDetail!.itmo != null
                      ? widget.getUserDetail!.userDetail!.itmo.toString():"",
                  email: widget.getUserDetail != null && widget.getUserDetail!.userDetail!.email != null
                      ? widget.getUserDetail!.userDetail!.email.toString()
                      : "",
                  mobileNo:  widget.getUserDetail != null && widget.getUserDetail!.userDetail!.mobNo != null
                      ? widget.getUserDetail!.userDetail!.mobNo.toString()
                      : "",
                ))).then((value) {
          if(value!=null && value){
            var caseIdDetails = {
              "caseId": widget.caseId.toString(),
            };
            BlocProvider.of<CaseDetailCubit>(context).fetchCaseDetail(caseIdDetails);
          }
        });
      },
      child: const Icon(
        Icons.edit,
        size: 18,
      ),
    );
  }

}
