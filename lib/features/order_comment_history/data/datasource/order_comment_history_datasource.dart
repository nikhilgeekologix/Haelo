import 'package:haelo_flutter/core/utils/exceptions.dart';
import 'package:haelo_flutter/core/utils/network_info.dart';
import 'package:haelo_flutter/features/order_comment_history/data/model/order_comment_history_model.dart';
import 'package:haelo_flutter/services/network_service.dart';
import 'package:haelo_flutter/urls.dart';

class OrderCommentHistoryDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;
  OrderCommentHistoryDataSource(this.networkService, this.networkInfo);

  Future<OrderCommentHistoryModel> fetchOrderCmtHistoryold(
      Map<String, String>? body) async {
    try {
      final response = await networkService.postRequestNew(
          isFullURL: false,
          url: Urls.ORDER_COMMENT_HISTORY,
          isAuth: true,
          versionName: "2.0",
          body: body);
      return OrderCommentHistoryModel.fromJson(response);
    } catch (e) {
      print("datasource $e");
      if ((e is ServerException) || (e is DataParsingException)) {
        rethrow;
      } else {
        throw NoConnectionException();
      }
    }
  }

  Future<OrderCommentHistoryModel> fetchOrderCmtHistory(
      Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
          isFullURL: false,
          url: Urls.ORDER_COMMENT_HISTORY,
          isAuth: true,
          versionName: "2.0",
          body: body);
      return OrderCommentHistoryModel.fromJson(response);
    } catch (e) {
      print("hello $e");
      throw ServerException('Failed to get data');
    }
  }
}
