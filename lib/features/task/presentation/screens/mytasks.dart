import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/core/utils/bottom_sheet_dialog.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/no_data_widget.dart';
import 'package:haelo_flutter/features/home_page/cubit/home_tasklist_cubit.dart';
import 'package:haelo_flutter/features/home_page/cubit/home_tasklist_state.dart';
import 'package:haelo_flutter/features/home_page/data/model/Home_TaskList_Model.dart';
import 'package:haelo_flutter/features/home_page/presentation/widgets/tasktiles.dart';
import 'package:haelo_flutter/features/task/cubit/delete_mytask_cubit.dart';
import 'package:haelo_flutter/features/task/cubit/delete_mytask_state.dart';
import 'package:haelo_flutter/features/task/presentation/screens/mytasks_bottom_sheet.dart';
import 'package:haelo_flutter/widgets/progress_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../widgets/error_widget.dart';
import 'createtask.dart';
import 'package:haelo_flutter/locators.dart' as di;

class MyTasks extends StatefulWidget {
  const MyTasks({Key? key}) : super(key: key);

  @override
  State<MyTasks> createState() => _MyTasksState();
}

class _MyTasksState extends State<MyTasks> {
  late SharedPreferences pref;

  bool isLoading = true;

  List<TaskData> taskList = [];
  int pageNum = 1;

  var taskListData;
  bool isSearch = false;
  bool isSearchFilter = false;
  TextEditingController search_textController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  List searchList = [];

  String filterMember = '';
  String filterStatus = '';

  @override
  void initState() {
    pref = di.locator();
    fetchTask();
    super.initState();
  }

