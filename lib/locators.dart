import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/locators/court_date_report_locator.dart';
import 'package:haelo_flutter/locators/delete_account_locator.dart';
import 'package:haelo_flutter/locators/my_alert_locator.dart';
import 'package:haelo_flutter/locators/order_cmt_history_locator.dart';
import 'package:haelo_flutter/locators/pending_order_report_locator.dart';
import 'package:haelo_flutter/locators/plans_locator.dart';
import 'package:haelo_flutter/locators/update_display_board_locator.dart';
import 'package:haelo_flutter/services/network_service.dart';
import 'package:haelo_flutter/urls.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'core/utils/network_info.dart';
import 'locators/aboutus_locator.dart';
import 'locators/accountsdelete_locator.dart';
import 'locators/addcaseType_locator.dart';
import 'locators/addcase_locator.dart';
import 'locators/addcomment_locator.dart';
import 'locators/adddetails_locator.dart';
import 'locators/addexpensesfees_locator.dart';
import 'locators/casedetail_locator.dart';
import 'locators/casedocuments_locator.dart';
import 'locators/casehistory_locator.dart';
import 'locators/casetasklist_locator.dart';
import 'locators/comments_locator.dart';
import 'locators/commentshistory_locator.dart';
import 'locators/coupons_locator.dart';
import 'locators/court_summary_locator.dart';
import 'locators/court_summary_new_locator.dart';
import 'locators/createcase_locator.dart';
import 'locators/createtask_locator.dart';
import 'locators/createwatchlist_locator.dart';
import 'locators/delete_mytask_locator.dart';
import 'locators/deletecase_locator.dart';
import 'locators/deletemycases_locator.dart';
import 'locators/display_board_locator.dart';
import 'locators/displayboard_mass_data_locator.dart';
import 'locators/displayboard_stage_item_locator.dart';
import 'locators/displayboard_summary_locator.dart';
import 'locators/docdelete_locator.dart';
import 'locators/drive_folder_creater.dart';
import 'locators/editcounsel_locator.dart';
import 'locators/expenses_locator.dart';
import 'locators/faq_locator.dart';
import 'locators/fees_locator.dart';
import 'locators/firm_register_locator.dart';
import 'locators/hidden_causelist_locator.dart';
import 'locators/hidecauselist_locator.dart';
import 'locators/home_mytask_locator.dart';
import 'locators/home_popup_locator.dart';
import 'locators/home_tasklist_locator.dart';
import 'locators/login_locator.dart';
import 'locators/login_verify_locator.dart';
import 'locators/main_causelistdata_locator.dart';
import 'locators/mobileemailupdate_locator.dart';
import 'locators/mycases_locator.dart';
import 'locators/myteam_locator.dart';
import 'locators/myteampopup_locator.dart';
import 'locators/office_Stage_locator.dart';
import 'locators/order_cmt_history_new.dart';
import 'locators/orderhistory_locator.dart';
import 'locators/paperdetail_locator.dart';
import 'locators/pending_order_download_file_locator.dart';
import 'locators/pending_order_update_locator.dart';
import 'locators/plan_details_locator.dart';
import 'locators/profile_locator.dart';
import 'locators/profileupdate_locator.dart';
import 'locators/promo_codes_locator.dart';
import 'locators/reassign_mytask_locator.dart';
import 'locators/showwatchlist_locator.dart';
import 'locators/splash_locator.dart';
import 'locators/task_caseno_locator.dart';
import 'locators/task_selectteam_locator.dart';
import 'locators/taskdetails_locator.dart';
import 'locators/taskdetailsbutton_locator.dart';
import 'locators/ticker_data_locator.dart';
import 'locators/unhide_causelist_locator.dart';
import 'locators/update_manually_locator.dart';
import 'locators/update_trial_locator.dart';
import 'locators/updatecomment_locator.dart';
import 'locators/user_loginregister_locator.dart';
import 'locators/viewandsave_locator.dart';
import 'locators/viewcauselist_locator.dart';

GetIt locator = GetIt.instance;

Future<void> init() async {
  //Http Client
  locator.registerLazySingleton<http.Client>(() => http.Client());

  //Network service
  locator.registerLazySingleton<NetworkService>(
    () => NetworkService(
      // baseUrl: "https://haeloapp.in/staging/api/", //STAGING
      baseUrl: Urls.BASE_URL, //"https://haeloapp.in/api/", //LIVE
      defaultHeaders: {
        //'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
        //'Authorization': prefs.getString('token') ?? '',
      },
      httpService: locator<http.Client>(),
    ),
  );

  // shared preferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  locator.registerLazySingleton<SharedPreferences>(
    () => prefs,
  );

  // data connection checker
  locator.registerLazySingleton<DataConnectionChecker>(
    () => DataConnectionChecker(),
  );

  // network info
  locator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      locator<DataConnectionChecker>(),
    ),
  );

  // locator.registerSingleton<FCMNotificationService>(FCMNotificationService());   //uncomment when use fcm

  await splashLocator();
  await loginLocator();
  await loginVerifyLocator();
  await firmRegisterLocator();
  await userLoginRegisterLocator();
  await HomeMyTaskLocator();
  await DisplayBoardLocator();
  await updateDisplayBoardLocator();
  await CourtSummaryLocator();
  await DisplayBoardSummaryLocator();
  await HomeTaskListLocator();
  await TaskCaseNoLocator();
  await TaskSelectTeamLocator();
  await CreateTaskLocator();
  await TaskDetailLocator();
  await TaskDetailsButtonLocator();
  await MainCauseListDataLocator();
  await ViewCauseListLocator();
  await AddCaseLocator();
  await AddCaseTypeLocator();
  await CauseListCreateCaseLocator();
  await HideCauseListLocator();
  await HiddenCauseListLocator();
  await UnHideCauseListLocator();
  await DeleteMyTaskLocator();
  await ReassignMyTaskLocator();
  await MyCasesLocator();
  await PaperDetailLocator();
  await CaseDetailLocator();
  await MobileEmailUpdateLocator();
  await CasesCommentLocator();
  await AddCommentLocator();
  await DeleteCommentLocator();
  await UpdateCommentLocator();
  await ProfileLocator();
  await ProfileUpdateLocator();
  await MyTeamLocator();
  await CommentsHistoryLocator();
  await OrderHistoryLocator();
  await ExpensesLocator();
  await FeesLocator();
  await AddExpensesFeesLocator();
  await AccountsDeleteLocator();
  await DeleteMyCaseLocator();
  await CaseHistoryLocator();
  await EditCounselLocator();
  await CaseTaskListLocator();
  await CaseDocumentsLocator();
  await AddDetailsLocator();
  await DocDeleteLocator();
  await ViewSaveLocator();
  await CreateWatchlistLocator();
  await ShowWatchlistLocator();
  await MyTeamPopupLocator();
  await AboutUsDeleteLocator();
  await FAQLocator();
  await MyAlertLocator();
  await deleteAccountLocator();
  await orderCommentHistoryLocator();
  await plansLocator();
  await courtDateReportLocator();
  await TickerDataLocator();
  await DisplayBoardStageItemLocator();
  await DisplayBoardMassDataLocator();
  await PlanDetailsLocator();
  await PendingOrderReportLocator();
  await OfficeStageLocator();
  await UpdateTrialLocator();
  await CourtSummaryNewLocator();
  await UpdateManuallyLocator();
  await PendingOrderDownloadFileLocator();
  await HomePopupLocator();
  await PromoCodesLocator();
  await CouponsLocator();
  await PendingOrderUpdateLocator();
  // await OrderCmtHistoryNewLocator();
  await DriveFolderCreatorLocator();
}
