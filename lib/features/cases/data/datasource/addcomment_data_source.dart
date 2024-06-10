import 'package:haelo_flutter/features/cases/data/model/addcomment_model.dart';
import 'package:haelo_flutter/features/cases/data/model/cmt_suggestion_model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';

class AddCommentDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  AddCommentDataSource(this.networkService, this.networkInfo);

  Future<AddCommentModel> fetchAddComment(Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.ADD_COMMENT,
        isAuth: true,
        body: body,
        // file: file,
        // fileKey: "uploadFile",
        versionName: "3.0",
      );
      return AddCommentModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }

  Future<CommentSuggestionModel> fetchCmtSuggestion(Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.CMT_SUGGESTION,
        isAuth: true,
        body: body,
        versionName: "1.0",
      );
      return CommentSuggestionModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }
}
