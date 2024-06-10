import 'package:haelo_flutter/features/drawer_content/data/model/myteam_model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';

class MyTeamDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  MyTeamDataSource(this.networkService, this.networkInfo);

  Future<MyTeamModel> fetchMyTeam(Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.MY_TEAM,
        isAuth: true,
        body: body,
        // file: file,
        // fileKey: "uploadFile",
        // versionName: "2.0",
      );
      return MyTeamModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }
}
