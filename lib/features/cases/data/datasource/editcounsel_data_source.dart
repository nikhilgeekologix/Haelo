import 'package:haelo_flutter/features/cases/data/model/editcounsel_model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';

class EditCounselDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  EditCounselDataSource(this.networkService, this.networkInfo);

  Future<EditCounselModel> fetchEditCounsel(Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.EDIT_COUNSEL,
        isAuth: true,
        body: body,
        // file: file,
        // fileKey: "uploadFile",
        versionName: "2.0",
      );
      return EditCounselModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }
}
