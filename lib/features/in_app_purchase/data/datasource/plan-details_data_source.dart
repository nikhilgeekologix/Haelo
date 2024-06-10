import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';
import '../../../home_page/data/model/home_mytask_model.dart';
import '../model/plan_details.dart';

class PlanDetailsDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  PlanDetailsDataSource(this.networkService, this.networkInfo);

  Future<PlanDetailsData> fetchPlanDetails() async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.PLAN_DETAILS,
        isAuth: true,
        versionName: "1.0",
      );
      return PlanDetailsData.fromJson(response);
    } catch (e) {
      print("e $e");
      throw ServerException('Failed to get data');
    }
  }
}
