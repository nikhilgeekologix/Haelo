import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/constants.dart';
import 'package:haelo_flutter/core/utils/functions.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/in_app_purchase/cubit/pay_request_cubit.dart';
import 'package:haelo_flutter/locators.dart' as di;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../drawer_content/presentation/screens/coupans_list.dart';
import '../../cubit/pay_request_state.dart';
import '../../data/model/promo_code_model.dart';
import '../consumable_store.dart';

class PromoCodePlanList extends StatefulWidget {
  final VoidCallback onClickPlanPressed;
  final VoidCallback onCancelPlanPressed;
  List<PromoCodeMonthData>? planList = [];

  PromoCodePlanList(this.planList,
      {super.key,
      required this.onClickPlanPressed,
      required this.onCancelPlanPressed});

  @override
  _PromoCodePlanListState createState() => _PromoCodePlanListState();
}

class _PromoCodePlanListState extends State<PromoCodePlanList> {
  final bool _kAutoConsume = Platform.isIOS || true;
  String kConsumableId = 'consumable';
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  bool _purchasePending = false;
  List<String> _consumables = <String>[];
  List<PurchaseDetails> _purchases = <PurchaseDetails>[];
  late SharedPreferences pref;
  List<String> planDetailsList = [];
  bool isLoading = false;
  List<String>? arrGoldPlanData = [];
  List<String>? arrSilverPlanData = [];
  String goldPlan = "";
  String silverPlan = "";
  String planId = "";
  String planAmount = "";

  @override
  void initState() {
    pref = di.locator();
    super.initState();
  }

