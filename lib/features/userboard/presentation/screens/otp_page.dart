import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:haelo_flutter/constants.dart';
import 'package:haelo_flutter/core/utils/functions.dart';
import 'package:haelo_flutter/features/bottom_bar/presentation/screens/bottom_nav_bar.dart';
import 'package:haelo_flutter/features/causeslist/cubit/viewandsave_cubit.dart';
import 'package:haelo_flutter/features/causeslist/cubit/viewandsave_state.dart';
import 'package:haelo_flutter/features/in_app_purchase/cubit/pay_request_cubit.dart';
import 'package:haelo_flutter/features/in_app_purchase/cubit/pay_request_state.dart';
import 'package:haelo_flutter/features/in_app_purchase/presentation/screen/trial_page.dart';
import 'package:haelo_flutter/features/userboard/cubit/firm_register_cubit.dart';
import 'package:haelo_flutter/features/userboard/cubit/firm_register_state.dart';
import 'package:haelo_flutter/features/userboard/cubit/user_loginregister_cubit.dart';
import 'package:haelo_flutter/features/userboard/cubit/user_loginregister_state.dart';
import 'package:haelo_flutter/urls.dart';
import 'package:haelo_flutter/widgets/alert_dialog.dart';
import 'package:haelo_flutter/widgets/app_button.dart';
import 'package:haelo_flutter/widgets/error_widget.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/utils/ui_helper.dart';
import 'package:haelo_flutter/locators.dart' as di;
import '../../../../services/firebase_service.dart';
import '../../../../widgets/date_format.dart';
import '../../../../widgets/progress_indicator.dart';
import '../../../bottom_bar/presentation/screens/bottombar.dart';
import 'login.dart';

class OtpVerify extends StatefulWidget {
  String mobileNo;
  String countryCode;
  final loginData;

  OtpVerify(
      {this.mobileNo = '', this.countryCode = '', required this.loginData})
      : super();

  @override
  _OtpVerifyState createState() => _OtpVerifyState();
}

class _OtpVerifyState extends State<OtpVerify> {
  // bool _isLoading = false;
  var code = "";
  // String pinCode = '';
  late SharedPreferences pref;
  late Timer _timer;
  int timerValue = 59;
  bool isResend = false;
  bool isResent = false;
  bool timerstart = false;

  bool isLoading = false;

  final formPinPut = GlobalKey<FormState>();

  // firebase variable;
  final FirebaseAuth auth = FirebaseAuth.instance;
  // CountDownController? timercontroller;

  String? verificationId;
  String otpErrorMsg =
      "You've entered an incorrect OTP.\nplease enter the correct OTP to continue";
  String mobForOtp = '';

  @override
  void initState() {
    print("otp_page started ${widget.loginData["userName"]}");
    print("otp_page started ${widget.loginData}");
    super.initState();
    // EasyLoading.dismiss();
    pref = di.locator();
    if (widget.loginData["isTeam"]) {
      mobForOtp = widget.loginData['firmMob'];
    } else {
      mobForOtp = widget.loginData["mobNo"];
    }
    initiateFirebaseAuthentication();
    isLoading = false;
    startTimer();
  }

  final FocusNode _pinCode = FocusNode();

