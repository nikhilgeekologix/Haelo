import 'package:haelo_flutter/features/cases/data/model/casehistory.model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';

class CaseHistoryDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  CaseHistoryDataSource(this.networkService, this.networkInfo);

  Future<CaseHistoryModel> fetchCaseHistory(Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.CASE_HISTORY,
        isAuth: true,
        body: body,
        // file: file,
        // fileKey: "uploadFile",
        versionName: "2.0",
      );
      return CaseHistoryModel.fromJson(response);
    } catch (e) {
      print("e ${e.toString()}");
      throw ServerException('Failed to get data');
    }
  }
}
