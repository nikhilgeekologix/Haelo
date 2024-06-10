import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';
import '../../../home_page/data/model/home_mytask_model.dart';
import '../model/plan_details.dart';
import '../model/promo_code_model.dart';

class PromoCodesDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  PromoCodesDataSource(this.networkService, this.networkInfo);

  Future<PromoCodesModel> fetchPromoCodesDetails() async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.PROMOCODE_DETAILS,
        isAuth: true,
        versionName: "1.0",
      );
      return PromoCodesModel.fromJson(response);
    } catch (e) {
      print("e $e");
      throw ServerException('Failed to get data');
    }
  }
}
