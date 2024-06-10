import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';
import '../model/office_stage_model.dart';

class OfficeStageSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  OfficeStageSource(this.networkService, this.networkInfo);

  Future<OfficeStageModel> fetchOfficeStage() async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.OFFICE_STAGE,
        isAuth: true,
        versionName: "1.0",
      );
      return OfficeStageModel.fromJson(response);
    } catch (e) {
      print("e $e");
      throw ServerException('Failed to get data');
    }
  }
}
