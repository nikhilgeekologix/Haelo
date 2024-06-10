import 'package:in_app_purchase/in_app_purchase.dart';


class Singleton {
  static final Singleton _singleton = Singleton._internal();
  Singleton._internal();
  static Singleton get instance => _singleton;

  InAppPurchase? iAP;
  PurchaseDetails? iAPPurchase;
  List<PurchaseDetails>? iAPCurrentPurchase;
  List<ProductDetails>? iAPProducts;
  // bool isPrime = false;
  var userType = '';
 // ReceiptResultData? planDetails;
  String planName = "";
  String planStartTime = "";
  String planEndTime = "";
  String planOrderID = "";
  var userSubscription;
}
