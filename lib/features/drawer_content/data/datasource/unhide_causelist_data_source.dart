import 'package:haelo_flutter/features/drawer_content/data/model/unhide_causelist_model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';

class UnHideCauseListDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  UnHideCauseListDataSource(this.networkService, this.networkInfo);

  Future<UnHideCauseListModel> fetchUnHideCauseList(
      Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.UNHIDE,
        isAuth: true,
        body: body,
        // file: file,
        // fileKey: "uploadFile",
        versionName: "2.0",
      );
      return UnHideCauseListModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }
}
