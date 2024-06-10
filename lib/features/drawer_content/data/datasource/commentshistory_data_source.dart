import 'package:haelo_flutter/features/drawer_content/data/model/commentshistory_model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';

class CommentsHistoryDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  CommentsHistoryDataSource(this.networkService, this.networkInfo);

  Future<CommentsHistoryModel> fetchCommentsHistory(Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.COMMENTS_HISTORY,
        isAuth: true,
        body: body,
        // file: file,
        // fileKey: "uploadFile",
        versionName: "2.0",
      );
      return CommentsHistoryModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }
}
