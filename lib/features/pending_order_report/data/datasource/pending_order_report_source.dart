import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';
import '../model/pending_oder_report_model.dart';

class PendingOrderReportSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;
  PendingOrderReportSource(this.networkService, this.networkInfo);

  Future<PendingOrderReportModel> fetchPendingOrderReport() async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.PENDING_ORDER_REPORT,
        isAuth: true,
        versionName: "2.0",
      );
      return PendingOrderReportModel.fromJson(response);
    } catch (e) {
      print("hello $e");
      throw ServerException('Failed to get data');
    }
  }
}
