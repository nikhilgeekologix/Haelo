import 'package:haelo_flutter/features/cases/data/model/fees_model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';

class FeesDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  FeesDataSource(this.networkService, this.networkInfo);

  Future<FeesModel> fetchFees(Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.FEES,
        isAuth: true,
        body: body,
        // file: file,
        // fileKey: "uploadFile",
        // versionName: "2.0",
      );
      return FeesModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }
}
