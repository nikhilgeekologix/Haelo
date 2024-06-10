import 'package:haelo_flutter/features/home_page/data/model/court_summary_model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';
import '../model/CourtSummaryNewModel.dart';

class CourtSummaryNewDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  CourtSummaryNewDataSource(this.networkService, this.networkInfo);

  Future<CourtSummaryNewModel> fetchCourtSummaryNew() async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.COURT_SUMMARY_NEW,
        isAuth: true,
        // versionName: "3.1",
      );
      return CourtSummaryNewModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }
}
