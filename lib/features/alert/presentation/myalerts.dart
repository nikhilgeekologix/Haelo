import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/core/utils/functions.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/alert/cubit/add_event_cubit.dart';
import 'package:haelo_flutter/features/alert/cubit/add_event_state.dart';
import 'package:haelo_flutter/features/alert/cubit/delete_alert_cubit.dart';
import 'package:haelo_flutter/features/alert/cubit/delete_alert_state.dart';
import 'package:haelo_flutter/features/alert/cubit/delete_watchlist/delete_watchlist_cubit.dart';
import 'package:haelo_flutter/features/alert/cubit/delete_watchlist/delete_watchlist_state.dart';
import 'package:haelo_flutter/features/alert/cubit/edit_watchlist/edit_watchlist_cubit.dart';
import 'package:haelo_flutter/features/alert/cubit/edit_watchlist/edit_watchlist_state.dart';
import 'package:haelo_flutter/features/alert/cubit/my_alert_cubit.dart';
import 'package:haelo_flutter/features/alert/cubit/my_alert_state.dart';
import 'package:haelo_flutter/features/alert/data/model/my_alert_model.dart';
import 'package:haelo_flutter/features/bottom_bar/presentation/screens/bottom_nav_bar.dart';
import 'package:haelo_flutter/features/bottom_bar/presentation/screens/bottombar.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/no_data_widget.dart';
import 'package:haelo_flutter/features/causeslist/cubit/main_causelistdata_cubit.dart';
import 'package:haelo_flutter/features/causeslist/cubit/main_causelistdata_state.dart';
import 'package:haelo_flutter/features/causeslist/presentation/screen/causelist_screen.dart';
import 'package:haelo_flutter/features/causeslist/presentation/screen/viewcauselist.dart';
import 'package:haelo_flutter/features/causeslist/presentation/widget/lawyers.dart';
import 'package:haelo_flutter/features/home_page/cubit/home_mytask_cubit.dart';
import 'package:haelo_flutter/widgets/date_format.dart';
import 'package:haelo_flutter/widgets/error_widget.dart';
import 'package:haelo_flutter/widgets/progress_indicator.dart';
import 'package:haelo_flutter/locators.dart' as di;
import '../../causeslist/presentation/screen/causelist_page.dart';

/// first class
class MyAlerts extends StatefulWidget {
  const MyAlerts({super.key});
  @override
  State<MyAlerts> createState() => _MyAlertsState();
}

class _MyAlertsState extends State<MyAlerts> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MyAlertCubit>(
            create: (BuildContext context) => MyAlertCubit(di.locator())),
      ],
      child: MyAlertsPage(),
    );
  }
}

class MyAlertsPage extends StatefulWidget {
  const MyAlertsPage({Key? key}) : super(key: key);

  @override
  State<MyAlertsPage> createState() => _MyAlertsPageState();
}

class _MyAlertsPageState extends State<MyAlertsPage> {
  bool? isCheck = false;
  bool isLoading = true;

  List<CauseWatchlist> causeWatchlist = [];
  List<Lawyerlist> lawyerList = [];
  List<Watchlist> watchList = [];

  List selectedLawyerList = [];
  var mainCauseListData;

