import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/constants.dart';
import 'package:haelo_flutter/core/utils/functions.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/in_app_purchase/cubit/pay_request_cubit.dart';
import 'package:haelo_flutter/features/in_app_purchase/data/model/plan_details.dart';
import 'package:haelo_flutter/features/in_app_purchase/data/model/plans_model.dart';
import 'package:haelo_flutter/features/in_app_purchase/presentation/screen/flutter_inapp_purchasee.dart';
import 'package:haelo_flutter/features/in_app_purchase/presentation/screen/inapp_purchase.dart';
import 'package:haelo_flutter/features/in_app_purchase/presentation/static.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:haelo_flutter/locators.dart' as di;
import '../../../../main.dart';
import '../../../../widgets/error_widget.dart';
import '../../cubit/pay_request_state.dart';
import '../../cubit/plan_detail_cubit.dart';
import '../../cubit/plan_detail_state.dart';
import '../consumable_store.dart';

class PlanList extends StatefulWidget {
  List<MonthsPlan>? planList = [];

  PlanList(this.planList, {Key? key}) : super(key: key);

  @override
  _PlanListState createState() => _PlanListState();
}

class _PlanListState extends State<PlanList> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: PageScrollPhysics(),
      // shrinkWrap: true,
      scrollDirection: Axis.vertical,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.height),
        child: Column(
          children:
              widget.planList!.map((element) => SinglePlan(element)).toList(),
        ),
      ),
    );
  }
}

class SinglePlan extends StatefulWidget {
  MonthsPlan planDetails;

  SinglePlan(this.planDetails, {Key? key}) : super(key: key);

  @override
  _SinglePlanState createState() => _SinglePlanState();
}

class _SinglePlanState extends State<SinglePlan> {
  bool showMore = false;
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
  List<String>? arrPlatinumPlanData = [];
  String goldPlan = "";
  String silverPlan = "";
  TextEditingController _codeController = TextEditingController();

