import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/constants.dart';
import 'package:haelo_flutter/core/utils/functions.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/no_data_widget.dart';
import 'package:haelo_flutter/features/drawer_content/cubit/myteam_cubit.dart';
import 'package:haelo_flutter/features/drawer_content/cubit/myteam_state.dart';
import 'package:haelo_flutter/features/drawer_content/cubit/myteampopup_cubit.dart';
import 'package:haelo_flutter/features/drawer_content/cubit/myteampopup_state.dart';
import 'package:haelo_flutter/locators.dart' as di;
import 'package:haelo_flutter/widgets/alert_dialog.dart';
import 'package:haelo_flutter/widgets/confirmation_dialog.dart';
import 'package:haelo_flutter/widgets/error_widget.dart';
import 'package:haelo_flutter/widgets/progress_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/ui_helper.dart';
import '../../../bottom_bar/presentation/screens/bottombar.dart';

class MyTeam extends StatefulWidget {
  const MyTeam({Key? key}) : super(key: key);

  @override
  State<MyTeam> createState() => _MyTeamState();
}

class _MyTeamState extends State<MyTeam> {
  @override
  void initState() {
    pref = di.locator();
    fetchTeamData();
    super.initState();
  }

  bool isLoading = true;
  late SharedPreferences pref;
  var popupData;
  String selectedUserId = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        titleSpacing: 0,
        centerTitle: false,
        title: Text(
          "My Team",
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
      body: Stack(
        // alignment: Alignment.center,
        children: [
          BlocConsumer<MyTeamPopupCubit, MyTeamPopupState>(
              builder: (context, state) {
            return const SizedBox();
          }, listener: (context, state) {
            if (state is MyTeamPopupLoading) {
              setState(() {
                isLoading = true;
              });
            }
            if (state is MyTeamPopupLoaded) {
              var popupList = state.myTeamPopupModel;
              selectedUserId = '';
              if (popupList.result == 1) {
                toast(msg: popupList.msg.toString());
                /*    showDialog(
                        context: context,
                        builder: (ctx) => AppMsgPopup(popupList.msg.toString(),isCloseIcon: false,isError: false,));*/
                fetchTeamData();
              } else {
                showDialog(
                    context: context,
                    builder: (ctx) => AppMsgPopup(
                          popupList.msg.toString(),
                        ));
              }
              setState(() {
                isLoading = false;
              });
            }
          }),
          BlocConsumer<MyTeamCubit, MyTeamState>(
            builder: (context, state) {
              if (state is MyTeamLoaded) {
                selectedUserId = '';
                var myTeamList = state.profileUpdateModel;
                if (myTeamList.result == 1) {
                  var myTeamData = myTeamList.data;
                  pref.getString(Constants.USER_ID);
                  print(pref.getString(Constants.USER_ID));
                  return myTeamData!.team!.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          //physics: const NeverScrollableScrollPhysics(),
                          itemCount: myTeamData!.team!.length,
                          itemBuilder: (context, index) {
                            bool isBlock = myTeamData.team![index].isBlocked!;
                            var idCheck =
                                myTeamData.team![index].memberId.toString();
                            return idCheck == pref.getString(Constants.USER_ID)
                                ? myTeamData!.team!.length == 1
                                    ? NoDataAvailable(
                                        "Your Team will be shown here.")
                                    : const SizedBox()
                                : Card(
                                    margin: const EdgeInsets.only(
                                        top: 10,
                                        left: 15,
                                        right: 15,
                                        bottom: 10),
                                    child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  myTeamData.team![index]
                                                              .userName !=
                                                          ""
                                                      ? Row(
                                                          children: [
                                                            Flexible(
                                                              child: Text(
                                                                myTeamData
                                                                    .team![
                                                                        index]
                                                                    .userName
                                                                    .toString(),
                                                                style: mpHeadLine16(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : const SizedBox(),
                                                  myTeamData.team![index]
                                                              .userName !=
                                                          ""
                                                      ? const SizedBox(
                                                          height: 5,
                                                        )
                                                      : const SizedBox(),
                                                  Text(
                                                    myTeamData
                                                        .team![index].mobileNo
                                                        .toString(),
                                                    style: mpHeadLine16(
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  RichText(
                                                    text: TextSpan(
                                                      text: 'id: ',
                                                      style: mpHeadLine14(),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                            text: myTeamData
                                                                .team![index]
                                                                .memberId
                                                                .toString(),
                                                            style:
                                                                mpHeadLine14()),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  RichText(
                                                    text: TextSpan(
                                                      text: 'Status: ',
                                                      style: mpHeadLine14(),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          text: myTeamData
                                                                      .team![
                                                                          index]
                                                                      .isDeleted
                                                                      .toString() ==
                                                                  "true"
                                                              ? "Deleted"
                                                              : myTeamData
                                                                          .team![
                                                                              index]
                                                                          .isBlocked
                                                                          .toString() ==
                                                                      "true"
                                                                  ? "Blocked"
                                                                  : "Active",
                                                          style: mpHeadLine14(
                                                              textColor: myTeamData
                                                                          .team![
                                                                              index]
                                                                          .isDeleted
                                                                          .toString() ==
                                                                      "true"
                                                                  ? AppColor
                                                                      .button_reject
                                                                  : myTeamData.team![index].isBlocked
                                                                              .toString() ==
                                                                          "true"
                                                                      ? AppColor
                                                                          .text_grey_color
                                                                      : Colors
                                                                          .green,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: 25,
                                              height: 25,
                                              child: myTeamData.team![index]
                                                          .isDeleted
                                                          .toString() ==
                                                      "true"
                                                  ? const SizedBox()
                                                  : PopupMenuButton<int>(
                                                      onSelected: (i) async {
                                                        if (i == 1) {
                                                          // var popupDeleteList = {
                                                          //   "userId": myTeamData.team![index].memberId.toString(),
                                                          //   "deleteFlag": "1",
                                                          //   "blockFlag": "",
                                                          // };
                                                          // BlocProvider.of<MyTeamPopupCubit>(context)
                                                          //     .fetchMyTeamPopup(popupDeleteList);
                                                          selectedUserId =
                                                              myTeamData
                                                                  .team![index]
                                                                  .memberId
                                                                  .toString();
                                                          showDeleteConfirmation(
                                                              myTeamData
                                                                  .team![index]
                                                                  .mobileNo);
                                                        } else if (i == 2) {
                                                          var popupDeleteList =
                                                              {
                                                            "userId": myTeamData
                                                                .team![index]
                                                                .memberId
                                                                .toString(),
                                                            "deleteFlag": "",
                                                            "blockFlag":
                                                                !isBlock
                                                                    ? "1"
                                                                    : "0",
                                                          };
                                                          BlocProvider.of<
                                                                      MyTeamPopupCubit>(
                                                                  context)
                                                              .fetchMyTeamPopup(
                                                                  popupDeleteList);
                                                        }
                                                      },
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0),
                                                      icon: const Icon(
                                                        Icons
                                                            .more_vert_outlined,
                                                        size: 22,
                                                        color: AppColor.black,
                                                      ),
                                                      itemBuilder: (context) =>
                                                          [
                                                        // popupmenu item 1
                                                        const PopupMenuItem(
                                                          value: 1,
                                                          child: Text("Delete"),
                                                        ),
                                                        // popupmenu item 2
                                                        PopupMenuItem(
                                                          value: 2,
                                                          child: Text(isBlock
                                                              ? "UnBlock"
                                                              : "Block"),
                                                        ),
                                                      ],
                                                      offset:
                                                          const Offset(-15, 10),
                                                      color: Colors.white,
                                                      elevation: 2,
                                                    ),
                                            ),
                                          ],
                                        )));
                          },
                        )
                      : isLoading
                          ? SizedBox()
                          : NoDataAvailable("Your Team will be shown here.");
                }
                return isLoading
                    ? SizedBox()
                    : NoDataAvailable("Your Team will be shown here.");
              }
              return isLoading
                  ? SizedBox()
                  : NoDataAvailable("Your Team will be shown here.");
            },
            listener: (context, state) {
              if (state is MyTeamLoading) {
                setState(() {
                  isLoading = true;
                });
              } else {
                setState(() {
                  isLoading = false;
                });
              }
            },
          ),
          Visibility(
            visible: isLoading,
            child: Center(child: const AppProgressIndicator()),
          ),
        ],
      ),
    );
  }

  fetchTeamData() {
    var team = {
      "showBlockedUser": "true",
    };
    BlocProvider.of<MyTeamCubit>(context).fetchMyTeam(team);
  }

  showDeleteConfirmation(mobileNumber) {
    String deleteConfirmMsg =
        "If you delete this user, the user ($mobileNumber) will not be able to access the account again. Are you sure you continue?";
    showDialog(
        context: context,
        builder: (ctx) => AppConfirmation(deleteConfirmMsg, deleteCallback));
  }

  void deleteCallback() {
    print("deleteCallback");
    Map<String, String> map = {
      "userId": selectedUserId,
      "deleteFlag": "1",
      "blockFlag": "",
    };
    BlocProvider.of<MyTeamPopupCubit>(context).fetchMyTeamPopup(map);
  }
}
