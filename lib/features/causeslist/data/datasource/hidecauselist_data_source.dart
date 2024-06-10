import 'package:haelo_flutter/features/causeslist/data/model/hidecauselist_model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';

class HideCauseListDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  HideCauseListDataSource(this.networkService, this.networkInfo);

  Future<HideCauseListModel> fetchHideCauseList(Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.Hide,
        isAuth: true,
        body: body,
        // file: file,
        // fileKey: "uploadFile",
        versionName: "1.0",
      );
      return HideCauseListModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }
}
