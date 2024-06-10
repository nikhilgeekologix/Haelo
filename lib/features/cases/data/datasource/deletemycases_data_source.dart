import 'package:haelo_flutter/features/cases/data/model/deletemycases_model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';

class DeleteMyCaseDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  DeleteMyCaseDataSource(this.networkService, this.networkInfo);

  Future<DeleteMyCaseModel> fetchDeleteMyCase(Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.DELETEMY_CASES,
        isAuth: true,
        body: body,
        // file: file,
        // fileKey: "uploadFile",
        // versionName: "2.0",
      );
      return DeleteMyCaseModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }
}
