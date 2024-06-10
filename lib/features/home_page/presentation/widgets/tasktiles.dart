import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/bottom_bar/presentation/screens/bottombar.dart';
import 'package:haelo_flutter/features/cases/cubit/casetasklist_cubit.dart';
import 'package:haelo_flutter/features/home_page/cubit/home_tasklist_cubit.dart';
import 'package:haelo_flutter/features/task/cubit/delete_mytask_cubit.dart';
import 'package:haelo_flutter/features/task/cubit/delete_mytask_state.dart';
import 'package:haelo_flutter/features/task/presentation/screens/mytasks.dart';
import 'package:haelo_flutter/features/task/presentation/screens/taskdetails.dart';

class TaskTiles extends StatelessWidget {
  final taskListTitle;
  final taskListPriority;
  final taskListDescription;
  final taskListDate;
  final taskListStatus;
  final taskId;
  final bool isFromHome;
  final caseid;
  final refreshCallback;
  const TaskTiles(
      {Key? key,
      required this.taskListTitle,
      required this.taskListPriority,
      required this.taskListDescription,
      required this.taskListDate,
      required this.taskListStatus,
      required this.taskId,
      this.isFromHome = false,
      this.caseid,
      this.refreshCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: mediaQW(context) * 0.82,
      child: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => TaskDetails(taskId)));
        },
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(12),
          child: ClipPath(
              clipper: ShapeBorderClipper(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: Container(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 10, bottom: 25),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                        color: taskListStatus == "1"
                            ? AppColor.pending_color
                            : taskListStatus == "2"
                                ? AppColor.rejected_color
                                : taskListStatus == "3"
                                    ? AppColor.accepted_color
                                    : taskListStatus == "4"
                                        ? AppColor.review_color
                                        : AppColor.complete_color,
                        width: 8),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            taskListTitle,
                            maxLines: 1,
                            style: mpHeadLine18(fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        taskListStatus == "1" || taskListStatus == "2"
                            ? Container(
                                width: 25,
                                height: 30,
                                child: PopupMenuButton<int>(
                                  onSelected: (i) {
                                    if (i == 2) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => TaskDetails(
                                                    taskId,
                                                    isReasign: true,
                                                  ))).then((value) {
                                        if (value != null && value) {
                                          refreshCallback(true);
                                        }
                                      });
                                    } else if (i == 1) {
                                      showDialog(
                                          context: context,
                                          builder: (ctx) {
                                            return AlertDialog(
                                              // insetPadding: EdgeInsets.symmetric(vertical: 305),
                                              contentPadding: EdgeInsets.zero,
                                              content: SizedBox(
                                                height: mediaQH(context) * 0.16,
                                                // width: mediaQW(context) * 0.8,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20,
                                                              right: 20,
                                                              top: 18),
                                                      child: Text(
                                                        "Are you sure, you want to delete ${taskListTitle.toString()}?",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: mpHeadLine14(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: InkWell(
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                              var deleteList = {
                                                                "update":
                                                                    "delete",
                                                                "taskId": taskId
                                                                    .toString(),
                                                              };
                                                              BlocProvider.of<
                                                                          DeleteMyTaskCubit>(
                                                                      context)
                                                                  .fetchDeleteMyTask(
                                                                      deleteList);
                                                            },
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              height: mediaQH(
                                                                      context) *
                                                                  0.05,
                                                              decoration: BoxDecoration(
                                                                  borderRadius: const BorderRadius
                                                                      .only(
                                                                      bottomLeft:
                                                                          Radius.circular(
                                                                              5)),
                                                                  border: Border.all(
                                                                      color: AppColor
                                                                          .primary)),
                                                              child: Text(
                                                                "Yes",
                                                                style: mpHeadLine16(
                                                                    textColor:
                                                                        AppColor
                                                                            .primary),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: InkWell(
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              height: mediaQH(
                                                                      context) *
                                                                  0.05,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                borderRadius: BorderRadius.only(
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            5)),
                                                                color: AppColor
                                                                    .primary,
                                                              ),
                                                              child: Text(
                                                                "No",
                                                                style: mpHeadLine16(
                                                                    textColor:
                                                                        AppColor
                                                                            .white),
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
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                    }
                                  },
                                  // padding: EdgeInsets.all(2),
                                  icon: const Icon(
                                    Icons.more_vert_outlined,
                                    size: 22,
                                    color: AppColor.black,
                                  ),
                                  itemBuilder: (context) => [
                                    // popupmenu item 1
                                    const PopupMenuItem(
                                      value: 1,
                                      child: Text("Delete"),
                                    ),
                                    // popupmenu item 2
                                    const PopupMenuItem(
                                      value: 2,
                                      child: Text("Re-assign"),
                                    ),
                                  ],
                                  offset: Offset(-15, 15),
                                  color: Colors.white,
                                  elevation: 2,
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),

                    const SizedBox(
                      height: 5,
                    ),
                    RichText(
                      text: TextSpan(
                          text: "Priority: ",
                          style: mpHeadLine14(),
                          children: <TextSpan>[
                            TextSpan(
                                text: taskListPriority == "1"
                                    ? "Low"
                                    : taskListPriority == "2"
                                        ? "Medium"
                                        : "High",
                                style: mpHeadLine14()),
                          ]),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      taskListDescription,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: mpHeadLine14(textColor: AppColor.hint_color_grey),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: taskListStatus == "4"
                              ? mediaQW(context) * 0.34
                              : mediaQW(context) * 0.28,
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: taskListStatus == "1"
                                  ? AppColor.pending_color
                                  : taskListStatus == "2"
                                      ? AppColor.rejected_color
                                      : taskListStatus == "3"
                                          ? AppColor.accepted_color
                                          : taskListStatus == "4"
                                              ? AppColor.review_color
                                              : AppColor.complete_color),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                taskListStatus == "1"
                                    ? Icons.access_time_outlined
                                    : taskListStatus == "2"
                                        ? Icons.cancel_presentation
                                        : taskListStatus == "3"
                                            ? Icons.task_outlined
                                            : taskListStatus == "4"
                                                ? Icons.list_alt_sharp
                                                : Icons.task_alt,
                                size: 20,
                                color: taskListStatus == "1"
                                    ? AppColor.pending_color_text
                                    : taskListStatus == "2"
                                        ? AppColor.rejected_color_text
                                        : taskListStatus == "3"
                                            ? AppColor.accepted_color_text
                                            : taskListStatus == "4"
                                                ? AppColor.review_color_text
                                                : AppColor.complete_color_text,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  taskListStatus == "1"
                                      ? "Pending"
                                      : taskListStatus == "2"
                                          ? "Rejected"
                                          : taskListStatus == "3"
                                              ? "Accepted"
                                              : taskListStatus == "4"
                                                  ? "Under Review"
                                                  : "Complete",
                                  style: mpHeadLine14(
                                      textColor: taskListStatus == "1"
                                          ? AppColor.pending_color_text
                                          : taskListStatus == "2"
                                              ? AppColor.rejected_color_text
                                              : taskListStatus == "3"
                                                  ? AppColor.accepted_color_text
                                                  : taskListStatus == "4"
                                                      ? AppColor
                                                          .review_color_text
                                                      : AppColor
                                                          .complete_color_text),
                                ),
                              )
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_month_outlined,
                              size: 20,
                              color: AppColor.hint_color_grey,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              taskListDate,
                              style: mpHeadLine14(
                                  textColor: AppColor.hint_color_grey),
                            )
                          ],
                        )
                      ],
                    ),
                    //
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
