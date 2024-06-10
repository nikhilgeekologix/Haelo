import 'package:haelo_flutter/features/task/data/model/createtask_model.dart';
import 'package:haelo_flutter/features/task/data/model/taskdetails_model.dart';

import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';

class TaskDetailDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  TaskDetailDataSource(this.networkService, this.networkInfo);

  Future<TaskDetailModel> fetchTaskDetail(Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.TASK_DETAILS,
        isAuth: true,
        body: body,
        // file: file,
        // fileKey: "uploadFile",
        // versionName: "2.0",
      );
      return TaskDetailModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }
}
