import 'package:haelo_flutter/features/home_page/data/model/court_summary_model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';

class CourtSummaryDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  CourtSummaryDataSource(this.networkService, this.networkInfo);

  Future<CourtSummaryModel> fetchCourtSummary(Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.COURT_SUMMARY,
        isAuth: true,
        body: body,
        // versionName: "3.1",
      );
      return CourtSummaryModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }
}
