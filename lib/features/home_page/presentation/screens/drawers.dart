import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:haelo_flutter/constants.dart';
import 'package:haelo_flutter/core/utils/functions.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/causeslist/presentation/widget/error_dialog.dart';
import 'package:haelo_flutter/features/court_date_report/presentation/screen/court_date_report_screen.dart';
import 'package:haelo_flutter/features/drawer_content/presentation/screens/draw_aboutus.dart';
import 'package:haelo_flutter/features/drawer_content/presentation/screens/draw_commentshistory.dart';
import 'package:haelo_flutter/features/drawer_content/presentation/screens/draw_faq.dart';
import 'package:haelo_flutter/features/drawer_content/presentation/screens/draw_hiddencauselist.dart';
import 'package:haelo_flutter/features/drawer_content/presentation/screens/draw_listinghistory.dart';
import 'package:haelo_flutter/features/drawer_content/presentation/screens/draw_orderhistory.dart';
import 'package:haelo_flutter/features/drawer_content/presentation/screens/draw_settings.dart';
import 'package:haelo_flutter/features/home_page/presentation/widgets/custometext.dart';
import 'package:haelo_flutter/features/in_app_purchase/presentation/screen/my_subscription.dart';
import 'package:haelo_flutter/features/in_app_purchase/presentation/screen/plans.dart';
import 'package:haelo_flutter/features/in_app_purchase/presentation/screen/promo_codes.dart';
import 'package:haelo_flutter/features/order_comment_history/presentation/screen/orderCommentHistory.dart';
import 'package:haelo_flutter/features/order_comment_history/presentation/screen/order_cmt_history_test.dart';
import 'package:haelo_flutter/features/order_comment_history/presentation/screen/order_cmt_history_test2.dart';
import 'package:haelo_flutter/features/ticker_data/presentation/ticker_data_screen.dart';
import 'package:haelo_flutter/features/userboard/presentation/screens/login.dart';
import 'package:haelo_flutter/features/userboard/presentation/widgets/html_content.dart';
import 'package:haelo_flutter/widgets/go_prime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../widgets/error_widget.dart';
import '../../../drawer_content/presentation/screens/coupans_list.dart';
import '../../../drawer_content/presentation/screens/draw_myteam.dart';
import '../../../drawer_content/presentation/screens/draw_paperhistory.dart';
import '../../../drawer_content/presentation/screens/draw_profile.dart';
import 'package:haelo_flutter/locators.dart' as di;
import 'package:google_sign_in/google_sign_in.dart' as google_sign_in;