  @override
  void dispose() {
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    if (_subscription != null) _subscription!.cancel();

    super.dispose();
  }

  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    print("88 purchaseDetailsList $purchaseDetailsList");

    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      print("91 purchaseUpdated ${purchaseDetails.status}");
      if (purchaseDetails.status == PurchaseStatus.pending) {
        print("payment pending");
        // toast(msg: "payment pending");
        setState(() {
          isLoading = false;
          widget.onClickPlanPressed();
        });
        // showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          print("payment error ");
          //toast(msg: "Payment cancelled");
          setState(() {
            isLoading = false;
            widget.onCancelPlanPressed();
          });
          // handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.canceled) {
          print("payment error ");
          //toast(msg: "Payment cancelled");
          setState(() {
            widget.onCancelPlanPressed();
          });
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          final bool valid = await _verifyPurchase(purchaseDetails);
          // print("????????????isvalid purchae $valid");
          if (valid) {
            unawaited(deliverProduct(purchaseDetails));
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }
        if (Platform.isAndroid) {
          if (!_kAutoConsume && purchaseDetails.productID == kConsumableId) {
            final InAppPurchaseAndroidPlatformAddition androidAddition =
                _inAppPurchase.getPlatformAddition<
                    InAppPurchaseAndroidPlatformAddition>();
            await androidAddition.consumePurchase(purchaseDetails);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    toast(msg: "Something went wrong, Please try again later");
    // handle invalid purchase here if  _verifyPurchase` failed.
  }

  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.productID == kConsumableId) {
      await ConsumableStore.save(purchaseDetails.purchaseID!);
      final List<String> consumables = await ConsumableStore.load();
      setState(() {
        _purchasePending = false;
        _consumables = consumables;
        print("145 ${_consumables}");
      });
    } else {
      setState(() {
        _purchases.add(purchaseDetails);
        _purchasePending = false;
      });
    }

    if (Platform.isAndroid) {
      if (!isLoading) {
        isLoading = true;
        String data = purchaseDetails.verificationData.localVerificationData;
        Map<String, dynamic> receiptData = jsonDecode(data);

        Map<String, String> body = {};
        body['recieptData'] = jsonEncode(receiptData).toString();
        body['planId'] = planId;
        body['platformType'] = "0";
        // body['total_amount'] = planAmount;
        body['payment_type'] = "promo_buy";
        BlocProvider.of<PayRequestCubit>(context).payRequest(body);
      }
    } else {
      Map<String, String> receiptData = {};
      receiptData['recieptData'] =
          purchaseDetails.verificationData.serverVerificationData;
      receiptData['planId'] = planId;
      receiptData['payment_type'] = "promo_buy";
      receiptData['platformType'] = "1";
      receiptData['password'] = "dad1e1144bde4a8b8ff2702cb45ee2c3";
      receiptData['exclude_old_transactions'] = "true";
      /*   receiptData['plan_price'] = widget.planDetails.productDetails!
          .price; //!=null?  widget.planDetails.planAmount;*/
      print("planId ==> $planId");
      BlocProvider.of<PayRequestCubit>(context).payRequest(receiptData);
      //"{\"receipt_data\":\"token or something like that==\",\"password\":\"86fe40c0040646fcaba640db896a6a09\",\"exclude_old_transactions\":\"true\",\"url_type\":\"2\",\"plan_price\":0.0}"
    }
  }

/*  void directAPiTest() {
    var decoded = {
      "orderId": "GPA.3310-1876-9302-69275",
      "packageName": "com.haeloapp",
      "productId": "com.haelo.haeloapp.sixmonthsilver",
      "purchaseTime": 1689311932773,
      "purchaseState": 0,
      "purchaseToken":
          "nhgmldadhohkedbfemajijeh.AO-J1OyNXyaEEiaFmg-ZxxLSv7HT1V7l-5aCFoZ7XQree9s3RScZg_W-a-gAEDtUUnBZAYPdwx5_vvFxDJ1R-E8enUynFvw8_Q",
      "quantity": 1,
      "autoRenewing": true,
      "acknowledged": false
    };

    Map<String, String> body = {};
    body['recieptData'] = jsonEncode(decoded);
    body['planId'] = "4";
    body['platformType'] = "0";
    print("bodysingleplan $body");

    Map<String, String> typedMap =
        body.map((key, value) => MapEntry(key, value.toString()));

    BlocProvider.of<PayRequestCubit>(context).payRequest(body);
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView.builder(
            itemCount: widget.planList!.length,
            itemBuilder: (context, index) {
              final plan = widget.planList![index];
              return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Color(0XFFFFD700), width: 2)),
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                plan.planName!.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: appTextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 1,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "₹",
                                style: TextStyle(
                                  color: AppColor.hint_color_grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Text("${plan.oldAmount}",
                                      style: TextStyle(
                                        color: AppColor.hint_color_grey,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      )),
                                  RotationTransition(
                                    turns: AlwaysStoppedAnimation(135 / 360),
                                    child: Container(
                                      height: 20,
                                      width: 2,
                                      color: AppColor.rejected_color_text,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "₹",
                                style: TextStyle(
                                  color: AppColor.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                "${plan.planAmount}",
                                style: appTextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Number of coupons: ${plan.promocodeCount!}",
                        textAlign: TextAlign.center,
                        style: appTextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${plan.planTitle}",
                            style: appTextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                textColor: AppColor.hint_color_grey),
                          ),
                          InkWell(
                            onTap: () {
                              final Stream<List<PurchaseDetails>>
                                  purchaseUpdated =
                                  _inAppPurchase.purchaseStream;
                              print(
                                  "47 purchaseUpdated ${purchaseUpdated.first}");
                              _subscription = purchaseUpdated.listen(
                                  (List<PurchaseDetails> purchaseDetailsList) {
                                if (!isLoading) {
                                  _listenToPurchaseUpdated(purchaseDetailsList);
                                }
                              }, onDone: () {
                                _subscription!.cancel();
                              }, onError: (Object error) {
                                print("objext error $error");
                              });
                              // isLoading=false;
                              setState(() {
                                planId = plan.planId.toString();
                                planAmount = plan.planAmount.toString();
                              });
                              print(
                                  "productDetails ==> ${plan.productDetails}");
                              subscribeToPlan(plan.productDetails!);
                              //goToPage(context, InApp());
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColor.primary),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Text("Choose Plan",
                                  style: appTextStyle(
                                    textColor: AppColor.white,
                                    fontWeight: FontWeight.w600,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
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
              if (model.result == 1 && model.promoData != null) {
                toast(msg: model.msg!);
                setState(() {
                  widget.onCancelPlanPressed();
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CouponList(),
                  ),
                );
                // goToHomePage(context);
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
        ],
      ),
    );
  }

  void subscribeToPlan(ProductDetails productDetails) {
    late PurchaseParam purchaseParam;

    if (Platform.isAndroid) {
      // NOTE: If you are making a subscription purchase/upgrade/downgrade, we recommend you to
      // verify the latest status of you your subscription by using server side receipt validation
      // and update the UI accordingly. The subscription purchase status shown
      // inside the app may not be accurate.
      // final GooglePlayPurchaseDetails? oldSubscription =
      // _getOldSubscription(productDetails, purchases);

      purchaseParam = GooglePlayPurchaseParam(
        productDetails: productDetails,
        // changeSubscriptionParam: (oldSubscription != null)
        //     ? ChangeSubscriptionParam(
        //   oldPurchaseDetails: oldSubscription,
        //   prorationMode:
        //   ProrationMode.immediateWithTimeProration,
        // )
        //     : null
      );
    } else {
      purchaseParam = PurchaseParam(
        productDetails: productDetails,
      );
    }
    final InAppPurchase _inAppPurchase = InAppPurchase.instance;

    if (productDetails.id == kConsumableId) {
      _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
    } else {
      _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    }
  }

  Widget showPromoCodeDialog(List<String> promoCodes) {
    return AlertDialog(
      title: Text('Success'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your subscription is successful.'),
          SizedBox(height: 10),
          Text('Here are the promo codes:'),
          SizedBox(height: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: promoCodes.map((promoCode) => Text(promoCode)).toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}
