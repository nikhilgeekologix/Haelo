// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
//
// class SubscriptionsProvider extends ChangeNotifier {
//
//   // save the stream to cancel it onDone
//   late StreamSubscription _streamSubscription;
//
//   SubscriptionsProvider() {
//     final Stream<List<PurchaseDetails>> purchaseUpdated = InAppPurchase.instance.purchaseStream;
//
//     _streamSubscription = purchaseUpdated.listen((purchaseDetailsList) {
//       // Handle the purchased subscriptions
//       _purchaseUpdate(purchaseDetailsList);
//
//     }, onDone: () {
//       _streamSubscription.cancel();
//
//     }, onError: (error) {
//       // handle the error
//     });
//   }
//
//   _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
//     // Purchased Subscriptions
//   }
//
//
//   _purchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
//
//     // check each item in the provider list
//     purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
//
//       // Sometimes the purchase is not completely done yet, in this case, show the pending UI again.
//       if (purchaseDetails.status == PurchaseStatus.pending) {
//         _showPendingUI();
//
//       } else {
//
//         // The status is NOT pending, lets check for an error
//         if (purchaseDetails.status == PurchaseStatus.error) {
//           // This happens if you close the app or dismiss the purchase dialog.
//           _handleError(purchaseDetails.error!);
//
//         } else if (purchaseDetails.status == PurchaseStatus.purchased ||
//             purchaseDetails.status == PurchaseStatus.restored) {
//
//           // Huge SUCCESS! This case handles the happy case whenever the user purchased or restored the purchase
//           _verifyPurchaseAndEnablePremium(purchaseDetails);
//
//         }
//
//         // Whenever the purchase is done, complete it by calling complete.
//         if (purchaseDetails.pendingCompletePurchase) {
//           await InAppPurchase.instance.completePurchase(purchaseDetails);
//         }
//       }
//     });
//   }
//
// }