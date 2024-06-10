import 'package:haelo_flutter/constants.dart';
import 'package:haelo_flutter/features/splash/data/model/splash_model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';


class SplashRemoteDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  SplashRemoteDataSource(this.networkService, this.networkInfo);
  Future<SplashModel> fetchConfig(Map<String, String> map) async {
    try {
      final response = await networkService.postRequestNew(
          isFullURL: false, url: Urls.APP_VERSION, isAuth: false,headers: map,
          versionName: Constants.version);
      return SplashModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }

}
