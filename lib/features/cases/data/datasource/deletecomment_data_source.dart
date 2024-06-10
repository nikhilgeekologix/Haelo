import 'package:haelo_flutter/features/cases/data/model/deletecomment_model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';

class DeleteCommentDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  DeleteCommentDataSource(this.networkService, this.networkInfo);

  Future<DeleteCommentModel> fetchDeleteComment(Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.DELETE_COMMENT,
        isAuth: true,
        body: body,
        // file: file,
        // fileKey: "uploadFile",
        versionName: "1.0",
      );
      return DeleteCommentModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }
}
