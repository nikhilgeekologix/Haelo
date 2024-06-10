import 'package:haelo_flutter/core/utils/exceptions.dart';
import 'package:haelo_flutter/core/utils/network_info.dart';
import 'package:haelo_flutter/features/in_app_purchase/data/model/my_subscription_model.dart';
import 'package:haelo_flutter/features/in_app_purchase/data/model/plans_model.dart';
import 'package:haelo_flutter/services/network_service.dart';
import 'package:haelo_flutter/urls.dart';

import '../model/pay_request_model.dart';

class PlansDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  PlansDataSource(this.networkService, this.networkInfo);

  Future<PlansModel> fetchAllPlans() async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.PLANS,
        isAuth: true,
        versionName: "1.0",
      );
      return PlansModel.fromJson(response);
    } catch (e) {
      print("datasource $e");
      if ((e is ServerException) || (e is DataParsingException)) {
        rethrow;
      } else {
        throw NoConnectionException();
      }
    }
  }

  Future<MySubscriptionModel> fetchMySubscription() async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.MY_SUBSCRIPTION,
        isAuth: true,
        versionName: "2.0",
      );
      return MySubscriptionModel.fromJson(response);
    } catch (e) {
      print("datasource $e");
      if ((e is ServerException) || (e is DataParsingException)) {
        rethrow;
      } else {
        throw NoConnectionException();
      }
    }
  }

  Future<PayRequestModel> payRequest(Map<String, String> data) async {
    try {
      final response = await networkService.postRequestNew(
          isFullURL: false,
          url: Urls.PAY_REQUIEST,
          isAuth: true,
          versionName: "2.0",
          body: data);
      return PayRequestModel.fromJson(response);
    } catch (e) {
      print("datasource $e");
      if ((e is ServerException) || (e is DataParsingException)) {
        rethrow;
      } else {
        throw NoConnectionException();
      }
    }
  }
}
