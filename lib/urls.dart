class Urls {
  // baseUrl ==>  https://haeloapp.in/staging/api/

  ///STAGING
  // static const String BASE_URL = 'https://haeloapp.in/staging/api/';
/*  static const String BASE_URL =
      'https://m45dn3wc-5000.inc1.devtunnels.ms/api/';*/

  ///LIVE
  static const String BASE_URL = 'https://haeloapp.in/api/';

  ///LIVE

  // app version on Splash
  static const String APP_VERSION = 'version-config';

  // admin-users(firm id) on Login
  static const String ADMIN_USER = 'login/admin-users';
  static const String LOGIN_VERIFY = 'login/verify';

  //firm registration during login
  static const String FIRM_REGISTER = 'firm-registration';

  //firm login and team login and register
  static const String USER_LOGINREGISTER = 'user/login-register';

  //home my task
  static const String HOME_MYTASK = 'home/mytask';

  //home page court summary
  static const String COURT_SUMMARY = 'home/court-summary';
  static const String COURT_SUMMARY_NEW = 'home/court-summary-new';

  //home page display board
  static const String DISPLAY_BOARD = 'display-board';

  //home page display board summary
  static const String DISPLAYBOARD_SUMMARY = 'home/summary';
  static const String DISPLAYBOARD_ITEMSTAGE = 'item-stage';

  //home page task list
  static const String HOME_TASKLIST = 'task-list';

//  create task case number
  static const String Task_CASENO = 'caseno-listing';

//  create task, select team
  static const String TASK_SELECTTEAM = 'admin/myteam';

//  main create task API
  static const String CREATE_TASK = 'admin/create-task';

//  task details in task
  static const String TASK_DETAILS = 'task-detail';

//  delete in my task
  static const String DELETE = 'admin/update-task';

//  Re-assign in My Task
  static const String REASSIGN = 'admin/update-task';

//  task details button
  static const String TASKDETAILS_BUTTON = 'admin/update-status';

  // main cause list data
  static const String CAUSELIST_MAIN = 'highcourt-data';

//  view cause list
  static const String VIEW_CAUSELIST = 'highcourt-listing';

//  Add Case
  static const String ADD_CASE = 'admin/add-case';

//  Case Type in Add Case
  static const String CASE_TYPE = 'case/case-type';

//  Show Watchlist in Save and View of Cause Watchlist
  static const String SHOW_WATCHLIST = 'case/watchlist';

//  Create Case in View Cause List
  static const String CREATE_CASE = 'causelist/create-mycase';

//  Create Watchlist in View and Save of CauseList
  static const String CREATE_WATCHLIST = 'case/create-watchlist';

//  View and Save in CauseList
  static const String VIEW_SAVE = 'user-config';

//  hide in view case list
  static const String Hide = 'causelist/hide-case';

//  hidden cause list in drawer content
  static const String HIDDEN_LIST = 'view-hidecauselist';

//  unhide the hidden cause list in drawer content
  static const String UNHIDE = 'unhide-causelist';

//  My Cases
  static const String MY_CASES = 'task/case-listing';
  static const String ADD_IMMEDIATE_CASE = 'case/add-immediate-case';

//  Delete My Cases
  static const String DELETEMY_CASES = 'case/delete';

//  Paper Details in My cases (Case Details)
  static const String PAPER_DETAILS = 'case/paper-details';

//  Case Details in My Cases (Case Details)
  static const String CASE_DETAILS = 'case/case-detail';

//  Mobile Email Itmo Update in My Case
  static const String MOBEMAIL_UPDATE = 'case/email-update';

//  Comments Tab Bar View in My Cases
  static const String COMMENT_TAB = 'case/comment-list';

//  Add Details in Edit of Documents
  static const String ADD_DETAILS = 'case/edit/document-content';

//  Add Comment in My Cases
  static const String ADD_COMMENT = 'case/comment';

//  Delete Comment in My Cases
  static const String DELETE_COMMENT = 'case/comment-delete';

  //Update Comment in My Cases
  static const String UPDATE_COMMENT = 'case/comment-edit';

//  Expenses in My Cases
  static const String EXPENSES = 'case/expenses';

//  Delete Documents in My Cases
  static const String DOC_DELETE = 'case/delete-docx';

//  Documents in My Cases
  static const String DOCUMENTS = 'case/upload-docx';

//  Task List in My Cases
  static const String TASKLIST = 'case/connected-tasklist';

//  Case History in My Cases
  static const String CASE_HISTORY = 'case/case-history';

//  Case History Edit Counsel in My Cases
  static const String EDIT_COUNSEL = 'case/edit-counsel';

//  Add Expenses/Fees in My Cases
  static const String ADDFEES_EXPENSES = 'case/add-accounts';

//  Delete Expenses/Fees in My Cases
  static const String DELETEFEES_EXPENSES = 'case/delete-accounts';

//  Fees in My Cases
  static const String FEES = 'case/fees';

//  Profile in Drawer
  static const String PROFILE = 'user/view-profile';

//  Update Profile in Drawer
  static const String UPDATE_PROFILE = 'user/editProfile';

//  My Team in Drawer
  static const String MY_TEAM = 'admin/myteam';

//  Comments History in Drawer
  static const String COMMENTS_HISTORY = 'sidebar/comment-history';

//  About Us in Drawer
  static const String ABOUT_US = 'user/about-app';

//  FAQ in Drawer
  static const String FAQ = 'user/faqs';

//  Order History in Drawer
  static const String ORDER_HISTORY = 'sidebar/order-history';

//  My Team Popup in Drawer
  static const String TEAM_POPUP = 'admin/manage-team';

  // update display board data
  static const String REFRESH_DISPLAY_BOARD = 'display-board-refresh';

  // update display board data
  static const String VIEW_ALERT = 'view-user-alert';

  // delete alert
  static const String DELETE_ALERT = 'delete-user-alert';

  // Add event to calendar
  static const String SET_CALENDAR_EVENT = 'set-calendar-alert';

  // auto download pdf
  static const String PDF_DOWNLOAD = 'user/pdf-download';
  static const String PDF_DOWNLOAD_NOTIFICATION = 'highcourt-listing-pdf';

  // delete account
  static const String USER_DELETE = 'user/delete';

  // quick-search-listing
  static const String QUICK_SEARCH_LISTING = 'cause/quick-search-listing';

  // order-comment-history
  static const String ORDER_COMMENT_HISTORY = 'case/order-comment-history';

  // delete watchlist > my alert
  static const String DELETE_WATCHLIST = 'case/delete-watchlist';

  // edit watchlist > case and lawyer
  static const String EDIT_WATCHLIST = 'case/edit-watchlist';

  // All plans
  static const String PLANS = 'pay/plan-details';

  // my subscription
  static const String MY_SUBSCRIPTION = 'pay/my-subscription';

  // pay transaction (to save data in db)
  static const String PAY_REQUIEST = 'pay/pay-request';

  // court-date-listing
  static const String COURT_DATE_LISTING = 'case/court-date-listing';

  // comment suggestion
  static const String CMT_SUGGESTION = 'case/suggestion-comments';
  static const String DRIVE_FOLDER_CREATOR = 'case/drive-folder-creater';

  // new ticker data table at display board
  static const String TICKER_DATA = 'ticker-data';

  static const String MASS_DATA = 'mass-cases';
  static const String PLAN_DETAILS = 'pay/plan-content';
  static const String PROMOCODE_DETAILS = 'pay/promocode-details';
  static const String PENDING_ORDER_REPORT = 'case/pending-order-report';
  static const String OFFICE_STAGE = 'office-stage';
  static const String MY_CASES_DOCUMENT = 'mycases/document/download';
  static const String UPDATE_TRIAL = 'pay/update-trial-popup';

  static const String HOME_APP_NOTIFICATION = 'home/app-notification';
  static const String PROMOCODES_LISTS = 'pay/promocode-list';
  static const String UPDATE_PENDING_ORDER = 'case/update-pennding-order';
}

//Absorve pointer
