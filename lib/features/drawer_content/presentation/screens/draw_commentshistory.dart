import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/core/utils/functions.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/bottom_bar/presentation/screens/bottombar.dart';
import 'package:haelo_flutter/features/cases/presentation/screens/casedetails.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/no_data_widget.dart';
import 'package:haelo_flutter/features/drawer_content/cubit/commentshistory_cubit.dart';
import 'package:haelo_flutter/features/drawer_content/cubit/commentshistory_state.dart';
import 'package:haelo_flutter/widgets/progress_indicator.dart';

import '../../../../core/utils/save_file.dart';

class CommentHistory extends StatefulWidget {
  const CommentHistory({Key? key}) : super(key: key);

  @override
  State<CommentHistory> createState() => _CommentHistoryState();
}

class _CommentHistoryState extends State<CommentHistory> {
  bool isLoading = true;
  var commentsHistoryData;

  @override
  void initState() {
    var comments = {
      "downloadFile": "",
    };
    BlocProvider.of<CommentsHistoryCubit>(context)
        .fetchCommentsHistory(comments);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        elevation: 1,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new_sharp,
            size: 24,
          ),
        ),
        backgroundColor: AppColor.white,
        titleSpacing: 0,
        centerTitle: false,
        title: Text(
          "Comments History",
          style: mpHeadLine16(
              fontWeight: FontWeight.w500,
              textColor: AppColor.bold_text_color_dark_blue),
        ),
        actions: [
          commentsHistoryData != null
              ? InkWell(
                  onTap: () {
                    var comments = {
                      "downloadFile": "excel",
                    };
                    BlocProvider.of<CommentsHistoryCubit>(context)
                        .fetchCommentsHistory(comments);
                  },
                  child: Icon(
                    Icons.download,
                    size: 22,
                  ),
                )
              : SizedBox(),
          const SizedBox(
            width: 10,
          ),
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
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Note: History will be for last 7 days rolling.",
                      style: mpHeadLine12(textColor: Colors.red.shade800),
                    ),
                    BlocConsumer<CommentsHistoryCubit, CommentsHistoryState>(
                        builder: (context, state) {
                      return const SizedBox();
                    }, listener: (context, state) {
                      if (state is CommentsHistoryLoading) {
                        setState(() {
                          isLoading = true;
                        });
                      }
                      if (state is CommentsHistoryLoaded) {
                        var commentsList = state.commentsHistoryModel;
                        if (commentsList.result == 1) {
                          if (commentsList.data != null) {
                            if (commentsList.data!.commentDetails != null &&
                                commentsList.data!.commentDetails!.isNotEmpty) {
                              setState(() {
                                commentsHistoryData = commentsList.data;
                                isLoading = false;
                              });
                            }

                            //for download data
                            if (commentsList.data!.downloadFile != null &&
                                commentsList.data!.downloadFile!.isNotEmpty) {
                              toast(msg: "Downloading started");
                              DateTime now = DateTime.now();
                              var fileName =
                                  "HAeLO_Comment_${now.millisecondsSinceEpoch}.${commentsList.data!.downloadFile!.toString().split(".").last}";
                              downloadData(
                                  commentsList.data!.downloadFile!, fileName);
                            }
                          }

                          setState(() {
                            isLoading = false;
                          });
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      } else {
                        setState(() {
                          isLoading = false;
                        });
                      }
                    }),
                    commentsHistoryData != null &&
                            commentsHistoryData!.commentDetails != null &&
                            commentsHistoryData!.commentDetails!.isNotEmpty
                        ? ListView.builder(
                            itemCount:
                                commentsHistoryData!.commentDetails!.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Card(
                                margin: const EdgeInsets.only(top: 15),
                                color: AppColor.display_board,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => CaseDetails(
                                                  caseId: commentsHistoryData
                                                      .commentDetails![index]
                                                      .caseId
                                                      .toString(),
                                                  index: 2,
                                                )));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          child: RichText(
                                            text: TextSpan(
                                                text: "By ",
                                                style: mpHeadLine14(
                                                    fontWeight: FontWeight.bold,
                                                    textColor: AppColor
                                                        .bold_text_color_dark_blue),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text: commentsHistoryData
                                                          .commentDetails![
                                                              index]
                                                          .user,
                                                      style: mpHeadLine14()),
                                                ]),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          child: RichText(
                                            text: TextSpan(
                                                text: "Case Name ",
                                                style: mpHeadLine14(
                                                    fontWeight: FontWeight.bold,
                                                    textColor: AppColor
                                                        .bold_text_color_dark_blue),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text:
                                                          "${commentsHistoryData.commentDetails![index].caseName ?? ""}"
                                                              .toString(),
                                                      style: mpHeadLine14()),
                                                ]),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          child: RichText(
                                            text: TextSpan(
                                                text: "Title ",
                                                style: mpHeadLine14(
                                                    fontWeight: FontWeight.bold,
                                                    textColor: AppColor
                                                        .bold_text_color_dark_blue),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text:
                                                          "${commentsHistoryData.commentDetails![index].caseTitle ?? ""}",
                                                      style: mpHeadLine14()),
                                                ]),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          child: RichText(
                                            text: TextSpan(
                                                text: "Court No ",
                                                style: mpHeadLine14(
                                                    fontWeight: FontWeight.bold,
                                                    textColor: AppColor
                                                        .bold_text_color_dark_blue),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text:
                                                          "${commentsHistoryData.commentDetails![index].courtNo ?? ""}",
                                                      style: mpHeadLine14()),
                                                ]),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          child: RichText(
                                            text: TextSpan(
                                                text: "S. No ",
                                                style: mpHeadLine14(
                                                    fontWeight: FontWeight.bold,
                                                    textColor: AppColor
                                                        .bold_text_color_dark_blue),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text:
                                                          "${commentsHistoryData.commentDetails![index].sno ?? ""}",
                                                      style: mpHeadLine14()),
                                                ]),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 30),
                                          child: RichText(
                                            maxLines: 10,
                                            text: TextSpan(
                                                text: "Comment ",
                                                style: mpHeadLine14(
                                                    fontWeight: FontWeight.bold,
                                                    textColor: AppColor
                                                        .bold_text_color_dark_blue),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text:
                                                        "${commentsHistoryData.commentDetails![index].comment ?? ""}",
                                                    style: mpHeadLine14(),
                                                  ),
                                                ]),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 30),
                                          child: RichText(
                                            text: TextSpan(
                                                text: "Date of listing ",
                                                style: mpHeadLine14(
                                                    fontWeight: FontWeight.bold,
                                                    textColor: AppColor
                                                        .bold_text_color_dark_blue),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text:
                                                          "${commentsHistoryData.commentDetails![index].dateOfListing ?? ""}",
                                                      style: mpHeadLine14()),
                                                ]),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              "${commentsHistoryData.commentDetails![index].timestamp ?? ""}",
                                              style: mpHeadLine12(),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : isLoading
                            ? SizedBox()
                            : NoDataAvailable(
                                "Your comment history will be shown here.")
                  ],
                ),
              ),
            ),
            Visibility(
              visible: isLoading,
              child: const Center(child: AppProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }

  downloadData(String file, String fileName) async {
    await downloadFiles(file, fileName);
  }
}
