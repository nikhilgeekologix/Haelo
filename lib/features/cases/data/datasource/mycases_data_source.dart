import 'package:haelo_flutter/features/cases/data/model/mycases_model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';

class MyCasesDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  MyCasesDataSource(this.networkService, this.networkInfo);

  Future<MyCasesModel> fetchMyCases(Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.MY_CASES,
        isAuth: true,
        body: body,
        // file: file,
        // fileKey: "uploadFile",
        versionName: "3.2",
      );
      //print("from datasource ${response}");
      return MyCasesModel.fromJson(response);
    } catch (e) {
      print("MyCasesModel errr $e");
      throw ServerException('Failed to get data');
    }
  }
}