  @override
  void initState() {
    BlocProvider.of<MyAlertCubit>(context).fetchMyAlert();
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
        title: Text(
          "My Alerts",
          style: mpHeadLine16(
              fontWeight: FontWeight.w500,
              textColor: AppColor.bold_text_color_dark_blue),
        ),
        actions: [
          selectedLawyerList.isNotEmpty
              ? InkWell(
                  onTap: () {
                    eventAddAlert(selectedLawyerList, context);
                  },
                  child: Icon(
                    Icons.add,
                    size: 24,
                  ),
                )
              : SizedBox(),
          const SizedBox(
            width: 15,
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
      body: Stack(
        children: [
          BlocConsumer<MyAlertCubit, MyAlertState>(
            builder: (context, state) {
              return const SizedBox();
            },
            listener: (context, state) {
              if (state is MyAlertLoading) {
                setState(() {
                  isLoading = true;
                });
              }
              if (state is MyAlertLoaded) {
                var alertModel = state.myAlertModel;
                if (alertModel.result == 1) {
                  setState(() {
                    causeWatchlist = alertModel.data!.causeWatchlist ?? [];
                    lawyerList = alertModel.data!.lawyerlist ?? [];
                    watchList = alertModel.data!.watchlist ?? [];
                    selectedLawyerList = [];
                    var mainCauseList = {
                      "dateFrom": getDDMMYYYY(DateTime.now().toString()),
                      "dateTo": "",
                    };
                    BlocProvider.of<MainCauseListDataCubit>(context)
                        .fetchMainCauseListData(mainCauseList);

                    isLoading = false;
                  });
                } else {
                  setState(() {
                    causeWatchlist = [];
                    lawyerList = [];
                    watchList = [];
                    isLoading = false;
                  });
                }
              }
            },
          ),
          BlocConsumer<DeleteAlertCubit, DeleteAlertState>(
            builder: (context, state) {
              return const SizedBox();
            },
            listener: (context, state) {
              if (state is DeleteAlertLoading) {
                setState(() {
                  isLoading = true;
                });
              }
              if (state is DeleteAlertLoaded) {
                var alertModel = state.model;
                if (alertModel.result == 1) {
                  toast(msg: alertModel.msg.toString());
                  /*  showDialog(
                      context: context,
                      builder: (ctx) => AppMsgPopup(
                            alertModel.msg.toString(),
                            isCloseIcon: false,
                            isError: false,
                          ));*/
                  BlocProvider.of<MyAlertCubit>(context).fetchMyAlert();
                  var bodyHomeMyTask = {
                    "dateToday": "",
                    "platformType": Platform.isAndroid
                        ? "0"
                        : "1" //o for android, 1 for iOS
                  };
                  print("before fetchhometask");
                  BlocProvider.of<HomeMyTaskCubit>(context)
                      .fetchHomeMyTask(bodyHomeMyTask);
                  setState(() {
                    isLoading = false;
                  });
                } else {
                  showDialog(
                      context: context,
                      builder: (ctx) => AppMsgPopup(
                            alertModel.msg.toString(),
                          ));
                  BlocProvider.of<MyAlertCubit>(context).fetchMyAlert();
                  setState(() {
                    isLoading = false;
                  });
                }
              } else {
                setState(() {
                  isLoading = false;
                });
              }
            },
          ),
          BlocConsumer<DeleteWatchlistCubit, DeleteWatchlistState>(
            builder: (context, state) {
              return const SizedBox();
            },
            listener: (context, state) {
              if (state is DeleteWatchlistLoading) {
                setState(() {
                  isLoading = true;
                });
              }
              if (state is DeleteWatchlistLoaded) {
                var alertModel = state.model;
                if (alertModel.result == 1) {
                  toast(msg: alertModel.msg.toString());
                  /*    showDialog(
                      context: context,
                      builder: (ctx) => AppMsgPopup(
                            alertModel.msg.toString(),
                            isCloseIcon: false,
                            isError: false,
                          ));*/
                  BlocProvider.of<MyAlertCubit>(context).fetchMyAlert();
                  var bodyHomeMyTask = {
                    "dateToday": "",
                    "platformType": Platform.isAndroid
                        ? "0"
                        : "1" //o for android, 1 for iOS
                  };
                  print("before fetchhometask");
                  BlocProvider.of<HomeMyTaskCubit>(context)
                      .fetchHomeMyTask(bodyHomeMyTask);
                  setState(() {
                    isLoading = false;
                  });
                } else {
                  showDialog(
                      context: context,
                      builder: (ctx) => AppMsgPopup(
                            alertModel.msg.toString(),
                          ));
                  BlocProvider.of<MyAlertCubit>(context).fetchMyAlert();
                  setState(() {
                    isLoading = false;
                  });
                }
              } else {
                setState(() {
                  isLoading = false;
                });
              }
            },
          ),
          BlocConsumer<AddEventCubit, AddEventState>(
            builder: (context, state) {
              return const SizedBox();
            },
            listener: (context, state) {
              if (state is AddEventLoading) {
                setState(() {
                  isLoading = true;
                });
              }
              if (state is AddEventLoaded) {
                var alertModel = state.model;
                if (alertModel.result == 1) {
                  toast(msg: alertModel.msg.toString());
                  /*   showDialog(
                      context: context,
                      builder: (ctx) => AppMsgPopup(
                            alertModel.msg.toString(),
                            isCloseIcon: false,
                            isError: false,
                          ));*/
                  BlocProvider.of<MyAlertCubit>(context).fetchMyAlert();
                  setState(() {
                    isLoading = false;
                  });
                } else {
                  showDialog(
                      context: context,
                      builder: (ctx) => AppMsgPopup(
                            alertModel.msg.toString(),
                          ));
                  BlocProvider.of<MyAlertCubit>(context).fetchMyAlert();
                  setState(() {
                    isLoading = false;
                  });
                }
              } else {
                setState(() {
                  isLoading = false;
                });
              }
            },
          ),
          causeWatchlist.isNotEmpty ||
                  lawyerList.isNotEmpty ||
                  watchList.isNotEmpty
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        itemCount: lawyerList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 1),
                            color: lawyerList[index].isHighlighted! >= 1
                                ? AppColor.primary.withAlpha(240)
                                : AppColor.grey_color,
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            var body = {
                                              "id": lawyerList[index]
                                                  .id
                                                  .toString(),
                                              "requestType": "default",
                                              "status": lawyerList[index]
                                                          .is_default ==
                                                      true
                                                  ? "0"
                                                  : "1",
                                            };
                                            BlocProvider.of<AddEventCubit>(
                                                    context)
                                                .addEventToCalendar(body);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Icon(
                                              lawyerList[index].is_default ==
                                                      true
                                                  ? Icons.bookmark
                                                  : Icons.bookmark_border,
                                              color: AppColor.hint_color_grey,
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            lawyerList[index].lawyerName !=
                                                        null &&
                                                    lawyerList[index]
                                                        .lawyerName!
                                                        .toString()
                                                        .isNotEmpty
                                                ? lawyerList[index].lawyerName!
                                                : lawyerList[index]
                                                        .selectedCaseNo ??
                                                    "",
                                            style: mpHeadLine18(
                                                fontWeight: FontWeight.w500,
                                                textColor: lawyerList[index]
                                                            .isHighlighted! >=
                                                        1
                                                    ? AppColor.white
                                                    : AppColor.black),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      lawyerList[index].lawyerName != null &&
                                              lawyerList[index]
                                                  .lawyerName!
                                                  .toString()
                                                  .isNotEmpty
                                          ? SizedBox(
                                              height: 24,
                                              width: 24,
                                              child: Checkbox(
                                                checkColor: AppColor.white,
                                                // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                /*   fillColor: MaterialStateColor
                                                    .resolveWith((states) =>
                                                        AppColor.primary),*/
                                                value: lawyerList[index]
                                                    .isSelected,
                                                onChanged: (value) {
                                                  print("value $value");

                                                  setState(() {
                                                    if (value == true) {
                                                      print(
                                                          "before $selectedLawyerList");
                                                      if (selectedLawyerList
                                                              .length <
                                                          3) {
                                                        // if(selectedLawyerList.isNotEmpty){
                                                        // for(int i=0; i<lawyerList.length; i++){
                                                        //   if(lawyerList[i].lawyerName != null &&
                                                        //       lawyerList[i]
                                                        //           .lawyerName!
                                                        //           .toString()
                                                        //           .isNotEmpty){
                                                        //     selectedLawyerList.add(lawyerList[i].id.toString());
                                                        //   }
                                                        // }}
                                                        lawyerList[index]
                                                            .isSelected = true;
                                                        selectedLawyerList.add(
                                                            lawyerList[index]
                                                                .id
                                                                .toString());
                                                      } else {
                                                        toast(
                                                            msg:
                                                                "You can not select more than 3 lawyers!");
                                                      }
                                                      print(
                                                          "after $selectedLawyerList");
                                                    } else {
                                                      print(
                                                          "else before $selectedLawyerList");
                                                      lawyerList[index]
                                                          .isSelected = false;
                                                      selectedLawyerList.remove(
                                                          lawyerList[index]
                                                              .id
                                                              .toString());
                                                      print(
                                                          "else after $selectedLawyerList");
                                                    }
                                                  });
                                                  if (selectedLawyerList
                                                      .isEmpty) {
                                                    for (int i = 0;
                                                        i < lawyerList.length;
                                                        i++) {
                                                      if (lawyerList[i]
                                                                  .lawyerName !=
                                                              null &&
                                                          lawyerList[i]
                                                              .lawyerName!
                                                              .toString()
                                                              .isNotEmpty) {
                                                        print(
                                                            "on index $i and value ${lawyerList[i].isSelected}");
                                                        if (lawyerList[i]
                                                                .isSelected ==
                                                            true) {
                                                          selectedLawyerList
                                                              .add(lawyerList[i]
                                                                  .id
                                                                  .toString());
                                                        }
                                                      }
                                                    }
                                                  }
                                                },
                                              ),
                                            )
                                          : SizedBox(
                                              height: 24,
                                              width: 24,
                                            ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          deleteAlert(
                                              lawyerList[index].id.toString(),
                                              context,
                                              isNotification: true);
                                        },
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.red[800],
                                          size: 20,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          //print("datefrom ${lawyerList[index].toDate!}");

                                          var fromDate = DateTime.now();

                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ViewCauseListScreenNew(
                                                        mainCauseListdata: {
                                                          "dateFrom": getDDMMYYYY(
                                                              fromDate
                                                                  .toString()),
                                                          "courtNo": lawyerList[
                                                                      index]
                                                                  .courtNo ??
                                                              "",
                                                          "causeListType":
                                                              lawyerList[index]
                                                                      .selectedCauseType ??
                                                                  "",
                                                          "judgeName": lawyerList[
                                                                      index]
                                                                  .selectedJudgeName ??
                                                              "",
                                                          "lawyerName": lawyerList[
                                                                      index]
                                                                  .lawyerName ??
                                                              "",
                                                          "caseNo": lawyerList[
                                                                      index]
                                                                  .selectedCaseNo ??
                                                              "",
                                                        },
                                                        isFromHomepage: false,
                                                        isDownloadOption: true,
                                                      )));
                                        },
                                        child: Icon(
                                          Icons.info,
                                          size: 18,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      ListView.builder(
                        itemCount: watchList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 1),
                            color: watchList[index].isHighlighted! >= 1
                                ? AppColor.primary.withAlpha(240)
                                : AppColor.grey_color,
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      watchList[index].watchlistName != null &&
                                              watchList[index]
                                                  .watchlistName!
                                                  .toString()
                                                  .isNotEmpty
                                          ? watchList[index].watchlistName!
                                          : "",
                                      style: mpHeadLine18(
                                        fontWeight: FontWeight.w500,
                                        textColor:
                                            watchList[index].isHighlighted! >= 1
                                                ? AppColor.white
                                                : AppColor.black,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          // go to case list with selection
                                          Map<String, dynamic> watchlistData = {
                                            "case_list":
                                                watchList[index].caselist ?? [],
                                            "watchlist_id":
                                                watchList[index].watchlistId,
                                            "watchlist_name":
                                                watchList[index].watchlistName,
                                          };
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BottomNavBar(
                                                        bottom: 3,
                                                        selectedWatchlistData:
                                                            watchlistData)),
                                            (route) => false,
                                          );
                                        },
                                        child: Icon(
                                          Icons.edit,
                                          size: 20,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          deleteAlert(
                                              watchList[index]
                                                  .watchlistId
                                                  .toString(),
                                              context,
                                              isWatchList: true);
                                        },
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.red[800],
                                          size: 20,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          var fromDate = DateTime.now();

                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ViewCauseListScreenNew(
                                                        mainCauseListdata: {
                                                          "dateFrom": getDDMMYYYY(
                                                              fromDate
                                                                  .toString()),
                                                        },
                                                        isFromHomepage: false,
                                                        isDownloadOption: true,
                                                      )));
                                        },
                                        child: Icon(
                                          Icons.info,
                                          size: 18,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      ListView.builder(
                        itemCount: causeWatchlist.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 1),
                            color: AppColor.grey_color,
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      causeWatchlist[index].watchlistName !=
                                                  null &&
                                              causeWatchlist[index]
                                                  .watchlistName
                                                  .toString()
                                                  .isNotEmpty
                                          ? causeWatchlist[index].watchlistName!
                                          : "",
                                      style: mpHeadLine18(
                                          fontWeight: FontWeight.w500),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          // go to lawyer list with selection
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          if (causeWatchlist[index]
                                                      .lawyerlist !=
                                                  null &&
                                              causeWatchlist[index]
                                                  .lawyerlist!
                                                  .isNotEmpty) {
                                            if (mainCauseListData != null &&
                                                mainCauseListData
                                                    .lawyerName.isNotEmpty) {
                                              // Map<String, dynamic> watchlistData={
                                              //   "case_list":watchList[index].caselist??[],
                                              //   "watchlist_id":watchList[index].watchlistId,
                                              //   "watchlist_name":watchList[index].watchlistName,
                                              // };
                                              showDialog(
                                                  context: context,
                                                  builder: (ctx) => Lawyers(
                                                        mainCauseListData,
                                                        selectedLawyerCallback,
                                                        () {},
                                                        causeWatchlist[index]
                                                            .lawyerlist,
                                                        watchListId:
                                                            causeWatchlist[
                                                                    index]
                                                                .watchlistId,
                                                      ));
                                            }
                                          } else {
                                            toast(
                                                msg:
                                                    "No lawyer found for this watchlist");
                                          }
                                          // Navigator.pushAndRemoveUntil(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //       builder: (context) => BottomBar(bottom: 2,
                                          //         selectedWatch v );
                                        },
                                        child: Icon(
                                          Icons.edit,
                                          size: 20,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          deleteAlert(
                                              causeWatchlist[index]
                                                  .watchlistId
                                                  .toString(),
                                              context,
                                              isWatchList: true);
                                        },
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.red[800],
                                          size: 20,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          var fromDate = DateTime.now();

                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ViewCauseListScreenNew(
                                                        mainCauseListdata: {
                                                          "dateFrom": getDDMMYYYY(
                                                              fromDate
                                                                  .toString()),
                                                        },
                                                        isFromHomepage: false,
                                                        isDownloadOption: true,
                                                      )));
                                        },
                                        child: Icon(
                                          Icons.info,
                                          size: 18,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      BlocConsumer<MainCauseListDataCubit,
                          MainCauseListDataState>(
                        builder: (context, state) {
                          return const SizedBox();
                        },
                        listener: (context, state) {
                          if (state is MainCauseListDataLoading) {
                            setState(() {
                              isLoading = true;
                            });
                          }
                          if (state is MainCauseListDataLoaded) {
                            var causeListDataModel =
                                state.mainCauseListDataModel;
                            if (causeListDataModel.result == 1) {
                              if (causeListDataModel.data != null) {
                                mainCauseListData = causeListDataModel.data;

                                // if(widget.selectedLawyer!=null && widget.selectedLawyer.isNotEmpty){
                                // FocusScope.of(context).requestFocus(FocusNode());
                                // if (mainCauseListData != null &&
                                //     mainCauseListData.lawyerName.isNotEmpty) {
                                //   showDialog(
                                //       context: context,
                                //       builder: (ctx) => Lawyers(mainCauseListData,
                                //           setLawyerDataCallback,setSearchedLawyer,
                                //           widget.selectedLawyer));
                                // }
                                // }

                                setState(() {});
                              }
                            }
                            // else {
                            //   toast(msg: causeListDataModel.msg.toString());
                            // }
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                      ),
                      BlocConsumer<EditWatchlistCubit, EditWatchlistState>(
                          builder: (context, state) {
                        if (state is EditWatchlistLoading) {
                          return AppProgressIndicator();
                        }
                        return const SizedBox();
                      }, listener: (context, state) {
                        if (state is EditWatchlistLoaded) {
                          var model = state.model;
                          if (model.result == 1) {
                            BlocProvider.of<MyAlertCubit>(context)
                                .fetchMyAlert();
                            toast(msg: model.msg.toString());
                            /*  showDialog(
                                context: context,
                                builder: (ctx) => AppMsgPopup(
                                      model.msg.toString(),
                                      isError: false,
                                    ));*/
                          } else {
                            showDialog(
                                context: context,
                                builder: (ctx) =>
                                    AppMsgPopup(model.msg.toString()));
                          }
                        }
                      }),
                    ],
                  ),
                )
              : isLoading
                  ? SizedBox()
                  : NoDataAvailable("Your My alerts will be shown here."),
          Visibility(
            visible: isLoading,
            child: const Center(child: AppProgressIndicator()),
          ),
        ],
      ),
    );
  }

  void deleteAlert(String id, BuildContext context,
      {bool isWatchList = false, bool isNotification = false}) {
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
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 18),
                    child: Text(
                      "Are you sure, you want to delete this ${isNotification ? "notification" : "watchlist"}?",
                      textAlign: TextAlign.center,
                      style: mpHeadLine14(fontWeight: FontWeight.w600),
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
                            Navigator.pop(context);
                            if (isWatchList) {
                              var body = {
                                "watchlistId": id,
                              };
                              BlocProvider.of<DeleteWatchlistCubit>(context)
                                  .deleteWatchlist(body);
                            } else {
                              var body = {
                                "id": id,
                              };
                              BlocProvider.of<DeleteAlertCubit>(context)
                                  .fetchMyAlert(body);
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: mediaQH(context) * 0.05,
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(5)),
                                border: Border.all(color: AppColor.primary)),
                            child: Text(
                              "Yes",
                              style: mpHeadLine16(textColor: AppColor.primary),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: mediaQH(context) * 0.05,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(5)),
                              color: AppColor.primary,
                            ),
                            child: Text(
                              "No",
                              style: mpHeadLine16(textColor: AppColor.white),
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
  }

  void eventAddAlert(List id, BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            // insetPadding: EdgeInsets.symmetric(vertical: 305),
            contentPadding: EdgeInsets.zero,
            content: SizedBox(
              // height: mediaQH(context) * 0.16,
              width: mediaQW(context) * 0.8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 18),
                    child: Text(
                      "Are you sure to update lawyers for Calendar events and auto File downloading at 12 AM?",
                      textAlign: TextAlign.center,
                      style: mpHeadLine14(fontWeight: FontWeight.w600),
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
                            Navigator.pop(context);
                            for (int i = 0; i < lawyerList.length; i++) {
                              if (lawyerList[i].lawyerName != null &&
                                  lawyerList[i]
                                      .lawyerName!
                                      .toString()
                                      .isNotEmpty) {
                                print(
                                    "on index $i and value ${lawyerList[i].isSelected}");
                                if (lawyerList[i].isSelected == true &&
                                    !selectedLawyerList.contains(
                                        lawyerList[i].id.toString())) {
                                  selectedLawyerList
                                      .add(lawyerList[i].id.toString());
                                }
                              }
                            }

                            print("id list $id");
                            String ids = "";
                            for (int i = 0;
                                i < selectedLawyerList.length;
                                i++) {
                              ids = ids + selectedLawyerList[i];
                              if (i != selectedLawyerList.length - 1) {
                                ids = "$ids,";
                              }
                            }

                            print("ids $ids");
                            var body = {
                              "idList": ids.toString(),
                            };
                            BlocProvider.of<AddEventCubit>(context)
                                .addEventToCalendar(body);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: mediaQH(context) * 0.05,
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(5)),
                                border: Border.all(color: AppColor.primary)),
                            child: Text(
                              "Yes",
                              style: mpHeadLine16(textColor: AppColor.primary),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: mediaQH(context) * 0.05,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(5)),
                              color: AppColor.primary,
                            ),
                            child: Text(
                              "No",
                              style: mpHeadLine16(textColor: AppColor.white),
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
  }

  void selectedLawyerCallback(String lawyers, String watchListId) {
    var body = {"watchlistId": watchListId.toString(), "caseList": lawyers};
    BlocProvider.of<EditWatchlistCubit>(context).editWatchlist(body);
  }
}