import '../../../in_app_purchase/presentation/screen/inapp_purchase.dart';
import '../../../in_app_purchase/presentation/screen/ios_plans.dart';
import '../../../mass_addition_of_case/presentation/mass_addition_of_cases.dart';
import '../../../pending_order_report/presentation/screen/pendingOrderReport.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  late SharedPreferences pref;

  @override
  void initState() {
    super.initState();
    print("hello from drawer");
    pref = di.locator();
  }

  void showPrimePopup(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    showDialog(
        context: context,
        builder: (ctx) => SafeArea(
              child: GoPrime(),
            ));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Drawer(
        width: size.width * 0.8,
        child: SingleChildScrollView(
          child: Column(children: [
            Container(
              alignment: Alignment.centerLeft,
              height: 45,
              // width: size.width * 1,
              padding: EdgeInsets.only(left: 15),
              decoration: BoxDecoration(
                  color: AppColor.primary,
                  border: Border(
                    bottom: BorderSide(color: Colors.orange, width: 2.5),
                  )),
              child: Text("HAeLO",
                  style: mpHeadLine18(
                    textColor: Colors.white,
                    fontWeight: FontWeight.w500,
                  )),
            ),
            InkWell(
              onTap: () {
                if (Platform.isIOS) {
                  Navigator.pop(context);
                  goToPage(context, IOSPlans());
                } else {
                  Navigator.pop(context);
                  goToPage(context, Plans());
                }

                // goToPage(context, InApp());
              },
              child: NeoText(
                  text: "Go Prime",
                  iconss: Icon(
                    Icons.workspace_premium_outlined,
                    color: AppColor.primary,
                  )),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                goToPage(context, PromoCodes());
              },
              child: NeoText(
                  text: "Purchase coupons",
                  iconss: Icon(
                    Icons.workspace_premium_outlined,
                    color: AppColor.primary,
                  )),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                goToPage(context, CouponList());
              },
              child: NeoText(
                  text: "My coupons",
                  iconss: Icon(
                    Icons.workspace_premium_outlined,
                    color: AppColor.primary,
                  )),
            ),
            InkWell(
              onTap: () {
                if (isPrime(pref) &&
                    (planName(pref) == Constants.goldPlan ||
                        planName(pref) == Constants.platinumPlan ||
                        planName(pref) == Constants.silverPlan)) {
                  Navigator.pop(context);
                  goToPage(context, MySubscription());
                } else {
                  // showPrimePopup(context);
                  Navigator.pop(context);
                  goToPage(context, MySubscription());
                }
              },
              child: NeoText(
                  text: "My Subscription",
                  iconss: Icon(
                    Icons.subscriptions_outlined,
                    color: AppColor.primary,
                  )),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileDraw()));
              },
              child: NeoText(
                  text: "Profile",
                  // size: 20,
                  // fontWeight: FontWeight.bold,
                  // color: Colors.black,
                  // wordSpacing: 1,
                  iconss: Icon(
                    Icons.person,
                    color: AppColor.primary,
                  )),
            ),
            pref.getString(Constants.USER_TYPE) == "2"
                ? SizedBox()
                : InkWell(
                    onTap: () {
                      if (isPrime(pref) &&
                          (planName(pref) == Constants.goldPlan ||
                              planName(pref) == Constants.platinumPlan ||
                              planName(pref) == Constants.silverPlan)) {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyTeam()));
                      } else {
                        showPrimePopup(context);
                      }
                    },
                    child: NeoText(
                        text: "My Team",
                        iconss: Icon(Icons.people, color: AppColor.primary))),
            InkWell(
                onTap: () {
                  if (isPrime(pref) &&
                      (planName(pref) == Constants.goldPlan ||
                          planName(pref) == Constants.platinumPlan)) {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CourtDateReportScreen()));
                  } else {
                    showPrimePopup(context);
                  }
                },
                child: NeoText(
                    text: "Court Date Report",
                    iconss: Icon(Icons.data_exploration_outlined,
                        color: AppColor.primary))),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                    onTap: () {
                      if (isPrime(pref) &&
                              (planName(pref) == Constants.goldPlan ||
                                  planName(pref) == Constants.silverPlan) ||
                          planName(pref) == Constants.platinumPlan) {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HiddenCauselist()));
                      } else {
                        showPrimePopup(context);
                      }
                    },
                    child: NeoText(
                        text: "My Hidden Cause List",
                        iconss: Icon(Icons.featured_play_list_outlined,
                            color: AppColor.primary))),
                InkWell(
                    onTap: () {
                      if (isPrime(pref)) {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const TickerDataTableScreen()));
                      } else {
                        showPrimePopup(context);
                      }
                    },
                    child: NeoText(
                        text: "Ticker Data",
                        iconss: Icon(Icons.table_chart_outlined,
                            color: AppColor.primary))),
                InkWell(
                    onTap: () {
                      if (isPrime(pref)) {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const MassAdditionOfCase()));
                      } else {
                        showPrimePopup(context);
                      }
                    },
                    child: NeoText(
                        text: "Mass addition of cases",
                        iconss: Icon(Icons.table_chart_outlined,
                            color: AppColor.primary))),
                InkWell(
                    onTap: () {
                      if (isPrime(pref)) {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PendingCmtHistory()));
                      } else {
                        showPrimePopup(context);
                      }
                    },
                    child: NeoText(
                        text: "Pending Order Report",
                        iconss: Icon(Icons.table_chart_outlined,
                            color: AppColor.primary))),
                InkWell(
                    onTap: () {
                      if (isPrime(pref) &&
                          (planName(pref) == Constants.goldPlan ||
                              planName(pref) == Constants.platinumPlan)) {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrderCmtHistory4(
                                      isFromCmt: true,
                                    )));
                      } else {
                        showPrimePopup(context);
                      }
                    },
                    child: NeoText(
                        text: "Order-Comment History",
                        iconss: Icon(Icons.featured_play_list_outlined,
                            color: AppColor.primary))),
                InkWell(
                    onTap: () {
                      if (isPrime(pref) &&
                          (planName(pref) == Constants.goldPlan ||
                              planName(pref) == Constants.platinumPlan)) {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrderHistory()));
                      } else {
                        showPrimePopup(context);
                      }
                    },
                    child: NeoText(
                        text: "Order Judgement/History",
                        iconss:
                            Icon(Icons.lock_clock, color: AppColor.primary))),
                InkWell(
                    onTap: () {
                      if (isPrime(pref) &&
                          (planName(pref) == Constants.goldPlan ||
                              planName(pref) == Constants.platinumPlan)) {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CommentHistory()));
                      } else {
                        showPrimePopup(context);
                      }
                    },
                    child: NeoText(
                        text: "Comments history",
                        iconss:
                            Icon(Icons.lock_clock, color: AppColor.primary))),
                InkWell(
                    onTap: () {
                      if (isPrime(pref) &&
                          (planName(pref) == Constants.goldPlan ||
                              planName(pref) == Constants.platinumPlan)) {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListingHistory()));
                      } else {
                        showPrimePopup(context);
                      }
                    },
                    child: NeoText(
                        text: "Date of Listing History",
                        iconss:
                            Icon(Icons.lock_clock, color: AppColor.primary))),
                InkWell(
                    onTap: () {
                      if (isPrime(pref) &&
                          (planName(pref) == Constants.goldPlan ||
                              planName(pref) == Constants.platinumPlan)) {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PaperDetailHistory()));
                      } else {
                        showPrimePopup(context);
                      }
                    },
                    child: NeoText(
                        text: "Paper Details history",
                        iconss: Icon(Icons.lock, color: AppColor.primary))),
                InkWell(
                    onTap: () {
                      if (isPrime(pref) &&
                          (planName(pref) == Constants.goldPlan ||
                              planName(pref) == Constants.platinumPlan)) {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SettingsDraw()));
                      } else {
                        showPrimePopup(context);
                      }
                    },
                    child: NeoText(
                        text: "Settings",
                        iconss: Icon(Icons.settings_applications_sharp,
                            color: AppColor.primary))),
              ],
            ),
            InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AboutUs()));
                },
                child: NeoText(
                    text: "About Us",
                    iconss: Icon(Icons.account_circle_rounded,
                        color: AppColor.primary))),
            InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyWebView(
                                "https://haeloapp.in/privacy-policy",
                                "Privacy Policy",
                              )));
                },
                child: NeoText(
                    text: "Privacy Policy",
                    iconss: Icon(Icons.shield, color: AppColor.primary))),
            InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyWebView(
                                "https://haeloapp.in/terms-and-conditions",
                                "Terms & Conditions",
                              )));
                },
                child: NeoText(
                    text: "Terms & Conditions",
                    iconss: Icon(Icons.shield, color: AppColor.primary))),
            InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => FAQ()));
                },
                child: NeoText(
                    text: "FAQs",
                    iconss:
                        Icon(Icons.question_mark, color: AppColor.primary))),
            InkWell(
                onTap: () {
                  _showLogoutDialog();
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                },
                child: NeoText(
                    text: "Logout",
                    iconss: Icon(Icons.lock_open, color: AppColor.primary))),
            Center(
              child: InkWell(
                onTap: () {
                  //FirebaseCrashlytics.instance.crash();
                },
                child: Text(
                  "V (${pref.getString(Constants.app_version)})",
                  style: mpHeadLine16(fontWeight: FontWeight.w700),
                ),
              ),
            ),
            SizedBox(
              height: 27,
            )
          ]),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    Widget cancelButton = TextButton(
      child: const Text(
        "Cancel",
        style: TextStyle(color: AppColor.primary),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Logout", style: TextStyle(color: AppColor.primary)),
      onPressed: () async {
        Navigator.of(context).pop();
        await pref.clear();
        final googleSignIn = google_sign_in.GoogleSignIn.standard();
        if (await googleSignIn.isSignedIn()) {
          googleSignIn.signOut();
        }
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => AppMsgPopup(
                  "Logout Successfully",
                  isCloseIcon: false,
                  isError: false,
                  btnCallback: () {
                    Navigator.of(context).pop();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                        (route) => false);
                  },
                ));
      },
    );

    var actoins = <Widget>[];
    actoins.add(cancelButton);
    actoins.add(continueButton);
    AlertDialogShow().showAlertDialog(
        context: context,
        actions: actoins,
        titleMsg: "Logout",
        contentStr: "Are you sure you want to logout?");
  }
}
