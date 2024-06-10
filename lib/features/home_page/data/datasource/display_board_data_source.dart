import 'package:fbroadcast/fbroadcast.dart';
import 'package:haelo_flutter/features/home_page/data/model/display_board_model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';

class DisplayBoardDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  DisplayBoardDataSource(this.networkService, this.networkInfo);

  Future<DisplayBoardModel> fetchDisplayBoard(Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
          isFullURL: false, url: Urls.DISPLAY_BOARD, isAuth: true, body: body,
          versionName: "2.0");
      return DisplayBoardModel.fromJson(response);
    }
    catch (e) {
      print("exception $e");
      return DisplayBoardModel();
      throw ServerException('Failed to get data');
    }
  }
}
