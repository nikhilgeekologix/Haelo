import 'package:haelo_flutter/features/causeslist/data/model/viewcauselist_model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';

class ViewCauseListDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  ViewCauseListDataSource(this.networkService, this.networkInfo);

  Future<ViewCauseListModel> fetchViewCauseList(
      Map<String, String> body, String versionName) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.VIEW_CAUSELIST,
        isAuth: true,
        body: body,
        versionName: versionName,
      );
      return ViewCauseListModel.fromJson(response);
    } catch (e) {
      print("exception type $e");
      throw ServerException('Failed to get data');
    }
  }

  Future<ViewCauseListModel> fetchQuickSearchData(
      Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.QUICK_SEARCH_LISTING,
        isAuth: true,
        body: body,
        versionName: "2.0",
      );
      return ViewCauseListModel.fromJson(response);
    } catch (e) {
      print("exception type $e");
      throw ServerException('Failed to get data');
    }
  }
}
