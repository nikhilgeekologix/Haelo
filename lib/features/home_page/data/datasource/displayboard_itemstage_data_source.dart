import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';
import '../model/displayboard_item_stage_model.dart';

class DisplayBoardItemStageDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  DisplayBoardItemStageDataSource(this.networkService, this.networkInfo);

  Future<DisplayBoardItemStageModel> fetchDisplayBoardItemStage(
      Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.DISPLAYBOARD_ITEMSTAGE,
        isAuth: true,
        body: body,
        versionName: "1.0",
      );
      return DisplayBoardItemStageModel.fromJson(response);
    } catch (e) {
      print("e $e");
      throw ServerException('Failed to get data');
    }
  }
}
