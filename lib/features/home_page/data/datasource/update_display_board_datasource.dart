import 'package:haelo_flutter/core/utils/exceptions.dart';
import 'package:haelo_flutter/core/utils/network_info.dart';
import 'package:haelo_flutter/features/home_page/data/model/update_display_board_model.dart';
import 'package:haelo_flutter/services/network_service.dart';
import 'package:haelo_flutter/urls.dart';

class UpdateDisplayBoardDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  UpdateDisplayBoardDataSource(this.networkService, this.networkInfo);

  Future<UpdateDisplayBoardModel> updateDisplayBoard(Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
          isFullURL: false, url: Urls.REFRESH_DISPLAY_BOARD,
          isAuth: true, body: body,
          versionName: "1.0");
      return UpdateDisplayBoardModel.fromJson(response);
    } catch (e) {
      print("update db error $e");
      throw ServerException('Failed to get data');
    }
  }
}
