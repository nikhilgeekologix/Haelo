import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/home_page/cubit/home_tasklist_cubit.dart';
import 'package:haelo_flutter/features/home_page/cubit/home_tasklist_state.dart';
import 'package:haelo_flutter/features/task/cubit/task_selectteam_cubit.dart';
import 'package:haelo_flutter/features/task/cubit/task_selectteam_state.dart';
import 'package:haelo_flutter/widgets/commonButtons.dart';

class TaskBottomSheet extends StatefulWidget {
  final filterCallback;
  final memberSelected;
  final statusSelected;
  const TaskBottomSheet({this.filterCallback, this.memberSelected,
    this.statusSelected,
    Key? key}) : super(key: key);

  @override
  State<TaskBottomSheet> createState() => _TaskBottomSheetState();
}

class _TaskBottomSheetState extends State<TaskBottomSheet> {
  List taskStatus = ["Pending", "Rejected", "Accepted", "Under Review", "Completed"];
                    //1, 2, 3,  4,  5
  String statusGrpValue = "";
  String statusSelectedValue = "";

  String teamGrpValue = "";
  String teamSelectedValue = "";
  var selectTeamData ;

  @override
  void initState() {
    print("abcd ${widget.statusSelected}");
    if(widget.statusSelected!=null){
      if(widget.statusSelected.toString().isNotEmpty) {
        statusGrpValue=taskStatus.indexOf(taskStatus[(int.parse(widget.statusSelected)-1)].toString()).toString();
        print("hello $statusGrpValue");
        statusSelectedValue = widget.statusSelected;
      }
    }
    BlocProvider.of<TaskSelectTeamCubit>(context).fetchTaskSelectTeam();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Padding(
      // padding: MediaQuery.of(context).viewInsets,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: SizedBox(
        height: mediaQH(context) * 0.67,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocConsumer<HomeTaskListCubit, HomeTaskListState>(
                  builder: (context, state) {
                    if (state is HomeTaskListLoading) {
                      return SizedBox(
                        height: mediaQH(context) * 0.8,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (state is HomeTaskListLoaded) {
                      final filterHomeTaskList = state.homeTaskListModel;
                      if (filterHomeTaskList.result == 1) {
                        var filterHomeTaskListData = filterHomeTaskList.data;
                      }
                    }
                    return const SizedBox();
                  },
                  listener: (context, state) {}),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: mediaQW(context) * 0.18,
                    child: const Divider(
                      thickness: 5,
                      color: AppColor.hint_color_grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.close,
                        color: AppColor.hint_color_grey,
                      )
                  ),
                  Text(
                    "Filter",
                    style: mpHeadLine20(textColor: AppColor.bold_text_color_dark_blue, fontWeight: FontWeight.w500),
                  ),
                  InkWell(
                    onTap: (){
                      widget.filterCallback("","");
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Reset",
                      style: mpHeadLine14(textColor:
                      teamGrpValue.isNotEmpty || statusGrpValue.isNotEmpty?AppColor.primary:
                      AppColor.hint_color_grey),
                    ),
                  )
                ],
              ),
              BlocConsumer<TaskSelectTeamCubit, TaskSelectTeamState>(
                  builder: (context, state) {
                    return const SizedBox();
                  },
                  listener: (context, state) {
                    if (state is TaskSelectTeamLoaded) {
                      final selectTeamModel = state.taskSelectTeamModel;
                      if (selectTeamModel.result == 1) {
                        selectTeamData = selectTeamModel.data;
                        print("widget.memberSelected ${widget.memberSelected}");
                        if(widget.memberSelected!=null){
                          if(widget.memberSelected.toString().isNotEmpty && selectTeamData.team.isNotEmpty) {
                            int idx =selectTeamData!.team!.indexWhere((element) => element.mobileNo==widget.memberSelected);
                            if(idx!=-1) {
                              teamGrpValue=selectTeamData!.team![idx].mobileNo.toString();
                              teamSelectedValue=widget.memberSelected;
                            }
                          }

                          setState(() {
                          });
                        }
                      }
                      // else {
                      //   toast(msg: selectTeamModel.msg.toString());
                      // }
                    }
                  }),
              const SizedBox(
                height: 20,
              ),
              selectTeamData!=null?Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Team member",
                    style: mpHeadLine18(textColor: AppColor.bold_text_color_dark_blue, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  ListView.builder(
                    itemCount: selectTeamData!.team!.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Theme(
                            data: ThemeData(
                              visualDensity: const VisualDensity(
                                  horizontal: VisualDensity.minimumDensity,
                                  vertical: VisualDensity.minimumDensity),
                              unselectedWidgetColor: AppColor.primary,
                            ),
                            child: RadioListTile(
                              contentPadding: EdgeInsets.zero,
                              activeColor: AppColor.primary,
                              title: Row(
                                children: [
                                  SizedBox(width: mediaQW(context) * 0.20,),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          selectTeamData.team![index].userName.toString(),
                                          style: mpHeadLine16(),
                                          maxLines: 2,
                                        ),
                                        Text(
                                          selectTeamData.team![index].mobileNo.toString(),
                                          style: mpHeadLine16(),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              value: selectTeamData.team![index].mobileNo.toString(),
                              groupValue: teamGrpValue,
                              onChanged: (value) {
                                setState(() {
                                  teamGrpValue = value.toString();
                                  teamSelectedValue= selectTeamData.team![index].mobileNo!=null?
                                  selectTeamData.team![index].mobileNo.toString():
                                  selectTeamData.team![index].userName.toString();
                                });
                              },
                            ),
                          ),
                         index!= selectTeamData!.team!.length-1? const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Divider(
                              thickness: 1,
                            ),
                          ):SizedBox()
                        ],
                      );
                    },
                  ),
                ],
              ):SizedBox(),



              const SizedBox(
                height: 4,
              ),
              const Divider(
                thickness: 1,
                color: AppColor.grey_color,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Task status",
                style: mpHeadLine18(textColor: AppColor.bold_text_color_dark_blue, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 10,
              ),
              ListView.builder(
                itemCount: taskStatus.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Theme(
                        data: ThemeData(
                          visualDensity: const VisualDensity(
                              horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                          unselectedWidgetColor: AppColor.primary,
                        ),
                        child: RadioListTile(
                          contentPadding: EdgeInsets.zero,
                          activeColor: AppColor.primary,
                          title: Row(
                            children: [
                              SizedBox(width: mediaQW(context) * 0.24,),
                              Text(
                                taskStatus[index],
                                style: mpHeadLine18(),
                              ),
                            ],
                          ),
                          value: (index).toString(),
                          groupValue: statusGrpValue,
                          onChanged: (value) {
                            setState(() {
                              statusGrpValue = value.toString();
                              statusSelectedValue=(index + 1).toString();
                            });
                          },
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Divider(
                          thickness: 1,
                        ),
                      )
                    ],
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: CommonButtons(
                  buttonText: "Apply Filter",
                  buttonCall: () {
                    widget.filterCallback(teamSelectedValue,statusSelectedValue);
                    // var body = {
                    //   "filterByMob": isTeamPermission,
                    //   "filterByStatus": isPermission,
                    // };
                    // BlocProvider.of<HomeTaskListCubit>(context).fetchHomeTaskList(body: body);
                    Navigator.pop(context);
                    // if (formKeyProfile.currentState!.validate()) ;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
