import 'package:haelo_flutter/features/cases/data/model/comments_model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';

class CasesCommentDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  CasesCommentDataSource(this.networkService, this.networkInfo);

  Future<CasesCommentModel> fetchCasesComment(Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.COMMENT_TAB,
        isAuth: true,
        body: body,
        // file: file,
        // fileKey: "uploadFile",
        versionName: "1.0",
      );
      return CasesCommentModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }
}
