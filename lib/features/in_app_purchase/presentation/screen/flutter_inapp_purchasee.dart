// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
//
// class FlutterInApp extends StatefulWidget {
//   @override
//   _InAppState createState() => new _InAppState();
// }
//
// class _InAppState extends State<FlutterInApp> {
//  late StreamSubscription _purchaseUpdatedSubscription;
//  late  StreamSubscription _purchaseErrorSubscription;
//  late   StreamSubscription _conectionSubscription;
//  final List<String> _productLists = Platform.isAndroid
//       ? [
//   "com.haelo.haeloapp.onemonthgold"
//   ]
//       : ['com.cooni.point1000', 'com.cooni.point5000'];
//
//   String _platformVersion = 'Unknown';
//   List<IAPItem> _items = [];
//   List<PurchasedItem> _purchases = [];
//
//   @override
//   void initState() {
//     initPlatformState();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     if (_conectionSubscription != null) {
//       _conectionSubscription.cancel();
//       //_conectionSubscription = null;
//     }
//     super.dispose();
//   }
//
//   // Platform messages are asynchronous, so we initialize in an async method.
//   Future<void> initPlatformState() async {
//     String platformVersion="";
//     // Platform messages may fail, so we use a try/catch PlatformException.
//
//     // prepare
//     var result = await FlutterInappPurchase.instance.initialize();
//     print('result: $result');
//
//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;
//
//     setState(() {
//       _platformVersion = platformVersion;
//     });
//
//     // refresh items for android
//     try {
//       String msg = await FlutterInappPurchase.instance.consumeAll();
//       print('consumeAllItems: $msg');
//     } catch (err) {
//       print('consumeAllItems error: $err');
//     }
//
//     _conectionSubscription =
//         FlutterInappPurchase.connectionUpdated.listen((connected) {
//           print('connected: $connected');
//         });
//
//     _purchaseUpdatedSubscription =
//         FlutterInappPurchase.purchaseUpdated.listen((productItem) {
//           print('purchase-updated: $productItem');
//         });
//
//     _purchaseErrorSubscription =
//         FlutterInappPurchase.purchaseError.listen((purchaseError) {
//           print('purchase-error: $purchaseError');
//         });
//   }
//
//   void _requestPurchase(IAPItem item) {
//     FlutterInappPurchase.instance.requestPurchase(item.productId!);
//   }
//
//   Future _getProduct() async {
//     List<IAPItem> items =
//     await FlutterInappPurchase.instance.getProducts(_productLists);
//     print("items ${items!.length}");
//     for (var item in items) {
//       print('${item.toString()}');
//       this._items.add(item);
//     }
//
//     setState(() {
//       this._items = items;
//       this._purchases = [];
//     });
//   }
//
//   Future _getPurchases() async {
//     List<PurchasedItem>? items =
//     await FlutterInappPurchase.instance.getAvailablePurchases();
//
//     print("items ${items!.length}");
//     for (var item in items!) {
//       print('${item.toString()}');
//       this._purchases.add(item);
//     }
//
//     setState(() {
//       this._items = [];
//       this._purchases = items;
//     });
//   }
//
//   Future _getPurchaseHistory() async {
//     List<PurchasedItem>? items =
//     await FlutterInappPurchase.instance.getPurchaseHistory();
//     print("items ${items!.length}");
//     for (var item in items!) {
//       print('autoRenewingAndroid:${item.autoRenewingAndroid!=null}');
//       print('isAcknowledgedAndroid ${item.isAcknowledgedAndroid}');
//       print('dataAndroid ${item.dataAndroid}');
//       print('purchaseStateAndroid ${item.purchaseStateAndroid}');
//       print('signatureAndroid${item.signatureAndroid}');
//       print('transactionReceipt${item.transactionReceipt}');
//       print('transactionDate ${item.transactionDate}\n\n');
//       this._purchases.add(item);
//     }
//
//     setState(() {
//       this._items = [];
//       this._purchases = items;
//     });
//   }
//
//   List<Widget> _renderInApps() {
//     List<Widget> widgets = this
//         ._items
//         .map((item) => Container(
//       margin: EdgeInsets.symmetric(vertical: 10.0),
//       child: Container(
//         child: Column(
//           children: <Widget>[
//             Container(
//               margin: EdgeInsets.only(bottom: 5.0),
//               child: Text(
//                 item.toString(),
//                 style: TextStyle(
//                   fontSize: 18.0,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//             ElevatedButton(
//               // color: Colors.orange,
//               onPressed: () {
//                 print("---------- Buy Item Button Pressed");
//                 this._requestPurchase(item);
//               },
//               child: Row(
//                 children: <Widget>[
//                   Expanded(
//                     child: Container(
//                       height: 48.0,
//                       alignment: Alignment(-1.0, 0.0),
//                       child: Text('Buy Item'),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     ))
//         .toList();
//     return widgets;
//   }
//
//   List<Widget> _renderPurchases() {
//     List<Widget> widgets = this
//         ._purchases
//         .map((item) => Container(
//       margin: EdgeInsets.symmetric(vertical: 10.0),
//       child: Container(
//         child: Column(
//           children: <Widget>[
//             Container(
//               margin: EdgeInsets.only(bottom: 5.0),
//               child: Text(
//                 item.toString(),
//                 style: TextStyle(
//                   fontSize: 18.0,
//                   color: Colors.black,
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     ))
//         .toList();
//     return widgets;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width - 20;
//     double buttonWidth = (screenWidth / 3) - 20;
//
//     return Container(
//       padding: EdgeInsets.all(10.0),
//       child: ListView(
//         children: <Widget>[
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: <Widget>[
//               Container(
//                 child: Text(
//                   'Running on: $_platformVersion\n',
//                   style: TextStyle(fontSize: 18.0),
//                 ),
//               ),
//               Column(
//                 children: <Widget>[
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: <Widget>[
//                       Container(
//                         width: buttonWidth,
//                         height: 60.0,
//                         margin: EdgeInsets.all(7.0),
//                         child:  ElevatedButton(
//                           // color: Colors.orange,
//                           // padding: EdgeInsets.all(0.0),
//                           onPressed: () async {
//                             print("---------- Connect Billing Button Pressed");
//                             await FlutterInappPurchase.instance.initialize();
//                           },
//                           child: Container(
//                             padding: EdgeInsets.symmetric(horizontal: 20.0),
//                             alignment: Alignment(0.0, 0.0),
//                             child: Text(
//                               'Connect Billing',
//                               style: TextStyle(
//                                 fontSize: 16.0,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Container(
//                         width: buttonWidth,
//                         height: 60.0,
//                         margin: EdgeInsets.all(7.0),
//                         child:  ElevatedButton(
//                           // color: Colors.orange,
//                           // padding: EdgeInsets.all(0.0),
//                           onPressed: () async {
//                             print("---------- End Connection Button Pressed");
//                             await FlutterInappPurchase.instance.finalize();
//                             if (_purchaseUpdatedSubscription != null) {
//                               _purchaseUpdatedSubscription.cancel();
//                               // _purchaseUpdatedSubscription = null;
//                             }
//                             if (_purchaseErrorSubscription != null) {
//                               _purchaseErrorSubscription.cancel();
//                               // _purchaseErrorSubscription = null;
//                             }
//                             setState(() {
//                               this._items = [];
//                               this._purchases = [];
//                             });
//                           },
//                           child: Container(
//                             padding: EdgeInsets.symmetric(horizontal: 20.0),
//                             alignment: Alignment(0.0, 0.0),
//                             child: Text(
//                               'End Connection',
//                               style: TextStyle(
//                                 fontSize: 16.0,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: <Widget>[
//                         Expanded(
//                           child: Container(
//
//                               margin: EdgeInsets.all(7.0),
//                               child:  ElevatedButton(
//                                 // color: Colors.orange,
//                                 onPressed: () {
//                                   print("---------- Get Items Button Pressed");
//                                   this._getProduct();
//                                 },
//                                 child: Container(
//                                   padding: EdgeInsets.symmetric(horizontal: 20.0),
//                                   alignment: Alignment(0.0, 0.0),
//                                   child: Text(
//                                     'Get Items',
//                                     style: TextStyle(
//                                       fontSize: 16.0,
//                                     ),
//                                   ),
//                                 ),
//                               )),
//                         ),
//                         Expanded(
//                           child: Container(
//                               margin: EdgeInsets.all(7.0),
//                               child:  ElevatedButton(
//                                 // color: Colors.orange,
//                                 onPressed: () {
//                                   print(
//                                       "---------- Get Purchases Button Pressed");
//                                   this._getPurchases();
//                                 },
//                                 child: Container(
//                                   padding: EdgeInsets.symmetric(horizontal: 20.0),
//                                   alignment: Alignment(0.0, 0.0),
//                                   child: Text(
//                                     'Get Purchases',
//                                     style: TextStyle(
//                                       fontSize: 16.0,
//                                     ),
//                                   ),
//                                 ),
//                               )),
//                         ),
//                         Expanded(
//                           child: Container(
//
//                               margin: EdgeInsets.all(7.0),
//                               child:  ElevatedButton(
//                                 // color: Colors.orange,
//                                 onPressed: () {
//                                   print(
//                                       "---------- Get Purchase History Button Pressed");
//                                   this._getPurchaseHistory();
//                                 },
//                                 child: Container(
//                                   padding: EdgeInsets.symmetric(horizontal: 20.0),
//                                   alignment: Alignment(0.0, 0.0),
//                                   child: Text(
//                                     'Get Purchase History',
//                                     style: TextStyle(
//                                       fontSize: 16.0,
//                                     ),
//                                   ),
//                                 ),
//                               )),
//                         ),
//                       ]),
//                 ],
//               ),
//               Column(
//                 children: this._renderInApps(),
//               ),
//               Column(
//                 children: this._renderPurchases(),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