  void fetchTask() {
    var bodyTaskList = {
      // "limit": "",
      "pageNo": "1",
    };
    BlocProvider.of<HomeTaskListCubit>(context)
        .fetchHomeTaskList(body: bodyTaskList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.home_background,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              InkWell(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Icon(Icons.menu),
                ),
              ),
              isSearch
                  ? SizedBox()
                  : Expanded(
                      child: Text(
                        "My Tasks",
                        style: mpHeadLine18(
                            fontWeight: FontWeight.w500,
                            textColor: AppColor.bold_text_color_dark_blue),
                      ),
                    ),
              !isSearch
                  ? Container(
                      margin: const EdgeInsets.only(right: 0, left: 5),
                      child: InkWell(
                          onTap: () => setState(() {
                                isSearch = true;
                              }),
                          child: const Icon(
                            Icons.search,
                            color: Colors.black,
                          )),
                    )
                  : Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: TextField(
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              searchFilterList(value.toLowerCase());
                            } else {
                              setState(() {
                                isSearchFilter = false;
                                searchList = [];
                              });
                            }
                          },
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isSearch = false;
                                    isSearchFilter = false;
                                    searchList = [];
                                  });
                                  /* Clear the search field */
                                },
                              ),
                              hintText: 'Search...',
                              border: InputBorder.none),
                        ),
                      ),
                    ),
              isSearch
                  ? SizedBox()
                  : Container(
                      margin: const EdgeInsets.only(right: 5, left: 5),
                      child: InkWell(
                        onTap: () {
                          BottomSheetDialog(
                              context,
                              TaskBottomSheet(
                                filterCallback: filtercallback,
                                memberSelected: filterMember,
                                statusSelected: filterStatus,
                              )).showScreen();
                        },
                        child: Stack(
                          children: [
                            const Icon(
                              Icons.filter_alt_outlined,
                              size: 25,
                              color: AppColor.bold_text_color_dark_blue,
                            ),
                            filterStatus.isEmpty && filterMember.isEmpty
                                ? SizedBox()
                                : Positioned(
                                    right: 5,
                                    top: 1,
                                    child: Container(
                                      color: AppColor.white,
                                      padding: EdgeInsets.all(1),
                                      child: Icon(
                                        Icons.brightness_1,
                                        size: 5,
                                        color: AppColor.rejected_color_text,
                                      ),
                                    ))
                          ],
                        ),
                      ),
                    )
            ],
          ),
        ),
        body: SafeArea(
          child: Stack(
            //alignment: Alignment.center,
            children: [
              BlocConsumer<HomeTaskListCubit, HomeTaskListState>(
                  builder: (context, state) {
                if (state is HomeTaskListLoaded) {
                  final taskListModel = state.homeTaskListModel;
                  if (taskListModel.result == 1) {
                    return searchList.isEmpty && !isSearchFilter
                        ? RefreshIndicator(
                            onRefresh: () async {
                              fetchTask();
                            },
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: taskList.length,
                                itemBuilder: (listViewContent, index) {
                                  if (index == taskList.length) {
                                    if (taskList.length !=
                                        taskListModel.count) {
                                      ListUpdate();
                                      return Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(top: 18),
                                            child: CircularProgressIndicator(
                                              color: AppColor.primary,
                                            ),
                                          ),
                                          // SizedBox(
                                          //     height: sgtl.deviceType == 'Mobile'
                                          //         ? sgtl.mediaQH * 0.1
                                          //         : sgtl.mediaQH * 0.12),
                                        ],
                                      );
                                    }
                                    return const SizedBox();
                                  } else {
                                    // var bmeObject = {
                                    //   "bmeId": activeList![index].sId.toString(),
                                    //   "associationId": activeList![index].association!.bme!.sId.toString(),
                                    //   "bmeName": activeList![index].association!.bme!.name.toString(),
                                    //   "bmeAddress": activeList![index].association!.bme!.address.toString(),
                                    //   "bmeType": "bme+$selectedAssociationType",
                                    // };
                                    return TaskTiles(
                                      taskListDate: taskListModel.data != null
                                          ? taskListModel.data![index].taskDate
                                              .toString()
                                          : "",
                                      taskListDescription: taskListModel.data !=
                                              null
                                          ? taskListModel.data![index].taskDesc
                                              .toString()
                                          : "",
                                      taskListPriority:
                                          taskListModel.data != null
                                              ? taskListModel
                                                  .data![index].taskPriority
                                                  .toString()
                                              : "",
                                      taskListStatus: taskListModel.data != null
                                          ? taskListModel
                                              .data![index].taskStatus
                                              .toString()
                                          : "",
                                      taskListTitle: taskListModel.data != null
                                          ? taskListModel.data![index].taskTitle
                                              .toString()
                                          : "",
                                      taskId: taskListModel.data != null
                                          ? taskListModel.data![index].taskId
                                              .toString()
                                          : "",
                                      isFromHome: true,
                                      refreshCallback: refreshCallback,
                                    );
                                  }
                                }),
                          )
                        : searchList.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: searchList.length,
                                itemBuilder: (listViewContent, index) {
                                  return TaskTiles(
                                    taskListDate:
                                        searchList![index].taskDate.toString(),
                                    taskListDescription:
                                        searchList![index].taskDesc.toString(),
                                    taskListPriority: searchList![index]
                                        .taskPriority
                                        .toString(),
                                    taskListStatus: searchList![index]
                                        .taskStatus
                                        .toString(),
                                    taskListTitle:
                                        searchList![index].taskTitle.toString(),
                                    taskId:
                                        searchList![index].taskId.toString(),
                                    isFromHome: true,
                                    refreshCallback: refreshCallback,
                                  );
                                })
                            : isLoading
                                ? SizedBox()
                                : NoDataAvailable("Search data not found.");
                  }
                  return isLoading
                      ? SizedBox()
                      : NoDataAvailable(
                          filterStatus.isEmpty && filterMember.isEmpty
                              ? "Your Task will be shown here."
                              : "No records found matching the search result.");
                }
                return const SizedBox();
              }, listener: (context, state) {
                if (state is HomeTaskListLoading) {
                  print("loafing ");
                  setState(() {
                    isLoading = true;
                  });
                  print("isloading $isLoading");
                }
                if (state is HomeTaskListLoaded) {
                  if (state.homeTaskListModel.result == 1) {
                    taskListData = state.homeTaskListModel;
                    // pageNum = taskListData.page;
                    if (pageNum == 1) {
                      if (taskListData.data != null) {
                        taskList = taskListData.data;
                        // setState(() {});
                      }
                    } else if (pageNum <= taskListData.pages) {
                      if (taskListData.data != null) {
                        taskList.addAll(taskListData.data);
                        // setState(() {});
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
              BlocConsumer<DeleteMyTaskCubit, DeleteMyTaskState>(
                  builder: (context, state) {
                return const SizedBox();
              }, listener: (context, state) {
                if (state is DeleteMyTaskLoaded) {
                  var deleteinpopup = state.deleteMyTaskModel;
                  if (deleteinpopup.result == 1) {
                    // toast(msg: deleteinpopup.msg.toString());
                    setState(() {
                      isLoading = false;
                    });
                    toast(msg: deleteinpopup.msg.toString());
                    /*   showDialog(
                        context: context,
                        builder: (ctx) => AppMsgPopup(
                          deleteinpopup.msg.toString(),
                          isCloseIcon: false,
                          isError: false,
                          btnCallback: () {
                            Navigator.pop(context);
                          },));*/
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
                              deleteinpopup.msg.toString(),
                            ));
                  }
                }
              }),
              Visibility(
                visible: isLoading,
                child: const Center(child: AppProgressIndicator()),
              ),
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
                      builder: (context) => CreateTask(
                            isfromHome: true,
                          )));
            }));
  }

  void ListUpdate() {
    pageNum += 1;

    var bodyTaskList = {
      // "limit": "",
      "pageNo": pageNum.toString(),
    };
    BlocProvider.of<HomeTaskListCubit>(context)
        .fetchHomeTaskList(body: bodyTaskList);
  }

  void refreshCallback(bool isRefresh) {
    if (isRefresh) {
      setState(() {
        isSearch = false;
        isSearchFilter = false;
        searchList = [];
      });
      var bodyTaskList = {
        // "limit": "",
        "pageNo": "1",
      };
      BlocProvider.of<HomeTaskListCubit>(context)
          .fetchHomeTaskList(body: bodyTaskList);
    }
  }

  void searchFilterList(String searchKey) {
    setState(() {
      searchList = [];
    });

    for (var item in taskList!) {
      if (item.taskTitle != null &&
              item.taskTitle!.toLowerCase().contains(searchKey) ||
          item.taskStatus != null &&
              item.taskStatus!.toLowerCase().contains(searchKey) ||
          item.taskDesc != null &&
              item.taskDesc!.toLowerCase().contains(searchKey)) {
        if (!searchList.contains(item)) {
          searchList.add(item);
        }
      }
    }
    // print("searchlist length ${searchList.length}");
    isSearchFilter = true;
    setState(() {});
  }

  void filtercallback(String member, String status) {
    isSearch = false;
    isSearchFilter = false;
    searchList = [];
    print("member $member  $status");

    if (member.isNotEmpty || status.isNotEmpty) {
      // if(member.isNotEmpty && status.isNotEmpty){
      //   for (int i = 0; i < taskList.length; i++) {
      //     if (taskList[i].taskStatus != null &&
      //         taskList[i]
      //             .taskStatus
      //             .toString()
      //             .toLowerCase()
      //             .contains(status.toLowerCase())) {
      //       searchList.add(taskList[i]);
      //     }
      //   }
      // }
      //
      // if(member.isEmpty){
      // for (int i = 0; i < taskList.length; i++) {
      //   if (taskList[i].taskStatus != null &&
      //       taskList[i]
      //           .taskStatus
      //           .toString()
      //           .toLowerCase()
      //           .contains(status.toLowerCase())) {
      //     searchList.add(taskList[i]);
      //   }
      // }}

      // isSearchFilter = true;
      var body = {
        "filterByMob": member,
        "filterByStatus": status,
      };
      BlocProvider.of<HomeTaskListCubit>(context).fetchHomeTaskList(body: body);
      filterMember = member;
      filterStatus = status;
    } else {
      filterStatus = "";
      filterMember = '';
      isSearch = false;
      isSearchFilter = false;
      searchList = [];
      var bodyTaskList = {
        // "limit": "",
        "pageNo": "1",
      };
      BlocProvider.of<HomeTaskListCubit>(context)
          .fetchHomeTaskList(body: bodyTaskList);
    }
  }
}
