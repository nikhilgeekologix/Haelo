import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/constants.dart';
import 'package:haelo_flutter/core/utils/hightlight_text.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/causeslist/presentation/screen/viewcauselist.dart';
import 'package:haelo_flutter/features/home_page/cubit/displayboard_summary_cubit.dart';
import 'package:haelo_flutter/features/home_page/cubit/displayboard_summary_state.dart';
import 'package:haelo_flutter/widgets/date_format.dart';
import 'package:haelo_flutter/widgets/error_widget.dart';
import 'package:haelo_flutter/widgets/progress_indicator.dart';

class CourtNote extends StatefulWidget {
  var body;
  CourtNote(this.body, {super.key});

  @override
  State<CourtNote> createState() => _CourtNoteState();
}

class _CourtNoteState extends State<CourtNote> {
  @override
  void initState() {
    BlocProvider.of<DisplayBoardSummaryCubit>(context)
        .fetchDisplayBoardSummary(widget.body);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        BlocBuilder<DisplayBoardSummaryCubit, DisplayBoardSummaryState>(
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
                var displaySummaryData = displaySummaryModel.data;
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
                                  "${widget.body['courtNo']}" +
                                  " Note",
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
                      ListView.builder(
                          itemCount: displaySummaryData!.summary!.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                      textAlign: TextAlign.start,
                                      text: TextSpan(
                                          text:
                                              "${displaySummaryData!.summary![index].causeListType}: ",
                                          style: mpHeadLine16(
                                              textColor: AppColor.primary,
                                              fontWeight: FontWeight.w500),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text:
                                                  "${displaySummaryData!.summary![index].notice}",
                                              style: mpHeadLine14(
                                                textColor: Colors.black,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            )
                                          ])),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  displaySummaryData!
                                                  .summary![index].benchName !=
                                              null &&
                                          displaySummaryData!.summary![index]
                                              .benchName!.isNotEmpty
                                      ? RichText(
                                          textAlign: TextAlign.start,
                                          text: TextSpan(
                                              text: "Bench: ",
                                              style: mpHeadLine16(
                                                  textColor: AppColor.primary,
                                                  fontWeight: FontWeight.w500),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text:
                                                      "${displaySummaryData!.summary![index].benchName}",
                                                  style: mpHeadLine14(
                                                    textColor: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                )
                                              ]))
                                      : SizedBox(),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Divider(
                                    height: 10,
                                    color: AppColor.text_grey_color,
                                  )
                                ],
                              ),
                            );
                          })
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
        ),
      ],
    );
  }
}
