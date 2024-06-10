import 'package:haelo_flutter/features/causeslist/data/model/main_causelistdata_model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';

class MainCauseListDataDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  MainCauseListDataDataSource(this.networkService, this.networkInfo);

  Future<MainCauseListDataModel> fetchMainCauseListData(Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.CAUSELIST_MAIN,
        isAuth: true,
        body: body,
        versionName: "2.0",
      );
      return MainCauseListDataModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }
}