  @override
  void initState() {
    pref = di.locator();
    BlocProvider.of<PlanDetailCubit>(context).fetchPlanDetailsStage();
    // final Stream<List<PurchaseDetails>> purchaseUpdated =
    //     _inAppPurchase.purchaseStream;
    // print("47 purchaseUpdated ${purchaseUpdated.first}");
    // _subscription =
    //     purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
    //       if(!isLoading) {
    //         _listenToPurchaseUpdated(purchaseDetailsList);
    //       }
    //     }, onDone: () {
    //       _subscription.cancel();
    //     }, onError: (Object error) {
    //       print("objext error $error");
    //     });
    // isLoading=false;
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
    // setState(() {
    //   isLoading=true;
    // });
    print("88 purchaseDetailsList $purchaseDetailsList");

    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      print("91 purchaseUpdated ${purchaseDetails.status}");
      if (purchaseDetails.status == PurchaseStatus.pending) {
        print("payment pending");
        toast(msg: "payment pending");
        setState(() {
          isLoading = false;
        });
        // showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          print("payment error ");
          //toast(msg: "Payment cancelled");
          setState(() {
            isLoading = false;
          });
          // handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          // print("101purchaseDetails ${purchaseDetails.verificationData.localVerificationData}");
          // print("102.5purchaseDetails ${purchaseDetails.verificationData.serverVerificationData}");
          // print("103.5purchaseDetails ${purchaseDetails.verificationData.source}");
          // print("104purchaseDetails// ${purchaseDetails.purchaseID}");
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
    // IMPORTANT!! Always verify purchase details before delivering the product.
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
        body['planId'] = widget.planDetails.planId.toString();
        body['platformType'] = "0";
        BlocProvider.of<PayRequestCubit>(context).payRequest(body);
      }
    } else if (Platform.isIOS) {
      Map<String, String> receiptData = {};
      receiptData['recieptData'] =
          purchaseDetails.verificationData.serverVerificationData;
      receiptData['password'] = "";
      receiptData['exclude_old_transactions'] = "";
      receiptData['url_type'] = "";
      receiptData['planId'] = widget.planDetails.planId.toString();
      receiptData['platformType'] = "1";
      receiptData['plan_price'] = widget.planDetails.productDetails!
          .price; //!=null?  widget.planDetails.planAmount;
      BlocProvider.of<PayRequestCubit>(context).payRequest(receiptData);
      //"{\"receipt_data\":\"token or something like that==\",\"password\":\"86fe40c0040646fcaba640db896a6a09\",\"exclude_old_transactions\":\"true\",\"url_type\":\"2\",\"plan_price\":0.0}"
    }
  }

  void directAPiTest() {
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: showMore ? mediaQH(context) * 0.9 : mediaQH(context) * 0.27,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Color(0XFFFFD700), width: 2)),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            margin: EdgeInsets.zero,
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )),
            child: Container(
              width: double.maxFinite,
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 1,
                      ),
                      Text(
                        "${widget.planDetails.planName!.toUpperCase()}",
                        style: appTextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "${widget.planDetails.planTitle}",
                        style: appTextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            textColor: AppColor.hint_color_grey),
                      ),
                      SizedBox(
                        height: 1,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "₹",
                            style: TextStyle(
                              color: AppColor.black,
                              fontSize: 21,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            "${widget.planDetails.planAmount}",
                            style: appTextStyle(
                                fontSize: 28, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Row(
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
                              Text("${widget.planDetails.oldAmount}",
                                  style: TextStyle(
                                    color: AppColor.hint_color_grey,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  )),
                              RotationTransition(
                                turns: AlwaysStoppedAnimation(135 / 360),
                                child: Container(
                                  height: 35,
                                  width: 2,
                                  color: AppColor.rejected_color_text,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      /*  SizedBox(
                        height: 10,
                      ),
                      Row(
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
                              Text("${widget.planDetails.oldAmount}",
                                  style: TextStyle(
                                    color: AppColor.hint_color_grey,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  )),
                              RotationTransition(
                                turns: AlwaysStoppedAnimation(135 / 360),
                                child: Container(
                                  height: 35,
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
                              fontSize: 21,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            "${widget.planDetails.planAmount}",
                            style: appTextStyle(
                                fontSize: 28, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),*/
                      // Text("Offer Valid Until 2 June 2024",
                      //   style: appTextStyle(
                      //       fontSize: 16,
                      //       fontWeight: FontWeight.w600,
                      //       textColor: AppColor.primary
                      //   ),),
                      // SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return RedeemCodePopup(
                                      widget.planDetails.planId.toString());
                                },
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(0),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Redeem Code",
                                  style: appTextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      textColor: AppColor.primary),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
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

                              subscribeToPlan(
                                  widget.planDetails.productDetails!);
                              //goToPage(context, InApp());
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColor.primary),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 10),
                              child: Text("Choose Plan",
                                  style: appTextStyle(
                                    textColor: AppColor.white,
                                    fontWeight: FontWeight.w600,
                                  )),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          (widget.planDetails.planName == "gold" ||
                                  widget.planDetails.planName == "platinum")
                              ? Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      widget.planDetails.planName == "platinum"
                                          ? "Additionally With Gold"
                                          : "Additionally With Silver",
                                      style: appTextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          textColor: AppColor.primary),
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  height: 10,
                                ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  if (!showMore) {
                                    setState(() {
                                      showMore = true;
                                    });
                                  } else {
                                    setState(() {
                                      showMore = false;
                                    });
                                  }
                                });
                              },
                              child: Text(
                                !showMore ? 'Read More' : 'Read Less',
                                style: appTextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    textColor: AppColor.primary),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                BlocConsumer<PlanDetailCubit, PlanDetailState>(
                    builder: (context, state) {
                  return const SizedBox();
                }, listener: (context, state) {
                  if (state is PlanDetailLoading) {
                    setState(() {
                      isLoading = true;
                    });
                  }
                  if (state is PlanDetailLoaded) {
                    var planDetailsData = state.planDetailsDataModel;
                    if (planDetailsData.result == 1) {
                      setState(() {
                        isLoading = false;
                      });
                      planDetailsList = planDetailsData.data![0].planData!;
                      arrGoldPlanData = planDetailsData.data
                          ?.firstWhere((element) =>
                              element.planName == widget.planDetails.planName)
                          .planData;
                      print("planDetailsData.data ==> $arrGoldPlanData");
                      arrSilverPlanData = planDetailsData.data
                          ?.firstWhere(
                              (element) => element.planName == "silver")
                          .planData;

                      arrPlatinumPlanData = planDetailsData.data
                          ?.firstWhere(
                              (element) => element.planName == "platinum")
                          .planData;
                      print(
                          "arrPlatinumPlanData.data ==> $arrPlatinumPlanData");
                    } else {
                      setState(() {
                        isLoading = false;
                      });
                      showDialog(
                          context: context,
                          builder: (ctx) => AppMsgPopup(
                                planDetailsData.msg,
                              ));
                    }
                  }
                }),

                /// add plan description
                Visibility(
                  visible: showMore,
                  child: Expanded(
                    child: Container(
                      padding: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          color: AppColor.text_grey_color.withOpacity(0.18),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          )),
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: planDetailsList.isNotEmpty
                            ? ((widget.planDetails.planName == "gold" &&
                                    arrGoldPlanData?.length != null)
                                ? arrGoldPlanData!.length
                                : (widget.planDetails.planName == "platinum" &&
                                        arrPlatinumPlanData?.length != null)
                                    ? arrPlatinumPlanData!.length
                                    : (widget.planDetails.planName ==
                                                "silver" &&
                                            arrSilverPlanData?.length != null)
                                        ? arrSilverPlanData!.length
                                        : 0)
                            : 0,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          print("planDetailsList $planDetailsList");
                          print("planDetailsList ${planDetailsList[index]}");
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  child: Text(
                                    planDetailsList.isNotEmpty &&
                                            (widget.planDetails.planName ==
                                                    "gold" ||
                                                widget.planDetails.planName ==
                                                    "platinum")
                                        ? arrGoldPlanData![index]
                                        : arrSilverPlanData![index],
                                    style: appTextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
                pref.setBool(
                    Constants.is_prime, model.data!.response!.isPrime == 1);
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
        ],
      ),
    );
  }

  void subscribeToPlan(ProductDetails productDetails) {
    // final Map<String, PurchaseDetails> purchases =
    // Map<String, PurchaseDetails>.fromEntries(
    //     _purchases.map((PurchaseDetails purchase) {
    //       if (purchase.pendingCompletePurchase) {
    //         _inAppPurchase.completePurchase(purchase);
    //       }
    //       return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
    //     }));

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

  Widget RedeemCodePopup(String planId) {
    return AlertDialog(
      title: Text('Redeem Code'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _codeController,
            decoration: InputDecoration(labelText: 'Enter code'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            String code = _codeController.text;
            _redeemCode(code, planId);
          },
          child: Text('Redeem'),
        ),
      ],
    );
  }

