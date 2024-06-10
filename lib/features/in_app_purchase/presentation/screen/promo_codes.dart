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
import 'package:haelo_flutter/features/in_app_purchase/data/model/promo_code_model.dart';
import 'package:haelo_flutter/features/in_app_purchase/presentation/screen/promo_code_single_plan.dart';
import 'package:haelo_flutter/features/in_app_purchase/presentation/screen/single_plan.dart';
import 'package:haelo_flutter/locators/plans_locator.dart';
import 'package:haelo_flutter/widgets/progress_indicator.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../../../home_page/presentation/screens/home_pages.dart';
import '../../cubit/plan_detail_cubit.dart';
import '../../cubit/promo_code_detail_cubit.dart';
import '../../cubit/promo_codes_state.dart';
import 'custom.dart';
import 'inapp_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

class PromoCodes extends StatefulWidget {
  const PromoCodes({super.key});

  @override
  State<PromoCodes> createState() => _PromoCodesState();
}

class _PromoCodesState extends State<PromoCodes> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
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
    print("already signedin");
    // if(Platform.isIOS){
    //
    // }
    // else{
    _kProductIds = <String>[
      Constants.oneMonthSilverPromoCode,
      Constants.oneMonthGoldPromoCode,
      Constants.oneMonthPlatinumPromoCode,
      Constants.sixMonthSilverPromoCode,
      Constants.sixMonthGoldPromoCode,
      Constants.sixMonthPlatinumPromoCode,
      Constants.twelveMonthSilverPromoCode,
      Constants.twelveMonthGoldPromoCode,
      Constants.twelveMonthPlatinumPromoCode,
      Constants.oneMonthSilverThreePromoCode,
      Constants.oneMonthSilverFivePromoCode,
      Constants.oneMonthPlatinumThreePromoCode,
      Constants.oneMonthPlatinumFivePromoCode,
      Constants.oneMonthGoldThreePromoCode,
      Constants.oneMonthGoldFivePromoCode,
      Constants.sixMonthSilverThreePromoCode,
      Constants.sixMonthSilverFivePromoCode,
      Constants.sixMonthGoldThreePromoCode,
      Constants.sixMonthGoldFivePromoCode,
      Constants.sixMonthPlatinumThreePromoCode,
      Constants.sixMonthPlatinumFivePromoCode,
      Constants.twelveMonthSilverThreePromoCode,
      Constants.twelveMonthSilverFivePromoCode,
      Constants.twelveMonthPlatinumThreePromoCode,
      Constants.twelveMonthPlatinumFivePromoCode,
      Constants.twelveMonthGoldThreePromoCode,
      Constants.twelveMonthGoldFivePromoCode,
    ];
    // }
    initStoreInfo();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    print("62 isavailable $isAvailable");

    if (!isAvailable) {
      setState(() {
        _products = <ProductDetails>[];
      });

      print("possibly gmail not login at playstore");
      return;
    }

    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    final ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
    // print("85 productDetailResponse ${productDetailResponse}");

    setState(() {
      _products = productDetailResponse.productDetails;
      isLoading = false;
    });
    if (_products.isNotEmpty) {
      // BlocProvider.of<PlansCubit>(context).fetchAllPlans();
      BlocProvider.of<PromoCodesCubit>(context).fetchPromoCodesDetailsStage();
    }

    print("107 product length  ${_products.length}");
    // _inAppPurchase.restorePurchases().then((value) {
    // });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Stack(children: [
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
              "Purchase coupons",
              style: mpHeadLine16(
                  fontWeight: FontWeight.w500,
                  textColor: AppColor.bold_text_color_dark_blue),
            ),
          ),
          body: Stack(
            children: [
              AbsorbPointer(
                absorbing: isLoading,
                child: Opacity(
                  opacity: !isLoading ? 1.0 : 0.2,
                  child: BlocConsumer<PromoCodesCubit, PromoCodesState>(
                      builder: (context, state) {
                    if (state is PromoCodesLoaded) {
                      var model = state.model;
                      if (model.result == 1 && model.data != null) {
                        for (int i = 0; i < model.data!.l1Month!.length; i++) {
                          if (model.data!.l1Month![i].planName == "gold" &&
                              model.data!.l1Month![i].planId.toString() ==
                                  "1" &&
                              model.data!.l1Month![i].promocodeCount
                                      .toString() ==
                                  "1") {
                            print("for gold");
                            var newIdx = _products.indexWhere((element) =>
                                element.id == Constants.oneMonthGoldPromoCode &&
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
                          if (model.data!.l1Month![i].planName == "silver" &&
                              model.data!.l1Month![i].planId.toString() ==
                                  "0" &&
                              model.data!.l1Month![i].promocodeCount
                                      .toString() ==
                                  "1") {
                            var newIdx = _products.indexWhere((element) =>
                                element.id ==
                                Constants.oneMonthSilverPromoCode);
                            if (newIdx != -1) {
                              var newPrice = _products[newIdx].rawPrice;
                              model.data!.l1Month![i].planAmount =
                                  ((newPrice)).toStringAsFixed(2);
                              model.data!.l1Month![i].productDetails =
                                  _products[newIdx];
                            }
                          }
                          if (model.data!.l1Month![i].planName == "silver" &&
                              model.data!.l1Month![i].planId.toString() ==
                                  "7" &&
                              model.data!.l1Month![i].promocodeCount
                                      .toString() ==
                                  "5") {
                            var newIdx = _products.indexWhere((element) =>
                                element.id ==
                                Constants.oneMonthSilverFivePromoCode);
                            if (newIdx != -1) {
                              var newPrice = _products[newIdx].rawPrice;
                              model.data!.l1Month![i].planAmount =
                                  ((newPrice)).toStringAsFixed(2);
                              model.data!.l1Month![i].productDetails =
                                  _products[newIdx];
                            }
                          }
                          if (model.data!.l1Month![i].planName == "gold" &&
                              model.data!.l1Month![i].planId.toString() ==
                                  "8" &&
                              model.data!.l1Month![i].promocodeCount
                                      .toString() ==
                                  "5") {
                            var newIdx = _products.indexWhere((element) =>
                                element.id ==
                                Constants.oneMonthGoldFivePromoCode);
                            if (newIdx != -1) {
                              var newPrice = _products[newIdx].rawPrice;
                              model.data!.l1Month![i].planAmount =
                                  ((newPrice)).toStringAsFixed(2);
                              model.data!.l1Month![i].productDetails =
                                  _products[newIdx];
                            }
                          }

                          if (model.data!.l1Month![i].planName == "silver" &&
                              model.data!.l1Month![i].planId.toString() ==
                                  "13" &&
                              model.data!.l1Month![i].promocodeCount
                                      .toString() ==
                                  "3") {
                            var newIdx = _products.indexWhere((element) =>
                                element.id ==
                                Constants.oneMonthSilverThreePromoCode);
                            if (newIdx != -1) {
                              var newPrice = _products[newIdx].rawPrice;
                              model.data!.l1Month![i].planAmount =
                                  ((newPrice)).toStringAsFixed(2);
                              model.data!.l1Month![i].productDetails =
                                  _products[newIdx];
                            }
                          }
                          if (model.data!.l1Month![i].planName == "gold" &&
                              model.data!.l1Month![i].planId.toString() ==
                                  "14" &&
                              model.data!.l1Month![i].promocodeCount
                                      .toString() ==
                                  "3") {
                            var newIdx = _products.indexWhere((element) =>
                                element.id ==
                                Constants.oneMonthGoldThreePromoCode);
                            if (newIdx != -1) {
                              var newPrice = _products[newIdx].rawPrice;
                              model.data!.l1Month![i].planAmount =
                                  ((newPrice)).toStringAsFixed(2);
                              model.data!.l1Month![i].productDetails =
                                  _products[newIdx];
                            }
                          }

                          if (model.data!.l1Month![i].planName == "platinum" &&
                              model.data!.l1Month![i].planId.toString() ==
                                  "19" &&
                              model.data!.l1Month![i].promocodeCount
                                      .toString() ==
                                  "1") {
                            print("for platinum");
                            var newIdx = _products.indexWhere((element) =>
                                element.id ==
                                    Constants.oneMonthPlatinumPromoCode &&
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
                          if (model.data!.l1Month![i].planName == "platinum" &&
                              model.data!.l1Month![i].planId.toString() ==
                                  "25" &&
                              model.data!.l1Month![i].promocodeCount
                                      .toString() ==
                                  "3") {
                            print("for platinum");
                            var newIdx = _products.indexWhere((element) =>
                                element.id ==
                                    Constants.oneMonthPlatinumThreePromoCode &&
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

                          if (model.data!.l1Month![i].planName == "platinum" &&
                              model.data!.l1Month![i].planId.toString() ==
                                  "22" &&
                              model.data!.l1Month![i].promocodeCount
                                      .toString() ==
                                  "5") {
                            print("for platinum");
                            var newIdx = _products.indexWhere((element) =>
                                element.id ==
                                    Constants.oneMonthPlatinumFivePromoCode &&
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

                        for (int i = 0; i < model.data!.l6Month!.length; i++) {
                          if (model.data!.l6Month![i].planName == "gold" &&
                              model.data!.l6Month![i].promocodeCount
                                      .toString() ==
                                  "1") {
                            var newIdx = _products.indexWhere((element) =>
                                element.id == Constants.sixMonthGoldPromoCode);
                            if (newIdx != -1) {
                              var newPrice = _products[newIdx].rawPrice;
                              model.data!.l6Month![i].planAmount =
                                  ((newPrice)).toStringAsFixed(2);
                              model.data!.l6Month![i].productDetails =
                                  _products[newIdx];
                            }
                          }
                          if (model.data!.l6Month![i].planName == "silver" &&
                              model.data!.l6Month![i].promocodeCount
                                      .toString() ==
                                  "1") {
                            var newIdx = _products.indexWhere((element) =>
                                element.id ==
                                Constants.sixMonthSilverPromoCode);
                            if (newIdx != -1) {
                              var newPrice = _products[newIdx].rawPrice;
                              model.data!.l6Month![i].planAmount =
                                  ((newPrice)).toStringAsFixed(2);
                              model.data!.l6Month![i].productDetails =
                                  _products[newIdx];
                            }
                          }
                          if (model.data!.l6Month![i].planName == "gold" &&
                              model.data!.l6Month![i].promocodeCount
                                      .toString() ==
                                  "3") {
                            var newIdx = _products.indexWhere((element) =>
                                element.id ==
                                Constants.sixMonthGoldThreePromoCode);
                            if (newIdx != -1) {
                              var newPrice = _products[newIdx].rawPrice;
                              model.data!.l6Month![i].planAmount =
                                  ((newPrice)).toStringAsFixed(2);
                              model.data!.l6Month![i].productDetails =
                                  _products[newIdx];
                            }
                          }
                          if (model.data!.l6Month![i].planName == "silver" &&
                              model.data!.l6Month![i].promocodeCount
                                      .toString() ==
                                  "3") {
                            var newIdx = _products.indexWhere((element) =>
                                element.id ==
                                Constants.sixMonthSilverThreePromoCode);
                            if (newIdx != -1) {
                              var newPrice = _products[newIdx].rawPrice;
                              model.data!.l6Month![i].planAmount =
                                  ((newPrice)).toStringAsFixed(2);
                              model.data!.l6Month![i].productDetails =
                                  _products[newIdx];
                            }
                          }

                          if (model.data!.l6Month![i].planName == "gold" &&
                              model.data!.l6Month![i].promocodeCount
                                      .toString() ==
                                  "5") {
                            var newIdx = _products.indexWhere((element) =>
                                element.id ==
                                Constants.sixMonthGoldFivePromoCode);
                            if (newIdx != -1) {
                              var newPrice = _products[newIdx].rawPrice;
                              model.data!.l6Month![i].planAmount =
                                  ((newPrice)).toStringAsFixed(2);
                              model.data!.l6Month![i].productDetails =
                                  _products[newIdx];
                            }
                          }
                          if (model.data!.l6Month![i].planName == "silver" &&
                              model.data!.l6Month![i].promocodeCount
                                      .toString() ==
                                  "5") {
                            var newIdx = _products.indexWhere((element) =>
                                element.id ==
                                Constants.sixMonthSilverFivePromoCode);
                            if (newIdx != -1) {
                              var newPrice = _products[newIdx].rawPrice;
                              model.data!.l6Month![i].planAmount =
                                  ((newPrice)).toStringAsFixed(2);
                              model.data!.l6Month![i].productDetails =
                                  _products[newIdx];
                            }
                          }

                          if (model.data!.l6Month![i].planName == "platinum" &&
                              model.data!.l6Month![i].promocodeCount
                                      .toString() ==
                                  "1") {
                            var newIdx = _products.indexWhere((element) =>
                                element.id ==
                                Constants.sixMonthPlatinumPromoCode);
                            if (newIdx != -1) {
                              var newPrice = _products[newIdx].rawPrice;
                              model.data!.l6Month![i].planAmount =
                                  ((newPrice)).toStringAsFixed(2);
                              model.data!.l6Month![i].productDetails =
                                  _products[newIdx];
                            }
                          }

                          if (model.data!.l6Month![i].planName == "platinum" &&
                              model.data!.l6Month![i].promocodeCount
                                      .toString() ==
                                  "3") {
                            var newIdx = _products.indexWhere((element) =>
                                element.id ==
                                Constants.sixMonthPlatinumThreePromoCode);
                            if (newIdx != -1) {
                              var newPrice = _products[newIdx].rawPrice;
                              model.data!.l6Month![i].planAmount =
                                  ((newPrice)).toStringAsFixed(2);
                              model.data!.l6Month![i].productDetails =
                                  _products[newIdx];
                            }
                          }

                          if (model.data!.l6Month![i].planName == "platinum" &&
                              model.data!.l6Month![i].promocodeCount
                                      .toString() ==
                                  "5") {
                            var newIdx = _products.indexWhere((element) =>
                                element.id ==
                                Constants.sixMonthPlatinumFivePromoCode);
                            if (newIdx != -1) {
                              var newPrice = _products[newIdx].rawPrice;
                              model.data!.l6Month![i].planAmount =
                                  ((newPrice)).toStringAsFixed(2);
                              model.data!.l6Month![i].productDetails =
                                  _products[newIdx];
                            }
                          }
                        }

                        for (int i = 0; i < model.data!.l12Month!.length; i++) {
                          if (model.data!.l12Month![i].planName == "gold" &&
                              model.data!.l12Month![i].planId.toString() ==
                                  "12" &&
                              model.data!.l12Month![i].promocodeCount
                                      .toString() ==
                                  "1") {
                            var newIdx = _products.indexWhere((element) =>
                                element.id ==
                                Constants.twelveMonthGoldPromoCode);
                            if (newIdx != -1) {
                              var newPrice = _products[newIdx].rawPrice;
                              model.data!.l12Month![i].planAmount =
                                  ((newPrice)).toStringAsFixed(2);
                              model.data!.l12Month![i].productDetails =
                                  _products[newIdx];
                            }
                          }
                          if (model.data!.l12Month![i].planName == "silver" &&
                              model.data!.l12Month![i].planId.toString() ==
                                  "11" &&
                              model.data!.l12Month![i].promocodeCount
                                      .toString() ==
                                  "1") {
                            var newIdx = _products.indexWhere((element) =>
                                element.id ==
                                Constants.twelveMonthSilverPromoCode);
                            if (newIdx != -1) {
                              var newPrice = _products[newIdx].rawPrice;
                              model.data!.l12Month![i].planAmount =
                                  ((newPrice)).toStringAsFixed(2);
                              model.data!.l12Month![i].productDetails =
                                  _products[newIdx];
                            }
                          }

                          if (model.data!.l12Month![i].planName == "silver" &&
                              model.data!.l12Month![i].planId.toString() ==
                                  "5" &&
                              model.data!.l12Month![i].promocodeCount
                                      .toString() ==
                                  "5") {
                            var newIdx = _products.indexWhere((element) =>
                                element.id ==
                                Constants.twelveMonthSilverFivePromoCode);
                            if (newIdx != -1) {
                              var newPrice = _products[newIdx].rawPrice;
                              model.data!.l12Month![i].planAmount =
                                  ((newPrice)).toStringAsFixed(2);
                              model.data!.l12Month![i].productDetails =
                                  _products[newIdx];
                            }
                          }

                          if (model.data!.l12Month![i].planName == "gold" &&
                              model.data!.l12Month![i].planId.toString() ==
                                  "6" &&
                              model.data!.l12Month![i].promocodeCount
                                      .toString() ==
                                  "5") {
                            var newIdx = _products.indexWhere((element) =>
                                element.id ==
                                Constants.twelveMonthGoldFivePromoCode);
                            if (newIdx != -1) {
                              var newPrice = _products[newIdx].rawPrice;
                              model.data!.l12Month![i].planAmount =
                                  ((newPrice)).toStringAsFixed(2);
                              model.data!.l12Month![i].productDetails =
                                  _products[newIdx];
                            }
                          }

                          if (model.data!.l12Month![i].planName == "silver" &&
                              model.data!.l12Month![i].planId.toString() ==
                                  "17" &&
                              model.data!.l12Month![i].promocodeCount
                                      .toString() ==
                                  "3") {
                            var newIdx = _products.indexWhere((element) =>
                                element.id ==
                                Constants.twelveMonthSilverThreePromoCode);
                            if (newIdx != -1) {
                              var newPrice = _products[newIdx].rawPrice;
                              model.data!.l12Month![i].planAmount =
                                  ((newPrice)).toStringAsFixed(2);
                              model.data!.l12Month![i].productDetails =
                                  _products[newIdx];
                            }
                          }
                          if (model.data!.l12Month![i].planName == "gold" &&
                              model.data!.l12Month![i].planId.toString() ==
                                  "18" &&
                              model.data!.l12Month![i].promocodeCount
                                      .toString() ==
                                  "3") {
                            var newIdx = _products.indexWhere((element) =>
                                element.id ==
                                Constants.twelveMonthGoldThreePromoCode);
                            if (newIdx != -1) {
                              var newPrice = _products[newIdx].rawPrice;
                              model.data!.l12Month![i].planAmount =
                                  ((newPrice)).toStringAsFixed(2);
                              model.data!.l12Month![i].productDetails =
                                  _products[newIdx];
                            }
                          }

                          if (model.data!.l12Month![i].planName == "platinum" &&
                              model.data!.l12Month![i].planId.toString() ==
                                  "24" &&
                              model.data!.l12Month![i].promocodeCount
                                      .toString() ==
                                  "1") {
                            var newIdx = _products.indexWhere((element) =>
                                element.id ==
                                Constants.twelveMonthPlatinumPromoCode);
                            if (newIdx != -1) {
                              var newPrice = _products[newIdx].rawPrice;
                              model.data!.l12Month![i].planAmount =
                                  ((newPrice)).toStringAsFixed(2);
                              model.data!.l12Month![i].productDetails =
                                  _products[newIdx];
                            }
                          }

                          if (model.data!.l12Month![i].planName == "platinum" &&
                              model.data!.l12Month![i].planId.toString() ==
                                  "27" &&
                              model.data!.l12Month![i].promocodeCount
                                      .toString() ==
                                  "3") {
                            var newIdx = _products.indexWhere((element) =>
                                element.id ==
                                Constants.twelveMonthPlatinumThreePromoCode);
                            if (newIdx != -1) {
                              var newPrice = _products[newIdx].rawPrice;
                              model.data!.l12Month![i].planAmount =
                                  ((newPrice)).toStringAsFixed(2);
                              model.data!.l12Month![i].productDetails =
                                  _products[newIdx];
                            }
                          }

                          if (model.data!.l12Month![i].planName == "platinum" &&
                              model.data!.l12Month![i].planId.toString() ==
                                  "21" &&
                              model.data!.l12Month![i].promocodeCount
                                      .toString() ==
                                  "5") {
                            var newIdx = _products.indexWhere((element) =>
                                element.id ==
                                Constants.twelveMonthPlatinumFivePromoCode);
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
                                  borderRadius: BorderRadius.circular(25.0)),
                              child: Container(
                                height: 45,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25.0)),
                                child: TabBar(
                                  indicator: BoxDecoration(
                                      color: AppColor.primary,
                                      borderRadius:
                                          BorderRadius.circular(25.0)),
                                  labelColor: Colors.white,
                                  unselectedLabelColor: Colors.black,
                                  splashBorderRadius: BorderRadius.circular(25),
                                  tabs: [
                                    if (model.data!.l1Month!.isNotEmpty)
                                      Tab(text: 'Monthly'),

                                    if (model.data!.l6Month!.isNotEmpty)
                                      Tab(text: '6 Months'),

                                    if (model.data!.l12Month!.isNotEmpty)
                                      Tab(text: '12 Months'),
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
                                  PromoCodePlanList(
                                    model.data!.l1Month,
                                    onClickPlanPressed: onPlanPurchaseShown,
                                    onCancelPlanPressed: onPlanCancelShown,
                                  ),

                                if (model.data!.l6Month!.isNotEmpty)
                                  PromoCodePlanList(
                                    model.data!.l6Month,
                                    onClickPlanPressed: onPlanPurchaseShown,
                                    onCancelPlanPressed: onPlanCancelShown,
                                  ),

                                if (model.data!.l12Month!.isNotEmpty)
                                  PromoCodePlanList(
                                    model.data!.l12Month,
                                    onClickPlanPressed: onPlanPurchaseShown,
                                    onCancelPlanPressed: onPlanCancelShown,
                                  ),
                                //PlanList(model.data!.l12Month),
                              ],
                            ))
                          ],
                        );
                      } else {
                        return NoDataAvailable("Subscription data not found.");
                      }
                    }
                    return SizedBox();
                  }, listener: (context, state) {
                    if (state is PromoCodesLoading) {
                      setState(() {
                        isLoading = true;
                      });
                    }
                    if (state is PromoCodesLoaded) {
                      setState(() {
                        isLoading = false;
                      });
                    }
                    if (state is PromoCodesError) {
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
        ),
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
      ]),
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
