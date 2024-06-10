import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:haelo_flutter/constants.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/no_data_widget.dart';
import 'package:haelo_flutter/features/in_app_purchase/cubit/plans_cubit.dart';
import 'package:haelo_flutter/features/in_app_purchase/cubit/plans_state.dart';
import 'package:haelo_flutter/features/in_app_purchase/data/model/plans_model.dart';
import 'package:haelo_flutter/features/in_app_purchase/presentation/screen/inapp_purchase.dart';
import 'package:haelo_flutter/features/in_app_purchase/presentation/screen/single_plan.dart';
import 'package:haelo_flutter/locators/plans_locator.dart';
import 'package:haelo_flutter/widgets/progress_indicator.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

import '../../../../main.dart';
import '../../../home_page/presentation/screens/home_pages.dart';
import 'custom.dart';
import 'iOS_single_plan.dart';

class IOSPlans extends StatefulWidget {
  const IOSPlans({Key? key}) : super(key: key);

  @override
  _PlansState createState() => _PlansState();
}

class _PlansState extends State<IOSPlans> {
  // final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  List<ProductDetails> _products = <ProductDetails>[];
  List<String> _kProductIds = <String>[];
  bool isLoading = true;
  bool onPlanPurchase = false;

  @override
  void initState() {
    initData();
    super.initState();
  }