// GooglePlayPurchaseDetails? _getOldSubscription(
//     ProductDetails productDetails, Map<String, PurchaseDetails> purchases) {
//   // This is just to demonstrate a subscription upgrade or downgrade.
//   // This method assumes that you have only 2 subscriptions under a group, 'subscription_silver' & 'subscription_gold'.
//   // The 'subscription_silver' subscription can be upgraded to 'subscription_gold' and
//   // the 'subscription_gold' subscription can be downgraded to 'subscription_silver'.
//   // Please remember to replace the logic of finding the old subscription Id as per your app.
//   // The old subscription is only required on Android since Apple handles this internally
//   // by using the subscription group feature in iTunesConnect.
//   GooglePlayPurchaseDetails? oldSubscription;
//   if (productDetails.id == _kSilverSubscriptionId &&
//       purchases[_kGoldSubscriptionId] != null) {
//     oldSubscription =
//     purchases[_kGoldSubscriptionId]! as GooglePlayPurchaseDetails;
//   } else if (productDetails.id == _kGoldSubscriptionId &&
//       purchases[_kSilverSubscriptionId] != null) {
//     oldSubscription =
//     purchases[_kSilverSubscriptionId]! as GooglePlayPurchaseDetails;
//   }
//   return oldSubscription;
// }
  void _redeemCode(String code, String planId) {
    if (code.isEmpty) {
      toast(msg: "Please enter redeem code");
    } else {
      Map<String, String> receiptData = {};
      receiptData['payment_type'] = "promo_use";
      receiptData['user_promocode'] = code;
      receiptData['platformType'] = "0";
      receiptData['planId'] = planId;
      setState(() {
        isLoading = true;
      });
      BlocProvider.of<PayRequestCubit>(context).payRequest(receiptData);
      Navigator.pop(context);
    }
  }
}
