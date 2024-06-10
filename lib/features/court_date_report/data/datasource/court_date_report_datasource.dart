import 'package:haelo_flutter/core/utils/exceptions.dart';
import 'package:haelo_flutter/core/utils/network_info.dart';
import 'package:haelo_flutter/features/court_date_report/data/model/court_date_report_model.dart';
import 'package:haelo_flutter/services/network_service.dart';
import 'package:haelo_flutter/urls.dart';

class CourtDateReportDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;
  CourtDateReportDataSource(this.networkService, this.networkInfo);

  // Future<CourtDateReportModel> fetchCourtDateReport(Map<String, String>? body) async {
  //   try {
  //     final response = await networkService.postRequestNew(
  //         isFullURL: false,
  //         url: Urls.COURT_DATE_LISTING,
  //         isAuth: true,
  //         versionName: "1.0",
  //         body: body
  //     );
  //     return CourtDateReportModel.fromJson(response);
  //   } catch (e) {
  //     print("datasource $e");
  //     if ((e is ServerException) || (e is DataParsingException)) {
  //       rethrow;
  //     } else {
  //       throw NoConnectionException();
  //     }
  //   }
  // }

  Future<CourtDateReportModel> fetchCourtDateReport(
      Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
          isFullURL: false,
          url: Urls.COURT_DATE_LISTING,
          isAuth: true,
          versionName: "2.0",
          body: body);
      return CourtDateReportModel.fromJson(response);
    } catch (e) {
      print("hello $e");
      throw ServerException('Failed to get data');
    }
  }
}
