import 'package:haelo_flutter/features/cases/data/model/docdelete_model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';

class DocDeleteDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  DocDeleteDataSource(this.networkService, this.networkInfo);

  Future<DocDeleteModel> fetchDocDelete(Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.DOC_DELETE,
        isAuth: true,
        body: body,
        // file: file,
        // fileKey: "uploadFile",
        versionName: "2.0",
      );
      return DocDeleteModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }
}
