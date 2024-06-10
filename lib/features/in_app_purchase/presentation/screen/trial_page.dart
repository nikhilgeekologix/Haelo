// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:haelo_flutter/constants.dart';
// import 'package:haelo_flutter/core/utils/functions.dart';
// import 'package:haelo_flutter/core/utils/ui_helper.dart';
// import 'package:haelo_flutter/features/in_app_purchase/cubit/pay_request_cubit.dart';
// import 'package:haelo_flutter/features/in_app_purchase/data/model/plans_model.dart';
// import 'package:haelo_flutter/features/in_app_purchase/presentation/screen/flutter_inapp_purchasee.dart';
// import 'package:haelo_flutter/features/in_app_purchase/presentation/screen/inapp_purchase.dart';
// import 'package:haelo_flutter/widgets/error_widget.dart';
// import 'package:haelo_flutter/widgets/progress_indicator.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
//
// import 'package:in_app_purchase_android/billing_client_wrappers.dart';
// import 'package:in_app_purchase_android/in_app_purchase_android.dart';
// import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
// import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:haelo_flutter/locators.dart' as di;
// import '../../cubit/pay_request_state.dart';
// import '../consumable_store.dart';
//
// class PrimeTrialPage extends StatefulWidget {
//   const PrimeTrialPage({super.key});
//
//   @override
//   State<PrimeTrialPage> createState() => _PrimeTrialPageState();
// }
//
// class _PrimeTrialPageState extends State<PrimeTrialPage> {
//   final bool _kAutoConsume = Platform.isIOS || true;
//   String kConsumableId = 'consumable';
//   late StreamSubscription<List<PurchaseDetails>> _subscription;
//   final InAppPurchase _inAppPurchase = InAppPurchase.instance;
//   bool _purchasePending = false;
//   List<String> _consumables = <String>[];
//   List<PurchaseDetails> _purchases = <PurchaseDetails>[];
//   late SharedPreferences pref;
//
//   List<ProductDetails> _products = <ProductDetails>[];
//   List<String> _kProductIds = <String>[];
//
//   bool isLoading=false;
//   List<String> trialFeatureList=[
//     "Quick search for multiple lawyers",
//     "Download your causelist (in pdf and excel)",
//     "View bunch information",
//     "Receive push alerts before the case is called",
//     "Add colour code to your cases for visual aid if the matter is having no/interim/full stay",
//     "Record/edit case level note sheets for each added case",
//   ];
//
//   @override
//   void initState() {
//     pref = di.locator();
//
//     final Stream<List<PurchaseDetails>> purchaseUpdated =
//         _inAppPurchase.purchaseStream;
//     print("47 purchaseUpdated ${purchaseUpdated.first}");
//     _subscription =
//         purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
//           if(!isLoading) {
//             _listenToPurchaseUpdated(purchaseDetailsList);
//           }
//         }, onDone: () {
//           _subscription.cancel();
//         }, onError: (Object error) {
//           print("objext error $error");
//         });
//     isLoading=false;
//     _kProductIds = <String>[
//       // "trail_test"
//       Constants.oneMonthGold,
//     ];
//     initStoreInfo();
//     super.initState();
//   }
//
//   Future<void> initStoreInfo() async {
//
//     final bool isAvailable = await _inAppPurchase.isAvailable();
//     print("62 isavailable $isAvailable");
//
//     if (!isAvailable) {
//       setState(() {
//         _products = <ProductDetails>[];
//       });
//     }
//
//     if (Platform.isIOS) {
//       final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
//       _inAppPurchase
//           .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
//       await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
//     }
//
//     final ProductDetailsResponse productDetailResponse =
//     await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
//     print("85 productDetailResponse ${productDetailResponse}");
//
//     setState(() {
//       _products = productDetailResponse.productDetails;
//       isLoading=false;
//     });
//
//     for( int i=0; i<_products.length; i++){
//       print("hello $i id${_products[i].id}|| price${_products[i].price}");
//     }
//     // _inAppPurchase.restorePurchases();
//
//     print("125 product length  ${_products.length}");
//
//   }
//
//   @override
//   void dispose() {
//     if (Platform.isIOS) {
//       final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
//       _inAppPurchase
//           .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
//       iosPlatformAddition.setDelegate(null);
//     }
//     _subscription.cancel();
//
//     super.dispose();
//   }
//
//   Future<void> _listenToPurchaseUpdated(
//       List<PurchaseDetails> purchaseDetailsList) async {
//     // setState(() {
//     //   // isLoading=true;
//     // });
//     print("88 purchaseDetailsList $purchaseDetailsList");
//
//     for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
//       print("91 purchaseUpdated ${purchaseDetails.status}");
//       if (purchaseDetails.status == PurchaseStatus.pending) {
//         print("payment pending");
//         toast(msg: "payment pending");
//         setState(() {
//           isLoading=false;
//         });
//         // showPendingUI();
//       } else {
//         if (purchaseDetails.status == PurchaseStatus.error) {
//           print("payment error ");
//           toast(msg: "payment error");
//           setState(() {
//             isLoading=false;
//           });
//           // handleError(purchaseDetails.error!);
//         }
//         else if (purchaseDetails.status == PurchaseStatus.purchased ||
//             purchaseDetails.status == PurchaseStatus.restored) {
//           // print("101purchaseDetails ${purchaseDetails.verificationData.localVerificationData}");
//           // print("102.5purchaseDetails ${purchaseDetails.verificationData.serverVerificationData}");
//           // print("103.5purchaseDetails ${purchaseDetails.verificationData.source}");
//           // print("104purchaseDetails// ${purchaseDetails.purchaseID}");
//           final bool valid = await _verifyPurchase(purchaseDetails);
//           // print("????????????isvalid purchae $valid");
//           if (valid) {
//             unawaited(deliverProduct(purchaseDetails));
//           } else {
//             _handleInvalidPurchase(purchaseDetails);
//             return;
//           }
//         }
//         if (Platform.isAndroid) {
//           if (!_kAutoConsume && purchaseDetails.productID == kConsumableId) {
//             final InAppPurchaseAndroidPlatformAddition androidAddition =
//             _inAppPurchase.getPlatformAddition<
//                 InAppPurchaseAndroidPlatformAddition>();
//             await androidAddition.consumePurchase(purchaseDetails);
//           }
//         }
//         if (purchaseDetails.pendingCompletePurchase) {
//           await _inAppPurchase.completePurchase(purchaseDetails);
//         }
//       }
//     }
//   }
//
//   Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
//     // IMPORTANT!! Always verify a purchase before delivering the product.
//     // For the purpose of an example, we directly return true.
//     return Future<bool>.value(true);
//   }
//
//   void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
//     toast(msg: "Something went wrong, Please try again later");
//     // handle invalid purchase here if  _verifyPurchase` failed.
//   }
//
//   Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
//     // IMPORTANT!! Always verify purchase details before delivering the product.
//     if (purchaseDetails.productID == kConsumableId) {
//       await ConsumableStore.save(purchaseDetails.purchaseID!);
//       final List<String> consumables = await ConsumableStore.load();
//       setState(() {
//         _purchasePending = false;
//         _consumables = consumables;
//         print("145 ${_consumables}");
//       });
//     } else {
//       setState(() {
//         _purchases.add(purchaseDetails);
//         _purchasePending = false;
//       });
//     }
//
//     if(Platform.isAndroid){
//       if(!isLoading){
//         isLoading=true;
//         String data=purchaseDetails.verificationData.localVerificationData;
//         Map<String, dynamic> receiptData=jsonDecode(data);
//
//         Map<String, String> body={};
//         body['recieptData']=jsonEncode(receiptData).toString();
//         body['planId']="1"; //static for 200 plan
//         body['platformType']="0"; // 0 for android, 1 for iOS
//         BlocProvider.of<PayRequestCubit>(context).payRequest(body);
//       }
//     }
//     else if(Platform.isIOS){
//       Map<String, String> receiptData={};
//       receiptData['recieptData']=purchaseDetails.verificationData.serverVerificationData;
//       receiptData['password']="";
//       receiptData['exclude_old_transactions']="";
//       receiptData['url_type']="";
//       receiptData['planId']="1";
//       receiptData['platformType']="1";
//       receiptData['plan_price']="";//!=null?  widget.planDetails.planAmount;
//       BlocProvider.of<PayRequestCubit>(context).payRequest(receiptData);
//       //"{\"receipt_data\":\"token or something like that==\",\"password\":\"86fe40c0040646fcaba640db896a6a09\",\"exclude_old_transactions\":\"true\",\"url_type\":\"2\",\"plan_price\":0.0}"
//     }
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.home_background,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             AbsorbPointer(
//               absorbing: isLoading,
//               child: Opacity(
//                 opacity: !isLoading ? 1.0 : 0.2,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       SizedBox(
//                         height: 50,
//                       ),
//                       Text(
//                         "Premium\nSubscription",
//                         style: appTextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.w600,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       SizedBox(
//                         height: 30,
//                       ),
//                       Container(
//                         padding: EdgeInsets.all(15),
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: AppColor.primary.withOpacity(0.4),
//                         ),
//                         child: Icon(Icons.lock_open, size: 40),
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Text(
//                         "Unlock All Contents",
//                         style: appTextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                             textColor: AppColor.primary),
//                       ),
//                       SizedBox(
//                         height: 25,
//                       ),
//                       Container(
//                         padding: EdgeInsets.only(top: 10),
//                         decoration: BoxDecoration(
//                             color: AppColor.text_grey_color.withOpacity(0.1),
//                             borderRadius: BorderRadius.only(
//                               bottomLeft: Radius.circular(20),
//                               bottomRight: Radius.circular(20),
//                             )),
//                         child: ListView.builder(
//                           physics: NeverScrollableScrollPhysics(),
//                           itemCount: trialFeatureList.length,
//                           shrinkWrap: true,
//                           itemBuilder: (context, index) {
//                             return Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Row(
//                                 children: [
//                                   Icon(
//                                     Icons.check,
//                                     color: Colors.green,
//                                   ),
//                                   SizedBox(
//                                     width: 10,
//                                   ),
//                                   Flexible(
//                                     child: Text(
//                                         trialFeatureList[index],
//                                       style: appTextStyle(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.w500),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                       SizedBox(
//                         height: 35,
//                       ),
//                       InkWell(
//                         onTap: (){
//                           if(_products.isNotEmpty) {
//                             int idx=_products.indexWhere((element) => element.price=="Free");
//                             if(idx!=-1) {
//                               subscribeToPlan(_products[idx]);
//                             }else{
//                               showDialog(
//                                   context: context,
//                                   builder: (ctx) => AppMsgPopup(
//                                       "Your account is not eligible for 'Free Trail'"));
//                             }
//                           }else{
//                             toast(msg: "Something went wrong");
//                           }
//                         },
//                         child: Container(
//                           padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             color: AppColor.primary.withOpacity(1),
//                           ),
//                           child: Column(
//                             children: [
//                               Text(
//                                 "Start 2-months FREE Trial",
//                                 style: appTextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.w600,
//                                     textColor: AppColor.white),
//                               ),
//                               SizedBox(
//                                 height: 5,
//                               ),
//                               Text(
//                                 "(then ₹249/month, if not cancelled)",
//                                 style: appTextStyle(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w400,
//                                     textColor: AppColor.white),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           pref.setBool(Constants.is_prime, false);
//                           pref.setString(Constants.plan_name, "");
//                           goToHomePage(context);
//                         },
//                         child: Text(
//                           "Continue without Premium",
//                           style: appTextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w600,
//                               textColor: Colors.black54),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 50,
//                       ),
//                       BlocConsumer<PayRequestCubit, PayRequestState>(builder: (context, state) {
//                         return SizedBox();
//                       },
//                           listener: (context, state) {
//                             if (state is PayRequestLoading) {
//                               setState(() {
//                                 isLoading=true;
//                               });
//                             }
//                             if (state is PayRequestLoaded) {
//                               var model=state.model;
//                               if(model.result==1 && model.data!=null){
//                                 toast(msg: model.msg!);
//                                 pref.setBool(Constants.is_prime, model.data!.response!.isPrime==1);
//                                 pref.setString(Constants.plan_name,
//                                     model.data!.response!.planName!.toLowerCase());
//                                 goToHomePage(context);
//                               }
//                               else {
//                                 toast(msg: model.msg!);
//                               }
//                               setState(() {
//                                 isLoading=false;
//                               });
//                             }
//                             if (state is PayRequestError) {
//                               setState(() {
//                                 isLoading=false;
//                               });
//                               if (state.message == "InternetFailure()") {
//                                 toast(msg: "Please check internet connection");
//                               } else {
//                                 toast(msg: "Something went wrong");
//                               }
//                             }
//                           }),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Visibility(
//               visible: isLoading,
//               child: const Center(child: AppProgressIndicator()),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void subscribeToPlan(ProductDetails productDetails){
//
//     // final Map<String, PurchaseDetails> purchases =
//     // Map<String, PurchaseDetails>.fromEntries(
//     //     _purchases.map((PurchaseDetails purchase) {
//     //       if (purchase.pendingCompletePurchase) {
//     //         _inAppPurchase.completePurchase(purchase);
//     //       }
//     //       return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
//     //     }));
//
//
//     late PurchaseParam purchaseParam;
//
//     if (Platform.isAndroid) {
//       // NOTE: If you are making a subscription purchase/upgrade/downgrade, we recommend you to
//       // verify the latest status of you your subscription by using server side receipt validation
//       // and update the UI accordingly. The subscription purchase status shown
//       // inside the app may not be accurate.
//       // final GooglePlayPurchaseDetails? oldSubscription =
//       // _getOldSubscription(productDetails, purchases);
//
//       purchaseParam = GooglePlayPurchaseParam(
//         productDetails: productDetails,
//         // changeSubscriptionParam: (oldSubscription != null)
//         //     ? ChangeSubscriptionParam(
//         //   oldPurchaseDetails: oldSubscription,
//         //   prorationMode:
//         //   ProrationMode.immediateWithTimeProration,
//         // )
//         //     : null
//       );
//     } else {
//       purchaseParam = PurchaseParam(
//         productDetails: productDetails,
//       );
//     }
//     final InAppPurchase _inAppPurchase = InAppPurchase.instance;
//
//     if (productDetails.id == kConsumableId) {
//       _inAppPurchase.buyConsumable(
//           purchaseParam: purchaseParam);
//     } else {
//       _inAppPurchase.buyNonConsumable(
//           purchaseParam: purchaseParam);
//     }
//   }
// }
