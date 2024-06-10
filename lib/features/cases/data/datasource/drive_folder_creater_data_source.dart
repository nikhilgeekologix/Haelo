import 'package:haelo_flutter/features/cases/data/model/addcomment_model.dart';
import 'package:haelo_flutter/features/cases/data/model/cmt_suggestion_model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';

class DriveFolderCreatorDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  DriveFolderCreatorDataSource(this.networkService, this.networkInfo);

  Future<AddCommentModel> fetchDriveFolderCreator(
      Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.DRIVE_FOLDER_CREATOR,
        isAuth: true,
        body: body,
        versionName: "1.0",
      );
      return AddCommentModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }
}
