import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:custom_timer/custom_timer.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/constants.dart';
import 'package:haelo_flutter/core/utils/functions.dart';
import 'package:haelo_flutter/core/utils/hightlight_text.dart';
import 'package:haelo_flutter/core/utils/save_file.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/alert/presentation/myalerts.dart';
import 'package:haelo_flutter/features/causeslist/presentation/screen/causelist_page.dart';
import 'package:haelo_flutter/features/home_page/cubit/court_summary_cubit.dart';
import 'package:haelo_flutter/features/home_page/cubit/court_summary_new_cubit.dart';
import 'package:haelo_flutter/features/home_page/cubit/court_summary_state.dart';
import 'package:haelo_flutter/features/home_page/cubit/display_board_cubit.dart';
import 'package:haelo_flutter/features/home_page/cubit/display_board_state.dart';
import 'package:haelo_flutter/features/home_page/cubit/home_mytask_cubit.dart';
import 'package:haelo_flutter/features/home_page/cubit/home_mytask_state.dart';
import 'package:haelo_flutter/features/home_page/cubit/home_tasklist_cubit.dart';
import 'package:haelo_flutter/features/home_page/cubit/update_display_board/update_display_board_cubit.dart';
import 'package:haelo_flutter/features/home_page/cubit/update_display_board/update_display_board_state.dart';
import 'package:haelo_flutter/features/home_page/data/model/display_board_model.dart';
import 'package:haelo_flutter/features/home_page/presentation/screens/quicksearch_homepage.dart';
import 'package:haelo_flutter/features/home_page/presentation/widgets/case_info.dart';
import 'package:haelo_flutter/features/home_page/presentation/widgets/court_summary.dart';
import 'package:haelo_flutter/features/home_page/presentation/widgets/display_board_note.dart';
import 'package:haelo_flutter/features/in_app_purchase/cubit/pay_request_state.dart';
import 'package:haelo_flutter/features/userboard/presentation/widgets/session_expired.dart';
import 'package:haelo_flutter/locators.dart' as di;
import 'package:haelo_flutter/widgets/date_format.dart';
import 'package:haelo_flutter/widgets/error_widget.dart';
import 'package:haelo_flutter/widgets/go_prime.dart';
import 'package:haelo_flutter/widgets/progress_indicator.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../../main.dart';
import '../../../../services/firebase_service.dart';
import '../../../causeslist/presentation/screen/causelist.dart';
import '../../../in_app_purchase/cubit/pay_request_cubit.dart';
import '../../../in_app_purchase/presentation/screen/inapp_purchase.dart';
import '../../../order_comment_history/presentation/screen/orderCommentHistory.dart';
import '../../../userboard/presentation/widgets/trial_session.dart';
import '../../cubit/court_summary_new_state.dart';
import '../../cubit/home_popup_cubit.dart';
import '../../cubit/home_popup_state.dart';
import '../widgets/court_note.dart';
import '../widgets/court_summary_new.dart';
import '../widgets/dot_animation.dart';
import '../widgets/item_stage_info.dart';
import '../widgets/session_end_popup.dart';
import 'drawers.dart';

var currentClass;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _Home_PageState();
}

