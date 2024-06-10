import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:haelo_flutter/core/utils/bottom_sheet_dialog.dart';
import 'package:haelo_flutter/core/utils/functions.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/drawer_content/cubit/delete_account/delete_account_cubit.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/pdf_screen.dart';
import 'package:haelo_flutter/features/google_drive/drive_integration.dart';
import 'package:haelo_flutter/features/google_drive/drive_webview.dart';
import 'package:haelo_flutter/features/google_drive/g_drive_handler/gdrive_page.dart';
import 'package:haelo_flutter/features/google_drive/html_drive_code.dart';
import 'package:haelo_flutter/features/order_comment_history/presentation/screen/order_cmt_history_test.dart';
// import 'package:haelo_flutter/features/pdf_test.dart';
import 'package:haelo_flutter/features/userboard/cubit/login_verify_cubit.dart';
import 'package:haelo_flutter/features/userboard/cubit/login_verify_state.dart';
import 'package:haelo_flutter/features/userboard/presentation/screens/otp_page.dart';
import 'package:haelo_flutter/features/userboard/presentation/widgets/html_content.dart';
import 'package:haelo_flutter/widgets/alert_dialog.dart';
import 'package:haelo_flutter/widgets/app_button.dart';
import 'package:haelo_flutter/widgets/error_widget.dart';
import 'package:haelo_flutter/widgets/progress_indicator.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constants.dart';
import '../../../../locators.dart';
import '../../../in_app_purchase/presentation/screen/flutter_inapp_purchasee.dart';
import '../../cubit/login_cubit.dart';
import '../../cubit/login_state.dart';
import '../../data/model/admin_user_model.dart';
import '../widgets/admin_user_bottomsheet.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  static String verify = "";

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  void configLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.yellow
      ..backgroundColor = Colors.green
      ..indicatorColor = Colors.yellow
      ..textColor = Colors.yellow
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = true
      ..dismissOnTap = false;
    // ..customAnimation = CustomAnimation();
  }

  bool isTeam = true;
  bool isLogin = true;
  bool isRegister = true;
  Color buttonColor = AppColor.primary;
  Color buttonTxtColor = AppColor.white;

  String welcomeLableText = "Login with your mobile number";
  String termsLable = "By signin in you agree to the Terms and Conditions";
  String buttonLable1 = "New User ?";
  String buttonLable2 = "Register";
  String buttonName = "Login";
  String userType = "2";
  String loginType = "0";
  var fcmToken = "123456";

  // final WebViewController webViewController;

  late SharedPreferences pref;

  bool isFirmId = true;
  bool isFirmName = false;
  bool isName = false;

  bool isChecked = false;
  String firmId = '';
  String firmMobile = '';
  String htmlText =
      '''<p>Office login is for the &lsquo;super-user&rsquo; of an advocate&rsquo;s office. Generally, this &lsquo;super-user&rsquo; should be the principal/senior partner of the office. There are certain editing rights (in the app) available to this &lsquo;super-user&rsquo; only. Super-user needs to provide his/her phone number, office name and his/her name. He/she would be assigned a firm id automatically by the app.&nbsp;</p>\n\n<p>All other members (other partners, associates, advocate clerks etc) should login the app through Member login. They will have to enter the firm id (available with the &lsquo;super-user&rsquo;), their mobile number and name; to register in the app. They will have to get the OTP from their office &lsquo;super-user&rsquo;.</p>\n\n<p>Office members will be able to share resources in the app only if they login in Office-Member configuration as described above. Members of an advocate&rsquo;s office should refrain from logging in separately vide separate Office login.</p>\n''';

  List<AdminUsers>? adminUsers = [];

  TextEditingController firmIdController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController firmNameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController countryCode = TextEditingController();

  bool isLoading = false;
  String officeNote = "";
  String teamNote = "";
  String firmLoginError =
      "Please login with Firm Admin as you have been registered as a Firm Admin.";

  List<TextSpan> spans = [];

  firmIdCallback(String firmId_) {
    firmId = firmId_;
    firmIdController.text = firmId_;
    int index = adminUsers!.indexWhere((element) => element.firmId == firmId_);
    firmMobile = adminUsers![index].mobileNo!;
    // firmName=adminUsers![index].firmName??"";
    print("firmid $firmId_");
    setState(() {});
  }

  void FcmToken() {
    FirebaseMessaging.instance.getToken().then((value) {
      fcmToken = value!;
      print("fcmToken ${fcmToken}");
    });
  }

  @override
  void initState() {
    BlocProvider.of<LoginCubit>(context).fetchAdminUser();
    countryCode.text = "+91";
    FcmToken();
    pref = locator();

    pref.setBool(Constants.is_court_filter, false);
    super.initState();
  }

  final FocusNode _mobileNo = FocusNode();

  /// Creates the [KeyboardActionsConfig] to hook up the fields
  /// and their focus nodes to our [FormKeyboardActions].
  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: false,
      actions: [
        KeyboardActionsItem(focusNode: _mobileNo),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isError = true;
    return Container(
      // color: AppColor.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColor.white,
          body: KeyboardActions(
            config: _buildConfig(context),
            child: Stack(
              children: [
                AbsorbPointer(
                  absorbing: isLoading,
                  child: Opacity(
                    opacity: !isLoading ? 1.0 : 0.2,
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        margin: const EdgeInsets.symmetric(vertical: 30),
                        child: Column(
                          children: [
                            BlocConsumer<LoginCubit, LoginState>(
                                builder: (context, state) {
                              // if (state is AdminUserLoading) {
                              //   return Center(
                              //     child: CircularProgressIndicator(
                              //       color: AppColor.primary,
                              //     ),
                              //   );
                              // }
                              return SizedBox();
                            }, listener: (context, state) async {
                              if (state is AdminUserLoaded) {
                                final model = state.model;
                                if (model.result == 1) {
                                  adminUsers = model.data!.adminUsers ?? [];
                                  officeNote = model.data!.userInfo ?? "";
                                  teamNote = model.data!.teamInfo ?? "";
                                } else {
                                  adminUsers = [];
                                }
                                setState(() {});
                              }
                            }),
                            BlocConsumer<LoginVerifyCubit, LoginVerifyState>(
                                builder: (context, state) {
                              // if (state is LoginVerifyLoading) {
                              //   print("LoginVerifyLoading");
                              //
                              //   // EasyLoading.show();
                              //   // Future.delayed(const Duration(seconds: 5), () {
                              //   //   EasyLoading.dismiss();
                              //   //   if (isError) {
                              //   //     toast(msg: "Something Went Wrong, Please Try Again Later");
                              //   //   }
                              //   // });
                              //   return SizedBox();
                              // }
                              return const SizedBox();
                            }, listener: (context, state) async {
                              if (state is LoginVerifyLoading) {
                                setState(() {
                                  isLoading = true;
                                });
                              }
                              if (state is LoginVerifyLoaded) {
                                final model = state.model;
                                if (model.result == 1) {
                                  print("result1---------");
                                  setState(() {
                                    isLoading = false;
                                  });
                                  var loginData = {
                                    "countryCode": countryCode.text,
                                    "mobNo": mobileNoController.text,
                                    "userName": nameController.text,
                                    "fcmToken": fcmToken,
                                    "type": userType,
                                    "isRegister": loginType,
                                    "isLogin": isLogin,
                                    "isTeam": isTeam,
                                    "firmMob": firmMobile,
                                    "firmId": firmId,
                                    "firmName": firmNameController.text,
                                  };
                                  goToPage(
                                      context,
                                      OtpVerify(
                                        loginData: loginData,
                                      ));
                                  // await FirebaseAuth.instance.verifyPhoneNumber(
                                  //   phoneNumber:
                                  //   '${countryCode.text + mobileNoController.text}',
                                  //   verificationCompleted:
                                  //       (PhoneAuthCredential credential) {
                                  //     print("verificationCompleted");
                                  //   },
                                  //   verificationFailed:
                                  //       (FirebaseAuthException e) {
                                  //     print("verificationFailed");
                                  //         setState(() {
                                  //           isLoading=false;
                                  //         });
                                  //   },
                                  //   codeSent: (String verificationId,
                                  //       int? resendToken) {
                                  //     Login.verify = verificationId;
                                  //
                                  //
                                  //     isError = false;
                                  //
                                  //     goToPage(
                                  //         context,
                                  //         OtpVerify(
                                  //           loginData: loginData,
                                  //         ));
                                  //   },
                                  //   codeAutoRetrievalTimeout:
                                  //       (String verificationId) {
                                  //         setState(() {
                                  //           isLoading=false;
                                  //         });
                                  //       },
                                  // ).then((value) {
                                  //   print("after value");
                                  //   // setState(() {
                                  //   //   isLoading=false;
                                  //   // });
                                  // });
                                } else {
                                  print("isLogin $isLogin");
                                  print("isTeam $isTeam");
                                  setState(() {
                                    isLoading = false;
                                  });
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  //AppDialogShow().showErrorDialog(context, model.msg.toString(),);
                                  // if(isTeam && isLogin){
                                  //   if(model.msg.toString()==firmLoginError){
                                  //     userTypeChangeDialog();
                                  //   }
                                  // }else{
                                  showDialog(
                                      context: context,
                                      builder: (ctx) => AppMsgPopup(
                                            model.msg.toString(),
                                          ));
                                  // }
                                }
                              }
                            }),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 4),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            isTeam = false;
                                            changeMemberType(true);
                                          });
                                        },
                                        child: Container(
                                          // width: mediaQW(context) / 2.5,
                                          height: 45,
                                          alignment: Alignment.center,
                                          // margin: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                          // padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                          decoration: BoxDecoration(
                                              color: isTeam
                                                  ? AppColor.disabled_color
                                                  : AppColor.primary,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Text("Office",
                                              style: mpHeadLine16(
                                                  textColor: !isTeam
                                                      ? AppColor.white
                                                      : AppColor.black,
                                                  fontWeight: FontWeight.w100)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 4),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            isTeam = true;
                                            changeMemberType(true);
                                          });
                                        },
                                        child: Container(
                                          // width: mediaQW(context) / 2.5,
                                          height: 45,
                                          alignment: Alignment.center,
                                          // margin: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                          // padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                          decoration: BoxDecoration(
                                              color: !isTeam
                                                  ? AppColor.disabled_color
                                                  : AppColor.primary,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Text("Member",
                                              style: mpHeadLine16(
                                                  textColor: isTeam
                                                      ? AppColor.white
                                                      : AppColor.black,
                                                  fontWeight: FontWeight.w100)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                alignment: Alignment.centerLeft,
                                margin: const EdgeInsets.only(top: 35),
                                child: Text(
                                  "Welcome",
                                  style: mpHeadLine(
                                      textColor:
                                          AppColor.bold_text_color_dark_blue,
                                      fontFamily: "gilroy_semi_bold",
                                      fontSize: 32),
                                )),
                            Container(
                                alignment: Alignment.centerLeft,
                                margin: const EdgeInsets.only(top: 5),
                                child: Text(
                                  "$welcomeLableText",
                                  style: mpHeadLine14(
                                      textColor: AppColor.text_grey_color,
                                      fontFamily: "gilroy_regular"),
                                )),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColor.lyt_stroke_color),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  isFirmId
                                      ? Container(
                                          margin: EdgeInsets.only(
                                              left: 20, top: 10),
                                          padding: EdgeInsets.zero,
                                          child: Text(
                                            "Please select firm id.",
                                            style: mpHeadLine12(
                                                fontFamily: "gilroy_regular",
                                                textColor:
                                                    AppColor.text_grey_color),
                                          ),
                                        )
                                      : const SizedBox(),
                                  isFirmId
                                      ? InkWell(
                                          onTap: () {
                                            BottomSheetDialog(
                                                    context,
                                                    AdminUserBottomSheet(
                                                        adminUsers: adminUsers,
                                                        firmIdCallback:
                                                            firmIdCallback),
                                                    radius: 10,
                                                    bgColor: Colors.transparent,
                                                    elevation: 0)
                                                .showScreen();
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 5, 10, 5),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: TextFormField(
                                                    style: mpHeadLine14(
                                                        fontFamily:
                                                            "gilroy_regular",
                                                        textColor:
                                                            AppColor.black),
                                                    strutStyle:
                                                        StrutStyle.disabled,
                                                    scrollPadding:
                                                        EdgeInsets.zero,
                                                    controller:
                                                        firmIdController,
                                                    decoration: InputDecoration(
                                                      hintText: "firmid",
                                                      hintStyle: mpHeadLine16(
                                                        textColor: AppColor
                                                            .hint_color_grey,
                                                      ),
                                                      border: InputBorder.none,
                                                      isDense: true,
                                                      enabled: false,
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                    ),
                                                  ),
                                                ),
                                                const Icon(
                                                    Icons.keyboard_arrow_down,
                                                    color: AppColor.primary),
                                              ],
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                  SizedBox(
                                    height: isFirmId ? 5 : 0,
                                  ),
                                  isFirmId
                                      ? const Divider(
                                          color: AppColor.text_grey_color,
                                          height: 1)
                                      : const SizedBox(),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    height: 45,
                                    alignment: Alignment.center,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          // margin: EdgeInsets.only(left: 10),
                                          alignment: Alignment.center,
                                          height: 45,
                                          width: 40,
                                          // color: AppColor.rejected_color,
                                          child: Text(
                                            countryCode.text,
                                            style: TextStyle(
                                                color: AppColor.black,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 3,
                                            ),
                                            alignment: Alignment.center,
                                            height: 45,
                                            child: TextField(
                                              controller: mobileNoController,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontFamily: "gilroy_regular",
                                                  height: 25 / 23,
                                                  color: AppColor.black),

                                              // mpHeadLine16(
                                              //     fontFamily: "gilroy_regular",
                                              //     textColor: AppColor.black),
                                              strutStyle:
                                                  StrutStyle.fromTextStyle(
                                                TextStyle(
                                                    fontFamily:
                                                        "gilroy_regular",
                                                    height: 25 / 23,
                                                    color: AppColor.black),
                                              ),
                                              scrollPadding: EdgeInsets.zero,
                                              keyboardType:
                                                  TextInputType.number,
                                              focusNode: _mobileNo,
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(
                                                    10),
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              cursorHeight: 14,
                                              decoration: InputDecoration(
                                                hintText: "Phone number",
                                                hintStyle: mpHeadLine16(
                                                    textColor: AppColor
                                                        .hint_color_grey),
                                                border: InputBorder.none,
                                                isDense: true,
                                                contentPadding: EdgeInsets.zero,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  isFirmName
                                      ? const Divider(
                                          color: AppColor.grey_color,
                                          height: 1,
                                        )
                                      : const SizedBox(),
                                  isFirmName
                                      ? Container(
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                          ),
                                          height: 55,
                                          alignment: Alignment.center,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 3,
                                                  ),
                                                  alignment: Alignment.center,
                                                  height: 45,
                                                  child: TextField(
                                                    controller:
                                                        firmNameController,
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "gilroy_regular",
                                                        height: 25 / 23,
                                                        color: AppColor.black),

                                                    // mpHeadLine16(
                                                    //     fontFamily: "gilroy_regular",
                                                    //     textColor: AppColor.black),
                                                    strutStyle: StrutStyle
                                                        .fromTextStyle(
                                                      TextStyle(
                                                          fontFamily:
                                                              "gilroy_regular",
                                                          height: 25 / 23,
                                                          color:
                                                              AppColor.black),
                                                    ),
                                                    scrollPadding:
                                                        EdgeInsets.zero,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    cursorHeight: 14,
                                                    decoration: InputDecoration(
                                                      hintText: "Firm Name",
                                                      hintStyle: mpHeadLine16(
                                                          textColor: AppColor
                                                              .hint_color_grey),
                                                      border: InputBorder.none,
                                                      isDense: true,
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ) /*Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          padding: const EdgeInsets.all(5),
                                          child: TextFormField(
                                            style: mpHeadLine16(
                                                fontFamily: "gilroy_regular",
                                                textColor: AppColor.black),
                                            strutStyle: StrutStyle.disabled,
                                            controller: firmNameController,
                                            scrollPadding: EdgeInsets.zero,
                                            decoration: InputDecoration(
                                              hintText: "Firm Name",
                                              hintStyle: mpHeadLine16(
                                                  textColor:
                                                      AppColor.hint_color_grey),
                                              border: InputBorder.none,
                                              isDense: true,
                                              contentPadding: EdgeInsets.zero,
                                            ),
                                          ),
                                        )*/
                                      : const SizedBox(),
                                  isName
                                      ? const Divider(
                                          color: AppColor.grey_color,
                                          height: 1,
                                        )
                                      : const SizedBox(),
                                  isName
                                      ? Container(
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                          ),
                                          height: 55,
                                          alignment: Alignment.center,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 3,
                                                  ),
                                                  alignment: Alignment.center,
                                                  height: 45,
                                                  child: TextField(
                                                    controller: nameController,
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "gilroy_regular",
                                                        height: 25 / 23,
                                                        color: AppColor.black),

                                                    // mpHeadLine16(
                                                    //     fontFamily: "gilroy_regular",
                                                    //     textColor: AppColor.black),
                                                    strutStyle: StrutStyle
                                                        .fromTextStyle(
                                                      TextStyle(
                                                          fontFamily:
                                                              "gilroy_regular",
                                                          height: 25 / 23,
                                                          color:
                                                              AppColor.black),
                                                    ),
                                                    scrollPadding:
                                                        EdgeInsets.zero,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    cursorHeight: 14,
                                                    decoration: InputDecoration(
                                                        hintText: "Name",
                                                        hintStyle: mpHeadLine16(
                                                            textColor: AppColor
                                                                .hint_color_grey),
                                                        border:
                                                            InputBorder.none,
                                                        isDense: true,
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                        alignLabelWithHint:
                                                            true),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ) /*Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 13),
                                          padding: const EdgeInsets.all(5),
                                          child: TextFormField(
                                            style: mpHeadLine16(
                                                fontFamily: "gilroy_regular",
                                                textColor: AppColor.black),
                                            strutStyle: StrutStyle.disabled,
                                            scrollPadding: EdgeInsets.zero,
                                            controller: nameController,
                                            decoration: InputDecoration(
                                              hintText: "Name",
                                              hintStyle: mpHeadLine16(
                                                  textColor:
                                                      AppColor.hint_color_grey),
                                              border: InputBorder.none,
                                              isDense: true,
                                              contentPadding: EdgeInsets.zero,
                                            ),
                                          ),
                                        )*/
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                            Container(
                              // alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.only(top: 15),
                              child: Row(
                                // mainAxisSize: MainAxisSize.max,
                                children: [
                                  Theme(
                                    data: ThemeData(
                                      useMaterial3: false,
                                      unselectedWidgetColor: AppColor.primary,
                                      // checkboxTheme: CheckboxThemeData(fillColor: )
                                    ),
                                    child: Checkbox(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      value: isChecked,
                                      onChanged: (boolValue) {
                                        setState(() {
                                          isChecked = boolValue!;
                                        });
                                      },
                                      checkColor: AppColor.rejected_color,
                                      activeColor: AppColor.primary,
                                      // fillColor: MaterialStateProperty.all(
                                      //     AppColor.white
                                      // ),
                                    ),
                                  ),
                                  Flexible(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => MyWebView(
                                                      "https://haeloapp.in/terms-and-conditions",
                                                      "Terms & Conditions",
                                                    )));
                                      },
                                      child: Text(
                                        "$termsLable",
                                        style: mpHeadLine12(
                                            textColor: AppColor.primary,
                                            fontFamily: "gilroy_regular"),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin:
                                  const EdgeInsets.only(top: 10, bottom: 22),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "$buttonLable1",
                                    style: mpHeadLine12(
                                        textColor:
                                            AppColor.bold_text_color_dark_blue,
                                        fontFamily: "gilroy_regular"),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        isLogin = !isLogin;
                                        changeMemberType(false);
                                      });
                                    },
                                    child: Text(
                                      "$buttonLable2",
                                      style: mpHeadLine14(
                                          textColor: AppColor.primary,
                                          fontFamily: "gilroy_regular"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AppButton(
                              btnName: buttonName,
                              voidCallback: userLoginEvent,
                              isLoading: isLoading,
                              cornerRadius: 30,
                            ),
                            SizedBox(
                              height: 22,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Note:",
                                style: mpHeadLine16(
                                    textColor: AppColor.rejected_color_text),
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            HtmlWidget(
                              isTeam ? teamNote : officeNote,
                              textStyle:
                                  mpHeadLine14(fontWeight: FontWeight.w500),
                            ),
                            // InkWell(
                            //   onTap: (){
                            //     goToPage(context, OrderCmtHistory());
                            //   },
                            //   child: Padding(
                            //     padding: const EdgeInsets.all(8.0),
                            //     child: Icon(Icons.add),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (isLoading)
                  Positioned.fill(
                    child: Center(
                      child: AppProgressIndicator(),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void changeMemberType(bool showPopup) {
    print("isTeam $isTeam");
    setState(() {
      if (!isTeam) {
        //show a popup
        if (showPopup) {
          /*   isLogin
              ? toast(msg: "Are you sure you want to login with Office?")
              : toast(msg: "Are you sure you want to Register with Office?");*/

          showDialog(
              context: context,
              builder: (ctx) => AppMsgPopup(
                    isLogin
                        ? "Are you sure you want to login with Office?"
                        : "Are you sure you want to Register with Office?",
                    isCloseIcon: false,
                    isError: false,
                  ));
        }
        userType = "1";
        //Firm
        firmIdController.clear();
        firmId = '';
        firmMobile = "";
        firmNameController.text = "";
        if (isLogin) {
          isFirmId = false;
          isFirmName = false;
          isName = false;
          changeLoginData();
        } else {
          isFirmId = false;
          isFirmName = true;
          isName = true;
          changeLoginData();
        }
      } else {
        //in case of team
        userType = "2";
        if (isLogin) {
          isFirmId = true;
          isFirmName = false;
          isName = false;
          changeLoginData();
        } else {
          isFirmId = true;
          isFirmName = false;
          isName = true;
          changeLoginData();
        }
      }
    });
  }

  void btnCall() {
    print("login print");
    Navigator.pop(context);
  }

  void changeLoginData() {
    if (isLogin) {
      loginType = "0";
      welcomeLableText = "Login with your mobile number";
      termsLable = "By signing in you agree to the Terms and Conditions";
      buttonLable1 = "New User ?";
      buttonLable2 = "Register";
      buttonName = "Login";
    } else {
      loginType = "1";
      welcomeLableText = "Get started with your mobile number";
      termsLable = "By registering you agree to the Terms and Conditions";
      buttonLable1 = "Already Registered ?";
      buttonLable2 = "Login";
      buttonName = "Register";
    }
  }

  void userLoginEvent() async {
    print("isTeam $isTeam firmId $firmId");
    if (isTeam && firmId.isEmpty) {
      toast(msg: "Please select firm id.");
      return;
    } else if (mobileNoController.text.isEmpty) {
      toast(msg: "Please enter mobile number");
      return;
    } else if (mobileNoController.text.length < 10) {
      toast(msg: "Please enter correct mobile number");
      return;
    } else if (!isChecked) {
      toast(msg: "Please accept our T&C");
      return;
    } else if (!isLogin && nameController.text.isEmpty) {
      toast(msg: "Please enter your name");
      return;
    } else {
      callVerifyNumberApi();
    }
    print("final call api");
  }

  void callVerifyNumberApi() {
    var body = {
      "mobNo": mobileNoController.text,
      "type": userType,
      "isRegister": loginType,
    };
    BlocProvider.of<LoginVerifyCubit>(context).fetchLoginVerify(body);
  }

  void userTypeChangeDialog() {
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
      child: const Text("Yes", style: TextStyle(color: AppColor.primary)),
      onPressed: () async {
        BlocProvider.of<DeleteAccountCubit>(context).deleteAccount();
      },
    );

    var actoins = <Widget>[];
    actoins.add(cancelButton);
    actoins.add(continueButton);
    AlertDialogShow().showAlertDialog(
        context: context,
        actions: actoins,
        titleMsg: "Account Change Alert",
        contentStr: "Do you want to login with member?");
  }
}
