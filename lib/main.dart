import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:haelo_flutter/constants.dart';
import 'package:haelo_flutter/core/utils/project_singleton.dart';
import 'package:haelo_flutter/features/alert/cubit/add_event_cubit.dart';
import 'package:haelo_flutter/features/alert/cubit/auto_download/auto_download_cubit.dart';
import 'package:haelo_flutter/features/alert/cubit/delete_alert_cubit.dart';
import 'package:haelo_flutter/features/alert/cubit/delete_watchlist/delete_watchlist_cubit.dart';
import 'package:haelo_flutter/features/alert/cubit/edit_watchlist/edit_watchlist_cubit.dart';
import 'package:haelo_flutter/features/alert/cubit/my_alert_cubit.dart';
import 'package:haelo_flutter/features/bottom_bar/presentation/screens/bottom_nav_bar.dart';
import 'package:haelo_flutter/features/cases/cubit/cmt_suggestion/cmt_suggestion_cubit.dart';
import 'package:haelo_flutter/features/court_date_report/cubit/court_date_report_cubit.dart';
import 'package:haelo_flutter/features/drawer_content/cubit/coupons_cubit.dart';
import 'package:haelo_flutter/features/drawer_content/cubit/delete_account/delete_account_cubit.dart';
import 'package:haelo_flutter/features/home_page/cubit/update_display_board/update_display_board_cubit.dart';
import 'package:haelo_flutter/features/home_page/presentation/screens/home_pages.dart';
import 'package:haelo_flutter/features/in_app_purchase/cubit/my_subscription_cubit.dart';
import 'package:haelo_flutter/features/in_app_purchase/cubit/pay_request_cubit.dart';
import 'package:haelo_flutter/features/in_app_purchase/cubit/plans_cubit.dart';
import 'package:haelo_flutter/features/order_comment_history/cubit/order_comment_history_cubit.dart';
import 'package:haelo_flutter/features/userboard/presentation/screens/login.dart';
import 'package:haelo_flutter/services/firebase_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;

// TODO: Add stream controller
// import 'package:rxdart/rxdart.dart';

