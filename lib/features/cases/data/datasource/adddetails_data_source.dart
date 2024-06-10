import 'package:haelo_flutter/features/cases/data/model/adddetails_model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';

class AddDetailsDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  AddDetailsDataSource(this.networkService, this.networkInfo);

  Future<AddDetailsModel> fetchAddDetails(Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.ADD_DETAILS,
        isAuth: true,
        body: body,
        // file: file,
        // fileKey: "uploadFile",
        // versionName: "1.0",
      );
      return AddDetailsModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }
}
