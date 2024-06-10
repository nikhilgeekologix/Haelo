import 'package:haelo_flutter/features/cases/data/model/casetasklist_model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';

class CaseTaskListDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  CaseTaskListDataSource(this.networkService, this.networkInfo);

  Future<CaseTaskListModel> fetchCaseTaskList(Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.TASKLIST,
        isAuth: true,
        body: body,
        // file: file,
        // fileKey: "uploadFile",
        // versionName: "2.0",
      );
      return CaseTaskListModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }
}