import 'core/utils/ui_helper.dart';
import 'features/cases/cubit/accountsdelete_cubit.dart';
import 'features/cases/cubit/addcomment_cubit.dart';
import 'features/cases/cubit/adddetails_cubit.dart';
import 'features/cases/cubit/addexpensesfees_cubit.dart';
import 'features/cases/cubit/casedetail_cubit.dart';
import 'features/cases/cubit/casedocuments_cubit.dart';
import 'features/cases/cubit/casehistory_cubit.dart';
import 'features/cases/cubit/casetasklist_cubit.dart';
import 'features/cases/cubit/comments_cubit.dart';
import 'features/cases/cubit/deletecomment_cubit.dart';
import 'features/cases/cubit/deletemycases_cubit.dart';
import 'features/cases/cubit/docdelete_cubit.dart';
import 'features/cases/cubit/drive_folder_creater_cubit.dart';
import 'features/cases/cubit/editcounsel_cubit.dart';
import 'features/cases/cubit/expenses_cubit.dart';
import 'features/cases/cubit/fees_cubit.dart';
import 'features/cases/cubit/mobileemailupdate_cubit.dart';
import 'features/cases/cubit/mycases_cubit.dart';
import 'features/cases/cubit/office_stage_cubit.dart';
import 'features/cases/cubit/paperdetail_cubit.dart';
import 'features/cases/cubit/update_manually_cubit.dart';
import 'features/cases/cubit/updatecomment_cubit.dart';
import 'features/causeslist/cubit/addcase_cubit.dart';
import 'features/causeslist/cubit/addcasetype_cubit.dart';
import 'features/causeslist/cubit/createcase_cubit.dart';
import 'features/causeslist/cubit/createwatchlist_cubit.dart';
import 'features/causeslist/cubit/hidecauselist_cubit.dart';
import 'features/causeslist/cubit/main_causelistdata_cubit.dart';
import 'features/causeslist/cubit/showwatchlist_cubit.dart';
import 'features/causeslist/cubit/viewandsave_cubit.dart';
import 'features/drawer_content/cubit/aboutus_cubit.dart';
import 'features/drawer_content/cubit/commentshistory_cubit.dart';
import 'features/drawer_content/cubit/faq_cubit.dart';
import 'features/drawer_content/cubit/hidden_causelist_cubit.dart';
import 'features/drawer_content/cubit/myteam_cubit.dart';
import 'features/drawer_content/cubit/myteampopup_cubit.dart';
import 'features/drawer_content/cubit/orderhistory_cubit.dart';
import 'features/drawer_content/cubit/profile_cubit.dart';
import 'features/drawer_content/cubit/profileupdate_cubit.dart';
import 'features/drawer_content/cubit/unhide_causelist_cubit.dart';
import 'features/google_drive/g_drive_handler/gdrivehandler_function.dart';
import 'features/home_page/cubit/court_summary_cubit.dart';
import 'features/home_page/cubit/court_summary_new_cubit.dart';
import 'features/home_page/cubit/display_board_cubit.dart';
import 'features/home_page/cubit/displayboard_item_stage_cubit.dart';
import 'features/home_page/cubit/displayboard_summary_cubit.dart';
import 'features/home_page/cubit/home_mytask_cubit.dart';
import 'features/home_page/cubit/home_popup_cubit.dart';
import 'features/home_page/cubit/home_tasklist_cubit.dart';
import 'features/in_app_purchase/cubit/plan_detail_cubit.dart';
import 'features/in_app_purchase/cubit/promo_code_detail_cubit.dart';
import 'features/mass_addition_of_case/cubit/displayboard_item_stage_cubit.dart';
import 'features/order_comment_history/cubit/order_cmt_history_cubit.dart';
import 'features/pending_order_report/cubit/pending_order_download_file_cubit.dart';
import 'features/pending_order_report/cubit/pending_order_report_cubit.dart';
import 'features/pending_order_report/cubit/pending_order_update_cubit.dart';
import 'features/splash/cubit/splash_cubit.dart';
import 'features/splash/presentation/screens/splash_screen.dart';
import 'features/task/cubit/createtask_cubit.dart';
import 'features/task/cubit/delete_mytask_cubit.dart';
import 'features/task/cubit/reassign_mytask_cubit.dart';
import 'features/task/cubit/task_caseno_cubit.dart';
import 'features/task/cubit/task_selectteam_cubit.dart';
import 'features/task/cubit/taskdetails_cubit.dart';
import 'features/task/cubit/taskdetailsbutton_cubit.dart';
import 'features/task/presentation/screens/mytasks.dart';
import 'features/ticker_data/cubit/ticker_data_cubit.dart';
import 'features/userboard/cubit/firm_register_cubit.dart';
import 'features/userboard/cubit/login_cubit.dart';
import 'features/userboard/cubit/login_verify_cubit.dart';
import 'features/userboard/cubit/update_trial_cubit.dart';
import 'features/userboard/cubit/user_loginregister_cubit.dart';
import 'locators.dart' as di;

// for passing messages from event handler to the UI
// final _messageStreamController = BehaviorSubject<RemoteMessage>();
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
var sgtl = Singleton.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  tz.initializeTimeZones();
  FirebaseService().startFirebaseNotification();
  // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  // FCMService().startFirebaseNotification();

  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });

  GoogleDriveHandler().setAPIKey(
    apiKey: Constants.api_key,
  );

  // final service = FlutterBackgroundService();
  // await service.configure(
  //     androidConfiguration: AndroidConfiguration(
  //       // this will be executed when app is in foreground or background in separated isolate
  //       onStart: onStart,
  //       // auto start service
  //       autoStart: true,
  //       isForegroundMode: true,
  //       // notificationChannelId: notificationChannelId, // this must match with notification channel you created above.
  //       // initialNotificationTitle: 'AWESOME SERVICE',
  //       // initialNotificationContent: 'Initializing',
  //       // foregroundServiceNotificationId: notificationId,
  //     ),
  //     iosConfiguration: IosConfiguration());
  await FlutterDownloader.initialize();
  print("firebase/// ${Firebase.apps}");
  // if (Firebase.apps.isEmpty) {
  //   Firebase.initializeApp();
  // }

  runApp(MyApp());
}

