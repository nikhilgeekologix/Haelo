import 'package:haelo_flutter/features/task/data/model/createtask_model.dart';

import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';

class CreateTaskDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  CreateTaskDataSource(this.networkService, this.networkInfo);

  Future<CreateTaskModel> fetchCreateTask(Map<String, String> body, file) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.CREATE_TASK,
        isAuth: true,
        body: body,
        file: file,
        fileKey: "uploadFile",
        versionName: "2.0",
      );
      return CreateTaskModel.fromJson(response);
    } catch (e) {
      print("excepion $e");
      throw ServerException('Failed to get data');
    }
  }
}
