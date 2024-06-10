import 'package:haelo_flutter/features/cases/data/model/casedetails_model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';

class CaseDetailDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  CaseDetailDataSource(this.networkService, this.networkInfo);

  Future<CaseDetailModel> fetchCaseDetail(Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.CASE_DETAILS,
        isAuth: true,
        body: body,
        // file: file,
        // fileKey: "uploadFile",
        versionName: "2.0",
      );
      return CaseDetailModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }
}
