import 'package:haelo_flutter/features/userboard/data/model/login_verify_model.dart';

import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';
import 'package:http/http.dart' as http;

class LoginVerifyDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  LoginVerifyDataSource(this.networkService, this.networkInfo);

  Future<LoginVerificationModel> fetchLoginVerify(Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.LOGIN_VERIFY,
        isAuth: false,
        body: body,
      );

      return LoginVerificationModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }
}
