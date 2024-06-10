class Constants {
  //failures
  static const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
  static const String UNEXPECTED_FAILURE = 'Unexpected Failure';

  //User
  static const String ACCESS_TOKEN = "access_token";
  static const String USER_NAME = "user_name";
  static const String USER_IMAGE = "user_image";
  static const String USER_PHONE = "user_phone";
  static const String USER_ID = "user_id";
  static const String FIRM_ID = "firm_id";
  static const String MOB_NO = "mobile_no";
  static const String USER_TYPE = "userType"; // 1 for office, 2 for member
  static const String ROLE_TYPE = "role_type";
  static const String IS_LOGIN = 'is_login';
  static const String LOGIN_FLAG =
      'login_flag'; //0 normal login, 1 google, 2 guest(skip)
  static const String FCM_PUSH_TOKEN = 'push_token';

  static const String alertDeactive = 'Session Expired';
  static const String alertDeactiveMsg =
      "Your session is expired.\n Please login again.";

  //setting
  static const String notification_sound = 'sound';
  static const String auto_download = 'download';
  static const String calendar_event_add = 'event';

  //others
  static const String version = '2.0'; //this is api version
  static const String app_version = '';
  static const String is_court_filter = 'is_court_filter';

  //in app purchase
  static const String is_prime = 'is_prime';

  ///true= active plan, false= free plan
  static const String plan_name = 'plan_name'; // trail, silver, gold
  static const String trailPlan = 'trial';
  // static const String   freePlan = 'free';
  static const String silverPlan = 'silver';
  static const String goldPlan = 'gold';
  static const String platinumPlan = 'platinum';

  /// android play console inapp purchase id's
  static const String oneMonthGold = "com.haelo.haeloapp.onemonthgold";
  static const String oneMonthPlatinum = "com.haelo.haeloapp.onemonthplatinum";
  static const String oneMonthSilver = "com.haelo.haeloapp.onemonthsilver";
  static const String sixMonthGold = "com.haelo.haeloapp.sixmonthgold";
  static const String sixMonthSilver = "com.haelo.haeloapp.sixmonthsilver";
  static const String sixMonthPlatinum = "com.haelo.haeloapp.sixmonthplatinum";
  static const String twelveMonthGold = "com.haelo.haeloapp.twelvemonthgold";
  static const String twelveMonthGoldIOS =
      "com.haelo.haeloapp.twelvemonthgold_iOS";
  static const String twelveMonthPlatinum =
      "com.haelo.haeloapp.twelvemonthplatinum";
  static const String twelveMonthSilver =
      "com.haelo.haeloapp.twelvemonthsilver";
  static const String twelveMonthSilverIOS =
      "om.haelo.haeloapp.twelvemonthsilver_iOS";

  // android play console promo code  in app purchase id's
  static const String oneMonthSilverPromoCode =
      "com.haelo.haeloapp.onemonthsilver_pm";

  static const String oneMonthGoldPromoCode =
      "com.haelo.haeloapp.onemonthgold_pm";

  static const String oneMonthPlatinumPromoCode =
      "com.haelo.haeloapp.onemonthplatinum_pm";

  /// add more promo codes for platinum

  static const String sixMonthGoldPromoCode =
      "com.haelo.haeloapp.sixmonthgold_pm";
  static const String sixMonthSilverPromoCode =
      "com.haelo.haeloapp.sixmonthsilver_pm";
  static const String sixMonthPlatinumPromoCode =
      "com.haelo.haeloapp.sixmonthplatinum_pm";

  static const String twelveMonthSilverPromoCode =
      "com.haelo.haeloapp.twelvemonthsilver_pm";
  static const String twelveMonthGoldPromoCode =
      "com.haelo.haeloapp.twelvemonthgold_pm";
  static const String twelveMonthPlatinumPromoCode =
      "com.haelo.haeloapp.twelvemonthplatinumpm";

  static const String oneMonthSilverThreePromoCode =
      "com.haelo.haeloapp.onemonthsil_three_pm";
  static const String oneMonthGoldThreePromoCode =
      "com.haelo.haeloapp.onemonthgold_three_pm";
  static const String oneMonthPlatinumThreePromoCode =
      "com.haelo.haeloapp.onemonththreeplati_pm";

  static const String oneMonthSilverFivePromoCode =
      "com.haelo.haeloapp.onemonthsil_five_pm";
  static const String oneMonthGoldFivePromoCode =
      "com.haelo.haeloapp.onemonthgold_five_pm";
  static const String oneMonthPlatinumFivePromoCode =
      "com.haelo.haeloapp.onemonthplati_five_pm";

  static const String sixMonthSilverThreePromoCode =
      "com.haelo.haeloapp.sixmonthsil_three_pm";
  static const String sixMonthGoldThreePromoCode =
      "com.haelo.haeloapp.sixmonthgold_three_pm";
  static const String sixMonthPlatinumThreePromoCode =
      "com.haelo.haeloapp.sixmonthplati_threepm";

  static const String sixMonthSilverFivePromoCode =
      "com.haelo.haeloapp.sixmonthsil_five_pm";
  static const String sixMonthGoldFivePromoCode =
      "com.haelo.haeloapp.sixmonthgold_five_pm";
  static const String sixMonthPlatinumFivePromoCode =
      "com.haelo.haeloapp.sixmonthplati_five_pm";

  static const String twelveMonthSilverThreePromoCode =
      "com.haelo.haeloapp.twelvemonthsilver3_pm";
  static const String twelveMonthGoldThreePromoCode =
      "com.haelo.haeloapp.twelvemonthgold_3_pm";
  static const String twelveMonthPlatinumThreePromoCode =
      "com.haelo.haeloapp.twelvemonthplati_3_pm";

  static const String twelveMonthSilverFivePromoCode =
      "com.haelo.haeloapp.twelvemonthsilver5_pm";
  static const String twelveMonthGoldFivePromoCode =
      "com.haelo.haeloapp.twelvemonthgold_5_pm";
  static const String twelveMonthPlatinumFivePromoCode =
      "com.haelo.haeloapp.twelvemonthplati_5_pm";

  // com.haelo.haeloapp.twelvemonthplatinum_five_promo_code
  ///iOS app store connect inapp purchase
  //static const String   oneMonthGold = "com.haelo.haeloapp.onemonthsilver";

  //for google drive
  static const String api_key = "AIzaSyBlew2KkTvNMVRxj9DilDEN5LCj-9jMZaw";

  //other
  static const String comment_note =
      "If you are adding a comment BEFORE the matter has been called, you will NOT see this case on the display board in the app, also, you will NOT get the notifications for the same";
}

class ImageConstant {
  static const String bell = "assets/images/bell.svg";
  static const String close = "assets/images/close.png";
  static const String document = "assets/images/document.svg";
  static const String document_edit = "assets/images/document_edit.svg";
  static const String error = "assets/images/error.png";
  static const String home = "assets/images/home.svg";
  static const String logo = "assets/images/logo.png";
  static const String iIcon = "assets/images/i.png";
  static const String n_alpha = "assets/images/n_alpha.jpg";
  static const String pdf = "assets/images/pdf.png";
  static const String scroll = "assets/images/scroll.png";
  static const String xlsx = "assets/images/xlsx.png";
  static const String loading_gif = "assets/images/loading_gif.gif";
  static const String crown = "assets/images/crown.png";
}
