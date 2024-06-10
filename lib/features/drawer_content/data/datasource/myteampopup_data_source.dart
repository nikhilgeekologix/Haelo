import 'package:haelo_flutter/features/drawer_content/data/model/myteampopup_model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';

class MyTeamPopupDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  MyTeamPopupDataSource(this.networkService, this.networkInfo);

  Future<MyTeamPopupModel> fetchMyTeamPopup(Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.TEAM_POPUP,
        isAuth: true,
        body: body,
        // file: file,
        // fileKey: "uploadFile",
        // versionName: "2.0",
      );
      return MyTeamPopupModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }
}
