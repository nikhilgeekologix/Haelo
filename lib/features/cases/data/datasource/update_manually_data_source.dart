import 'package:haelo_flutter/features/cases/data/model/mycases_model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';
import '../model/adddetails_model.dart';

class UpdateManuallyDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  UpdateManuallyDataSource(this.networkService, this.networkInfo);

  Future<AddDetailsModel> fetchUpdateManually(Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.ADD_IMMEDIATE_CASE,
        isAuth: true,
        body: body,
        versionName: "1.0",
      );
      return AddDetailsModel.fromJson(response);
    } catch (e) {
      print("MyCasesModel errr $e");
      throw ServerException('Failed to get data');
    }
  }
}
