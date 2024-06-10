import 'package:haelo_flutter/features/userboard/data/model/firm_register_model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';
import 'package:http/http.dart' as http;

class FirmRegisterDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  FirmRegisterDataSource(this.networkService, this.networkInfo);

  Future<FirmRegisterModel> fetchFirmRegister(Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.FIRM_REGISTER,
        isAuth: false,
        body: body,
        versionName: "3.0"
      );

      return FirmRegisterModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }
}
