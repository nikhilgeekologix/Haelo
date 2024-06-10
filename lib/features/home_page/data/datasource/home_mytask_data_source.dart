import 'package:haelo_flutter/features/home_page/data/model/home_mytask_model.dart';

import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';

class HomeMyTaskDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  HomeMyTaskDataSource(this.networkService, this.networkInfo);

  Future<HomeMyTaskModel> fetchHomeMyTask(Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.HOME_MYTASK,
        isAuth: true,
        body: body,
        versionName: "3.2",
      );
      return HomeMyTaskModel.fromJson(response);
    } catch (e) {
      print("server ex ${e.toString()}");
      throw ServerException('Failed to get data');
    }
  }
}
