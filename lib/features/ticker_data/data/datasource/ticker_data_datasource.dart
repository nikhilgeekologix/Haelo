import 'package:haelo_flutter/core/utils/exceptions.dart';
import 'package:haelo_flutter/core/utils/network_info.dart';
import 'package:haelo_flutter/features/home_page/data/model/update_display_board_model.dart';
import 'package:haelo_flutter/services/network_service.dart';
import 'package:haelo_flutter/urls.dart';

import '../model/ticker_data_model.dart';

class TickerDataDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  TickerDataDataSource(this.networkService, this.networkInfo);

  Future<TickerDataModel> TickerData(Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
          isFullURL: false,
          url: Urls.TICKER_DATA,
          isAuth: true,
          body: body,
          versionName: "2.0");
      return TickerDataModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }
}
