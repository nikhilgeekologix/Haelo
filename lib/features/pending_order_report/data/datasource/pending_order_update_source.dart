import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';
import '../model/pending_dowload_file_model.dart';
import '../model/pending_oder_report_model.dart';

class PendingOrderUpdateSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;
  PendingOrderUpdateSource(this.networkService, this.networkInfo);

  Future<PendingDownloadFileModel> fetchPendingOrderUpdate(
      Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.UPDATE_PENDING_ORDER,
        isAuth: true,
        body: body,
        versionName: "1.0",
      );
      return PendingDownloadFileModel.fromJson(response);
    } catch (e) {
      print("hello $e");
      throw ServerException('Failed to get data');
    }
  }
}
