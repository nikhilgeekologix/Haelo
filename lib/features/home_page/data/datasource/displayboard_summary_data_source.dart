import 'package:haelo_flutter/features/home_page/data/model/display_board_model.dart';
import 'package:haelo_flutter/features/home_page/data/model/displayboard_summary_model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';

class DisplayBoardSummaryDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  DisplayBoardSummaryDataSource(this.networkService, this.networkInfo);

  Future<DisplayBoardSummaryModel> fetchDisplayBoardSummary(
      Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.DISPLAYBOARD_SUMMARY,
        isAuth: true,
        body: body,
        versionName: "3.1",
      );
      return DisplayBoardSummaryModel.fromJson(response);
    } catch (e) {
      print("e $e");
      throw ServerException('Failed to get data');
    }
  }
}
