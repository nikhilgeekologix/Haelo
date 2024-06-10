import 'package:haelo_flutter/features/causeslist/data/model/viewandsave_model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';

class ViewSaveDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  ViewSaveDataSource(this.networkService, this.networkInfo);

  Future<ViewSaveModel> fetchViewSave(Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.VIEW_SAVE,
        isAuth: true,
        body: body,
        // file: file,
        // fileKey: "uploadFile",
        // versionName: "1.0",
      );
      return ViewSaveModel.fromJson(response);
    } catch (e) {
      print("server error ${e.toString()}");
      throw ServerException('Failed to get data');
    }
  }
}