class _Home_PageState extends State<HomePage>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  Timer? mytimer;
  late CustomTimerController _timerController = CustomTimerController(
    vsync: this,
    begin: Duration(seconds: 1),
    end: Duration(hours: 24),
    initialState: CustomTimerState.reset,
    interval: CustomTimerInterval.values[1],
  );
  int second = 0;
  int refreshedInterval = 30;
  late SharedPreferences pref;
  bool trialWarningShown = false;
  bool isSessionEndPopUp = false;
  var presentDate;
  bool isFromBackground = false;
  bool userIsUnauthorized = false;
  final Set<String> selectedNames = Set<String>();
  final Set<String> selectedCaseNumber = Set<String>();
  Color? backGroundColor;
  List chipList = [
    "Chip Widget fo Geekologix",
    "Widget for Geekologix",
    "Geekologix"
  ];

  List<String>? listDate = [];
  List<QuickSearchChipList>? quickSearchList = [];

  int showDate = 0;
  bool isVisible = true;
  bool isLongPress = false;
  var displayData;
  List displayDataTickerList = [];
  List filteredDisplayDataTickerList = [];
  var userListenData;
  var summaryData;
  var summaryDataNew;
  var displaySummaryData;
  var taskListData;
  bool isCauseListOpen = true;
  bool isInfoDetailOpen = false;
  bool isFirstTime = true;
  String selectedDate = "";
  String displayTime = "";
  String caseNo = "";
  String watchListName = "";
  String itemName = "";
  String display_board_note =
      "This display board is synced with the high court website's display board (refreshed every 30 seconds) and may vary with the courtroom and HC app's display board";
  bool isLoading = true;
  ScrollController controller = ScrollController();

  // DateTime currentTime = DateTime.now();

  static const int numItems = 1;

  // List<bool> selected = List<bool>.generate(numItems, (int index) => false);
  var userData;
  bool isCourtFilter = false;

  ///iap
  bool _isAvailable = false;
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  late StreamSubscription _subscription;
  int _coins = 0;

  var validationID = "Valid ID";

  // String oneYearID = 'com.v2r.NT.oneyear';
  // String threeMonthsID = 'com.v2r.NT.threemonth';
  // String oneMonthsID = 'com.v2r.NT.onemonth';

  List<String> _notFoundIds = <String>[];
  List<String> _consumables = <String>[];
  bool _purchasePending = false;
  bool _loading = true;
  String? _queryProductError;
  final List<String> _kProductIds = [
    // "trail_test",
    Constants.oneMonthGold,
    Constants.oneMonthSilver,
    Constants.oneMonthPlatinum,
    Constants.sixMonthGold,
    Constants.sixMonthSilver,
    Constants.sixMonthPlatinum,
    Constants.twelveMonthGoldIOS,
    Constants.twelveMonthSilverIOS,
    Constants.twelveMonthPlatinum,
  ];

  ///

  @override
  void initState() {
    displayData = null;
    isFromBackground = false;
    pref = di.locator();
    print("login type ${pref.getString(Constants.USER_TYPE)}");
    print("isPrime ==>  ${isPrime(pref)}");
    _getCourtValue();
    // _getSessionEndValue();

    WidgetsBinding.instance.addObserver(this);
    var bodyHomeMyTask = {
      "dateToday": "",
      "platformType": Platform.isAndroid ? "0" : "1" //o for android, 1 for iOS
    };
    BlocProvider.of<HomeMyTaskCubit>(context).fetchHomeMyTask(bodyHomeMyTask);
    var body = {
      "dateToday": "",
    };
    BlocProvider.of<DisplayBoardCubit>(context).fetchDisplayBoard(body);
    super.initState();
    var bodyTaskList = {
      "limit": "5",
      "pageNo": "1",
    };
    BlocProvider.of<HomeTaskListCubit>(context)
        .fetchHomeTaskList(body: bodyTaskList);

    var bodyStatus = {
      "status": "",
    };
    BlocProvider.of<HomePopupCubit>(context).fetchHomePopup(bodyStatus);
    _timerController.start();

    _timerController.addListener(() {
      //print(_timerController.interval.index);
      second = second + 1;
      // print("second $second");
      if (second >= refreshedInterval) {
        //  print("call api here");
        updateDisplayBoard();
        second = 0;
      }
      // print(_timerController.interval.name);
    });

    FBroadcast.instance().register("unauthorized", (value, callback) {
      userIsUnauthorized = true;
      showDialog(
          context: context,
          builder: (ctx) => SessionExpired(
                pref: pref,
                onLoginPressed: updateIsUnauthorized,
              ),
          barrierDismissible: false,
          useRootNavigator: false);
    });

    if (pref.getBool(Constants.is_court_filter) != null &&
        pref.getBool(Constants.is_court_filter) == true) {
      isCourtFilter = true;
    } else {
      isCourtFilter = false;
    }

    // inapp_last_purchases();
    if (Platform.isIOS) {
      final InAppPurchase _iap = InAppPurchase.instance;
      sgtl.iAP = _iap;
      final Stream<List<PurchaseDetails>> purchaseUpdated =
          sgtl.iAP!.purchaseStream;
      _subscription =
          purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      }, onDone: () {
        // _subscription.cancel();
      }, onError: (Object error) {
        // handle error here.
      });
      initStoreInfo();
      checkIAP();
    }
  }

  inapp_last_purchases() {
    ///iap
    if (Platform.isIOS) {
      final InAppPurchase _iap = InAppPurchase.instance;
      sgtl.iAP = _iap;
      final Stream<List<PurchaseDetails>> purchaseUpdated =
          sgtl.iAP!.purchaseStream;
      _subscription =
          purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      }, onDone: () {
        // _subscription.cancel();
      }, onError: (Object error) {
        // handle error here.
      });
      initStoreInfo();
      checkIAP();
    }

    ///iAP end
  }

  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // print(">>>>>>>>>>>>>>>>>>. didChangeAppLifecycleState ");
    //print(">>>>>>>>>>>>>>>>>>. $state and  ${AppLifecycleState.resumed}");
    if (state == AppLifecycleState.resumed) {
      print("this runtime ${runtimeType}");
      if (runtimeType == _Home_PageState) {
        isFromBackground = true;
        // print("isFromBackground $isFromBackground");
        // print("this msg is printing for homepage only");
        var bodyHomeMyTask = {
          "dateToday": "",
          "platformType": Platform.isAndroid ? "0" : "1"
          //o for android, 1 for iOS
        };
        BlocProvider.of<HomeMyTaskCubit>(context)
            .fetchHomeMyTask(bodyHomeMyTask);
        // updateDisplayBoard();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColor.home_background,
          drawer: AppDrawer(),
          body: Container(
            height: mediaQH(context),
            padding: EdgeInsets.only(bottom: 10),
            child: RefreshIndicator(
              onRefresh: () async {
                updateDisplayBoard();
              },
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Container(
                  height: mediaQH(context),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: 12),
                        color: Colors.white,
                        child: SingleChildScrollView(
                          physics: NeverScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, right: 20, top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      // onTap: () {
                                      //   Navigator.push(context, MaterialPageRoute(builder: (context) => TestingGroupedList()));
                                      // },
                                      child: SizedBox(
                                        width: mediaQW(context) * 0.8,
                                        child: InkWell(
                                          child: Text(
                                            userListenData != null
                                                ? "HAeLO " +
                                                    userListenData!.userName
                                                        .toString()
                                                : "",
                                            style: mpHeadLine20(
                                                fontWeight: FontWeight.bold,
                                                textColor: AppColor
                                                    .bold_text_color_dark_blue),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                  left: 15,
                                  right: 18,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      isCauseListOpen = !isCauseListOpen;
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Causelist Update',
                                          style: mpHeadLine18(
                                              textColor: Colors.red.shade800,
                                              fontWeight: FontWeight.w600)),
                                      Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 10,
                                          left: 15,
                                          right: 18,
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            BlocProvider.of<
                                                        CourtSummaryNewCubit>(
                                                    context)
                                                .fetchCourtNewSummary();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: AppColor.primary,
                                                borderRadius:
                                                    BorderRadius.circular(3)),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 3),
                                            child: Text(
                                              "Quick Update",
                                              style: appTextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w500,
                                                  textColor: AppColor.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      isCauseListOpen
                                          ? Icon(
                                              Icons
                                                  .keyboard_arrow_down_outlined,
                                              color: Colors.red.shade800,
                                            )
                                          : Icon(
                                              Icons.keyboard_arrow_up_outlined,
                                              color: Colors.red.shade800,
                                            )
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: isCauseListOpen,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5, left: 15),
                                      child: Row(
                                        children: [
                                          MyBlinkingButton(),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          SizedBox(
                                            width: mediaQW(context) * 0.8,
                                            child: Text(
                                              userListenData != null
                                                  ? userListenData!.heading
                                                      .toString()
                                                  : "",
                                              style: mpHeadLine12(
                                                textColor: Colors.red.shade800,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          /* userListenData != null &&
                                                  userListenData!.daily_file !=
                                                      null &&
                                                  userListenData!.daily_file!
                                                      .toString()
                                                      .isNotEmpty
                                              ? InkWell(
                                                  onTap: () async {
                                                    toast(
                                                        msg:
                                                            "Downloading started");
                                                    DateTime now =
                                                        DateTime.now();
                                                    var fileName =
                                                        "HAeLO_Daily_${now.day}_${now.month}.${userListenData!.daily_file!.toString().split(".").last}";
                                                    await downloadFiles(
                                                        userListenData!
                                                            .daily_file!
                                                            .toString(),
                                                        fileName);
                                                  },
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Icon(
                                                      Icons.file_download,
                                                      size: 18,
                                                      color: AppColor.primary,
                                                    ),
                                                  ),
                                                )
                                              : SizedBox()*/
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5, left: 15),
                                      child: Row(
                                        children: [
                                          MyBlinkingButton(),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          SizedBox(
                                            width: mediaQW(context) * 0.8,
                                            child: Text(
                                              userListenData != null
                                                  ? userListenData!.heading2
                                                      .toString()
                                                  : "",
                                              style: mpHeadLine12(
                                                textColor: Colors.red.shade800,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          /*       userListenData != null &&
                                                  userListenData!.supp_file !=
                                                      null &&
                                                  userListenData!.supp_file!
                                                      .toString()
                                                      .isNotEmpty
                                              ? InkWell(
                                                  onTap: () async {
                                                    toast(
                                                        msg:
                                                            "Downloading started");
                                                    DateTime now =
                                                        DateTime.now();
                                                    var fileName =
                                                        "HAeLO_Supply_${now.day}_${now.month}.${userListenData!.supp_file!.toString().split(".").last}";
                                                    await downloadFiles(
                                                        userListenData!
                                                            .supp_file!
                                                            .toString(),
                                                        fileName);
                                                  },
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Icon(
                                                      Icons.file_download,
                                                      size: 18,
                                                      color: AppColor.primary,
                                                    ),
                                                  ),
                                                )
                                              : SizedBox()*/
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              /* Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                  left: 15,
                                  right: 18,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    var causeListDates = summaryDataNew
                                        .map((data) => data.causeListDate ?? '')
                                        .toSet()
                                        .toList();

                                    print(causeListDates);

                                    showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (BuildContext context) {
                                          return CourtSummaryNew(summaryDataNew,
                                              causeListDates ?? "");
                                        });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: AppColor.primary,
                                        borderRadius: BorderRadius.circular(3)),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    child: Text(
                                      "Quick Update",
                                      style: appTextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          textColor: AppColor.white),
                                    ),
                                  ),
                                ),
                              ),*/
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            updateDisplayBoard();
                          },
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // BlocConsumer<DisplayBoardSummaryCubit,
                                //     DisplayBoardSummaryState>(builder: (context, state) {
                                //   return const SizedBox();
                                // }, listener: (context, state) {
                                //   if (state is DisplayBoardSummaryLoading) {
                                //     EasyLoading.show();
                                //   }
                                //   if (state is DisplayBoardSummaryLoaded) {
                                //     EasyLoading.dismiss();
                                //     final displaySummaryModel =
                                //         state.displayBoardSummaryModel;
                                //     if (displaySummaryModel.result == 1) {
                                //       if (displaySummaryModel.data != null) {
                                //         displaySummaryData = displaySummaryModel.data;
                                //         setState(() {});
                                //       }
                                //     }
                                //   }
                                // }),
                                BlocConsumer<HomePopupCubit, HomePopupState>(
                                    builder: (context, state) {
                                  return const SizedBox();
                                }, listener: (context, state) {
                                  if (state is HomePopupLoaded) {
                                    final homeDataMessage = state.model;
                                    if (homeDataMessage.result == 1) {
                                      if (homeDataMessage.data != null) {
                                        showDialog(
                                            context: context,
                                            builder: (ctx) => SessionEndPopup(
                                                  onOkayPressed:
                                                      updateSessionPopupShown,
                                                  message: homeDataMessage
                                                      .data!.messageBody
                                                      .toString(),
                                                  title: homeDataMessage
                                                      .data!.messageTitle
                                                      .toString(),
                                                ),
                                            barrierDismissible: false,
                                            useRootNavigator: false);
                                      }
                                    }
                                  }
                                }),
                                BlocConsumer<CourtSummaryNewCubit,
                                    CourtSummaryNewState>(
                                  builder: (context, state) {
                                    return const SizedBox();
                                  },
                                  listener: (context, state) {
                                    if (state is CourtSummaryNewLoaded) {
                                      final summaryModelNew =
                                          state.courtSummaryNewModel;
                                      if (summaryModelNew.result == 1) {
                                        if (summaryModelNew.data != null) {
                                          summaryDataNew = summaryModelNew.data;
                                          setState(() {
                                            isLoading = false;
                                          });
                                          var causeListDates = summaryDataNew
                                              .map((data) =>
                                                  data.causeListDate ?? '')
                                              .toSet()
                                              .toList();

                                          print(causeListDates);

                                          showDialog(
                                              context: context,
                                              barrierDismissible: true,
                                              builder: (BuildContext context) {
                                                return CourtSummaryNew(
                                                    summaryDataNew,
                                                    causeListDates ?? "");
                                              });
                                        }
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
                                  },
                                ),
                                /* BlocConsumer<CourtSummaryNewCubit,
                                        CourtSummaryNewState>(
                                    builder: (context, state) {
                                  return const SizedBox();
                                }, listener: (context, state) {
                                  if (state is CourtSummaryNewLoaded) {
                                    final summaryModelNew =
                                        state.courtSummaryNewModel;
                                    if (summaryModelNew.result == 1) {
                                      if (summaryModelNew.data != null) {
                                        summaryDataNew = summaryModelNew.data;
                                        setState(() {
                                          isLoading = false;
                                        });
                                        var causeListDates = summaryDataNew
                                            .map((data) =>
                                                data.causeListDate ?? '')
                                            .toSet()
                                            .toList();

                                        print(causeListDates);

                                        showDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            builder: (BuildContext context) {
                                              return CourtSummaryNew(
                                                  summaryDataNew,
                                                  causeListDates ?? "");
                                            });
                                      }
                                    } else {
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                  }
                                }),*/
                                BlocConsumer<CourtSummaryCubit,
                                        CourtSummaryState>(
                                    builder: (context, state) {
                                  return const SizedBox();
                                }, listener: (context, state) {
                                  if (state is CourtSummaryLoaded) {
                                    final summaryModel =
                                        state.courtSummaryModel;
                                    if (summaryModel.result == 1) {
                                      if (summaryModel.data != null) {
                                        summaryData = summaryModel.data;
                                      }
                                    }
                                  }
                                }),
                                BlocConsumer<HomeMyTaskCubit, HomeMyTaskState>(
                                    builder: (context, state) {
                                  return SizedBox();
                                  //
                                }, listener: (context, state) {
                                  if (state is HomeMyTaskLoaded) {
                                    final model = state.homeMyTaskModel;
                                    if (model.result == 1 &&
                                        model.data != null) {
                                      userData = model.data;
                                      //quick search data
                                      var causeWatchList =
                                          userData!.causeWatchlist;
                                      var lawyerList = userData.lawyerlist;
                                      var watchList = userData.watchlist;
                                      quickSearchList!.clear();

                                      bool? isTrail =
                                          model.data?.planDetails?.isTrail;
                                      String? expiryDate =
                                          model.data?.expiryDate;
                                      int? isPrime =
                                          model.data?.planDetails?.isPrime;
                                      String? planName =
                                          model.data?.planDetails?.planName;

                                      if ((isPrime == 0)) {
                                        setState(() {
                                          isCourtFilter = false;
                                        });
                                        _saveCourtValue(isCourtFilter);
                                      }
                                      /* if (!isSessionEndPopUp) {
                                        setState(() {
                                          isSessionEndPopUp = true;
                                        });
                                        _saveSessionEndValue(isSessionEndPopUp);
                                        showDialog(
                                            context: context,
                                            builder: (ctx) => SessionEndPopup(
                                                  onOkayPressed:
                                                      updateSessionPopupShown,
                                                  message: '',
                                                ),
                                            barrierDismissible: false,
                                            useRootNavigator: false);
                                      }*/

                                      if (isPrime == 0) {
                                        FirebaseService()
                                            .subscribeToTopic("Free");
                                      } else {
                                        FirebaseService()
                                            .unsubscribeToTopic("Free");
                                        if (planName == "gold") {
                                          FirebaseService()
                                              .unsubscribeToTopic("silver");
                                          FirebaseService()
                                              .unsubscribeToTopic("platinum");
                                          FirebaseService()
                                              .subscribeToTopic("gold");
                                        } else if (planName == "platinum") {
                                          FirebaseService()
                                              .unsubscribeToTopic("silver");
                                          FirebaseService()
                                              .unsubscribeToTopic("gold");
                                          FirebaseService()
                                              .subscribeToTopic("platinum");
                                        } else {
                                          FirebaseService()
                                              .unsubscribeToTopic("gold");
                                          FirebaseService()
                                              .unsubscribeToTopic("platinum");
                                          FirebaseService()
                                              .subscribeToTopic("silver");
                                        }
                                      }

                                      print("isTrail $isTrail");
                                      print("isPrime $isPrime");
                                      print("expiryDate $expiryDate");
                                      print(
                                          "expiryDate ${getExpiryDate(expiryDate!)}");

                                      if (isTrail! &&
                                          !trialWarningShown &&
                                          !userIsUnauthorized) {
                                        trialWarningShown = true;
                                        showDialog(
                                            context: context,
                                            builder: (ctx) => TrialWarning(
                                                  onOkayPressed:
                                                      updateTrialWarningShown,
                                                  expiryDate:
                                                      getExpiryDate(expiryDate),
                                                ),
                                            barrierDismissible: false,
                                            useRootNavigator: false);
                                      }

                                      for (int i = 0;
                                          i < causeWatchList!.length;
                                          i++) {
                                        // print("for causelist");
                                        if (causeWatchList[i].watchlistName !=
                                                null &&
                                            causeWatchList[i]
                                                .watchlistName!
                                                .isNotEmpty) {
                                          quickSearchList!
                                              .add(QuickSearchChipList(
                                            lawyerList:
                                                causeWatchList[i].lawyerlist,
                                            lawyer:
                                                causeWatchList[i].lawyerlist,
                                            watchListName:
                                                causeWatchList[i].watchlistName,
                                          ));
                                        }
                                      }

                                      for (int j = 0;
                                          j < lawyerList!.length;
                                          j++) {
                                        if (lawyerList[j].lawyer != null) {
                                          // print("inside lawyer");
                                          quickSearchList!.add(
                                              QuickSearchChipList(
                                                  caseNo: lawyerList[j].caseNo,
                                                  isHighlighted: lawyerList[j]
                                                      .isHighlighted,
                                                  lawyer:
                                                      lawyerList[j].lawyer));
                                        }
                                      }

                                      for (int k = 0;
                                          k < watchList!.length;
                                          k++) {
                                        if (watchList[k].watchlistName !=
                                                null &&
                                            watchList[k]
                                                .watchlistName!
                                                .isNotEmpty) {
                                          //print("for watchlist");
                                          quickSearchList!.add(
                                            QuickSearchChipList(
                                                caseList: watchList[k].caselist,
                                                isHighlighted:
                                                    watchList[k].isHighlighted,
                                                watchListName:
                                                    watchList[k].watchlistName,
                                                caseNo: watchList[k]
                                                    .caselist!
                                                    .join(",")),
                                          );
                                        }
                                      }

                                      /// homepage data
                                      userListenData =
                                          state.homeMyTaskModel.data;
                                      presentDate = state
                                          .homeMyTaskModel.data!.currentDate;

                                      listDate = state
                                          .homeMyTaskModel.data!.lastDateList;
                                      // print("plandetails ${state.homeMyTaskModel.data!.planDetails!.isPrime}");
                                      // print("plandetails ${state.homeMyTaskModel.data!.planDetails!.planName}");
                                      if (state.homeMyTaskModel.data!
                                              .planDetails !=
                                          null) {
                                        pref.setBool(
                                            Constants.is_prime,
                                            state.homeMyTaskModel.data!
                                                    .planDetails!.isPrime ==
                                                1);
                                        pref.setString(
                                            Constants.plan_name,
                                            state.homeMyTaskModel.data!
                                                .planDetails!.planName!);
                                      }
                                      // print("presentDate-----");
                                      // print("isFromBackground----- $isFromBackground");
                                      if (isFromBackground) {
                                        showDate = listDate!
                                            .indexOf(presentDate.toString());
                                        // print("showDate>> $showDate");
                                        dashBardAPICalling();
                                        isFromBackground = false;
                                      }

                                      // print(listDate!
                                      //     .indexOf(presentDate.toString()));
                                      if (isFirstTime) {
                                        isFirstTime = false;
                                        showDate = listDate!
                                            .indexOf(presentDate.toString());

                                        dashBardAPICalling();
                                        var bodyCourtSummary = {
                                          "dateToday": listDate != null
                                              ? listDate![showDate].toString()
                                              : "",
                                        };
                                        BlocProvider.of<CourtSummaryCubit>(
                                                context)
                                            .fetchCourtSummary(
                                                bodyCourtSummary);
                                        listDate = state
                                            .homeMyTaskModel.data!.lastDateList;
                                        setState(() {});
                                      }
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (ctx) => AppMsgPopup(
                                              model.msg.toString()));
                                    }
                                  }
                                }),
                                SingleChildScrollView(
                                  physics: NeverScrollableScrollPhysics(),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 25, top: 10, right: 20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            DecoratedBox(
                                              decoration: BoxDecoration(
                                                color: AppColor.display_board,
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                CauseList(
                                                                    isFromHome:
                                                                        true),
                                                          ),
                                                        );
                                                      },
                                                      child: Text(
                                                        "Create New Quick Search",
                                                        style: appTextStyle(
                                                          fontSize:
                                                              Platform.isAndroid
                                                                  ? 10
                                                                  : 13,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          textColor:
                                                              AppColor.primary,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        MyAlerts()));
                                                      },
                                                      child: Text(
                                                        "View All",
                                                        style: appTextStyle(
                                                          fontSize: 10,
                                                          textColor:
                                                              AppColor.primary,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            quickSearchList!.isEmpty
                                                ? SizedBox()
                                                : Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              InkWell(
                                                                child: Text(
                                                                  "Quick Search",
                                                                  style: mpHeadLine18(
                                                                      fontFamily:
                                                                          "gilroy_regular",
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              /* selectedNames
                                                                      .isNotEmpty
                                                                  ? InkWell(
                                                                      onTap:
                                                                          () {
                                                                        _timerController
                                                                            .pause();
                                                                        var fromDate =
                                                                            DateTime.now();
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder: (context) => ViewCauseListScreenNew(
                                                                                      mainCauseListdata: {
                                                                                        "dateFrom": getDDMMYYYY(fromDate.toString()),
                                                                                        "lawyerName": selectedNames.isNotEmpty ? selectedNames : null,
                                                                                        "caseNo": selectedCaseNumber.isNotEmpty ? selectedCaseNumber : null,
                                                                                      },
                                                                                      isFromHomepage: true,
                                                                                      isDownloadOption: true,
                                                                                      isGotoCourt: true,
                                                                                      isQuickSearch: true,
                                                                                      quickScrollDate: presentDate,
                                                                                    ))).then((value) {
                                                                          _timerController
                                                                              .start();
                                                                        });
                                                                      },
                                                                      child:
                                                                          const Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: 8.0),
                                                                        child: Icon(
                                                                            Icons.add),
                                                                      ),
                                                                    )
                                                                  : SizedBox(),*/
                                                              selectedNames
                                                                          .isNotEmpty &&
                                                                      selectedNames
                                                                              .length ==
                                                                          1
                                                                  ? InkWell(
                                                                      onTap:
                                                                          () {
                                                                        _timerController
                                                                            .pause();
                                                                        String
                                                                            lawyerName =
                                                                            "$selectedNames";
                                                                        String cleanedLawyerName = lawyerName.replaceAll(
                                                                            RegExp(r'[{}]+'),
                                                                            '');
                                                                        String
                                                                            caseNumber =
                                                                            "$selectedCaseNumber";
                                                                        String cleanedCaseNumber = caseNumber.replaceAll(
                                                                            RegExp(r'[{}]+'),
                                                                            '');
                                                                        print(
                                                                            "ViewCauseListScreenNew selectedNames ==> $cleanedLawyerName");

                                                                        if (selectedNames
                                                                            .contains(watchListName)) {
                                                                          setState(
                                                                              () {
                                                                            cleanedLawyerName =
                                                                                "";
                                                                          });
                                                                        }

                                                                        var fromDate =
                                                                            DateTime.now();
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder: (context) => ViewCauseListScreenNew(
                                                                                      mainCauseListdata: {
                                                                                        "dateFrom": getDDMMYYYY(fromDate.toString()),
                                                                                        "lawyerName": selectedNames.isNotEmpty ? cleanedLawyerName : null,
                                                                                        "caseNo": selectedCaseNumber.isNotEmpty ? cleanedCaseNumber : null,
                                                                                      },
                                                                                      isFromHomepage: true,
                                                                                      isDownloadOption: true,
                                                                                      isGotoCourt: true,
                                                                                      isQuickSearch: true,
                                                                                      quickScrollDate: presentDate,
                                                                                    ))).then((value) {
                                                                          _timerController
                                                                              .start();
                                                                        });
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        "Open",
                                                                        style: mpHeadLine14(
                                                                            textColor:
                                                                                AppColor.primary,
                                                                            fontWeight: FontWeight.w500),
                                                                      ),
                                                                    )
                                                                  : selectedNames
                                                                              .isNotEmpty &&
                                                                          selectedNames.length >
                                                                              1
                                                                      ? InkWell(
                                                                          onTap:
                                                                              () {
                                                                            _timerController.pause();
                                                                            String
                                                                                lawyerName =
                                                                                "$selectedNames";
                                                                            String
                                                                                cleanedLawyerName =
                                                                                lawyerName.replaceAll(RegExp(r'[{}]+'), '');

                                                                            /*String
                                                                                caseNumber =
                                                                                "$selectedCaseNumber";
                                                                            String
                                                                                cleanedCaseNumber =
                                                                                caseNumber.replaceAll(RegExp(r'[{}]+'), '');*/
                                                                            print("ViewCauseListScreenNew selectedNames ==> $cleanedLawyerName");
                                                                            var fromDate =
                                                                                DateTime.now();
                                                                            Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (context) => ViewCauseListScreenNew(
                                                                                          mainCauseListdata: {
                                                                                            "dateFrom": getDDMMYYYY(fromDate.toString()),
                                                                                            "lawyerName": selectedNames.isNotEmpty ? cleanedLawyerName : null,
                                                                                            "caseNo": null,
                                                                                          },
                                                                                          isFromHomepage: true,
                                                                                          isDownloadOption: true,
                                                                                          isGotoCourt: true,
                                                                                          isQuickSearch: true,
                                                                                          quickScrollDate: presentDate,
                                                                                        ))).then((value) {
                                                                              _timerController.start();
                                                                            });
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            "Combine",
                                                                            style:
                                                                                mpHeadLine14(textColor: AppColor.primary, fontWeight: FontWeight.w500),
                                                                          ),
                                                                        )
                                                                      : SizedBox(),
                                                              selectedNames
                                                                      .isNotEmpty
                                                                  ? Text(
                                                                      "  |  ",
                                                                      style: mpHeadLine14(
                                                                          textColor: AppColor
                                                                              .black,
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                    )
                                                                  : SizedBox(),
                                                              InkWell(
                                                                onTap: () {
                                                                  if (isPrime(
                                                                          pref) &&
                                                                      (planName(pref) ==
                                                                              Constants
                                                                                  .goldPlan ||
                                                                          planName(pref) ==
                                                                              Constants.platinumPlan)) {
                                                                    _timerController
                                                                        .pause();
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) => OrderCmtHistory4(
                                                                                  isFromCmt: true,
                                                                                ))).then((value) {
                                                                      _timerController
                                                                          .start();
                                                                      setState(
                                                                          () {});
                                                                    });
                                                                  } else {
                                                                    FocusScope.of(
                                                                            context)
                                                                        .requestFocus(
                                                                            FocusNode());
                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        builder: (ctx) =>
                                                                            SafeArea(
                                                                              child: GoPrime(),
                                                                            ));
                                                                  }
                                                                },
                                                                child: Text(
                                                                  "Order sheet",
                                                                  style: mpHeadLine14(
                                                                      textColor:
                                                                          AppColor
                                                                              .primary,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              ),

                                                              /*InkWell(
                                                                onTap: () {
                                                                  _timerController
                                                                      .pause();
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              MyAlerts())).then(
                                                                      (value) {
                                                                    _timerController
                                                                        .start();
                                                                    setState(
                                                                        () {});
                                                                  });
                                                                },
                                                                child: Text(
                                                                  "View All",
                                                                  style: mpHeadLine14(
                                                                      textColor:
                                                                          AppColor
                                                                              .primary,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              ),*/
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 8,
                                                      ),

                                                      /// Quick Search
                                                      ConstrainedBox(
                                                        constraints:
                                                            BoxConstraints(
                                                          minHeight: 100,
                                                          maxHeight: 150,
                                                        ),
                                                        child: Scrollbar(
                                                          trackVisibility: true,
                                                          thumbVisibility: true,
                                                          controller:
                                                              controller,
                                                          interactive: true,
                                                          thickness: 10,
                                                          child:
                                                              ListView.builder(
                                                            itemCount:
                                                                quickSearchList!
                                                                    .length,
                                                            shrinkWrap: true,
                                                            scrollDirection:
                                                                Axis.vertical,
                                                            controller:
                                                                controller,
                                                            // physics:
                                                            //     NeverScrollableScrollPhysics(),
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              print(
                                                                  "lawyer ${quickSearchList![index].lawyer.toString()}");
                                                              print(
                                                                  "caseNo ${quickSearchList![index].caseNo.toString()}");
                                                              return InkWell(
                                                                onTap: () {
                                                                  String
                                                                      lawyerName =
                                                                      quickSearchList![
                                                                              index]
                                                                          .lawyer
                                                                          .toString();
                                                                  String
                                                                      cleanedLawyerName =
                                                                      lawyerName.replaceAll(
                                                                          RegExp(
                                                                              r'[{}]+'),
                                                                          '');
                                                                  String
                                                                      caseNumber =
                                                                      quickSearchList![
                                                                              index]
                                                                          .caseNo
                                                                          .toString();
                                                                  String
                                                                      cleanedCaseNumber =
                                                                      caseNumber.replaceAll(
                                                                          RegExp(
                                                                              r'[{}]+'),
                                                                          '');

                                                                  if (selectedNames
                                                                      .isEmpty) {
                                                                    setState(
                                                                        () {
                                                                      isLongPress =
                                                                          false;
                                                                    });
                                                                  }
                                                                  if (!isLongPress) {
                                                                    _timerController
                                                                        .pause();
                                                                    var fromDate =
                                                                        DateTime
                                                                            .now();
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) => ViewCauseListScreenNew(
                                                                                  mainCauseListdata: {
                                                                                    "dateFrom": getDDMMYYYY(fromDate.toString()),
                                                                                    "lawyerName": quickSearchList![index].lawyer.toString() != "null" ? cleanedLawyerName : null,
                                                                                    "caseNo": quickSearchList![index].caseNo != null ? cleanedCaseNumber : null,
                                                                                  },
                                                                                  isFromHomepage: true,
                                                                                  isDownloadOption: true,
                                                                                  isGotoCourt: true,
                                                                                  isQuickSearch: true,
                                                                                  quickScrollDate: presentDate,
                                                                                ))).then((value) {
                                                                      _timerController
                                                                          .start();
                                                                    });
                                                                  } else {
                                                                    caseNo = quickSearchList![
                                                                            index]
                                                                        .caseNo
                                                                        .toString();

                                                                    watchListName = quickSearchList![
                                                                            index]
                                                                        .caseNo
                                                                        .toString();

                                                                    itemName = quickSearchList![index].watchListName !=
                                                                                null &&
                                                                            quickSearchList![index]
                                                                                .watchListName!
                                                                                .isNotEmpty
                                                                        ? quickSearchList![index]
                                                                            .caseNo
                                                                            .toString()
                                                                        : quickSearchList![index].lawyer != null &&
                                                                                quickSearchList![index].lawyer!.isNotEmpty
                                                                            ? quickSearchList![index].lawyer.toString()
                                                                            : quickSearchList![index].caseNo.toString();

                                                                    if (watchListName
                                                                            .isNotEmpty &&
                                                                        selectedNames
                                                                            .contains(watchListName)) {
                                                                      if (selectedNames
                                                                          .contains(
                                                                              itemName)) {
                                                                        setState(
                                                                            () {
                                                                          selectedNames
                                                                              .remove(itemName);
                                                                        });
                                                                      } else {
                                                                        setState(
                                                                            () {
                                                                          selectedNames
                                                                              .add(itemName);
                                                                        });
                                                                      }
                                                                    } else {
                                                                      if (selectedNames
                                                                          .contains(
                                                                              itemName)) {
                                                                        setState(
                                                                            () {
                                                                          selectedNames
                                                                              .remove(itemName);
                                                                          selectedCaseNumber
                                                                              .remove(caseNo);
                                                                        });
                                                                      } else {
                                                                        setState(
                                                                            () {
                                                                          selectedNames
                                                                              .add(itemName);
                                                                          selectedCaseNumber
                                                                              .add(caseNo);
                                                                        });
                                                                      }
                                                                    }
                                                                  }
                                                                },
                                                                onLongPress:
                                                                    () {
                                                                  setState(() {
                                                                    isLongPress =
                                                                        true;
                                                                  });
                                                                  caseNo = quickSearchList![
                                                                          index]
                                                                      .caseNo
                                                                      .toString();

                                                                  watchListName =
                                                                      quickSearchList![
                                                                              index]
                                                                          .caseNo
                                                                          .toString();

                                                                  print(
                                                                      "QuickSearch lawyer ==>  ${quickSearchList![index].lawyer.toString()}");
                                                                  itemName = quickSearchList![index].watchListName == null &&
                                                                          quickSearchList![index].watchListName !=
                                                                              null &&
                                                                          quickSearchList![index]
                                                                              .watchListName!
                                                                              .isNotEmpty
                                                                      ? quickSearchList![
                                                                              index]
                                                                          .caseNo
                                                                          .toString()
                                                                      : quickSearchList![index].lawyer != null &&
                                                                              quickSearchList![index].watchListName ==
                                                                                  null &&
                                                                              quickSearchList![index]
                                                                                  .lawyer!
                                                                                  .isNotEmpty
                                                                          ? quickSearchList![index]
                                                                              .lawyer
                                                                              .toString()
                                                                          : quickSearchList![index]
                                                                              .caseNo
                                                                              .toString();

                                                                  print(
                                                                      "QuickSearch caseNumber ==>  $caseNo");
                                                                  print(
                                                                      "QuickSearch itemName ==>  $itemName");
                                                                  if (watchListName
                                                                          .isNotEmpty &&
                                                                      selectedNames
                                                                          .contains(
                                                                              watchListName)) {
                                                                    if (selectedNames
                                                                        .contains(
                                                                            itemName)) {
                                                                      setState(
                                                                          () {
                                                                        selectedNames
                                                                            .remove(itemName);
                                                                      });
                                                                    } else {
                                                                      setState(
                                                                          () {
                                                                        selectedNames
                                                                            .add(itemName);
                                                                      });
                                                                    }
                                                                  } else {
                                                                    if (selectedNames
                                                                        .contains(
                                                                            itemName)) {
                                                                      setState(
                                                                          () {
                                                                        selectedNames
                                                                            .remove(itemName);
                                                                        selectedCaseNumber
                                                                            .remove(caseNo);
                                                                      });
                                                                    } else {
                                                                      setState(
                                                                          () {
                                                                        selectedNames
                                                                            .add(itemName);
                                                                        selectedCaseNumber
                                                                            .add(caseNo);
                                                                      });
                                                                    }
                                                                  }

                                                                  print(
                                                                      "selectedNames ==> $selectedNames");
                                                                  print(
                                                                      "selectedNames ==> ${selectedNames.length}");
                                                                  print(
                                                                      "itemName ==> $itemName");
                                                                  print(
                                                                      "selectedCaseNumber ==> $selectedCaseNumber");
                                                                },
                                                                child: Wrap(
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          vertical:
                                                                              3),
                                                                      child:
                                                                          Container(
                                                                        constraints:
                                                                            BoxConstraints(
                                                                          maxWidth:
                                                                              MediaQuery.of(context).size.width * 0.8,
                                                                        ),
                                                                        child:
                                                                            Chip(
                                                                          materialTapTargetSize:
                                                                              MaterialTapTargetSize.shrinkWrap,
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              5),
                                                                          backgroundColor: selectedNames.contains(quickSearchList![index].lawyer.toString()) || selectedNames.contains(quickSearchList![index].caseNo.toString()) || selectedNames.contains(quickSearchList![index].watchListName.toString())
                                                                              ? AppColor.complete_color_text
                                                                              : (quickSearchList![index].isHighlighted != null && quickSearchList![index].isHighlighted! >= 1)
                                                                                  ? AppColor.primary
                                                                                  : Colors.white,
                                                                          label:
                                                                              Text(
                                                                            quickSearchList![index].watchListName != null && quickSearchList![index].watchListName!.isNotEmpty
                                                                                ? quickSearchList![index].watchListName.toString()
                                                                                : quickSearchList![index].lawyer != null && quickSearchList![index].lawyer!.isNotEmpty
                                                                                    ? quickSearchList![index].lawyer.toString()
                                                                                    : quickSearchList![index].caseNo.toString(),
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style: mpHeadLine16(
                                                                                textColor: selectedNames.contains(quickSearchList![index].lawyer.toString()) || selectedNames.contains(quickSearchList![index].caseNo.toString()) || selectedNames.contains(quickSearchList![index].watchListName.toString())
                                                                                    ? AppColor.white
                                                                                    : quickSearchList![index].isHighlighted != null && quickSearchList![index].isHighlighted! >= 1
                                                                                        ? AppColor.white
                                                                                        : AppColor.primary),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                // Navigator.push(
                                                //     context, MaterialPageRoute(builder: (context) => TestingAppli()));
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Display Board",
                                                    style: mpHeadLine18(
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      /* InkWell(
                                                        onTap: () {
                                                          var causeListDates =
                                                              summaryDataNew
                                                                  .map((data) =>
                                                                      data.causeListDate ??
                                                                      '')
                                                                  .toSet()
                                                                  .toList();

                                                          print(causeListDates);

                                                          showDialog(
                                                              context: context,
                                                              barrierDismissible:
                                                                  true,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return CourtSummaryNew(
                                                                    summaryDataNew,
                                                                    causeListDates ??
                                                                        "");
                                                              });
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color: AppColor
                                                                  .primary,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          3)),
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 3),
                                                          child: Text(
                                                            "Quick Update",
                                                            style: appTextStyle(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                textColor:
                                                                    AppColor
                                                                        .white),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),*/
                                                      InkWell(
                                                        onTap: () {
                                                          showDialog(
                                                              context: context,
                                                              builder: (ctx) =>
                                                                  courtNoteDialog(
                                                                      userData,
                                                                      context));
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors.red,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          3)),
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 3),
                                                          child: Text(
                                                            "Note",
                                                            style: appTextStyle(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                textColor:
                                                                    AppColor
                                                                        .white),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          showDialog(
                                                              context: context,
                                                              barrierDismissible:
                                                                  true,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return CourtSummary(
                                                                    summaryData,
                                                                    listDate !=
                                                                            null
                                                                        ? listDate![showDate]
                                                                            .toString()
                                                                        : "");
                                                              });
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color: AppColor
                                                                  .primary,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          3)),
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 3),
                                                          child: Text(
                                                            "Summary",
                                                            style: appTextStyle(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                textColor:
                                                                    AppColor
                                                                        .white),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 7,
                                            ),
                                            Text(
                                              display_board_note,
                                              style: appTextStyle(
                                                  fontSize: 10,
                                                  textColor: Colors.redAccent,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(
                                              height: 0,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                BlocConsumer<DisplayBoardCubit,
                                        DisplayBoardState>(
                                    builder: (context, state) {
                                  // if (state is DisplayBoardLoading) {
                                  //   return AppProgressIndicator();
                                  // }
                                  return const SizedBox();
                                }, listener: (context, state) {
                                  if (state is DisplayBoardLoading) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                  }
                                  if (state is DisplayBoardLoaded) {
                                    final dispModel = state.displayBoardModel;
                                    if (dispModel.result == 1) {
                                      if (dispModel.data != null) {
                                        setState(() {
                                          displayData = null;
                                          displayData = dispModel.data;
                                          // displayDataTickerList=displayData.ticker;
                                          print("isPrime//// ${isPrime(pref)}");
                                          displayDataTickerList = List.generate(
                                              displayData.ticker.length,
                                              (indexOfElement) => displayData
                                                  .ticker[indexOfElement]);

                                          if (isCourtFilter) {
                                            displayDataTickerList =
                                                displayDataTickerList
                                                    .where((element) => element
                                                        .mycases.isNotEmpty)
                                                    .toList();
                                          }

                                          print(
                                              "displayDataTickerList//// ${displayDataTickerList.length}");
                                          updateDisplayBoard();

                                          print(
                                              "display data??? ${displayData.date}");
                                          if (displayData != null &&
                                              displayData.time != null) {
                                            displayTime = displayData.time;
                                          }
                                          isLoading = false;
                                        });
                                      }
                                    } else {
                                      //toast(msg: dispModel.msg.toString());
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                  }
                                }),

                                BlocConsumer<UpdateDisplayBoardCubit,
                                        UpdateDisplayBoardState>(
                                    builder: (context, state) {
                                  return const SizedBox();
                                }, listener: (context, state) {
                                  // if (state is UpdateDisplayBoardLoading) {
                                  //   setState(() {
                                  //     isLoading=true;
                                  //   });
                                  // }
                                  if (state is UpdateDisplayBoardLoaded) {
                                    final refreshModel = state.model;
                                    if (refreshModel.data != null) {
                                      if (refreshModel.result == 1) {
                                        List refreshedData =
                                            refreshModel.data!.data!.ticker!;
                                        if (refreshModel.data!.data != null &&
                                            refreshModel.data!.data!.ticker !=
                                                null &&
                                            displayData != null &&
                                            displayData.ticker != null &&
                                            (isPrime(pref))) {
                                          for (int i = 0;
                                              i < refreshedData.length;
                                              i++) {
                                            int tempIndex =
                                                displayDataTickerList
                                                    .indexWhere((element) =>
                                                        element.courtNo ==
                                                        refreshedData![i]
                                                            .courtNo);
                                            if (tempIndex != -1) {
                                              displayDataTickerList[tempIndex]
                                                      .itemNo =
                                                  refreshedData[i].itemNo;
                                            } else {
                                              Ticker tick = Ticker();
                                              tick.courtNo =
                                                  refreshedData[i].courtNo;
                                              tick.itemNo =
                                                  refreshedData[i].itemNo;
                                              tick.benchList = [];
                                              tick.benchCount = 0;
                                              tick.mycases = [];
                                              tick.mycases = [];
                                              if (!isCourtFilter) {
                                                displayDataTickerList.add(tick);
                                              }
                                            }
                                          }
                                        }
                                        print(
                                            "displayDataTickerList//// ${displayDataTickerList.length}");
                                        sortDisplayBoardData();
                                        if (isCourtFilter) {
                                          displayDataTickerList =
                                              displayDataTickerList
                                                  .where((element) => element
                                                      .mycases.isNotEmpty)
                                                  .toList();
                                        }
                                        setState(() {});
                                      }
                                      if (refreshModel.data!.data != null &&
                                          refreshModel.data!.data!.time !=
                                              null) {
                                        displayTime =
                                            refreshModel.data!.data!.time!;
                                      }
                                      setState(() {
                                        isLoading = false;
                                      });
                                    } else {
                                      //toast(msg: refreshModel.msg.toString());
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                    setState(() {
                                      second = 0;
                                    });
                                  }
                                }),
                                /*&&
                                      displayData != null &&
                                      displayDataTickerList.isNotEmpty*/
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, top: 0, right: 10, bottom: 0),
                                  child: SwitchListTile(
                                    onChanged: (value) {
                                      if (isPrime(pref)) {
                                        setState(() {
                                          isCourtFilter = value;
                                          pref.setBool(
                                              Constants.is_court_filter,
                                              isCourtFilter);

                                          _saveCourtValue(isCourtFilter);

                                          if (isCourtFilter) {
                                            displayDataTickerList =
                                                displayDataTickerList
                                                    .where((element) => element
                                                        .mycases.isNotEmpty)
                                                    .toList();
                                          } else {
                                            displayDataTickerList =
                                                List.generate(
                                                    displayData.ticker.length,
                                                    (indexOfElement) =>
                                                        displayData.ticker[
                                                            indexOfElement]);
                                            sortDisplayBoardData();
                                          }
                                        });
                                      } else {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        showDialog(
                                            context: context,
                                            builder: (ctx) => SafeArea(
                                                  child: GoPrime(),
                                                ));
                                      }
                                    },
                                    value: isCourtFilter,
                                    dense: true,
                                    title: Text(
                                      'Show "My Case" Courts only',
                                      style: appTextStyle(
                                          fontSize: 16,
                                          textColor: Colors.black,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    controlAffinity:
                                        ListTileControlAffinity.trailing,
                                    // trackColor: MaterialStateProperty.all(
                                    //     AppColor.rejected_color_text),
                                  ),
                                ),
                                const SizedBox(
                                  height: 0,
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, top: 0, right: 20, bottom: 60),
                                  child: Stack(
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    // mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(7)),
                                        elevation: 5,
                                        shadowColor: Colors.black,
                                        color: Colors.white,
                                        semanticContainer: false,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20,
                                                  left: 10,
                                                  right: 10,
                                                  bottom: 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      showDate !=
                                                              listDate!.length -
                                                                  1
                                                          ? InkWell(
                                                              onTap: () {
                                                                if (!isPrime(
                                                                    pref)) {
                                                                  FocusScope.of(
                                                                          context)
                                                                      .requestFocus(
                                                                          FocusNode());
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (ctx) =>
                                                                              SafeArea(
                                                                                child: GoPrime(),
                                                                              ));
                                                                  return;
                                                                }

                                                                if (showDate <
                                                                    listDate!
                                                                            .length -
                                                                        1) {
                                                                  setState(() {
                                                                    showDate +=
                                                                        1;
                                                                    print(
                                                                        "showDate-----------$showDate");
                                                                    print(
                                                                        "okk showDate-----------${listDate![showDate].toString()}");
                                                                  });

                                                                  var bodyHomeMyTask =
                                                                      {
                                                                    "dateToday": listDate !=
                                                                            null
                                                                        ? listDate![showDate]
                                                                            .toString()
                                                                        : "",
                                                                    "platformType":
                                                                        Platform.isAndroid
                                                                            ? "0"
                                                                            : "1"
                                                                    //o for android, 1 for iOS
                                                                  };
                                                                  BlocProvider.of<
                                                                              HomeMyTaskCubit>(
                                                                          context)
                                                                      .fetchHomeMyTask(
                                                                          bodyHomeMyTask);
                                                                  var body = {
                                                                    "dateToday": listDate !=
                                                                            null
                                                                        ? listDate![showDate]
                                                                            .toString()
                                                                        : "",
                                                                    "platformType":
                                                                        Platform.isAndroid
                                                                            ? "0"
                                                                            : "1"
                                                                    //o for android, 1 for iOS
                                                                  };
                                                                  BlocProvider.of<
                                                                              DisplayBoardCubit>(
                                                                          context)
                                                                      .fetchDisplayBoard(
                                                                          body);
                                                                  isVisible !=
                                                                      isVisible;
                                                                  var bodyCourtSummary =
                                                                      {
                                                                    "dateToday": listDate !=
                                                                            null
                                                                        ? listDate![showDate]
                                                                            .toString()
                                                                        : "",
                                                                  };
                                                                  BlocProvider.of<
                                                                              CourtSummaryCubit>(
                                                                          context)
                                                                      .fetchCourtSummary(
                                                                          bodyCourtSummary);
                                                                }
                                                              },
                                                              child: Visibility(
                                                                // visible: false,
                                                                child:
                                                                    const Icon(
                                                                  Icons
                                                                      .arrow_back_ios,
                                                                  size: 15,
                                                                ),
                                                              ),
                                                            )
                                                          : SizedBox(),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        displayData != null
                                                            ? displayData.date
                                                                .toString()
                                                            : "",
                                                        style: mpHeadLine14(),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      showDate != 0
                                                          ? InkWell(
                                                              onTap: () {
                                                                if (!isPrime(
                                                                    pref)) {
                                                                  FocusScope.of(
                                                                          context)
                                                                      .requestFocus(
                                                                          FocusNode());
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (ctx) =>
                                                                              SafeArea(
                                                                                child: GoPrime(),
                                                                              ));
                                                                  return;
                                                                }
                                                                if (showDate !=
                                                                    0)
                                                                  setState(() {
                                                                    showDate -=
                                                                        1;
                                                                    // print(
                                                                    //     "showDate-----------$showDate");
                                                                  });
                                                                var bodyHomeMyTask =
                                                                    {
                                                                  "dateToday": listDate !=
                                                                          null
                                                                      ? listDate![
                                                                              showDate]
                                                                          .toString()
                                                                      : "",
                                                                  "platformType":
                                                                      Platform.isAndroid
                                                                          ? "0"
                                                                          : "1"
                                                                  //o for android, 1 for iOS
                                                                };
                                                                BlocProvider.of<
                                                                            HomeMyTaskCubit>(
                                                                        context)
                                                                    .fetchHomeMyTask(
                                                                        bodyHomeMyTask);
                                                                var body = {
                                                                  "dateToday": listDate !=
                                                                          null
                                                                      ? listDate![
                                                                              showDate]
                                                                          .toString()
                                                                      : "",
                                                                  "platformType":
                                                                      Platform.isAndroid
                                                                          ? "0"
                                                                          : "1"
                                                                  //o for android, 1 for iOS
                                                                };
                                                                BlocProvider.of<
                                                                            DisplayBoardCubit>(
                                                                        context)
                                                                    .fetchDisplayBoard(
                                                                        body);
                                                                var bodyCourtSummary =
                                                                    {
                                                                  "dateToday": listDate !=
                                                                          null
                                                                      ? listDate![
                                                                              showDate]
                                                                          .toString()
                                                                      : "",
                                                                };
                                                                BlocProvider.of<
                                                                            CourtSummaryCubit>(
                                                                        context)
                                                                    .fetchCourtSummary(
                                                                        bodyCourtSummary);
                                                              },
                                                              child: const Icon(
                                                                Icons
                                                                    .arrow_forward_ios_rounded,
                                                                size: 15,
                                                              ),
                                                            )
                                                          : SizedBox(),
                                                    ],
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      displayTime.isNotEmpty
                                                          ? displayTime
                                                          : "",
                                                      style: mpHeadLine14(
                                                          textColor:
                                                              Colors.grey),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5, right: 5, bottom: 5),
                                              child: Theme(
                                                data: Theme.of(context)
                                                    .copyWith(
                                                        dividerColor:
                                                            Colors.transparent),
                                                child: DataTable(
                                                    dividerThickness: 0.0,
                                                    columnSpacing: 0,
                                                    horizontalMargin: 5,
                                                    columns: [
                                                      DataColumn(
                                                          // numeric: false,
                                                          label: Container(
                                                        width:
                                                            mediaQW(context) *
                                                                0.19,
                                                        child: Center(
                                                          child: Text(
                                                            "Court No.",
                                                            style: appTextStyle(
                                                              fontSize: 15,
                                                            ),
                                                          ),
                                                        ),
                                                      )),
                                                      DataColumn(
                                                          label: InkWell(
                                                        onTap: () {
                                                          _timerController
                                                              .pause();
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      ViewCauseListScreenNew(
                                                                        mainCauseListdata: {
                                                                          "dateFrom":
                                                                              getddMMYYYY_with_splash(listDate![showDate].toString()),
                                                                          "dateTo":
                                                                              getddMMYYYY_with_splash(listDate![showDate].toString()),
                                                                        },
                                                                        isFromHomepage:
                                                                            false,
                                                                      ))).then(
                                                              (value) {
                                                            _timerController
                                                                .start();
                                                          });
                                                        },
                                                        child: Container(
                                                          width:
                                                              mediaQW(context) *
                                                                  0.19,
                                                          child: Center(
                                                            child: Text(
                                                              "Item No.",
                                                              style: appTextStyle(
                                                                  fontSize: 15,
                                                                  textColor:
                                                                      AppColor
                                                                          .primary),
                                                            ),
                                                          ),
                                                        ),
                                                      )),
                                                      DataColumn(
                                                          label: Container(
                                                        width:
                                                            mediaQW(context) *
                                                                0.44,
                                                        child: Center(
                                                          child: Text(
                                                            "My Case",
                                                            style: appTextStyle(
                                                              fontSize: 15,
                                                            ),
                                                          ),
                                                        ),
                                                      )),
                                                    ],
                                                    rows: List<
                                                            DataRow>.generate(
                                                        displayData != null
                                                            ? displayDataTickerList
                                                                .length
                                                            : 0, (int index) {
                                                      String items = displayData !=
                                                              null
                                                          ? displayDataTickerList[
                                                                  index]
                                                              .itemNo
                                                              .toString()
                                                          : "-";

                                                      print(
                                                          "displayDataTickerList ${displayDataTickerList[index].itemNo}");
                                                      // var UpdateItems = items.split("(");
                                                      // var prefix = UpdateItems[0].trim();
                                                      // var fullVariable =
                                                      //     UpdateItems.sublist(1)
                                                      //         .join(',')
                                                      //         .trim();
                                                      // print("fullVariable------- $fullVariable");
                                                      // print("items------$items");
                                                      //  String cases =
                                                      //      displayData != null
                                                      //          ? displayData
                                                      //              .ticker[index]
                                                      //              .mycases
                                                      //              .join(', ')
                                                      //          : "";
                                                      List casesList =
                                                          displayData != null
                                                              ? displayDataTickerList[
                                                                      index]
                                                                  .mycases
                                                              : [];
                                                      String resultString =
                                                          casesList.join(', ');
                                                      print(
                                                          "resultString ==> $resultString");

                                                      // print("cases------$cases");
                                                      ScrollController
                                                          caseScrollController =
                                                          ScrollController();
                                                      return DataRow(
                                                        color: MaterialStateProperty
                                                            .resolveWith<
                                                                Color?>((Set<
                                                                    MaterialState>
                                                                states) {
                                                          // All rows will have the same selected color.
                                                          if (states.contains(
                                                              MaterialState
                                                                  .selected)) {
                                                            return Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .primary
                                                                .withOpacity(
                                                                    0.08);
                                                          }
                                                          // Even rows will have a grey color.
                                                          if (index.isEven) {
                                                            return AppColor
                                                                .display_board;
                                                          }
                                                          return null; // Use default value for other states and odd rows.
                                                        }),
                                                        cells: <DataCell>[
                                                          DataCell(
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                right: 22.0,
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Visibility(
                                                                    visible:
                                                                        resultString !=
                                                                            "",
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          4.0),
                                                                      child:
                                                                          InkWell(
                                                                        onTap:
                                                                            () {
                                                                          if (!isPrime(
                                                                              pref)) {
                                                                            FocusScope.of(context).requestFocus(FocusNode());
                                                                            showDialog(
                                                                                context: context,
                                                                                builder: (ctx) => SafeArea(
                                                                                      child: GoPrime(),
                                                                                    ));
                                                                            return;
                                                                          }
                                                                          if (displayDataTickerList[index].benchCount ==
                                                                              1) {
                                                                            var displayBoardSummary =
                                                                                {
                                                                              "dateToday": listDate != null ? listDate![showDate].toString() : "",
                                                                              "courtNo": displayData != null ? displayDataTickerList[index].courtNo.toString() : "",
                                                                              "sno": displayData != null && resultString != "" ? resultString : items,
                                                                            };

                                                                            showDialog(
                                                                                context: context,
                                                                                barrierDismissible: true,
                                                                                builder: (BuildContext context) {
                                                                                  return ItemStageInfo(
                                                                                      //displayData.ticker[index],
                                                                                      displayBoardSummary);
                                                                                });
                                                                          } else {
                                                                            showDialog(
                                                                                context: context,
                                                                                builder: (ctx) => AlertDialog(
                                                                                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                                                                    // insetPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                                                                                    content: SizedBox(
                                                                                      // height: 200,
                                                                                      width: mediaQW(context) * 0.2,
                                                                                      child: ListView.builder(
                                                                                        itemCount: displayDataTickerList[index].benchList.length,
                                                                                        shrinkWrap: true,
                                                                                        scrollDirection: Axis.vertical,
                                                                                        itemBuilder: (context, i) {
                                                                                          return InkWell(
                                                                                            onTap: () {
                                                                                              Navigator.pop(context);
                                                                                              showDialog(
                                                                                                  context: context,
                                                                                                  barrierDismissible: true,
                                                                                                  builder: (BuildContext context) {
                                                                                                    var displayBoardSummary = {
                                                                                                      "dateToday": listDate != null ? listDate![showDate].toString() : "",
                                                                                                      "courtNo": displayData != null ? displayDataTickerList[index].courtNo.toString() : "",
                                                                                                      "sno": resultString,
                                                                                                      "benchName": displayDataTickerList[index].benchList[i].benchName.toString(),
                                                                                                    };
                                                                                                    return ItemStageInfo(displayBoardSummary);
                                                                                                  });
                                                                                            },
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.all(8.0),
                                                                                              child: Column(
                                                                                                children: [
                                                                                                  Text(
                                                                                                    displayDataTickerList[index].benchList[i].benchName.toString(),
                                                                                                    style: mpHeadLine14(),
                                                                                                    textAlign: TextAlign.center,
                                                                                                  ),
                                                                                                  displayDataTickerList[index].benchList.length - 1 == index
                                                                                                      ? SizedBox()
                                                                                                      : const Divider(
                                                                                                          thickness: 1,
                                                                                                          color: AppColor.grey_color,
                                                                                                        )
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          );
                                                                                        },
                                                                                      ),
                                                                                    ),
                                                                                    actions: <Widget>[]));
                                                                          }
                                                                        },
                                                                        child: Image
                                                                            .asset(
                                                                          ImageConstant
                                                                              .iIcon,
                                                                          color:
                                                                              AppColor.button_accept,
                                                                          height:
                                                                              20,
                                                                          width:
                                                                              20,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                      displayData !=
                                                                              null
                                                                          ? displayDataTickerList[index]
                                                                              .courtNo
                                                                              .toString()
                                                                          : "",
                                                                      style: mpHeadLine14(
                                                                          fontWeight:
                                                                              FontWeight.w500)),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          DataCell(
                                                            InkWell(
                                                              onTap: () {
                                                                // items="108-with111(D)";
                                                                print(
                                                                    "value $items");
                                                                List itemList =
                                                                    items.split(
                                                                        "-");
                                                                print(
                                                                    "last ${itemList.last}");
                                                                // if (items
                                                                //     .toString()
                                                                //     .isNotEmpty) {
                                                                _timerController
                                                                    .pause();

                                                                if (displayDataTickerList[
                                                                            index]
                                                                        .benchCount ==
                                                                    1) {
                                                                  String
                                                                      numberString =
                                                                      "";
                                                                  if (items
                                                                          .toString()
                                                                          .isNotEmpty &&
                                                                      items !=
                                                                          "-") {
                                                                    numberString = itemList
                                                                        .last
                                                                        .replaceAll(
                                                                            RegExp('[^0-9]'),
                                                                            '');
                                                                  }
                                                                  print(
                                                                      "numberstring $numberString");

                                                                  // print(
                                                                  //     "display board ${items
                                                                  //         .toString()
                                                                  //         .isNotEmpty &&
                                                                  //         items !=
                                                                  //             "-"}");

                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => ViewCauseListScreenNew(mainCauseListdata: {
                                                                                "dateFrom": getddMMYYYY_with_splash(listDate![showDate].toString()),
                                                                                "dateTo": "",
                                                                                "courtNo": displayData != null ? displayDataTickerList[index].courtNo.toString() : "",
                                                                                "sNo": numberString,
                                                                                "type": items.toString().isNotEmpty && items != "-"
                                                                                    ? items.toString().contains("D")
                                                                                        ? "Daily"
                                                                                        : "Supplementary"
                                                                                    : "",
                                                                              }, isFromHomepage: true, isScrollToSno: items.toString().isNotEmpty && items != "-", isFilter: false))).then((value) {
                                                                    _timerController
                                                                        .start();
                                                                  });
                                                                } else {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder: (ctx) => AlertDialog(
                                                                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                                                          // insetPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                                                                          content: SizedBox(
                                                                            // height: 200,
                                                                            width:
                                                                                mediaQW(context) * 0.2,
                                                                            child:
                                                                                ListView.builder(
                                                                              itemCount: displayDataTickerList[index].benchList.length,
                                                                              shrinkWrap: true,
                                                                              scrollDirection: Axis.vertical,
                                                                              itemBuilder: (context, i) {
                                                                                return InkWell(
                                                                                  onTap: () {
                                                                                    //Navigator.pop(context);
                                                                                    String numberString = "";
                                                                                    if (items.toString().isNotEmpty && items != "-") {
                                                                                      numberString = itemList.last.replaceAll(RegExp('[^0-9]'), '');
                                                                                    }
                                                                                    Navigator.push(
                                                                                        context,
                                                                                        MaterialPageRoute(
                                                                                            builder: (context) => ViewCauseListScreenNew(mainCauseListdata: {
                                                                                                  "dateFrom": getddMMYYYY_with_splash(listDate![showDate].toString()),
                                                                                                  "dateTo": "",
                                                                                                  "courtNo": displayData != null ? displayDataTickerList[index].courtNo.toString() : "",
                                                                                                  "judgeName": displayDataTickerList[index].benchList[i].benchName.toString(),
                                                                                                  "sNo": numberString,
                                                                                                  "type": items.toString().isNotEmpty && items != "-"
                                                                                                      ? items.toString().contains("D")
                                                                                                          ? "Daily"
                                                                                                          : "Supplementary"
                                                                                                      : "",
                                                                                                }, isFromHomepage: true, isScrollToSno: items.toString().isNotEmpty && items != "-", isFilter: false))).then((value) {
                                                                                      _timerController.start();
                                                                                    });
                                                                                  },
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: Column(
                                                                                      children: [
                                                                                        Text(
                                                                                          displayDataTickerList[index].benchList[i].benchName.toString(),
                                                                                          style: mpHeadLine14(),
                                                                                          textAlign: TextAlign.center,
                                                                                        ),
                                                                                        displayDataTickerList[index].benchList.length - 1 == i
                                                                                            ? SizedBox()
                                                                                            : const Divider(
                                                                                                thickness: 1,
                                                                                                color: AppColor.grey_color,
                                                                                              )
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              },
                                                                            ),
                                                                          ),
                                                                          actions: <Widget>[]));
                                                                }
                                                              },
                                                              child: Center(
                                                                  child: Transform
                                                                      .translate(
                                                                offset:
                                                                    const Offset(
                                                                        0, 5),
                                                                child:
                                                                    HighlightText(
                                                                  items.isNotEmpty
                                                                      ? items
                                                                      : "-",
                                                                  "(S)",
                                                                  items.isEmpty ||
                                                                          items ==
                                                                              "-"
                                                                      ? mpHeadLine14(
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          textColor: AppColor
                                                                              .primary)
                                                                      : TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          color: Colors
                                                                              .transparent,
                                                                          decorationColor: AppColor
                                                                              .primary,
                                                                          shadows: [
                                                                            Shadow(
                                                                                color: Colors.black,
                                                                                offset: Offset(0, -5))
                                                                          ],
                                                                          decoration: TextDecoration
                                                                              .underline,
                                                                          decorationThickness:
                                                                              3),
                                                                  items.isEmpty ||
                                                                          items ==
                                                                              "-"
                                                                      ? mpHeadLine14(
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          textColor: AppColor
                                                                              .primary)
                                                                      : TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          color: Colors
                                                                              .transparent,
                                                                          decorationColor: AppColor
                                                                              .primary,
                                                                          shadows: [
                                                                            Shadow(
                                                                                color: Colors.red,
                                                                                offset: Offset(0, -5))
                                                                          ],
                                                                          decoration: TextDecoration
                                                                              .underline,
                                                                          decorationThickness:
                                                                              3),
                                                                ),
                                                              )),
                                                            ),
                                                          ),
                                                          DataCell(Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Stack(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                children: [
                                                                  Container(
                                                                    width: mediaQW(
                                                                            context) *
                                                                        0.2,
                                                                    clipBehavior:
                                                                        Clip.hardEdge,
                                                                    margin: EdgeInsets.only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10),
                                                                    decoration:
                                                                        const BoxDecoration(),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          SingleChildScrollView(
                                                                        scrollDirection:
                                                                            Axis.horizontal,
                                                                        controller:
                                                                            caseScrollController,
                                                                        child:
                                                                            Row(
                                                                          children:
                                                                              casesList.map((e) {
                                                                            //  print("items $items");
                                                                            int item =
                                                                                -1;
                                                                            int cas =
                                                                                -1;
                                                                            if (items.isNotEmpty) {
                                                                              item = int.parse(items.replaceAll(RegExp(r'[^0-9]'), ''));
                                                                            }
                                                                            if (e != null &&
                                                                                e.toString().isNotEmpty) {
                                                                              cas = int.parse(e.replaceAll(RegExp(r'[^0-9]'), ''));
                                                                            }

                                                                            /// Case List
                                                                            return InkWell(
                                                                              onTap: () {
                                                                                print("e :: $e");
                                                                                if (e != null && e.toString().isNotEmpty) {
                                                                                  _timerController.pause();

                                                                                  if (displayDataTickerList[index].benchCount == 1) {
                                                                                    String numberString = e.replaceAll(RegExp('[^0-9]'), '');
                                                                                    _timerController.pause();
                                                                                    Navigator.push(
                                                                                        context,
                                                                                        MaterialPageRoute(
                                                                                            builder: (context) => ViewCauseListScreenNew(
                                                                                                  mainCauseListdata: {
                                                                                                    "dateFrom": getddMMYYYY_with_splash(listDate![showDate].toString()),
                                                                                                    "dateTo": getddMMYYYY_with_splash(listDate![showDate].toString()),
                                                                                                    "courtNo": displayData != null ? displayDataTickerList[index].courtNo.toString() : "",
                                                                                                    "sNo": numberString,
                                                                                                    "type": e.toString().contains("D") ? "Daily" : "Supplementary",
                                                                                                  },
                                                                                                  isFromHomepage: true,
                                                                                                  isScrollToSno: true,
                                                                                                  isDownloadOption: true,
                                                                                                  isFilter: false,
                                                                                                  isGotoCourt: true,
                                                                                                ))).then((value) {
                                                                                      _timerController.start();
                                                                                    });
                                                                                  } else {
                                                                                    showDialog(
                                                                                        context: context,
                                                                                        builder: (ctx) => AlertDialog(
                                                                                            contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                                                                            // insetPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                                                                                            content: SizedBox(
                                                                                              // height: 200,
                                                                                              width: mediaQW(context) * 0.2,
                                                                                              child: ListView.builder(
                                                                                                itemCount: displayDataTickerList[index].benchList.length,
                                                                                                shrinkWrap: true,
                                                                                                scrollDirection: Axis.vertical,
                                                                                                itemBuilder: (context, i) {
                                                                                                  return InkWell(
                                                                                                    onTap: () {
                                                                                                      String numberString = e.replaceAll(RegExp('[^0-9]'), '');

                                                                                                      Navigator.push(
                                                                                                          context,
                                                                                                          MaterialPageRoute(
                                                                                                              builder: (context) => ViewCauseListScreenNew(mainCauseListdata: {
                                                                                                                    "dateFrom": getddMMYYYY_with_splash(listDate![showDate].toString()),
                                                                                                                    "dateTo": "",
                                                                                                                    "courtNo": displayData != null ? displayDataTickerList[index].courtNo.toString() : "",
                                                                                                                    "judgeName": displayDataTickerList[index].benchList[i].benchName.toString(),
                                                                                                                    "sNo": numberString,
                                                                                                                    "type": e.toString().contains("D") ? "Daily" : "Supplementary",
                                                                                                                  }, isFromHomepage: true, isScrollToSno: true, isFilter: false))).then((value) {
                                                                                                        _timerController.start();
                                                                                                      });
                                                                                                    },
                                                                                                    child: Padding(
                                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                                      child: Column(
                                                                                                        children: [
                                                                                                          Text(
                                                                                                            displayDataTickerList[index].benchList[i].benchName.toString(),
                                                                                                            style: mpHeadLine14(),
                                                                                                            textAlign: TextAlign.center,
                                                                                                          ),
                                                                                                          displayDataTickerList[index].benchList.length - 1 == i
                                                                                                              ? SizedBox()
                                                                                                              : const Divider(
                                                                                                                  thickness: 1,
                                                                                                                  color: AppColor.grey_color,
                                                                                                                )
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                  );
                                                                                                },
                                                                                              ),
                                                                                            ),
                                                                                            actions: <Widget>[]));
                                                                                  }
                                                                                }

                                                                                // if (e != null &&
                                                                                //     e.toString().isNotEmpty) {
                                                                                //   String numberString = e.replaceAll(RegExp('[^0-9]'), '');
                                                                                //   _timerController.pause();
                                                                                //   Navigator.push(
                                                                                //       context,
                                                                                //       MaterialPageRoute(
                                                                                //           builder: (context) => ViewCauseList(
                                                                                //                 mainCauseListdata: {
                                                                                //                   "dateFrom": getddMMYYYY_with_splash(listDate![
                                                                                //                   showDate]
                                                                                //                       .toString()),
                                                                                //                   "dateTo": getddMMYYYY_with_splash(listDate![
                                                                                //                   showDate]
                                                                                //                       .toString()),
                                                                                //                   "courtNo":  displayData !=null
                                                                                //                       ? displayData
                                                                                //                       .ticker[
                                                                                //                   index]
                                                                                //                       .courtNo
                                                                                //                       .toString()
                                                                                //                       : "",
                                                                                //                   "sNo":numberString,
                                                                                //                   "type":e.toString().contains("D")?"Daily":"Supplementary",
                                                                                //                 },
                                                                                //                 isFromHomepage: true,
                                                                                //             isScrollToSno: true,
                                                                                //             isDownloadOption: true,
                                                                                //               isFilter: false
                                                                                //               ))).then((value) {
                                                                                //     _timerController.start();
                                                                                //   });
                                                                                // }
                                                                              },
                                                                              child: HighlightText(
                                                                                "$e" + "${casesList.indexOf(e) != casesList.length - 1 ? ", " : ""}",
                                                                                "(S)",
                                                                                mpHeadLine14(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    textColor: cas == -1 && item == -1
                                                                                        ? AppColor.black
                                                                                        : cas < item
                                                                                            ? Colors.grey
                                                                                            : AppColor.black),
                                                                                mpHeadLine14(fontWeight: FontWeight.w500, textColor: Colors.red),
                                                                              ),
                                                                            );
                                                                          }).toList(),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  casesList.length >
                                                                          1
                                                                      ? Positioned(
                                                                          left:
                                                                              0,
                                                                          child: InkWell(
                                                                              onTap: () {
                                                                                caseScrollController.jumpTo(caseScrollController.position.pixels - 40);
                                                                              },
                                                                              child: //caseScrollController.hasClients && caseScrollController.position.pixels==0?
                                                                                  const Icon(
                                                                                Icons.arrow_back_ios,
                                                                                size: 15,
                                                                              ) //:SizedBox(),
                                                                              ),
                                                                        )
                                                                      : SizedBox(),
                                                                  casesList.length >
                                                                          2
                                                                      ? Positioned(
                                                                          right:
                                                                              -2,
                                                                          child:
                                                                              InkWell(
                                                                            onTap:
                                                                                () {
                                                                              caseScrollController.jumpTo(caseScrollController.position.pixels + 40);
                                                                            },
                                                                            child:
                                                                                const Icon(
                                                                              Icons.arrow_forward_ios_rounded,
                                                                              size: 15,
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : SizedBox(),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  if (!isPrime(
                                                                      pref)) {
                                                                    FocusScope.of(
                                                                            context)
                                                                        .requestFocus(
                                                                            FocusNode());
                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        builder: (ctx) =>
                                                                            SafeArea(
                                                                              child: GoPrime(),
                                                                            ));
                                                                    return;
                                                                  }
                                                                  if (displayDataTickerList[
                                                                              index]
                                                                          .benchCount ==
                                                                      1) {
                                                                    var displayBoardSummary =
                                                                        {
                                                                      "dateToday": listDate !=
                                                                              null
                                                                          ? listDate![showDate]
                                                                              .toString()
                                                                          : "",
                                                                      "courtNo": displayData !=
                                                                              null
                                                                          ? displayDataTickerList[index]
                                                                              .courtNo
                                                                              .toString()
                                                                          : "",
                                                                      "benchName": displayData !=
                                                                              null
                                                                          ? displayDataTickerList[index]
                                                                              .benchList[0]
                                                                              .benchName
                                                                              .toString()
                                                                          : "",
                                                                    };
                                                                    // BlocProvider.of<
                                                                    //             DisplayBoardSummaryCubit>(
                                                                    //         context)
                                                                    //     .fetchDisplayBoardSummary(
                                                                    //         displayBoardSummary);

                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        barrierDismissible:
                                                                            true,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return CourtInfo(
                                                                              //displayData.ticker[index],
                                                                              displayBoardSummary);
                                                                        });
                                                                  } else {
                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        builder: (ctx) => AlertDialog(
                                                                            contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                                                            // insetPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                                                                            content: SizedBox(
                                                                              // height: 200,
                                                                              width: mediaQW(context) * 0.2,
                                                                              child: ListView.builder(
                                                                                itemCount: displayDataTickerList[index].benchList.length,
                                                                                shrinkWrap: true,
                                                                                scrollDirection: Axis.vertical,
                                                                                itemBuilder: (context, i) {
                                                                                  return InkWell(
                                                                                    onTap: () {
                                                                                      Navigator.pop(context);
                                                                                      showDialog(
                                                                                          context: context,
                                                                                          barrierDismissible: true,
                                                                                          builder: (BuildContext context) {
                                                                                            var displayBoardSummary = {
                                                                                              "dateToday": listDate != null ? listDate![showDate].toString() : "",
                                                                                              "courtNo": displayData != null ? displayDataTickerList[index].courtNo.toString() : "",
                                                                                              "benchName": displayDataTickerList[index].benchList[i].benchName.toString(),
                                                                                            };
                                                                                            return CourtInfo(displayBoardSummary);
                                                                                          });
                                                                                    },
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                      child: Column(
                                                                                        children: [
                                                                                          Text(
                                                                                            displayDataTickerList[index].benchList[i].benchName.toString(),
                                                                                            style: mpHeadLine14(),
                                                                                            textAlign: TextAlign.center,
                                                                                          ),
                                                                                          displayDataTickerList[index].benchList.length - 1 == index
                                                                                              ? SizedBox()
                                                                                              : const Divider(
                                                                                                  thickness: 1,
                                                                                                  color: AppColor.grey_color,
                                                                                                )
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                },
                                                                              ),
                                                                            ),
                                                                            actions: <Widget>[]));
                                                                  }
                                                                },
                                                                child:
                                                                    const Icon(
                                                                  Icons.info,
                                                                  color: AppColor
                                                                      .primary,
                                                                  size: 20,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 6,
                                                              ),
                                                              /*     displayDataTickerList[
                                                                              index]
                                                                          .is_court_note !=
                                                                      0
                                                                  ? InkWell(
                                                                      onTap:
                                                                          () {
                                                                        if (!isPrime(
                                                                            pref)) {
                                                                          FocusScope.of(context)
                                                                              .requestFocus(FocusNode());
                                                                          showDialog(
                                                                              context: context,
                                                                              builder: (ctx) => SafeArea(
                                                                                    child: GoPrime(),
                                                                                  ));
                                                                          return;
                                                                        }
                                                                        showDialog(
                                                                            context:
                                                                                context,
                                                                            barrierDismissible:
                                                                                true,
                                                                            builder:
                                                                                (BuildContext context) {
                                                                              var body = {
                                                                                "dateToday": listDate != null ? listDate![showDate].toString() : "",
                                                                                "courtNo": displayData != null ? displayDataTickerList[index].courtNo.toString() : "",
                                                                                "benchName": displayData != null ? displayDataTickerList[index].benchList[0].benchName.toString() : "",
                                                                                "isNoticeType": "1"
                                                                              };

                                                                              return CourtNote(body);
                                                                            });
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        padding:
                                                                            EdgeInsets.all(5),
                                                                        decoration: BoxDecoration(
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            color: AppColor.rejected_color_text),
                                                                        child:
                                                                            Text(
                                                                          "N",
                                                                          style: appTextStyle(
                                                                              textColor: AppColor.white,
                                                                              fontSize: 9,
                                                                              fontWeight: FontWeight.w600),
                                                                        ),
                                                                      )
                                                              )
                                                                  : SizedBox(),*/
                                                              Visibility(
                                                                visible: displayDataTickerList[
                                                                            index]
                                                                        .is_court_note !=
                                                                    0,
                                                                child: InkWell(
                                                                    onTap: () {
                                                                      if (!isPrime(
                                                                          pref)) {
                                                                        FocusScope.of(context)
                                                                            .requestFocus(FocusNode());
                                                                        showDialog(
                                                                            context:
                                                                                context,
                                                                            builder: (ctx) =>
                                                                                SafeArea(
                                                                                  child: GoPrime(),
                                                                                ));
                                                                        return;
                                                                      }
                                                                      showDialog(
                                                                          context:
                                                                              context,
                                                                          barrierDismissible:
                                                                              true,
                                                                          builder:
                                                                              (BuildContext context) {
                                                                            var body =
                                                                                {
                                                                              "dateToday": listDate != null ? listDate![showDate].toString() : "",
                                                                              "courtNo": displayData != null ? displayDataTickerList[index].courtNo.toString() : "",
                                                                              "benchName": displayData != null ? displayDataTickerList[index].benchList[0].benchName.toString() : "",
                                                                              "isNoticeType": "1"
                                                                            };

                                                                            return CourtNote(body);
                                                                          });
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              5),
                                                                      decoration: BoxDecoration(
                                                                          shape: BoxShape
                                                                              .circle,
                                                                          color:
                                                                              AppColor.rejected_color_text),
                                                                      child:
                                                                          Text(
                                                                        "N",
                                                                        style: appTextStyle(
                                                                            textColor: AppColor
                                                                                .white,
                                                                            fontSize:
                                                                                9,
                                                                            fontWeight:
                                                                                FontWeight.w600),
                                                                      ),
                                                                    )),
                                                                replacement: SizedBox(
                                                                    width: mediaQW(
                                                                            context) *
                                                                        0.04,
                                                                    height: mediaQH(
                                                                            context) *
                                                                        0.04),
                                                              ),
                                                              SizedBox(
                                                                width: displayDataTickerList[index]
                                                                            .is_court_note !=
                                                                        0
                                                                    ? 10
                                                                    : 10,
                                                              ),
                                                            ],
                                                          )),
                                                        ],
                                                      );
                                                    })),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Visibility(
                                        visible: isLoading,
                                        child: const Center(
                                            child: AppProgressIndicator()),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 150,
                                ),
                                BlocConsumer<PayRequestCubit, PayRequestState>(
                                    builder: (context, state) {
                                  return SizedBox();
                                }, listener: (context, state) {
                                  if (state is PayRequestLoading) {
                                    setState(() {
                                      // isLoading=true;
                                    });
                                  }
                                  if (state is PayRequestLoaded) {
                                    var model = state.model;
                                    if (model.result == 1 &&
                                        model.data != null) {
                                      toast(msg: model.msg!);
                                      pref.setBool(Constants.is_prime,
                                          model.data!.response!.isPrime == 1);
                                      pref.setString(
                                          Constants.plan_name,
                                          model.data!.response!.planName!
                                              .toLowerCase());
                                    } else {
                                      toast(msg: model.msg!);
                                    }
                                    setState(() {
                                      // isLoading=false;
                                    });
                                  }
                                  if (state is PayRequestError) {
                                    setState(() {
                                      // isLoading=false;
                                    });
                                    // if (state.message == "InternetFailure()") {
                                    //   toast(msg: "Please check internet connection");
                                    // } else {
                                    //   toast(msg: "Something went wrong");
                                    // }
                                  }
                                }),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        /*     _purchasePending == true
            ? const Stack(
                children: [
                  Opacity(
                    opacity: 0.3,
                    child: ModalBarrier(
                      dismissible: false,
                      color: Colors.grey,
                    ),
                  ),
                  Center(
                    child: CircularProgressIndicator(),
                  )
                ],
              )
            : SizedBox()*/
      ],
    );
  }

  void dashBardAPICalling() {
    print("dashBardAPICalling//////////////////");
    selectedDate = listDate![showDate];
    var body = {
      "dateToday": selectedDate,
    };
    BlocProvider.of<DisplayBoardCubit>(context).fetchDisplayBoard(body);
  }

  void updateDisplayBoard() {
    // print("this runtime ${this.runtimeType}");
    if (runtimeType == _Home_PageState) {
      // print("this msg is printing for homepage only");
      var fromDate = DateTime.now();
      // print("calling updateDisplayBoard ${listDate}");
      // print("calling updateDisplayBoard// ${showDate}");
      if (listDate != null &&
          listDate!.isNotEmpty &&
          getYYYYMMDDNew(fromDate.toString()) == listDate![showDate]) {
        selectedDate = listDate![showDate];
        var body = {
          "dateToday": selectedDate,
        };
        BlocProvider.of<UpdateDisplayBoardCubit>(context)
            .updateDisplayBoard(body);

        var bodyHomeMyTask = {
          "dateToday": "",
          "platformType":
              Platform.isAndroid ? "0" : "1" //o for android, 1 for iOS
        };
        BlocProvider.of<HomeMyTaskCubit>(context)
            .fetchHomeMyTask(bodyHomeMyTask);
        // toast(msg: "updating data",bgColor: Colors.red,txtColor: Colors.white);
        // print("calling updateDisplayBoard");
      }
    }
  }

  sortDisplayBoardData() {
    if (!isPrime(pref)) {
      List localList = displayDataTickerList;
      displayDataTickerList = [];
      localList.shuffle();
      print("displayDataTickerList11 ${displayDataTickerList.length}");

      int listLength = localList.length > 3 ? 3 : localList.length;

      for (int i = 0; i < listLength; i++) {
        displayDataTickerList.add(localList[i]);
      }
      displayDataTickerList.sort((a, b) {
        //print("first date ${a.date} second ${b.date}");
        if (a.courtNo != null && b.courtNo != null) {
          int court1 = a.courtNo;
          int court2 = b.courtNo;
          return court1!.compareTo(court2);
        } else {
          return a.courtNo!.compareTo(b.courtNo!);
        }
      });

      if (isCourtFilter) {
        displayDataTickerList = displayDataTickerList
            .where((element) => element.mycases.isNotEmpty)
            .toList();
      }
      // displayDataTickerList = List.generate(3, (index) => Random().nextInt(displayDataTickerList.length));
      print("displayDataTickerList end ${displayDataTickerList.length}");
    }
  }

  @override
  void dispose() {
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition = sgtl
          .iAP!
          .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    _subscription.cancel();
    WidgetsBinding.instance.removeObserver(this);
    // if (mytimer!.isActive) mytimer!.cancel();
    if (_timerController.hasListeners) {
      _timerController.dispose();
    }
    super.dispose();
  }

  ///iAP start

  void setSubscription(planName, sTime, eTime, pID) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> activeList = [];
    if (pref.getStringList("activePlanListPref") != null) {
      activeList.addAll(pref.getStringList("activePlanListPref")!);
    }
    // pref.setString('planName', planName);
    // pref.setString('planStartTime', sTime);
    // pref.setString('planEndTime', eTime);
    // pref.setString('planID', pID);
    // pref.setString('planBuyTime', DateTime.now().toString());
    String cDate = DateTime.now().toString();
    Map<String, String> planData = {
      "planName": planName,
      "planStartTime": sTime,
      "planEndTime": eTime,
      "planID": pID,
      "planBuyTime": cDate,
    };

    if (activeList.isNotEmpty) {
      bool planContains = false;
      for (var i in activeList) {
        if (jsonDecode(i)["planBuyTime"] == cDate) {
          planContains = true;
        }
      }
      if (planContains == false) {
        activeList.add(jsonEncode(planData));
      }
    } else {
      activeList.add(jsonEncode(planData));
    }
    pref.setStringList('activePlanListPref', activeList);
  }

  void checkIAP() async {
    _isAvailable = await sgtl.iAP!.isAvailable();
    print(_isAvailable);
    if (_isAvailable) {
      await _getUserProducts();
    }
  }

  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails is AppStorePurchaseDetails) {
        SKPaymentTransactionWrapper skProduct =
            (purchaseDetails as AppStorePurchaseDetails).skPaymentTransaction;
        print(skProduct.transactionState);
        if (skProduct.transactionState ==
            SKPaymentTransactionStateWrapper.failed) {
          setState(() {
            _purchasePending = false;
          });
        }
      }
      if (purchaseDetails.status == PurchaseStatus.pending) {
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          final bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            unawaited(deliverProduct(purchaseDetails));
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }
        // if (Platform.isAndroid) {
        //   if (!_kAutoConsume && purchaseDetails.productID == _kConsumableId) {
        //     final InAppPurchaseAndroidPlatformAddition androidAddition =
        //         _inAppPurchase.getPlatformAddition<
        //             InAppPurchaseAndroidPlatformAddition>();
        //     await androidAddition.consumePurchase(purchaseDetails);
        //   }
        // }
        if (purchaseDetails.pendingCompletePurchase) {
          await sgtl.iAP!.completePurchase(purchaseDetails);
        }
      }
    }
  }

  void showPendingUI() {
    setState(() {
      _purchasePending = true;
    });
  }

  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify purchase details before delivering the product.
    // if (purchaseDetails.productID == _kConsumableId) {
    //   await ConsumableStore.save(purchaseDetails.purchaseID!);
    //   final List<String> consumables = await ConsumableStore.load();
    //   setState(() {
    //     _purchasePending = false;
    //     _consumables = consumables;
    //   });
    // } else {
    setState(() {
      _purchases.add(purchaseDetails);
      sgtl.iAPCurrentPurchase = _purchases;
      validationID =
          purchaseDetails.verificationData.serverVerificationData.toString();
      if (Platform.isAndroid) {
        validateReceipt(purchaseDetails);
      } else {
        validateIOSReceipt(purchaseDetails);
      }

      // _purchasePending = false;
    });
    // }
  }

  void handleError(IAPError error) {
    setState(() {
      _purchasePending = false;
    });
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await sgtl.iAP!.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = <ProductDetails>[];
        _purchases = <PurchaseDetails>[];
        _notFoundIds = <String>[];
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    /// iOS Comment
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition = sgtl
          .iAP!
          .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    final ProductDetailsResponse productDetailResponse =
        await sgtl.iAP!.queryProductDetails(_kProductIds.toSet());
    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error!.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _notFoundIds = productDetailResponse.notFoundIDs;
      _purchasePending = false;
      _loading = false;
    });
  }

  // Method to retrieve product list
  Future<void> _getUserProducts() async {
    // Set<String> ids = {oneYearID, threeMonthsID, oneMonthsID};
    Set<String> ids = {
      'com.haelo.haeloapp.onemonthsilver',
      'com.haelo.haeloapp.onemonthgold',
      'com.haelo.haeloapp.onemonthplatinum',
      "com.haelo.haeloapp.sixmonthsilver",
      "com.haelo.haeloapp.sixmonthgold",
      "com.haelo.haeloapp.sixmonthplatinum",
      "com.haelo.haeloapp.twelvemonthgold_iOS",
      "com.haelo.haeloapp.twelvemonthplatinum",
      "com.haelo.haeloapp.twelvemonthsilver_iOS",
    };
    print("_kProductIds ==> ${_kProductIds.toSet()}");
    ProductDetailsResponse response = await sgtl.iAP!.queryProductDetails(ids);

    setState(() {
      _products = response.productDetails;
    });

    print("_getUserProducts ==> $_products");
    sgtl.iAPProducts = _products;
  }

  // checks if a user has purchased a certain product
  PurchaseDetails _hasUserPurchased(String productID) {
    return _purchases.firstWhere((purchase) => purchase.productID == productID);
  }

  void validateReceipt(PurchaseDetails purchaseDetails) {
    String data = purchaseDetails.verificationData.localVerificationData;
    Map<String, dynamic> receiptData = jsonDecode(data);
    print(purchaseDetails);
    Map<String, String> body = {};
    body['recieptData'] = jsonEncode(receiptData).toString();
    // body['planId'] = purchaseDetails.productID.toString();
    body['platformType'] = "0";

    if (purchaseDetails.verificationData.serverVerificationData.isNotEmpty &&
        purchaseDetails.productID.toString().isNotEmpty) {
      BlocProvider.of<PayRequestCubit>(context).payRequest(body);
      print("api Calling ==> payRequest");
    }
    /*  Map<String, String> receiptData = {};
    receiptData['receipt_data'] = "";
    receiptData['password'] = "";
    receiptData['exclude_old_transactions'] = "true";
    receiptData['url_type'] = "1";
    receiptData['plan_price'] = "0";
    BlocProvider.of<PayRequestCubit>(context).payRequest(receiptData);*/
    // dynamic data = {
    //   "receipt_data": validationID,
    //   "password": "86fe40c0040646fcaba640db896a6a09",
    //   "exclude_old_transactions": "true",
    //   "url_type": 1,
    //   "plan_price": 0
    // };
    // context.read<ReceiptValidCubit>().receiptValidation(context, data);
  }

  void validateIOSReceipt(PurchaseDetails purchaseDetails) {
    Map<String, String> receiptData = {};
    receiptData['recieptData'] =
        purchaseDetails.verificationData.serverVerificationData;
    receiptData['password'] = "dad1e1144bde4a8b8ff2702cb45ee2c3";
    receiptData['exclude_old_transactions'] = "true";
    // receiptData['url_type'] = "";
    // receiptData['planId'] = purchaseDetails.productID.toString();
    receiptData['platformType'] = "1";

    if (purchaseDetails.verificationData.serverVerificationData.isNotEmpty &&
        purchaseDetails.productID.toString().isNotEmpty) {
      BlocProvider.of<PayRequestCubit>(context).payRequest(receiptData);
      print("api Calling ==> payRequest");
    }

    // dynamic data = {
    //   "receipt_data": validationID,
    //   "password": "86fe40c0040646fcaba640db896a6a09",
    //   "exclude_old_transactions": "true",
    //   "url_type": 1,
    //   "plan_price": 0
    // };
    // context.read<ReceiptValidCubit>().receiptValidation(context, data);
  }

  Future<void> _saveCourtValue(bool isCourtFilter) async {
    print("isCourtFilter $isCourtFilter");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isCourtFilter', isCourtFilter);
  }

  Future<void> _getCourtValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isCourtFilter = prefs.getBool('isCourtFilter') ?? false;
    print("Retrieved value: $isCourtFilter");
  }

  /* Future<void> _saveSessionEndValue(bool isCourtFilter) async {
    print("isSessionEndPopUp $isCourtFilter");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('SessionEndPopUp', isSessionEndPopUp);
  }

  Future<void> _getSessionEndValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isSessionEndPopUp = prefs.getBool('SessionEndPopUp') ?? false;
    print("Retrieved SessionEndPopUp: $isSessionEndPopUp");
  }*/

  ///iAP end

  void updateTrialWarningShown() {
    trialWarningShown = false;
  }

  void updateSessionPopupShown() {
    var bodyTaskList = {
      "status": "0",
    };
    BlocProvider.of<HomePopupCubit>(context).fetchHomePopup(bodyTaskList);
  }

  void updateIsUnauthorized() {
    userIsUnauthorized = false;
  }
}

class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
