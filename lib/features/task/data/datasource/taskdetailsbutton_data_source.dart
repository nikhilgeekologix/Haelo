import 'package:haelo_flutter/features/task/data/model/taskdetailsbuttons_model.dart';

import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';

class TaskDetailsButtonDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  TaskDetailsButtonDataSource(this.networkService, this.networkInfo);

  Future<TaskDetailsButtonModel> fetchTaskDetailsButton(Map<String, String> body, {file}) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.TASKDETAILS_BUTTON,
        isAuth: true,
        body: body,
        file: file,
        fileKey: "uploadFile",
        // versionName: "2.0",
      );
      return TaskDetailsButtonModel.fromJson(response);
    } catch (e) {
      print("exception $e");
      throw ServerException('Failed to get data');
    }
  }
}