// Future<void> onStart(ServiceInstance service) async {
//   // Only available for flutter 3.0.0 and later
//   DartPluginRegistrant.ensureInitialized();
//
// }

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark));

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiBlocProvider(
      providers: [
        BlocProvider<SplashCubit>(
            create: (BuildContext context) => SplashCubit(di.locator())),
        BlocProvider<LoginCubit>(
            create: (BuildContext context) => LoginCubit(di.locator())),
        BlocProvider<LoginVerifyCubit>(
            create: (BuildContext context) => LoginVerifyCubit(di.locator())),
        BlocProvider<FirmRegisterCubit>(
            create: (BuildContext context) => FirmRegisterCubit(di.locator())),
        BlocProvider<UserLoginRegisterCubit>(
            create: (BuildContext context) =>
                UserLoginRegisterCubit(di.locator())),
        BlocProvider<HomeMyTaskCubit>(
            create: (BuildContext context) => HomeMyTaskCubit(di.locator())),
        BlocProvider<DisplayBoardCubit>(
            create: (BuildContext context) => DisplayBoardCubit(di.locator())),
        BlocProvider<CourtSummaryCubit>(
            create: (BuildContext context) => CourtSummaryCubit(di.locator())),
        BlocProvider<DisplayBoardSummaryCubit>(
            create: (BuildContext context) =>
                DisplayBoardSummaryCubit(di.locator())),
        BlocProvider<DisplayBoardItemStageCubit>(
            create: (BuildContext context) =>
                DisplayBoardItemStageCubit(di.locator())),
        BlocProvider<HomeTaskListCubit>(
            create: (BuildContext context) => HomeTaskListCubit(di.locator())),
        BlocProvider<TaskCaseNoCubit>(
            create: (BuildContext context) => TaskCaseNoCubit(di.locator())),
        BlocProvider<TaskSelectTeamCubit>(
            create: (BuildContext context) =>
                TaskSelectTeamCubit(di.locator())),
        BlocProvider<CreateTaskCubit>(
            create: (BuildContext context) => CreateTaskCubit(di.locator())),
        BlocProvider<TaskDetailCubit>(
            create: (BuildContext context) => TaskDetailCubit(di.locator())),
        BlocProvider<TaskDetailsButtonCubit>(
            create: (BuildContext context) =>
                TaskDetailsButtonCubit(di.locator())),
        BlocProvider<MainCauseListDataCubit>(
            create: (BuildContext context) =>
                MainCauseListDataCubit(di.locator())),
        // BlocProvider<ViewCauseListCubit>(
        //     create: (BuildContext context) => ViewCauseListCubit(di.locator())),
        BlocProvider<AddCaseCubit>(
            create: (BuildContext context) => AddCaseCubit(di.locator())),
        BlocProvider<AddCaseTypeCubit>(
            create: (BuildContext context) => AddCaseTypeCubit(di.locator())),
        BlocProvider<CauseListCreateCaseCubit>(
            create: (BuildContext context) =>
                CauseListCreateCaseCubit(di.locator())),
        BlocProvider<HideCauseListCubit>(
            create: (BuildContext context) => HideCauseListCubit(di.locator())),
        BlocProvider<HiddenCauseListCubit>(
            create: (BuildContext context) =>
                HiddenCauseListCubit(di.locator())),
        BlocProvider<UnHideCauseListCubit>(
            create: (BuildContext context) =>
                UnHideCauseListCubit(di.locator())),
        BlocProvider<DeleteMyTaskCubit>(
            create: (BuildContext context) => DeleteMyTaskCubit(di.locator())),
        BlocProvider<ReassignMyTaskCubit>(
            create: (BuildContext context) =>
                ReassignMyTaskCubit(di.locator())),
        BlocProvider<MyCasesCubit>(
            create: (BuildContext context) => MyCasesCubit(di.locator())),
        BlocProvider<PaperDetailCubit>(
            create: (BuildContext context) => PaperDetailCubit(di.locator())),
        BlocProvider<CaseDetailCubit>(
            create: (BuildContext context) => CaseDetailCubit(di.locator())),
        BlocProvider<MobileEmailUpdateCubit>(
            create: (BuildContext context) =>
                MobileEmailUpdateCubit(di.locator())),
        BlocProvider<CasesCommentCubit>(
            create: (BuildContext context) => CasesCommentCubit(di.locator())),
        BlocProvider<AddCommentCubit>(
            create: (BuildContext context) => AddCommentCubit(di.locator())),
        BlocProvider<DeleteCommentCubit>(
            create: (BuildContext context) => DeleteCommentCubit(di.locator())),
        BlocProvider<UpdateCommentCubit>(
            create: (BuildContext context) => UpdateCommentCubit(di.locator())),
        BlocProvider<ProfileCubit>(
            create: (BuildContext context) => ProfileCubit(di.locator())),
        BlocProvider<ProfileUpdateCubit>(
            create: (BuildContext context) => ProfileUpdateCubit(di.locator())),
        BlocProvider<MyTeamCubit>(
            create: (BuildContext context) => MyTeamCubit(di.locator())),
        BlocProvider<CommentsHistoryCubit>(
            create: (BuildContext context) =>
                CommentsHistoryCubit(di.locator())),
        BlocProvider<OrderHistoryCubit>(
            create: (BuildContext context) => OrderHistoryCubit(di.locator())),
        BlocProvider<ExpensesCubit>(
            create: (BuildContext context) => ExpensesCubit(di.locator())),
        BlocProvider<FeesCubit>(
            create: (BuildContext context) => FeesCubit(di.locator())),
        BlocProvider<AddExpensesFeesCubit>(
            create: (BuildContext context) =>
                AddExpensesFeesCubit(di.locator())),
        BlocProvider<AccountsDeleteCubit>(
            create: (BuildContext context) =>
                AccountsDeleteCubit(di.locator())),
        BlocProvider<DeleteMyCaseCubit>(
            create: (BuildContext context) => DeleteMyCaseCubit(di.locator())),
        BlocProvider<CaseHistoryCubit>(
            create: (BuildContext context) => CaseHistoryCubit(di.locator())),
        BlocProvider<EditCounselCubit>(
            create: (BuildContext context) => EditCounselCubit(di.locator())),
        BlocProvider<CaseTaskListCubit>(
            create: (BuildContext context) => CaseTaskListCubit(di.locator())),
        BlocProvider<CaseDocumentsCubit>(
            create: (BuildContext context) => CaseDocumentsCubit(di.locator())),
        BlocProvider<AddDetailsCubit>(
            create: (BuildContext context) => AddDetailsCubit(di.locator())),
        BlocProvider<DocDeleteCubit>(
            create: (BuildContext context) => DocDeleteCubit(di.locator())),
        BlocProvider<ViewSaveCubit>(
            create: (BuildContext context) => ViewSaveCubit(di.locator())),
        BlocProvider<CreateWatchlistCubit>(
            create: (BuildContext context) =>
                CreateWatchlistCubit(di.locator())),
        BlocProvider<ShowWatchlistCubit>(
            create: (BuildContext context) => ShowWatchlistCubit(di.locator())),
        BlocProvider<MyTeamPopupCubit>(
            create: (BuildContext context) => MyTeamPopupCubit(di.locator())),
        BlocProvider<AboutUsCubit>(
            create: (BuildContext context) => AboutUsCubit(di.locator())),
        BlocProvider<FAQCubit>(
            create: (BuildContext context) => FAQCubit(di.locator())),
        BlocProvider<UpdateDisplayBoardCubit>(
            create: (BuildContext context) =>
                UpdateDisplayBoardCubit(di.locator())),
        BlocProvider<MyAlertCubit>(
            create: (BuildContext context) => MyAlertCubit(di.locator())),
        BlocProvider<DeleteAlertCubit>(
            create: (BuildContext context) => DeleteAlertCubit(di.locator())),
        BlocProvider<AddEventCubit>(
            create: (BuildContext context) => AddEventCubit(di.locator())),
        BlocProvider<AutoDownloadCubit>(
            create: (BuildContext context) => AutoDownloadCubit(di.locator())),
        BlocProvider<DeleteAccountCubit>(
            create: (BuildContext context) => DeleteAccountCubit(di.locator())),
        BlocProvider<OrderCommentHistoryCubit>(
            create: (BuildContext context) =>
                OrderCommentHistoryCubit(di.locator())),
        BlocProvider<DeleteWatchlistCubit>(
            create: (BuildContext context) =>
                DeleteWatchlistCubit(di.locator())),
        BlocProvider<EditWatchlistCubit>(
            create: (BuildContext context) => EditWatchlistCubit(di.locator())),
        BlocProvider<PlansCubit>(
            create: (BuildContext context) => PlansCubit(di.locator())),
        BlocProvider<MySubscriptionCubit>(
            create: (BuildContext context) =>
                MySubscriptionCubit(di.locator())),
        BlocProvider<PayRequestCubit>(
            create: (BuildContext context) => PayRequestCubit(di.locator())),
        BlocProvider<CourtDateReportCubit>(
            create: (BuildContext context) =>
                CourtDateReportCubit(di.locator())),
        BlocProvider<CommentSuggestionCubit>(
            create: (BuildContext context) =>
                CommentSuggestionCubit(di.locator())),
        BlocProvider<TickerDataCubit>(
            create: (BuildContext context) => TickerDataCubit(di.locator())),
        BlocProvider<DisplayBoardMassDataCubit>(
            create: (BuildContext context) =>
                DisplayBoardMassDataCubit(di.locator())),
        BlocProvider<PlanDetailCubit>(
            create: (BuildContext context) => PlanDetailCubit(di.locator())),
        BlocProvider<PendingOrderReportCubit>(
            create: (BuildContext context) =>
                PendingOrderReportCubit(di.locator())),
        BlocProvider<OfficeStageCubit>(
            create: (BuildContext context) => OfficeStageCubit(di.locator())),
        BlocProvider<UpdateTrialCubit>(
            create: (BuildContext context) => UpdateTrialCubit(di.locator())),
        BlocProvider<CourtSummaryNewCubit>(
            create: (BuildContext context) =>
                CourtSummaryNewCubit(di.locator())),
        BlocProvider<UpdateManuallyCubit>(
            create: (BuildContext context) =>
                UpdateManuallyCubit(di.locator())),
        BlocProvider<PendingOrderDownloadFileCubit>(
            create: (BuildContext context) =>
                PendingOrderDownloadFileCubit(di.locator())),
        BlocProvider<HomePopupCubit>(
            create: (BuildContext context) => HomePopupCubit(di.locator())),
        BlocProvider<PromoCodesCubit>(
            create: (BuildContext context) => PromoCodesCubit(di.locator())),
        BlocProvider<CouponsCubit>(
            create: (BuildContext context) => CouponsCubit(di.locator())),
        BlocProvider<PendingOrderUpdateCubit>(
            create: (BuildContext context) =>
                PendingOrderUpdateCubit(di.locator())),
        /*BlocProvider<OrderCmtHistoryCubit>(
            create: (BuildContext context) =>
                OrderCmtHistoryCubit(di.locator())),*/
        BlocProvider<DriveFolderCreatorCubit>(
            create: (BuildContext context) =>
                DriveFolderCreatorCubit(di.locator())),
      ],
      child: MaterialApp(
        title: 'HAeLO',
        theme: ThemeData(
            useMaterial3: false,
            primarySwatch: Colors.blue,
            /*  colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.yellow, background: Colors.red),*/
            appBarTheme: const AppBarTheme(
              color: Colors.white,
              elevation: 1.0,
              iconTheme:
                  IconThemeData(color: AppColor.bold_text_color_dark_blue),
            )),
        //home: SplashScreen(),
        navigatorKey: navigatorKey,
        builder: EasyLoading.init(),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/': (context) => const SplashScreen(),
          // When navigating to the "/second" route, build the SecondScreen widget.
          '/Login': (context) => const Login(),
          '/bottomBar': (context) => BottomNavBar(
                bottom: 0,
              ),
          '/HomePage': (context) => const HomePage(),
          '/MyTasks': (context) => const MyTasks(),
          // '/CauseList': (context) => const CauseList(),
          // '/MyCases': (context) => const MyCases(),
          //  '/CaseDetails': (context) => const CaseDetails(),
        },
      ),
    );
  }
}
