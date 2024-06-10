import 'package:haelo_flutter/features/cases/data/model/casedocuments_model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';

class CaseDocumentsDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  CaseDocumentsDataSource(this.networkService, this.networkInfo);

  Future<CaseDocumentsModel> fetchCaseDocuments(Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.DOCUMENTS,
        isAuth: true,
        body: body,
        // file: file,
        // fileKey: "uploadFile",
        versionName: "2.0",
      );
      return CaseDocumentsModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }
}
