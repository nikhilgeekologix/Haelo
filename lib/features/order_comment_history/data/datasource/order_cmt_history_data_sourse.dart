import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';
import '../model/order_cmt_history_data_model.dart';

class OrderCmtHistoryDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;
  OrderCmtHistoryDataSource(this.networkService, this.networkInfo);

  Future<OrderCommentHistoryModel> fetchOrderCmtHistoryData(
      Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.ORDER_COMMENT_HISTORY,
        isAuth: true,
        body: body,
        versionName: "2.0",
      );
      return OrderCommentHistoryModel.fromJson(response);
    } catch (e) {
      print("hello $e");
      throw ServerException('Failed to get data');
    }
  }
}
