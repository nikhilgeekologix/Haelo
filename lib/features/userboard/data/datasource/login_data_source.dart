import 'package:haelo_flutter/constants.dart';

import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';
import '../model/admin_user_model.dart';


class LoginDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  LoginDataSource(this.networkService, this.networkInfo);

  Future<AdminUserModel> fetchAdminUser() async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false, url: Urls.ADMIN_USER, isAuth: false,
      versionName: Constants.version);
      return AdminUserModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }

}
