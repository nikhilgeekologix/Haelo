import 'package:haelo_flutter/features/causeslist/data/model/addcase_model.dart';
import 'package:haelo_flutter/features/causeslist/data/model/createcase_model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';

class CauseListCreateCaseDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  CauseListCreateCaseDataSource(this.networkService, this.networkInfo);

  Future<CauseListCreateCaseModel> fetchCauseListCreateCase(Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.CREATE_CASE,
        isAuth: true,
        body: body,
        // file: file,
        // fileKey: "uploadFile",
        versionName: "1.0",
      );
      return CauseListCreateCaseModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }
}
