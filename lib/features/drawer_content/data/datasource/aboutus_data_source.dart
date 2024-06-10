import 'package:haelo_flutter/features/drawer_content/data/model/aboutus_model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';

class AboutUsDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  AboutUsDataSource(this.networkService, this.networkInfo);

  Future<AboutUsModel> fetchAboutUs() async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.ABOUT_US,
        isAuth: true,
        // body: body,
        // file: file,
        // fileKey: "uploadFile",
        // versionName: "2.0",
      );
      return AboutUsModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }
}
