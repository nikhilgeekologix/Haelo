import 'package:haelo_flutter/features/causeslist/data/model/addcase_model.dart';
import 'package:haelo_flutter/features/causeslist/data/model/addcasetype_model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';

class AddCaseTypeDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  AddCaseTypeDataSource(this.networkService, this.networkInfo);

  Future<AddCaseTypeModel> fetchAddCaseType() async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.CASE_TYPE,
        isAuth: true,
        // body: body,
        // file: file,
        // fileKey: "uploadFile",
        versionName: "2.0",
      );
      return AddCaseTypeModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }
}
