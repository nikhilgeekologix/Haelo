import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/causeslist/presentation/widget/error_dialog.dart';
import 'package:haelo_flutter/features/drawer_content/presentation/widgets/textformfield_decoration.dart';
import 'package:haelo_flutter/features/task/cubit/reassign_mytask_cubit.dart';
import 'package:haelo_flutter/features/task/cubit/reassign_mytask_state.dart';
import 'package:haelo_flutter/features/task/cubit/task_selectteam_cubit.dart';
import 'package:haelo_flutter/features/task/cubit/task_selectteam_state.dart';

class DetailsStatusReassign extends StatefulWidget {
  final getTaskId;
  final callbackToParent;
  const DetailsStatusReassign({Key? key, required this.getTaskId, this.callbackToParent}) : super(key: key);

  @override
  State<DetailsStatusReassign> createState() => _DetailsStatusReassignState();
}

class _DetailsStatusReassignState extends State<DetailsStatusReassign> {
  TextEditingController _selectTeamReassignController = TextEditingController();

  @override
  void initState() {
    // pref = di.locator();
    BlocProvider.of<TaskSelectTeamCubit>(context).fetchTaskSelectTeam();
    super.initState();
    // _priorityController.text = itemsPriority[1].toString();
  }

  var teamMemberId="";

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskSelectTeamCubit, TaskSelectTeamState>(
        builder: (context, state) {
          if (state is TaskSelectTeamLoaded) {
            final selectTeamModel = state.taskSelectTeamModel;
            if (selectTeamModel.result == 1) {
              var selectTeamData = selectTeamModel.data;
              var reassignMemberId = selectTeamData!.team![0].memberId;
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            content: Container(
                              width: double.maxFinite,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxHeight: MediaQuery.of(context).size.height * 0.4,
                                    ),
                                    child: ListView.builder(
                                      itemCount: selectTeamData!.team!.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 15,
                                          ),
                                          child:  InkWell(
                                            onTap: () {
                                              setState(() {
                                                if( selectTeamData.team![index].userName!=null &&
                                                    selectTeamData.team![index].userName.toString().isNotEmpty){
                                                  _selectTeamReassignController.text =
                                                      selectTeamData.team![index].userName.toString();
                                                }else {
                                                  _selectTeamReassignController.text =
                                                    selectTeamData.team![index].mobileNo.toString();
                                                }
                                                teamMemberId = selectTeamData.team![index].memberId.toString();
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 4.0,bottom: 4),
                                              child: Column(
                                                children: [
                                                  selectTeamData.team![index].userName!=null &&
                                                      selectTeamData.team![index].userName.toString().isNotEmpty?
                                                  Text(selectTeamData.team![index].userName.toString()):SizedBox(),
                                                  selectTeamData.team![index].mobileNo!=null?
                                                  Text(
                                                    selectTeamData.team![index].mobileNo.toString(),
                                                  ):SizedBox(),
                                                 index!= selectTeamData!.team!.length-1?
                                                 Divider(
                                                    color: Colors.grey[300],
                                                    thickness: 1,
                                                  ):SizedBox()
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                            actions: [],
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        enabled: false,
                        controller: _selectTeamReassignController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          labelText: "Team",
                          labelStyle: TextStyle(color: Colors.black),
                          suffixIcon: const Icon(
                            Icons.arrow_drop_down_sharp,
                            color: Colors.black,
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(width: 1, color: Colors.black),
                          ),
                          errorBorder: errorboarder,
                          focusedBorder: focusboarder,
                          border: boarder,
                        ),
                        // validator: FormValidation().validatePriority,
                      ),
                    ),
                  ),
                  // BlocConsumer<ReassignMyTaskCubit, ReassignMyTaskState>(
                  //     builder: (context, state) {
                  //       if (state is ReassignMyTaskLoaded) {
                  //         var reassignMyTask = state.reassignMyTaskModel;
                  //         if (reassignMyTask.result == 0) {
                  //           toast(msg: reassignMyTask.msg.toString());
                  //           // AlertDialogShow().showAlertDialog(
                  //           //   context: context,
                  //           //   // actions: actoins,
                  //           //   titleMsg: "Update",
                  //           //   contentStr: "APP update msg 0000000000",
                  //           // );
                  //
                  //           // return ErrorDialog().showLogoutDialog(context, msg: "Task");
                  //         }
                  //         if (reassignMyTask.result == 1) {
                  //           toast(msg: reassignMyTask.msg.toString());
                  //           // AlertDialogShow().showAlertDialog(
                  //           //   context: context,
                  //           //   // actions: actoins,
                  //           //   titleMsg: "Update",
                  //           //   contentStr: "APp update msg",
                  //           // );
                  //         }
                  //       }
                  //       return const SizedBox();
                  //     },
                  //     listener: (context, state) {}),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: ElevatedButton(
                      child: Text(
                        "Reassign",
                        style: mpHeadLine16(textColor: Colors.white),
                      ),
                      style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all(Size(mediaQW(context), 40)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                          backgroundColor: MaterialStateProperty.all(AppColor.primary)),
                      onPressed: () {
                        if(teamMemberId.isEmpty){
                          toast(msg: "Please select team member");
                          return;
                        }
                        var reassignList = {
                          "update": "reassign",
                          "taskId": widget.getTaskId.toString(),
                          "reassign": teamMemberId.toString(),
                        };
                        BlocProvider.of<ReassignMyTaskCubit>(context).fetchReassignMyTask(reassignList);
                      },
                    ),
                  )
                ],
              );
            } else {
              toast(msg: selectTeamModel.msg.toString());
            }
          }
          return const SizedBox();
        },
        listener: (context, index) {});
  }
}