  Future<void> initData() async {
    // GoogleSignIn _googleSignIn = GoogleSignIn(
    //   scopes: ['email'],
    // );
    // if (!await _googleSignIn.isSignedIn()) {
    //   final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    //   if (googleUser == null) {
    //     print("gmail login not done");
    //     toast(msg: "Please login to continue");
    //     // User canceled the login process
    //     return;
    //   }
    //
    // }
    print("already signedin");
    // if(Platform.isIOS){
    //
    // }
    // else{
    _kProductIds = <String>[
      //"HAeLO_Gold","HAeLO_Silver"
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
      // "com.haelo.haeloapp.onemonthgold",
      // "com.haelo.haeloapp.sixmonthgold",
    ];
    // }
    initStoreInfo();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await sgtl.iAP!.isAvailable();
    print("62 isavailable $isAvailable");

    if (!isAvailable) {
      setState(() {
        _products = <ProductDetails>[];
      });

      print("possibly gmail not login at playstore");
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
    // print("85 productDetailResponse ${productDetailResponse}");

    setState(() {
      _products = productDetailResponse.productDetails;
      isLoading = false;
    });
    if (_products.isNotEmpty) {
      BlocProvider.of<PlansCubit>(context).fetchAllPlans();
    }
    // for( int i=0; i<_products.length; i++){
    //   print("hello $i id${_products[i].id}|| price${_products[i].price}");
    // }

    print("107 product length  ${_products.length}");
    // _inAppPurchase.restorePurchases().then((value) {
    // });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Stack(
        children: [
          Scaffold(
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
                titleSpacing: 0,
                centerTitle: false,
                backgroundColor: AppColor.white,
                title: Text(
                  "Go Prime",
                  style: mpHeadLine16(
                      fontWeight: FontWeight.w500,
                      textColor: AppColor.bold_text_color_dark_blue),
                ),
              ),
              body: Padding(
                padding: EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    AbsorbPointer(
                      absorbing: isLoading,
                      child: Opacity(
                        opacity: !isLoading ? 1.0 : 0.2,
                        child: BlocConsumer<PlansCubit, PlansState>(
                            builder: (context, state) {
                          if (state is PlansLoaded) {
                            var model = state.model;
                            if (model.result == 1 && model.data != null) {
                              for (int i = 0;
                                  i < model.data!.l1Month!.length;
                                  i++) {
                                if (model.data!.l1Month![i].planName ==
                                    "gold") {
                                  print("for gold");
                                  var newIdx = _products.indexWhere((element) =>
                                      element.id == Constants.oneMonthGold &&
                                      element.price != "Free");

                                  print("gnewIdx $newIdx");
                                  if (newIdx != -1) {
                                    var newPrice = _products[newIdx].rawPrice;
                                    model.data!.l1Month![i].planAmount =
                                        ((newPrice)).toStringAsFixed(2);
                                    model.data!.l1Month![i].productDetails =
                                        _products[newIdx];
                                  }
                                }
                                if (model.data!.l1Month![i].planName ==
                                    "silver") {
                                  var newIdx = _products.indexWhere((element) =>
                                      element.id == Constants.oneMonthSilver);
                                  if (newIdx != -1) {
                                    var newPrice = _products[newIdx].rawPrice;
                                    model.data!.l1Month![i].planAmount =
                                        ((newPrice)).toStringAsFixed(2);
                                    model.data!.l1Month![i].productDetails =
                                        _products[newIdx];
                                  }
                                }
                                if (model.data!.l1Month![i].planName ==
                                    "platinum") {
                                  print("for platinum");
                                  var newIdx = _products.indexWhere((element) =>
                                      element.id ==
                                          Constants.oneMonthPlatinum &&
                                      element.price != "Free");

                                  print("gnewIdx $newIdx");
                                  if (newIdx != -1) {
                                    var newPrice = _products[newIdx].rawPrice;
                                    model.data!.l1Month![i].planAmount =
                                        ((newPrice)).toStringAsFixed(2);
                                    model.data!.l1Month![i].productDetails =
                                        _products[newIdx];
                                  }
                                }
                              }

                              for (int i = 0;
                                  i < model.data!.l6Month!.length;
                                  i++) {
                                if (model.data!.l6Month![i].planName ==
                                    "gold") {
                                  var newIdx = _products.indexWhere((element) =>
                                      element.id == Constants.sixMonthGold);
                                  if (newIdx != -1) {
                                    var newPrice = _products[newIdx].rawPrice;
                                    model.data!.l6Month![i].planAmount =
                                        ((newPrice)).toStringAsFixed(2);
                                    model.data!.l6Month![i].productDetails =
                                        _products[newIdx];
                                  }
                                }
                                if (model.data!.l6Month![i].planName ==
                                    "silver") {
                                  var newIdx = _products.indexWhere((element) =>
                                      element.id == Constants.sixMonthSilver);
                                  if (newIdx != -1) {
                                    var newPrice = _products[newIdx].rawPrice;
                                    model.data!.l6Month![i].planAmount =
                                        ((newPrice)).toStringAsFixed(2);
                                    model.data!.l6Month![i].productDetails =
                                        _products[newIdx];
                                  }
                                }
                                if (model.data!.l6Month![i].planName ==
                                    "platinum") {
                                  var newIdx = _products.indexWhere((element) =>
                                      element.id == Constants.sixMonthPlatinum);
                                  if (newIdx != -1) {
                                    var newPrice = _products[newIdx].rawPrice;
                                    model.data!.l6Month![i].planAmount =
                                        ((newPrice)).toStringAsFixed(2);
                                    model.data!.l6Month![i].productDetails =
                                        _products[newIdx];
                                  }
                                }
                              }

                              for (int i = 0;
                                  i < model.data!.l12Month!.length;
                                  i++) {
                                if (model.data!.l12Month![i].planName ==
                                    "gold") {
                                  var newIdx = _products.indexWhere((element) =>
                                      element.id ==
                                      Constants.twelveMonthGoldIOS);
                                  if (newIdx != -1) {
                                    var newPrice = _products[newIdx].rawPrice;
                                    model.data!.l12Month![i].planAmount =
                                        ((newPrice)).toStringAsFixed(2);
                                    model.data!.l12Month![i].productDetails =
                                        _products[newIdx];
                                  }
                                }
                                if (model.data!.l12Month![i].planName ==
                                    "silver") {
                                  var newIdx = _products.indexWhere((element) =>
                                      element.id ==
                                      Constants.twelveMonthSilverIOS);
                                  if (newIdx != -1) {
                                    var newPrice = _products[newIdx].rawPrice;
                                    model.data!.l12Month![i].planAmount =
                                        ((newPrice)).toStringAsFixed(2);
                                    model.data!.l12Month![i].productDetails =
                                        _products[newIdx];
                                  }
                                }
                                if (model.data!.l12Month![i].planName ==
                                    "platinum") {
                                  var newIdx = _products.indexWhere((element) =>
                                      element.id ==
                                      Constants.twelveMonthPlatinum);
                                  if (newIdx != -1) {
                                    var newPrice = _products[newIdx].rawPrice;
                                    model.data!.l12Month![i].planAmount =
                                        ((newPrice)).toStringAsFixed(2);
                                    model.data!.l12Month![i].productDetails =
                                        _products[newIdx];
                                  }
                                }
                              }
                              // });

                              return Column(
                                children: [
                                  Card(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0)),
                                    child: Container(
                                      height: 45,
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25.0)),
                                      child: TabBar(
                                        indicator: BoxDecoration(
                                            color: AppColor.primary,
                                            borderRadius:
                                                BorderRadius.circular(25.0)),
                                        labelColor: Colors.white,
                                        unselectedLabelColor: Colors.black,
                                        splashBorderRadius:
                                            BorderRadius.circular(25),
                                        tabs: [
                                          if (model.data!.l1Month!.isNotEmpty)
                                            Tab(text: 'Monthly'),
                                          if (model.data!.l6Month!.isNotEmpty)
                                            Tab(text: '6 Months'),

                                          if (model.data!.l12Month!.isNotEmpty)
                                            Tab(text: '12 Months'),

                                          Tab(text: 'Contact Us'),
                                          // Tab(
                                          //   text: 'Yearly',
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: TabBarView(
                                    children: [
                                      if (model.data!.l1Month!.isNotEmpty)
                                        IosPlanList(
                                          model.data!.l1Month,
                                          onClickPlanPressed:
                                              onPlanPurchaseShown,
                                          onCancelPlanPressed:
                                              onPlanCancelShown,
                                        ),

                                      if (model.data!.l6Month!.isNotEmpty)
                                        IosPlanList(
                                          model.data!.l6Month,
                                          onClickPlanPressed:
                                              onPlanPurchaseShown,
                                          onCancelPlanPressed:
                                              onPlanCancelShown,
                                        ),

                                      if (model.data!.l12Month!.isNotEmpty)
                                        IosPlanList(
                                          model.data!.l12Month,
                                          onClickPlanPressed:
                                              onPlanPurchaseShown,
                                          onCancelPlanPressed:
                                              onPlanCancelShown,
                                        ),
                                      Custom(),

                                      //PlanList(model.data!.l12Month),
                                    ],
                                  ))
                                ],
                              );
                            } else {
                              return NoDataAvailable(
                                  "Subscription data not found.");
                            }
                          }
                          return SizedBox();
                        }, listener: (context, state) {
                          if (state is PlansLoading) {
                            setState(() {
                              isLoading = true;
                            });
                          }
                          if (state is PlansLoaded) {
                            setState(() {
                              isLoading = false;
                            });
                          }
                          if (state is PlansError) {
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
                      ),
                    ),
                    Visibility(
                      visible: isLoading,
                      child: const Center(child: AppProgressIndicator()),
                    ),
                  ],
                ),
              )),
          onPlanPurchase == true
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
              : SizedBox()
        ],
      ),
    );
  }

  void onPlanPurchaseShown() {
    setState(() {
      onPlanPurchase = true;
    });
  }

  void onPlanCancelShown() {
    setState(() {
      onPlanPurchase = false;
    });
  }
}
