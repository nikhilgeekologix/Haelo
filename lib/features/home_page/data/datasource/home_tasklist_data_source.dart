import 'package:haelo_flutter/features/home_page/data/model/Home_TaskList_Model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';

class HomeTaskListDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  HomeTaskListDataSource(this.networkService, this.networkInfo);
  // int page
  Future<HomeTaskListModel> fetchHomeTaskList(Map<String, String>? body) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.HOME_TASKLIST,
        isAuth: true,
        body: body,
        versionName: "2.0",
      );
      return HomeTaskListModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }
}
