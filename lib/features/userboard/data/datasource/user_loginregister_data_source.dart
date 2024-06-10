import 'package:haelo_flutter/features/userboard/data/model/user_loginregister_model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';
import 'package:http/http.dart' as http;

class UserLoginRegisterDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  UserLoginRegisterDataSource(this.networkService, this.networkInfo);

  Future<UserLoginRegisterModel> fetchUserLoginRegister(Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.USER_LOGINREGISTER,
        isAuth: false,
        body: body,
        versionName: "2.0"

      );

      return UserLoginRegisterModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }
}
