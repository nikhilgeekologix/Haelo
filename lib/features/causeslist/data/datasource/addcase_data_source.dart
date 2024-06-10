import 'package:haelo_flutter/features/causeslist/data/model/addcase_model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';

class AddCaseDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  AddCaseDataSource(this.networkService, this.networkInfo);

  Future<AddCaseModel> fetchAddCase(Map<String, String> body, file) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.ADD_CASE,
        isAuth: true,
        body: body,
        file: file,
        fileKey: "uploadFile",
        versionName: "3.1",
      );
      return AddCaseModel.fromJson(response);
    } catch (e) {
      print("hello $e");
      throw ServerException('Failed to get data');
    }
  }
}
