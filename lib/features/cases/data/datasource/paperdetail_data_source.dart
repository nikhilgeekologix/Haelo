import 'package:haelo_flutter/features/cases/data/model/paperdetail_model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';

class PaperDetailDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  PaperDetailDataSource(this.networkService, this.networkInfo);

  Future<PaperDetailModel> fetchPaperDetail(Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.PAPER_DETAILS,
        isAuth: true,
        body: body,
        // file: file,
        // fileKey: "uploadFile",
        versionName: "1.0",
      );
      return PaperDetailModel.fromJson(response);
    } catch (e) {
      print("heelpp $e");
      throw ServerException('Failed to get data');
    }
  }
}