  /// Creates the [KeyboardActionsConfig] to hook up the fields
  /// and their focus nodes to our [FormKeyboardActions].
  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: false,
      actions: [
        KeyboardActionsItem(focusNode: _pinCode),
      ],
    );
  }

  initiateFirebaseAuthentication() async {
    Future.delayed(Duration(seconds: 1), () {
      if (widget.loginData["isTeam"]) {
        toast(msg: "Please get your OTP from firm admin");
        /* showDialog(
            context: context,
            builder: (ctx) => AppMsgPopup(
              "Please get your OTP from firm admin",
              isError: false,isCloseIcon: false,));*/
      }
    });

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '${widget.loginData["countryCode"] + mobForOtp}',
      verificationCompleted: (PhoneAuthCredential credential) {
        print("hello verificationCompleted ${credential}");
      },
      verificationFailed: (FirebaseAuthException e) {
        print("hello verificationFailed ${e}");
      },
      codeSent: (String verificationId, int? resendToken) {
        print(
            "hello codeSent ${verificationId} and resent token ${resendToken}");
        Login.verify = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print("hello codeAutoRetrievalTimeout ${verificationId}");
      },
    );
    //
    // await FirebaseAuth.instance.verifyPhoneNumber(
    //   phoneNumber:
    //   '${widget.loginData['countryCode'] + widget.loginData['mobNo']}',
    //   verificationCompleted:
    //       (PhoneAuthCredential credential) {
    //     print("verificationCompleted");
    //   },
    //   verificationFailed: (FirebaseAuthException e) {
    //     if (e.code == 'invalid-phone-number') {
    //       print('The provided phone number is not valid.');
    //     }
    //    // toast(msg: "Verification failed");
    //   },
    //   codeSent: (String verificationId,
    //       int? resendToken) {
    //     Login.verify = verificationId;
    //   },
    //   codeAutoRetrievalTimeout:
    //       (String verificationId) {
    //   },
    // ).then((value) {
    //   print("after value");
    //   // setState(() {
    //   //   isLoading=false;
    //   // });
    // });
  }

  startTimer() {
    setState(() {
      timerValue = 59;
    });
    isResend = false;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _timer = timer;
      if (timerValue < 1) {
        isResend = true;
        _timer.cancel();
        setState(() {
          // isResend = false;
        });
      } else {
        setState(() {
          timerValue--;
        });
      }
      // setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  TextEditingController _pinFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.white,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColor.white,
          body: SafeArea(
            child: KeyboardActions(
              config: _buildConfig(context),
              child: Stack(
                children: [
                  AbsorbPointer(
                    absorbing: isLoading,
                    child: Opacity(
                      opacity: !isLoading ? 1.0 : 0.2,
                      child: SizedBox(
                        height: mediaQH(context),
                        child: Stack(
                          children: [
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  BlocConsumer<FirmRegisterCubit,
                                          FirmRegisterState>(
                                      builder: (context, state) {
                                    return SizedBox();
                                  }, listener: (context, state) async {
                                    if (state is FirmRegisterLoaded) {
                                      final model = state.model;
                                      if (model.result == 1) {
                                        var registerUsers = model.data;
                                        pref.setString(Constants.ACCESS_TOKEN,
                                            registerUsers!.accessToke!);
                                        pref.setString(Constants.FIRM_ID,
                                            registerUsers!.firmId!);
                                        pref.setString(Constants.MOB_NO,
                                            registerUsers!.mobileNo!);
                                        pref.setString(
                                            Constants.USER_TYPE,
                                            widget.loginData["type"]
                                                .toString());
                                        pref.setString(Constants.USER_ID,
                                            registerUsers!.userId!.toString());
                                        pref.setBool(Constants.IS_LOGIN, true);
                                        print(
                                            "access token ${pref.getString(Constants.ACCESS_TOKEN)}");
                                        print(
                                            "mobile number ${pref.getString(Constants.MOB_NO)}");

                                        PackageInfo packageInfo =
                                            await PackageInfo.fromPlatform();

                                        var currentVersion =
                                            packageInfo.version;
                                        pref.setString(Constants.app_version,
                                            currentVersion);
                                        if (!widget.loginData["isLogin"]) {
                                          addToQuick(context);
                                        }
                                        if (registerUsers!.planDetails !=
                                            null) {
                                          setPlan(
                                              registerUsers!
                                                      .planDetails!.isPrime ==
                                                  1,
                                              registerUsers!
                                                  .planDetails!.planName!);
                                        }
                                        //no need to call pay request api for ios
                                        //in this case
                                        /*     Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PrimeTrialPage(),
                                            ),
                                            (route) => false);*/
                                        goToHomePage(context);
                                      } else {
                                        toast(msg: model.msg.toString());
                                      }
                                    }
                                  }),
                                  BlocConsumer<UserLoginRegisterCubit,
                                          UserLoginRegisterState>(
                                      builder: (context, state) {
                                    return SizedBox();
                                  }, listener: (context, state) async {
                                    if (state is UserLoginRegisterLoading) {
                                      setState(() {
                                        isLoading = true;
                                      });
                                    }
                                    if (state is UserLoginRegisterLoaded) {
                                      final model = state.model;
                                      if (model.result == 1) {
                                        var userLoginRegister = model.data;
                                        pref.setString(Constants.ACCESS_TOKEN,
                                            userLoginRegister!.accessToke!);
                                        if (userLoginRegister!.firmId != null) {
                                          pref.setString(Constants.FIRM_ID,
                                              userLoginRegister!.firmId!);
                                        }
                                        pref.setBool(Constants.IS_LOGIN, true);
                                        pref.setString(Constants.MOB_NO,
                                            userLoginRegister!.mobileNo!);
                                        pref.setString(
                                            Constants.USER_ID,
                                            userLoginRegister!.userId!
                                                .toString());
                                        pref.setString(
                                            Constants.USER_TYPE,
                                            widget.loginData["type"]
                                                .toString());
                                        print(
                                            "access token ${pref.getString(Constants.ACCESS_TOKEN)}");
                                        print(
                                            "mobile number ${pref.getString(Constants.MOB_NO)}");
                                        isLoading = false;
                                        PackageInfo packageInfo =
                                            await PackageInfo.fromPlatform();

                                        var currentVersion =
                                            packageInfo.version;
                                        pref.setString(Constants.app_version,
                                            currentVersion);
                                        print(
                                            "current version ${currentVersion}");
                                        if (!widget.loginData["isLogin"]) {
                                          addToQuick(context);
                                        }

                                        if (userLoginRegister!.planDetails !=
                                            null) {
                                          setPlan(
                                              userLoginRegister!
                                                      .planDetails!.isPrime ==
                                                  1,
                                              userLoginRegister!
                                                  .planDetails!.planName!);
                                          goToHomePage(context);
                                          /*   if (userLoginRegister!
                                                  .planDetails!.is_trail ==
                                              1) {
                                            setPlan(false, "");
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PrimeTrialPage(),
                                                ),
                                                (route) => false);
                                          }
                                          else {
                                            setPlan(
                                                userLoginRegister!
                                                        .planDetails!.isPrime ==
                                                    1,
                                                userLoginRegister!
                                                    .planDetails!.planName!);
                                            goToHomePage(context);
                                          }*/
                                        }
                                        // if(Platform.isIOS){
                                        //   Map<String, String> receiptData={};
                                        //   receiptData['receipt_data']="";
                                        //   receiptData['password']="";
                                        //   receiptData['exclude_old_transactions']="";
                                        //   receiptData['url_type']="";
                                        //   receiptData['plan_price']="";
                                        //   BlocProvider.of<PayRequestCubit>(context).payRequest(receiptData);
                                        // }
                                        // else{
                                        //   goToHomePage(context);
                                        // }
                                      } else {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        toast(msg: model.msg.toString());
                                      }
                                    }
                                  }),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(20, 15, 0, 0),
                                    padding: EdgeInsets.all(1),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Icon(
                                            Icons.arrow_back_ios,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 20, top: 70),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "OTP Verification",
                                      style: mpHeadLine20(
                                          fontWeight: FontWeight.w600,
                                          textColor: AppColor
                                              .bold_text_color_dark_blue,
                                          fontFamily: "gilroy_semi_bold"),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        const EdgeInsets.only(left: 20, top: 5),
                                    // final FirebaseAuth _auth = FirebaseAuth.instance;
                                    child: Row(
                                      children: [
                                        Text(
                                          "Please enter the OTP sent to ",
                                          style: mpHeadLine12(
                                              textColor:
                                                  AppColor.text_grey_color,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: "gilroy_regular"),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          '${widget.loginData["countryCode"] + ' ' + mobForOtp}',
                                          style: mpHeadLine12(
                                              textColor: AppColor
                                                  .bold_text_color_dark_blue,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: "gilroy_regular"),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Form(
                                    key: formPinPut,
                                    child: Container(
                                      // height: mediaQH(context) * 0.18,
                                      // color: Colors.yellow,
                                      margin: const EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        top: 25,
                                        bottom: 0,
                                      ),
                                      alignment: Alignment.centerLeft,
                                      child: PinCodeTextField(
                                        controller: _pinFieldController,
                                        // errorTextMargin: EdgeInsets.only(top: 70),
                                        appContext: context,
                                        length: 6,
                                        onChanged: (pin) {
                                          //pinCode = pin;
                                          // if (pin.length == 6) {
                                          setState(() {
                                            code = pin;
                                          });
                                          // Map<String, dynamic> body = {
                                          //   "mobile_number": '${widget.mobileNo.toString()}',
                                          //   "one_time_password": pinCode
                                          // };
                                          // context
                                          // .read<VerificationCubit>()
                                          // .otpVerification(body);
                                          // }
                                        },
                                        pinTheme: PinTheme(
                                          // fieldOuterPadding: EdgeInsets.symmetric(vertical: 20),
                                          shape: PinCodeFieldShape.box,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderWidth: 1.5,
                                          fieldHeight: 65,
                                          fieldWidth: 50,
                                          activeFillColor: Colors.white,
                                          activeColor: AppColor.primary,
                                          inactiveColor: AppColor.primary,
                                          selectedColor: AppColor.primary,
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please Enter OTP';
                                          } else if (value.length != 6) {
                                            return 'OTP is not valid';
                                          }
                                        },
                                        keyboardType: TextInputType.number,
                                        focusNode: _pinCode,
                                        showCursor: true,
                                        cursorColor: Colors.black,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        textStyle: mpHeadLine20(
                                            textColor: AppColor.black,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                  timerValue != 0
                                      ? Column(
                                          children: [
                                            Text(
                                              timerValue != 0
                                                  ? timerValue
                                                      .toString()
                                                      .padLeft(2, "0")
                                                  : "",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            SizedBox(
                                              height: 9,
                                            ),
                                          ],
                                        )
                                      : SizedBox(),
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Didn't receive the OTP ?",
                                          style: mpHeadLine14(
                                              textColor:
                                                  AppColor.text_grey_color,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "gilroy_regular"),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            if (isResend) {
                                              isResent = true;
                                              setState(() {});
                                              setState(() {
                                                startTimer();
                                                // timercontroller?.restart();
                                              });
                                              initiateFirebaseAuthentication();
                                              // FirebaseAuth.instance
                                              //     .verifyPhoneNumber(
                                              //   phoneNumber:
                                              //   '${widget
                                              //       .loginData["countryCode"] +
                                              //       widget.loginData["mobNo"]}',
                                              //   verificationCompleted: (
                                              //       PhoneAuthCredential credential) {},
                                              //   verificationFailed: (
                                              //       FirebaseAuthException e) {},
                                              //   codeSent: (String verificationId,
                                              //       int? resendToken) {
                                              //     Login.verify = verificationId;
                                              //   },
                                              //   codeAutoRetrievalTimeout: (
                                              //       String verificationId) {},
                                              // );
                                            }

                                            // isResend ? startTimer : null;
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(
                                              " Resend",
                                              style: mpHeadLine16(
                                                  textColor: isResend
                                                      ? AppColor.primary
                                                      : Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Raleway'),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: AppButton(
                                          btnName: "Verify",
                                          voidCallback: buttonClickEvent,
                                          isLoading: isLoading,
                                          cornerRadius: 30,
                                          borderColor: code.length == 6
                                              ? AppColor.primary
                                              : AppColor.grey_color,
                                          backgroundColor: code.length == 6
                                              ? AppColor.primary
                                              : AppColor.grey_color,
                                          textColor: code.length == 6
                                              ? AppColor.white
                                              : AppColor.black,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ), // if (authCredential.smsCode != null) {
                  ),
                  Visibility(
                    visible: isLoading,
                    child: const AppProgressIndicator(),
                  ),
                  BlocConsumer<PayRequestCubit, PayRequestState>(
                      builder: (context, state) {
                    return SizedBox();
                  }, listener: (context, state) {
                    if (state is PayRequestLoading) {
                      setState(() {
                        isLoading = true;
                      });
                    }
                    if (state is PayRequestLoaded) {
                      var model = state.model;
                      if (model.result == 1 && model.data != null) {
                        toast(msg: model.msg!);
                        pref.setBool(Constants.is_prime,
                            model.data!.response!.isPrime == 1);
                        pref.setString(Constants.plan_name,
                            model.data!.response!.planName!.toLowerCase());
                        goToHomePage(context);
                      } else {
                        toast(msg: model.msg!);
                      }
                      setState(() {
                        isLoading = false;
                      });
                    }
                    if (state is PayRequestError) {
                      setState(() {
                        isLoading = false;
                      });
                      if (state.message == "InternetFailure()") {
                        toast(msg: "Please check internet connection");
                      } else {
                        toast(msg: "Something went wrong");
                      }
                    }
                  }),
                  // BlocConsumer<ViewSaveCubit, ViewSaveState>(
                  //     builder: (context, state) {
                  //       return const SizedBox();
                  //     },
                  //     listener: (context, state) {
                  //       if (state is ViewSaveLoading) {
                  //         setState(() {
                  //           isLoading=true;
                  //         });
                  //       }
                  //       if (state is ViewSaveLoaded) {
                  //         var viewSaveList = state.viewSaveModel;
                  //         if (viewSaveList.result == 1) {
                  //           setTestPlan(true, "gold");
                  //           goToHomePage(context);
                  //         }else{
                  //           setState(() {
                  //             isLoading = false;
                  //           });
                  //           FocusScope.of(context).requestFocus(FocusNode());
                  //           //AppDialogShow().showErrorDialog(context, model.msg.toString(),);
                  //           showDialog(
                  //               context: context,
                  //               builder: (ctx) => FAppMsgPopup(
                  //                 viewSaveList.msg.toString(),));
                  //         }
                  //       }
                  //     }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> buttonClickEvent() async {
    // print(formPinPut.currentState!
    //     .validate());
    if (formPinPut.currentState!.validate()) {
      try {
        setState(() {
          isLoading = true;
        });
        if (Urls.BASE_URL == "https://haeloapp.in/api/") {
          PhoneAuthCredential credential = PhoneAuthProvider.credential(
              verificationId: Login.verify, smsCode: code);

          await auth.signInWithCredential(credential);
        }
        // print("loginverify ${Login.verify}");

        // print("login data ${widget
        //     .loginData["isLogin"]}");
        // print("login isTeam ${widget
        //     .loginData["isTeam"]}");
        if (!widget.loginData["isLogin"]) {
          if (widget.loginData["isTeam"]) {
            var body = {
              "mobNo": widget.loginData["mobNo"].toString(),
              "type": widget.loginData["type"].toString(),
              "firmId": widget.loginData["firmId"].toString(),
              // "firmName": widget
              //     .loginData["firmName"]
              //     .toString(),
              "fcmToken": widget.loginData["fcmToken"].toString(),
              "userName": widget.loginData["userName"].toString(),
              "platformType":
                  Platform.isAndroid ? "0" : "1" //o for android, 1 for iOS
            };

            FirebaseService().subscribeToTopic("Member");
            BlocProvider.of<UserLoginRegisterCubit>(context)
                .fetchUserLoginRegister(body);
            print("body param $body");
          } else {
            var body = {
              "mobNo": widget.loginData["mobNo"].toString(),
              "userName": widget.loginData["userName"].toString(),
              "firmName": widget.loginData["firmName"].toString(),
              "fcmToken": widget.loginData["fcmToken"].toString() ?? "",
              "platformType":
                  Platform.isAndroid ? "0" : "1" //o for android, 1 for iOS
            };

            FirebaseService().subscribeToTopic("Office");
            print("body1 param $body");
            BlocProvider.of<FirmRegisterCubit>(context).fetchFirmRegister(body);
          }
        } else {
          var body = {
            "mobNo": widget.loginData["mobNo"].toString(),
            "type": widget.loginData["type"].toString(),
            "firmId": widget.loginData["firmId"].toString(),
            "fcmToken": widget.loginData["fcmToken"].toString(),
            "platformType":
                Platform.isAndroid ? "0" : "1" //o for android, 1 for iOS
          };

          if (widget.loginData["firmId"].toString() == "") {
            FirebaseService().subscribeToTopic("Office");
          } else {
            FirebaseService().subscribeToTopic("Member");
          }

          BlocProvider.of<UserLoginRegisterCubit>(context)
              .fetchUserLoginRegister(body);
        }
      } catch (e) {
        showDialog(
            context: context, builder: (ctx) => AppMsgPopup(otpErrorMsg));
        print("Wrong Otp");
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void addToQuick(context) {
    var viewValueList = {
      "lawyer": widget.loginData["userName"].toString(),
      "FROM_DATE": getDDMMYYYY(DateTime.now().toString()),
      "TO_DATE": getDDMMYYYY(DateTime.now().toString()),
      "COURT_NUMBER": "",
      "SELECTED_JUDGES_NAME": "",
      "SELECTED_CAUSE_TYPE": "",
      "SELECTED_CASE_NUMBER": "",
      "SELECTED_LAWYER_NAME": "",
      "SELECTED_PARTY_NAME": "",
      "alert_id": "",
      "SELECTED_LAWYER_NAME": widget.loginData["userName"].toString(),
      "alert_id": "",
    };
    var viewList = {"filter": jsonEncode(viewValueList)};
    //print("viewList $viewList");
    BlocProvider.of<ViewSaveCubit>(context).fetchViewSave(viewList);
  }

  void setPlan(bool isPrime, String planName) {
    pref.setBool(Constants.is_prime, isPrime);
    pref.setString(Constants.plan_name, planName.toLowerCase());
  }
}
