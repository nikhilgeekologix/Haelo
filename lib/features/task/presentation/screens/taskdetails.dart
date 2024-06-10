import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/core/utils/functions.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/bottom_bar/presentation/screens/bottombar.dart';
import 'package:haelo_flutter/features/home_page/cubit/home_tasklist_cubit.dart';
import 'package:haelo_flutter/features/task/cubit/reassign_mytask_cubit.dart';
import 'package:haelo_flutter/features/task/cubit/reassign_mytask_state.dart';
import 'package:haelo_flutter/features/task/cubit/taskdetails_cubit.dart';
import 'package:haelo_flutter/features/task/cubit/taskdetails_state.dart';
import 'package:haelo_flutter/features/task/cubit/taskdetailsbutton_cubit.dart';
import 'package:haelo_flutter/features/task/cubit/taskdetailsbutton_state.dart';
import 'package:haelo_flutter/features/task/presentation/widgets/task_completed.dart';
import 'package:haelo_flutter/features/task/presentation/widgets/taskdetailsstatus_accepted.dart';
import 'package:haelo_flutter/features/task/presentation/widgets/taskdetailsstatus_reassign.dart';
import 'package:haelo_flutter/features/task/presentation/widgets/taskdetailsstatus_underreview.dart';
import 'package:haelo_flutter/widgets/error_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:haelo_flutter/locators.dart' as di;

import '../../../../constants.dart';

class TaskDetails extends StatefulWidget {
  final myTaskId;
  // final taskStatus;
  final isReasign;

  const TaskDetails(this.myTaskId, {this.isReasign = false}) : super();

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  bool isLoading = false;
  String mobileNumber = "";
  late SharedPreferences pref;

  @override
  void initState() {
    var body = {
      "taskId": widget.myTaskId.toString(),
    };
    BlocProvider.of<TaskDetailCubit>(context).fetchTaskDetail(body);
    pref = di.locator();
    print("MOB_NO ==> ${pref.getString(Constants.MOB_NO)}");
    mobileNumber = pref.getString(Constants.MOB_NO)!;
    // loadMobileNumber();
    super.initState();
  }

  var additionalData;

