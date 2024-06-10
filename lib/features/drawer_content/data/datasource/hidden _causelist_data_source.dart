import 'package:haelo_flutter/features/drawer_content/data/model/hidden_causelist_model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';

class HiddenCauseListDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  HiddenCauseListDataSource(this.networkService, this.networkInfo);

  Future<HiddenCauseListModel> fetchHiddenCauseList() async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.HIDDEN_LIST,
        isAuth: true,
        // body: body,
        // file: file,
        // fileKey: "uploadFile",
        versionName: "1.0",
      );
      return HiddenCauseListModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }
}
