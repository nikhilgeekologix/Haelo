import 'package:haelo_flutter/features/drawer_content/data/model/faq_model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';

class FAQDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  FAQDataSource(this.networkService, this.networkInfo);

  Future<FAQModel> fetchFAQ() async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.FAQ,
        isAuth: true,
        // body: body,
        // file: file,
        // fileKey: "uploadFile",
        // versionName: "2.0",
      );
      return FAQModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }
}