  String taskStatus = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.grey_color,
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
        backgroundColor: AppColor.white,
        titleSpacing: -5,
        title: Text(
          "Task Details",
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              BlocConsumer<TaskDetailCubit, TaskDetailState>(
                  builder: (context, state) {
                return const SizedBox();
              }, listener: (context, state) {
                if (state is TaskDetailLoading) {
                  setState(() {
                    isLoading = true;
                  });
                }
                if (state is TaskDetailLoaded) {
                  final taskDetailsScreenModel = state.taskDetailModel;
                  if (taskDetailsScreenModel.result == 1) {
                    setState(() {
                      isLoading = false;
                      additionalData = taskDetailsScreenModel.data;
                    });
                  } else {
                    setState(() {
                      isLoading = false;
                      additionalData = null;
                    });
                  }
                } else {
                  setState(() {
                    isLoading = false;
                  });
                }
              }),
              additionalData != null
                  ? SizedBox(
                      width: mediaQW(context) * 1,
                      // height: mediaQH(context) * 0.5,
                      child: Card(
                        margin:
                            const EdgeInsets.only(left: 15, right: 15, top: 25),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                    text: "Title : ",
                                    style: mpHeadLine14(
                                        fontWeight: FontWeight.w600),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: additionalData!
                                              .taskList!.taskTitle
                                              .toString(),
                                          style: mpHeadLine14()),
                                    ]),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              RichText(
                                maxLines: 12,
                                text: TextSpan(
                                    text: "Description : ",
                                    style: mpHeadLine14(
                                        fontWeight: FontWeight.w600),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: additionalData!.taskList!.taskDesc
                                            .toString(),
                                        style: mpHeadLine14(),
                                      ),
                                    ]),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              RichText(
                                text: TextSpan(
                                    text: "Created By : ",
                                    style: mpHeadLine14(
                                        fontWeight: FontWeight.w600),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: additionalData!
                                              .taskList!.creatorName
                                              .toString(),
                                          style: mpHeadLine14()),
                                    ]),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              RichText(
                                text: TextSpan(
                                    text: "Created For : ",
                                    style: mpHeadLine14(
                                        fontWeight: FontWeight.w600),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: additionalData!
                                                      .taskList!.assignerName !=
                                                  null
                                              ? additionalData!
                                                  .taskList!.assignerName
                                                  .toString()
                                              : additionalData!
                                                  .taskList!.taskAssign,
                                          style: mpHeadLine14()),
                                    ]),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              RichText(
                                text: TextSpan(
                                    text: "Priority : ",
                                    style: mpHeadLine14(
                                        fontWeight: FontWeight.w600),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: additionalData
                                                      .taskList!.taskPriority
                                                      .toString() ==
                                                  "1"
                                              ? "Low"
                                              : additionalData.taskList!
                                                          .taskPriority
                                                          .toString() ==
                                                      "2"
                                                  ? "Medium"
                                                  : "High",
                                          style: mpHeadLine14()),
                                    ]),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              RichText(
                                text: TextSpan(
                                    text: "Closure Permission : ",
                                    style: mpHeadLine14(
                                        fontWeight: FontWeight.w600),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: additionalData!
                                                      .taskList!.taskClosure
                                                      .toString() ==
                                                  "true"
                                              ? "Yes"
                                              : "No",
                                          style: mpHeadLine14()),
                                    ]),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              RichText(
                                text: TextSpan(
                                    text: "Case Id : ",
                                    style: mpHeadLine14(
                                        fontWeight: FontWeight.w600),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: additionalData!.taskList!.caseNo
                                              .toString(),
                                          style: mpHeadLine14()),
                                    ]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
              const SizedBox(
                height: 25,
              ),
              BlocConsumer<TaskDetailsButtonCubit, TaskDetailsButtonState>(
                  builder: (context, state) {
                return const SizedBox();
              }, listener: (context, state) {
                if (state is TaskDetailsButtonLoaded) {
                  final taskDetailsButtonModelValue =
                      state.taskDetailButtonModel;
                  if (taskDetailsButtonModelValue.result == 1) {
                    if (taskDetailsButtonModelValue.isUserAllowed == true) {
                      var bodyTaskList = {
                        // "limit": "",
                        "pageNo": "1",
                      };
                      BlocProvider.of<HomeTaskListCubit>(context)
                          .fetchHomeTaskList(body: bodyTaskList);
                      Navigator.pop(context);
                    }
                  }
                }
              }),
              BlocConsumer<ReassignMyTaskCubit, ReassignMyTaskState>(
                  listener: (context, state) {
                if (state is ReassignMyTaskLoading) {
                  setState(() {
                    isLoading = true;
                  });
                }
                if (state is ReassignMyTaskLoaded) {
                  var reassignMyTask = state.reassignMyTaskModel;
                  if (reassignMyTask.result == 1) {
                    setState(() {
                      isLoading = false;
                    });
                    toast(msg: reassignMyTask.msg.toString());
                    Navigator.pop(context, true);

                    /*   showDialog(
                        context: context,
                        builder: (ctx) => AppMsgPopup(
                              reassignMyTask.msg.toString(),
                              isCloseIcon: false,
                              isError: false,
                              btnCallback: () {
                                Navigator.pop(context);
                                Navigator.pop(context, true);
                              },
                            ));*/
                  } else {
                    setState(() {
                      isLoading = false;
                    });
                    showDialog(
                        context: context,
                        builder: (ctx) => AppMsgPopup(
                              reassignMyTask.msg.toString(),
                            ));
                  }
                } else {
                  setState(() {
                    isLoading = false;
                  });
                }
              }, builder: (context, state) {
                return SizedBox();
              }),
              widget.isReasign == true
                  ? DetailsStatusReassign(
                      getTaskId: widget.myTaskId,
                    )
                  : SizedBox(),
              isLoading
                  ? SizedBox()
                  : additionalData != null &&
                          additionalData.taskList.taskStatus == "1" &&
                          additionalData.taskList.taskAssign == mobileNumber
                      ? Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                child: Text(
                                  "Accept",
                                  style: mpHeadLine16(textColor: Colors.white),
                                ),
                                style: ButtonStyle(
                                    fixedSize: MaterialStateProperty.all(
                                        Size(mediaQW(context) * 0.45, 45)),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5))),
                                    backgroundColor: MaterialStateProperty.all(
                                        AppColor.button_accept)),
                                onPressed: () {
                                  var body = {
                                    "taskId": widget.myTaskId.toString(),
                                    "status": "3",
                                  };
                                  BlocProvider.of<TaskDetailsButtonCubit>(
                                          context)
                                      .fetchTaskDetailsButton(body);
                                },
                              ),
                              ElevatedButton(
                                child: Text(
                                  "Reject",
                                  style: mpHeadLine16(textColor: Colors.white),
                                ),
                                style: ButtonStyle(
                                    fixedSize: MaterialStateProperty.all(
                                        Size(mediaQW(context) * 0.45, 45)),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5))),
                                    backgroundColor: MaterialStateProperty.all(
                                        AppColor.button_reject)),
                                onPressed: () {
                                  var body = {
                                    "taskId": widget.myTaskId.toString(),
                                    "status": "2",
                                  };
                                  BlocProvider.of<TaskDetailsButtonCubit>(
                                          context)
                                      .fetchTaskDetailsButton(body);
                                },
                              ),
                            ],
                          ),
                        )
                      : SizedBox(),
              isLoading
                  ? SizedBox()
                  : additionalData != null &&
                          additionalData.taskList.taskStatus ==
                              "2" // this means pending
                      ? const SizedBox()
                      : additionalData != null &&
                              additionalData.taskList.taskStatus == "3"

                          ///this means accepted
                          ? DetailsStatusAccepted(
                              taskId: widget.myTaskId.toString(),
                            )
                          : additionalData != null &&
                                  additionalData.taskList.taskStatus == "4"
                              ? DetailsStatusUnderReview(
                                  //under review
                                  taskId: widget.myTaskId.toString(),
                                  data: additionalData != null
                                      ? additionalData.taskList!
                                      : null,
                                )
                              : additionalData != null &&
                                      additionalData.taskList.taskStatus == "5"
                                  ? TaskCompleted(
                                      taskId: widget.myTaskId.toString(),
                                      data: additionalData != null
                                          ? additionalData.taskList!
                                          : null)
                                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loadMobileNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      mobileNumber = prefs.getString('mobileNumber')!;
      print("mobileNumber ==> $mobileNumber");
    });
  }
}
