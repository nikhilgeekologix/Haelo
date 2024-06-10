import 'package:haelo_flutter/features/drawer_content/data/model/profileupdate_model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';

class ProfileUpdateDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  ProfileUpdateDataSource(this.networkService, this.networkInfo);

  Future<ProfileUpdateModel> fetchProfileUpdate(Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.UPDATE_PROFILE,
        isAuth: true,
        body: body,
        // file: file,
        // fileKey: "uploadFile",
        versionName: "2.0",
      );
      return ProfileUpdateModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }
}
