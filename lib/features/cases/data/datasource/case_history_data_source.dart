/*
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';
import '../model/mass_data.dart';

class DisplayBoardItemMassDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  DisplayBoardItemMassDataSource(this.networkService, this.networkInfo);

  Future<MassDataModel> fetchMassData(Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.MASS_DATA,
        isAuth: true,
        body: body,
        versionName: "1.0",
      );
      return MassDataModel.fromJson(response);
    } catch (e) {
      print("e $e");
      throw ServerException('Failed to get data');
    }
  }
}
*/
