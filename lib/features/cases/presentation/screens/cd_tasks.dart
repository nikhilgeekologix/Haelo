import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/cases/cubit/casetasklist_cubit.dart';
import 'package:haelo_flutter/features/cases/cubit/casetasklist_state.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/no_data_widget.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/tab_progress_indicator.dart';
import 'package:haelo_flutter/features/home_page/presentation/widgets/tasktiles.dart';
import 'package:haelo_flutter/features/task/cubit/delete_mytask_cubit.dart';
import 'package:haelo_flutter/features/task/cubit/delete_mytask_state.dart';
import 'package:haelo_flutter/features/task/presentation/screens/taskdetails.dart';
import 'package:haelo_flutter/widgets/date_format.dart';
import 'package:haelo_flutter/widgets/error_widget.dart';
import 'package:haelo_flutter/widgets/progress_indicator.dart';

class Tasks extends StatefulWidget {
  final getCaseId;
  const Tasks({Key? key, this.getCaseId}) : super(key: key);

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  bool isLoading = false;

  @override
  void initState() {
    var caseIdDetails = {
      "caseId": widget.getCaseId.toString(),
    };
    BlocProvider.of<CaseTaskListCubit>(context)
        .fetchCaseTaskList(caseIdDetails);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              BlocConsumer<CaseTaskListCubit, CaseTaskListState>(
                  builder: (context, state) {
                    if (state is CaseTaskListLoading) {
                      return TabProgressIndicator();
                    }
                    if (state is CaseTaskListLoaded) {
                      var taskList = state.caseTaskListModel;
                      if (taskList.result == 1) {
                        if (taskList.data != null) {
                          var taskListData = taskList.data;
                          return taskListData!.taskList!.isNotEmpty
                              ? ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: taskListData!.taskList!.length,
                                  itemBuilder: (listViewContent, index) {
                                    return TaskTiles(
                                      taskListDate: getCaseMMMMDYYYY(
                                          taskListData.taskList![index].taskDate
                                              .toString()),
                                      taskListDescription: taskListData
                                          .taskList![index].taskDesc
                                          .toString(),
                                      taskListPriority: taskListData
                                          .taskList![index].taskPriority
                                          .toString(),
                                      taskListStatus: taskListData
                                          .taskList![index].taskStatus
                                          .toString(),
                                      taskListTitle: taskListData
                                          .taskList![index].taskTitle
                                          .toString(),
                                      taskId: taskListData
                                          .taskList![index].taskId
                                          .toString(),
                                      isFromHome: false,
                                      caseid: widget.getCaseId,
                                    );
                                  })
                              : NoDataAvailable("Task will be shown here.");
                        }
                      }
                      return Align(
                          alignment: Alignment.center,
                          child: NoDataAvailable("Task will be shown here."));
                    }
                    return const SizedBox();
                  },
                  listener: (context, state) {}),
              BlocConsumer<DeleteMyTaskCubit, DeleteMyTaskState>(
                  builder: (context, state) {
                return const SizedBox();
              }, listener: (context, state) {
                if (state is DeleteMyTaskLoaded) {
                  var deleteinpopup = state.deleteMyTaskModel;
                  if (deleteinpopup.result == 1) {
                    //toast(msg: deleteinpopup.msg.toString());
                    setState(() {
                      isLoading = false;
                    });
                    toast(msg: deleteinpopup.msg.toString());
                    /* showDialog(
                        context: context,
                        builder: (ctx) => AppMsgPopup(
                          deleteinpopup.msg.toString(),
                          isCloseIcon: false,
                          isError: false,
                          btnCallback: () {
                            Navigator.pop(context);
                          },));*/
                    var caseIdDetails = {
                      "caseId": widget.getCaseId.toString(),
                    };
                    BlocProvider.of<CaseTaskListCubit>(context)
                        .fetchCaseTaskList(caseIdDetails);
                  } else {
                    setState(() {
                      isLoading = false;
                    });
                    showDialog(
                        context: context,
                        builder: (ctx) => AppMsgPopup(
                              deleteinpopup.msg.toString(),
                            ));
                  }
                }
              }),
            ],
          ),
        ),
        Visibility(
          visible: isLoading,
          child: const Center(child: AppProgressIndicator()),
        ),
      ],
    );
  }
}
