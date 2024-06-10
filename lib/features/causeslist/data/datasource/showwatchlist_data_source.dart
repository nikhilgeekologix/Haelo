import 'package:haelo_flutter/features/causeslist/data/model/addcase_model.dart';
import 'package:haelo_flutter/features/causeslist/data/model/showwatchlist_model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';

class ShowWatchlistDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  ShowWatchlistDataSource(this.networkService, this.networkInfo);

  Future<ShowWatchlistModel> fetchShowWatchlist() async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.SHOW_WATCHLIST,
        isAuth: true,
        // body: body,
        // file: file,
        // fileKey: "uploadFile",
        // versionName: "3.0",
      );
      return ShowWatchlistModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }
}
