import 'package:haelo_flutter/features/drawer_content/data/model/profile_model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';

class ProfileDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  ProfileDataSource(this.networkService, this.networkInfo);

  Future<ProfileModel> fetchProfile() async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.PROFILE,
        isAuth: true,
        // body: body,
        // file: file,
        // fileKey: "uploadFile",
        // versionName: "2.0",
      );
      return ProfileModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }
}
