import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/core/utils/file_pick.dart';
import 'package:haelo_flutter/core/utils/functions.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/bottom_bar/presentation/screens/bottombar.dart';
import 'package:haelo_flutter/features/drawer_content/presentation/widgets/formvalidations.dart';
import 'package:haelo_flutter/features/drawer_content/presentation/widgets/textformfield_decoration.dart';
import 'package:haelo_flutter/features/home_page/cubit/display_board_state.dart';
import 'package:haelo_flutter/features/home_page/cubit/home_tasklist_cubit.dart';
import 'package:haelo_flutter/features/home_page/cubit/home_tasklist_state.dart';
import 'package:haelo_flutter/features/task/cubit/createtask_cubit.dart';
import 'package:haelo_flutter/features/task/cubit/createtask_state.dart';
import 'package:haelo_flutter/features/task/cubit/task_caseno_cubit.dart';
import 'package:haelo_flutter/features/task/cubit/task_caseno_state.dart';
import 'package:haelo_flutter/features/task/cubit/task_selectteam_cubit.dart';
import 'package:haelo_flutter/features/task/cubit/task_selectteam_state.dart';
import 'package:haelo_flutter/features/task/presentation/widgets/task_case_list.dart';
import 'package:haelo_flutter/widgets/commonButtons.dart';
import 'package:haelo_flutter/widgets/date_format.dart';
import 'package:haelo_flutter/widgets/error_widget.dart';
import 'package:haelo_flutter/widgets/gallery_camera_dialog.dart';
import 'package:haelo_flutter/widgets/progress_indicator.dart';
import 'package:image_picker/image_picker.dart';

class CreateTask extends StatefulWidget {
  final getTaskCaseId;
  final getCaseNoo;
  final getCaseTitle;
  final dateOfListing;
  final bool isfromHome;

  const CreateTask(
      {Key? key,
      this.getTaskCaseId,
      this.getCaseNoo,
      this.getCaseTitle,
      this.dateOfListing,
      this.isfromHome = false})
      : super(key: key);

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  final formKeyCreatetask = GlobalKey<FormState>();

  var createTaskData;

  var caseNoBox = "Case No.";
  var caseIdBox;
  String taskType = "";

  var teamNameBox = "Select Team";
  var teamIdBox = "";

  var itemsPriority = ['Low', 'Medium', 'High'];
  var priorityId = "2";

  var Case, CaseID;
  var Team, TeamID;

  TextEditingController _caseNoController = TextEditingController();

  TextEditingController _priorityController = TextEditingController();
  TextEditingController _selectTeamController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  String noteOneDocuments =
      "1.) If you are concerned with the Privacy of your case options, you can choose Google Drive option.";
  String noteTwoDocuments =
      "2.) Document's maximum allowed file size is 20 mb.";

  String isPermission = "yes";
  bool isOpen = false;
  bool isLoading = false;

  @override
  void initState() {
    // pref = di.locator();
    BlocProvider.of<TaskCaseNoCubit>(context).fetchTaskCaseNo();
    BlocProvider.of<TaskSelectTeamCubit>(context).fetchTaskSelectTeam();
    super.initState();
    _priorityController.text = itemsPriority[1].toString();
    if (widget.getTaskCaseId != null) {
      _caseNoController.text = "${widget.getCaseNoo} \n ${widget.getCaseTitle}";
      caseIdBox = widget.getTaskCaseId.toString();
      taskType = "1";
    }
  }

  bool dottedBox = true;
  var file;

  final ImagePicker imagePicker = ImagePicker();
  List imageFileList = [];

  File? _image;

  File? _imageGallery;

