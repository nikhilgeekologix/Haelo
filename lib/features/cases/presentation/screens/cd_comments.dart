import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/constants.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/cases/cubit/comments_cubit.dart';
import 'package:haelo_flutter/features/cases/cubit/comments_state.dart';
import 'package:haelo_flutter/features/cases/cubit/deletecomment_cubit.dart';
import 'package:haelo_flutter/features/cases/cubit/deletecomment_state.dart';
import 'package:haelo_flutter/features/cases/presentation/screens/updatecomment.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/no_data_widget.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/tab_progress_indicator.dart';
import 'package:haelo_flutter/widgets/date_format.dart';
import 'package:haelo_flutter/widgets/error_widget.dart';

import 'addcomment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:haelo_flutter/locators.dart' as di;

class Comments extends StatefulWidget {
  final getCaseId;

  const Comments({Key? key, this.getCaseId}) : super(key: key);

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  bool isLoading = false;
  late SharedPreferences pref;
  @override
  void initState() {
    pref = di.locator();
    var caseIdDetails = {
      "caseId": widget.getCaseId.toString(),
    };
    BlocProvider.of<CasesCommentCubit>(context)
        .fetchCasesComment(caseIdDetails);
    super.initState();
  }

  var casesCommentData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              BlocConsumer<CasesCommentCubit, CasesCommentState>(
                  builder: (context, state) {
                    if (state is CasesCommentLoading) {
                      return TabProgressIndicator();
                    }
                    if (state is CasesCommentLoaded) {
                      var casesCommentList = state.casesCommentModel;
                      if (casesCommentList.result == 1) {
                        if (casesCommentList.data != null) {
                          casesCommentData = casesCommentList.data;
                          return casesCommentData!.commentlist!.isNotEmpty
                              ? ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount:
                                      casesCommentData!.commentlist!.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8, left: 7, right: 7),
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                // crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text("By:",
                                                      style: mpHeadLine14(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          textColor: AppColor
                                                              .bold_text_color_dark_blue)),
                                                  SizedBox(
                                                    width:
                                                        mediaQW(context) * 0.65,
                                                    child: Text(
                                                        casesCommentData
                                                                .commentlist![
                                                                    index]
                                                                .userName
                                                                .toString() +
                                                            " (${casesCommentData.commentlist![index].mobNo.toString()})",
                                                        style: mpHeadLine12(
                                                            textColor: AppColor
                                                                .bold_text_color_dark_blue)),
                                                  ),
                                                  // const SizedBox(
                                                  //   width: 45,
                                                  // ),
                                                  casesCommentData
                                                              .commentlist![
                                                                  index]
                                                              .mobNo
                                                              .toString() ==
                                                          pref.getString(
                                                              Constants.MOB_NO)
                                                      ? Row(
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (ctx) {
                                                                      return AlertDialog(
                                                                        // insetPadding: EdgeInsets.symmetric(vertical: 305),
                                                                        contentPadding:
                                                                            EdgeInsets.zero,
                                                                        content:
                                                                            SizedBox(
                                                                          height:
                                                                              mediaQH(context) * 0.18,
                                                                          // width: mediaQW(context) * 0.8,
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
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
                                                                                        var deleteComment = {
                                                                                          "commentId": casesCommentData.commentlist[index].commentId.toString(),
                                                                                        };
                                                                                        BlocProvider.of<DeleteCommentCubit>(context).fetchDeleteComment(deleteComment);
                                                                                        Navigator.pop(context);
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
                                                              child: Icon(
                                                                Icons.delete,
                                                                size: 20,
                                                                color: Colors
                                                                    .red
                                                                    .shade800,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 15,
                                                            ),
                                                            GestureDetector(
                                                                onTap: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => EditComment(
                                                                                getCaseIdd: widget.getCaseId,
                                                                                commentId: casesCommentData.commentlist[index].commentId.toString(),
                                                                                getComment: casesCommentData.commentlist![index].comment.toString(),
                                                                                isCaseHistory: false,
                                                                              )));
                                                                },
                                                                child: Icon(
                                                                    Icons.edit,
                                                                    size: 20,
                                                                    color: Colors
                                                                        .red
                                                                        .shade800))
                                                          ],
                                                        )
                                                      : SizedBox(),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              SizedBox(
                                                width: mediaQW(context) * 0.8,
                                                child: Text(
                                                    casesCommentData
                                                        .commentlist![index]
                                                        .comment
                                                        .toString(),
                                                    style: mpHeadLine14(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        textColor: AppColor
                                                            .bold_text_color_dark_blue)),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              // used Row in place of richtext so that card occupies appropriate space in page.
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                      casesCommentData
                                                                  .commentlist![
                                                                      index]
                                                                  .timestamp !=
                                                              null
                                                          ? dateTimeMMMDDYYYY(
                                                              casesCommentData
                                                                  .commentlist![
                                                                      index]
                                                                  .timestamp
                                                                  .toString(),
                                                            )
                                                          : "",
                                                      style: mpHeadLine12(
                                                          textColor: AppColor
                                                              .bold_text_color_dark_blue)),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : NoDataAvailable("Comments will be shown here.");
                        }
                      }
                      return NoDataAvailable("Comments will be shown here.");
                    }
                    return const SizedBox();
                  },
                  listener: (context, state) {}),
              BlocConsumer<DeleteCommentCubit, DeleteCommentState>(
                  builder: (context, state) {
                return const SizedBox();
              }, listener: (context, state) {
                if (state is DeleteCommentLoaded) {
                  var deleteCommentList = state.deleteCommentModel;

                  if (deleteCommentList.result == 1) {
                    setState(() {
                      isLoading = false;
                    });

                    toast(msg: deleteCommentList.msg.toString());
                    /*    showDialog(
                        context: context,
                        builder: (ctx) => AppMsgPopup(
                              deleteCommentList.msg.toString(),
                              isCloseIcon: false,
                              isError: false,
                              btnCallback: () {
                                Navigator.pop(context);
                              },
                            ));*/
                    var caseIdDetails = {
                      "caseId": widget.getCaseId.toString(),
                    };
                    BlocProvider.of<CasesCommentCubit>(context)
                        .fetchCasesComment(caseIdDetails);
                  } else {
                    setState(() {
                      isLoading = false;
                    });
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
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
            // isExtended: true,
            child: Icon(Icons.add),
            backgroundColor: AppColor.primary,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddComment(
                            isCaseHistory: false,
                            getCaseIdd: widget.getCaseId,
                          ))).then((value) {
                if (value != null && value) {
                  var caseIdDetails = {
                    "caseId": widget.getCaseId.toString(),
                  };
                  BlocProvider.of<CasesCommentCubit>(context)
                      .fetchCasesComment(caseIdDetails);
                }
              });
            }));
  }
}
