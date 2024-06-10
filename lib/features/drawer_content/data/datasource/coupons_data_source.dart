import 'package:haelo_flutter/features/drawer_content/data/model/aboutus_model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';
import '../model/coupons_model.dart';

class CouponsDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  CouponsDataSource(this.networkService, this.networkInfo);

  Future<CouponsModel> fetchCouponsList() async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.PROMOCODES_LISTS,
        isAuth: true,
      );
      return CouponsModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }
}