  TextEditingController search_textController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  List searchList = [];
  bool isSearch = false;

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
        titleSpacing: -5,
        title: Text(
          "Create Task",
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
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    BlocConsumer<CreateTaskCubit, CreateTaskState>(
                        builder: (context, state) {
                      return SizedBox();
                    }, listener: (context, state) {
                      if (state is CreateTaskLoading) {
                        setState(() {
                          isLoading = true;
                        });
                      }
                      if (state is CreateTaskLoaded) {
                        final createmodel = state.createTaskModel;
                        if (createmodel.result == 1) {
                          createTaskData = createmodel.data;
                          setState(() {
                            isLoading = false;
                          });
                          toast(msg: createmodel.msg.toString());
                          Navigator.pop(context, true);
                          /*      showDialog(
                              context: context,
                              builder: (ctx) => AppMsgPopup(
                                    createmodel.msg.toString(),
                                    isCloseIcon: false,
                                    isError: false,
                                    btnCallback: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context, true);
                                    },
                                  ));*/
                          var bodyTaskList = {
                            // "limit": "",
                            "pageNo": "1",
                          };
                          BlocProvider.of<HomeTaskListCubit>(context)
                              .fetchHomeTaskList(body: bodyTaskList);
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                          showDialog(
                              context: context,
                              builder: (ctx) => AppMsgPopup(
                                    createmodel.msg.toString(),
                                  ));
                        }
                      }
                    }),
                    BlocConsumer<HomeTaskListCubit, HomeTaskListState>(
                        builder: (context, state) {
                          if (state is HomeTaskListLoaded) {
                            final homeTaskList = state.homeTaskListModel;
                            if (homeTaskList.result == 1) {
                              // Navigator.pop(context);
                            }
                          }
                          return const SizedBox();
                        },
                        listener: (context, state) {}),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 25, horizontal: 20),
                      child: Form(
                        key: formKeyCreatetask,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _titleController,
                              cursorColor: AppColor.primary,
                              cursorHeight: 25,
                              maxLines: 2,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                labelText: "Title",
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: const BorderSide(
                                      width: 1, color: Colors.black),
                                ),
                                disabledBorder: disableboarder,
                                errorBorder: errorboarder,
                                focusedBorder: focusboarder,
                                border: boarder,
                              ),
                              validator: FormValidation().validateTitlename,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: _descriptionController,
                              textAlignVertical: TextAlignVertical.top,
                              minLines: 5,
                              maxLines: 12,
                              cursorColor: AppColor.primary,
                              cursorHeight: 25,
                              decoration: InputDecoration(
                                alignLabelWithHint: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                labelText: "Description",
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: const BorderSide(
                                      width: 1, color: Colors.black),
                                ),
                                disabledBorder: disableboarder,
                                errorBorder: errorboarder,
                                focusedBorder: focusboarder,
                                border: boarder,
                              ),
                              validator:
                                  FormValidation().validateDesciptionname,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                      content: SizedBox(
                                        width: double.maxFinite,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ListView.builder(
                                              itemCount: 3,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 15,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          _priorityController
                                                                  .text =
                                                              itemsPriority[
                                                                      index]
                                                                  .toString();
                                                          priorityId =
                                                              (index + 1)
                                                                  .toString();
                                                          print(
                                                              "priorityId---------$priorityId");
                                                          setState(() {});
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          itemsPriority[index]
                                                              .toString(),
                                                        ),
                                                      ),
                                                      index != 2
                                                          ? Divider(
                                                              color: Colors
                                                                  .grey[300],
                                                              thickness: 1.5,
                                                            )
                                                          : SizedBox()
                                                    ],
                                                  ),
                                                );
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                      actions: [],
                                    );
                                  },
                                );
                              },
                              child: TextFormField(
                                enabled: false,
                                controller: _priorityController,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 10),
                                  labelText: "Priority",
                                  labelStyle:
                                      const TextStyle(color: Colors.black45),
                                  suffixIcon: const Icon(
                                    Icons.arrow_drop_down_sharp,
                                    color: Colors.black,
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: const BorderSide(
                                        width: 1, color: Colors.black),
                                  ),
                                  errorBorder: errorboarder,
                                  focusedBorder: focusboarder,
                                  border: boarder,
                                ),
                                // validator: FormValidation().validatePriority,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            BlocConsumer<TaskCaseNoCubit, TaskCaseNoState>(
                                builder: (context, state) {
                                  if (state is TaskCaseNoLoaded) {
                                    final caseNoModel = state.taskCaseNoModel;
                                    if (caseNoModel.result == 1) {
                                      if (caseNoModel.data != null) {
                                        var caseNoData = caseNoModel.data;
                                        return InkWell(
                                          onTap: () {
                                            if (widget.getTaskCaseId == null) {
                                              showDialog(
                                                  context: context,
                                                  builder: (ctx) =>
                                                      TaskCaseList(
                                                          caseSelectCallback));
                                              // showDialog(
                                              //   context: context,
                                              //   builder: (BuildContext context) {
                                              //     return AlertDialog(
                                              //       contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                              //       content: Container(
                                              //         width: double.maxFinite,
                                              //         child: Column(
                                              //           mainAxisSize: MainAxisSize.min,
                                              //           children: [
                                              //             SizedBox(
                                              //               height: 40,
                                              //               child: TextFormField(
                                              //                 cursorHeight: 25,
                                              //                 controller: search_textController,
                                              //                 onChanged: (value) {
                                              //                   if (value.isNotEmpty) {
                                              //                     searchFilterList(value.toLowerCase());
                                              //                   } else {
                                              //                     setState(() {
                                              //                       isSearch = false;
                                              //                       searchList = [];
                                              //                     });
                                              //                   }
                                              //                 },
                                              //                 autofocus: true,
                                              //                 decoration: InputDecoration(
                                              //                   hintText: "Search",
                                              //                   contentPadding:
                                              //                   const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                              //                   border: boarder,
                                              //                   focusedBorder: OutlineInputBorder(
                                              //                     borderSide: BorderSide(width: 1, color: Colors.black),
                                              //                     borderRadius: BorderRadius.circular(5),
                                              //                   ),
                                              //                   suffixIcon: search_textController.text.isNotEmpty?
                                              //                   IconButton(
                                              //                     icon: const Icon(
                                              //                       Icons.close_outlined,
                                              //                       color: Colors.black,
                                              //                     ),
                                              //                     onPressed: () {
                                              //                       setState(() {
                                              //                         isSearch = false;
                                              //                         search_textController.text="";
                                              //                         //isSearchFilter = false;
                                              //                         searchList = [];
                                              //                       });
                                              //                       /* Clear the search field */
                                              //                     },
                                              //                   ):SizedBox(),
                                              //                 ),
                                              //               ),
                                              //             ),
                                              //             ConstrainedBox(
                                              //               constraints: BoxConstraints(
                                              //                 maxHeight: MediaQuery.of(context).size.height * 0.5,
                                              //               ),
                                              //               child: ListView.builder(
                                              //                 itemCount: caseNoData!.length,
                                              //                 shrinkWrap: true,
                                              //                 itemBuilder: (context, index) {
                                              //                   return InkWell(
                                              //                     onTap: () {
                                              //                       _caseNoController.text =
                                              //                       caseNoData[index].validCaseno!=null ?
                                              //                       caseNoData[index].validCaseno.toString():
                                              //                       caseNoData[index].caseNo.toString();
                                              //                       caseIdBox = caseNoData[index].caseNo.toString();
                                              //                       setState(() {});
                                              //                       Navigator.pop(context);
                                              //                     },
                                              //                     child: Column(
                                              //                       children: [
                                              //                         Padding(
                                              //                           padding: const EdgeInsets.symmetric(vertical: 4.0),
                                              //                           child: Text(
                                              //                               caseNoData[index].validCaseno!=null ?
                                              //                               caseNoData[index].validCaseno.toString():
                                              //                               caseNoData[index].caseNo.toString(),
                                              //                             textAlign: TextAlign.center,
                                              //                           ),
                                              //                         ),
                                              //                         index!=caseNoData!.length-1?
                                              //                         Divider(
                                              //                           color: Colors.grey[300],
                                              //                           thickness: 1.5,
                                              //                         ):SizedBox()
                                              //                       ],
                                              //                     ),
                                              //                   );
                                              //                 },
                                              //               ),
                                              //             )
                                              //           ],
                                              //         ),
                                              //       ),
                                              //       actions: [],
                                              //     );
                                              //   },
                                              // );
                                            }
                                          },
                                          child: TextFormField(
                                            enabled: false,
                                            minLines: 1,
                                            maxLines: 4,
                                            controller: _caseNoController,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 15,
                                                      horizontal: 10),
                                              labelText: caseNoBox,
                                              labelStyle: const TextStyle(
                                                  color: Colors.black),
                                              suffixIcon: const Icon(
                                                Icons.arrow_drop_down_sharp,
                                                color: Colors.black,
                                              ),
                                              disabledBorder:
                                                  OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: const BorderSide(
                                                    width: 1,
                                                    color: Colors.black),
                                              ),
                                              errorBorder: errorboarder,
                                              focusedBorder: focusboarder,
                                              border: boarder,
                                            ),
                                            // validator: FormValidation().validateCaseNo,
                                          ),
                                        );
                                      }
                                    } else {
                                      toast(msg: caseNoModel.msg.toString());
                                    }
                                  }
                                  return const SizedBox();
                                },
                                listener: (context, state) {}),
                            const SizedBox(
                              height: 15,
                            ),
                            BlocConsumer<TaskSelectTeamCubit,
                                    TaskSelectTeamState>(
                                builder: (context, state) {
                                  if (state is TaskSelectTeamLoaded) {
                                    final selectTeamModel =
                                        state.taskSelectTeamModel;
                                    if (selectTeamModel.result == 1) {
                                      var selectTeamData = selectTeamModel.data;
                                      return InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 10),
                                                content: Container(
                                                  width: double.maxFinite,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      ConstrainedBox(
                                                        constraints:
                                                            BoxConstraints(
                                                          maxHeight:
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.4,
                                                        ),
                                                        child: ListView.builder(
                                                          itemCount:
                                                              selectTeamData!
                                                                  .team!.length,
                                                          shrinkWrap: true,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return InkWell(
                                                              onTap: () {
                                                                _selectTeamController
                                                                        .text =
                                                                    selectTeamData
                                                                        .team![
                                                                            index]
                                                                        .userName
                                                                        .toString();
                                                                teamIdBox =
                                                                    selectTeamData
                                                                        .team![
                                                                            index]
                                                                        .memberId
                                                                        .toString();
                                                                setState(() {
                                                                  Navigator.pop(
                                                                      context);
                                                                });
                                                              },
                                                              child: Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        15,
                                                                    vertical:
                                                                        2),
                                                                child: Column(
                                                                  children: [
                                                                    Text(selectTeamData
                                                                        .team![
                                                                            index]
                                                                        .userName
                                                                        .toString()),
                                                                    Text(
                                                                      selectTeamData
                                                                          .team![
                                                                              index]
                                                                          .mobileNo
                                                                          .toString(),
                                                                    ),
                                                                    index !=
                                                                            selectTeamData!.team!.length -
                                                                                1
                                                                        ? Divider(
                                                                            color:
                                                                                Colors.grey[300],
                                                                            thickness:
                                                                                1.5,
                                                                          )
                                                                        : SizedBox()
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: TextFormField(
                                          enabled: false,
                                          controller: _selectTeamController,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 0,
                                                    horizontal: 10),
                                            labelText: teamNameBox,
                                            labelStyle: const TextStyle(
                                                color: Colors.black),
                                            suffixIcon: const Icon(
                                              Icons.arrow_drop_down_sharp,
                                              color: Colors.black,
                                            ),
                                            disabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: const BorderSide(
                                                  width: 1,
                                                  color: Colors.black),
                                            ),
                                            errorBorder: errorboarder,
                                            focusedBorder: focusboarder,
                                            border: boarder,
                                          ),
                                          // validator: FormValidation().validateTeamMember,
                                        ),
                                      );
                                    } else {
                                      toast(
                                          msg: selectTeamModel.msg.toString());
                                    }
                                  }
                                  return const SizedBox();
                                },
                                listener: (context, index) {}),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 15, bottom: 35),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    isOpen = !isOpen;
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Additional Data",
                                      style: mpHeadLine16(
                                          textColor: AppColor
                                              .bold_text_color_dark_blue,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    isOpen
                                        ? const Icon(
                                            Icons.keyboard_arrow_up,
                                            size: 25,
                                            color: AppColor
                                                .bold_text_color_dark_blue,
                                          )
                                        : const Icon(
                                            Icons.keyboard_arrow_down,
                                            size: 25,
                                            color: AppColor
                                                .bold_text_color_dark_blue,
                                          )
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                              visible: isOpen,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Closure Permission",
                                      style: mpHeadLine18(
                                          textColor: AppColor
                                              .bold_text_color_dark_blue,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Radio(
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          fillColor:
                                              MaterialStateColor.resolveWith(
                                                  (states) => AppColor.primary),
                                          value: "yes",
                                          groupValue: isPermission,
                                          onChanged: (value) {
                                            setState(() {
                                              isPermission = value.toString();
                                              print(
                                                  "isPermission--------------$isPermission");
                                            });
                                          },
                                        ),
                                        Text(
                                          "YES",
                                          style: mpHeadLine16(),
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        Radio(
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          fillColor:
                                              MaterialStateColor.resolveWith(
                                                  (states) => AppColor.primary),
                                          activeColor: AppColor.primary,
                                          value: "no",
                                          groupValue: isPermission,
                                          onChanged: (value) {
                                            setState(() {
                                              isPermission = value.toString();
                                            });
                                          },
                                        ),
                                        Text(
                                          "NO",
                                          style: mpHeadLine16(),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    Text(
                                      "Documents",
                                      style: mpHeadLine18(
                                          textColor: AppColor
                                              .bold_text_color_dark_blue,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Add upto 5 images in jpeg or png format.Maximum allowed file size is 20 mb.",
                                      style: mpHeadLine14(
                                          textColor: AppColor.hint_color_grey),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 15,
                                      ),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: mediaQH(context) * 0.090,
                                              // width: mediaQW(context) * 0.5,
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount:
                                                    imageFileList!.length,
                                                itemBuilder: (context, index) {
                                                  return Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 12,
                                                                  top: 8),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            child: imageFileList![
                                                                            index]
                                                                        .path
                                                                        .contains(
                                                                            "png") ||
                                                                    imageFileList![
                                                                            index]
                                                                        .path
                                                                        .contains(
                                                                            "jpg")
                                                                ? Image.file(
                                                                    File(imageFileList![
                                                                            index]
                                                                        .path),
                                                                    // height: 650,
                                                                    width: 60,
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  )
                                                                : Container(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            10.0),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              4),
                                                                      color: Colors
                                                                          .grey
                                                                          .shade400,
                                                                    ),
                                                                    child: Icon(
                                                                      Icons
                                                                          .image,
                                                                      size: 35,
                                                                    ),
                                                                  ),
                                                          )),
                                                      Positioned(
                                                          right: 5,
                                                          top: 1,
                                                          child: Container(
                                                            width: 20,
                                                            height: 20,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          )),
                                                      Positioned(
                                                          right: 5,
                                                          top: 1,
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              FocusScope.of(
                                                                      context)
                                                                  .requestFocus(
                                                                      FocusNode());
                                                              setState(() {
                                                                imageFileList
                                                                    .removeAt(
                                                                        index);
                                                              });
                                                            },
                                                            child: Icon(
                                                              Icons.cancel,
                                                              color: Colors
                                                                  .red.shade800,
                                                            ),
                                                          )),
                                                    ],
                                                  );
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              width: 13,
                                            ),
                                            // selectImages();
                                            GestureDetector(
                                              onTap: () {
                                                FocusScope.of(context)
                                                    .requestFocus(FocusNode());
                                                showDialog(
                                                    context: context,
                                                    builder: (ctx) => SafeArea(
                                                          child:
                                                              GalleryCameraDialog(
                                                                  isDoc: true,
                                                                  is_g_Drive:
                                                                      true,
                                                                  onClickValue:
                                                                      (isGallery) {
                                                                    if (isGallery ==
                                                                        4) {
                                                                      pickFromGdrive(
                                                                          imgCallBack,
                                                                          context);
                                                                    } else if (isGallery ==
                                                                        3) {
                                                                      pickDocument(
                                                                          imgCallBack);
                                                                    } else {
                                                                      pickImage(
                                                                          isGallery,
                                                                          context,
                                                                          imgCallBack);
                                                                    }
                                                                  }),
                                                        ));
                                              },
                                              child: Visibility(
                                                visible: dottedBox,
                                                child: DottedBorder(
                                                  borderType: BorderType.RRect,
                                                  radius: Radius.circular(6),
                                                  dashPattern: [10, 10],
                                                  color: Colors.grey,
                                                  strokeWidth: 2,
                                                  child: Container(
                                                    height: 65,
                                                    width: 65,
                                                    child: Icon(
                                                      Icons.add,
                                                      color: AppColor
                                                          .hint_color_grey,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                  ]),
                            ),
                            CommonButtons(
                              buttonText: "Create",
                              buttonCall: () {
                                // if (formKeyCreatetask.currentState!.validate()) {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                if (_titleController.text.isEmpty) {
                                  toast(msg: "Please enter title");
                                  return;
                                }
                                if (_descriptionController.text.isEmpty) {
                                  toast(msg: "Please enter description");
                                  return;
                                }
                                /*   if (widget.isfromHome) {
                                  if (_caseNoController.text.isEmpty) {
                                    toast(msg: "Please select case no");
                                    return;
                                  }
                                }*/

                                if (teamIdBox.isEmpty) {
                                  toast(msg: "Please select team member");
                                  return;
                                }

                                List<File>? imageFileList1 = [];
                                for (int i = 0; i < imageFileList.length; i++) {
                                  File file =
                                      File(imageFileList[i].path.toString());
                                  imageFileList1.add(file);
                                }
                                // if (imageFileList.isNotEmpty) {
                                //   file = imageFileList[0];
                                // }
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                var todayDate = DateTime.now();
                                var body = {
                                  "title": _titleController.text.trim(),
                                  "desc": _descriptionController.text.trim(),
                                  "memberId": teamIdBox.toString(),
                                  "priority": priorityId,
                                  "closure":
                                      isPermission == "yes" ? "true" : "false",
                                  "caseId": _caseNoController.text.isNotEmpty
                                      ? caseIdBox.toString()
                                      : "",
                                  "caseNo": _caseNoController.text.isNotEmpty
                                      ? _caseNoController.text.trim()
                                      : "",
                                  "taskType":
                                      !widget.isfromHome ? taskType : "",
                                  "orderDate": !widget.isfromHome
                                      ? getYYYYMMDD(
                                          widget.dateOfListing.toString())
                                      : getYYYYMMDDNew(todayDate.toString()),
                                };
                                BlocProvider.of<CreateTaskCubit>(context)
                                    .fetchCreateTask(body, imageFileList1);
                                // }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
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

  void imgCallBack(XFile xfile, bool isDoc) {
    print("gstFile");
    File file = File(xfile.path);
    imageFileList!.add(file);

    if (imageFileList!.length >= 5) {
      dottedBox = false;
    }
    setState(() {});
  }

  void caseSelectCallback(String name, String id) {
    _caseNoController.text = name;
    caseIdBox = id;
    setState(() {});
  }
}
