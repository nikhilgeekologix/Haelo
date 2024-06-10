import 'package:haelo_flutter/features/home_page/data/model/court_summary_model.dart';
import 'package:haelo_flutter/features/task/data/model/task_caseno_model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';

class TaskCaseNoDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  TaskCaseNoDataSource(this.networkService, this.networkInfo);

  Future<TaskCaseNoModel> fetchTaskCaseNo() async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.Task_CASENO,
        isAuth: true,
        // body: body,
      );
      return TaskCaseNoModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }
}
