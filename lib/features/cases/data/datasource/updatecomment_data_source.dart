import 'package:haelo_flutter/features/cases/data/model/updatecomment_model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';

class UpdateCommentDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  UpdateCommentDataSource(this.networkService, this.networkInfo);

  Future<UpdateCommentModel> fetchUpdateComment(
      Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.UPDATE_COMMENT,
        isAuth: true,
        body: body,
        // file: file,
        // fileKey: "uploadFile",
        versionName: "3.1",
      );
      return UpdateCommentModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }
}
