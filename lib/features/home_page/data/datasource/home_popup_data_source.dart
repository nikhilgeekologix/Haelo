import 'package:haelo_flutter/features/userboard/data/model/login_verify_model.dart';

import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';
import 'package:http/http.dart' as http;

import '../model/HomeStatusModel.dart';

class HomePopupBoardDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  HomePopupBoardDataSource(this.networkService, this.networkInfo);

  Future<HomeStatusModel> fetchHomePopupBoard(Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.HOME_APP_NOTIFICATION,
        body: body,
        isAuth: false,
      );

      return HomeStatusModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }
}
