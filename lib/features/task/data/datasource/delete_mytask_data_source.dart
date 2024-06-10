import 'package:haelo_flutter/features/task/data/model/delete_mytask_model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';

class DeleteMyTaskDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  DeleteMyTaskDataSource(this.networkService, this.networkInfo);

  Future<DeleteMyTaskModel> fetchDeleteMyTask(Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.DELETE,
        isAuth: true,
        body: body,
        // file: file,
        // fileKey: "uploadFile",
        versionName: "1.0",
      );
      return DeleteMyTaskModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }
}
