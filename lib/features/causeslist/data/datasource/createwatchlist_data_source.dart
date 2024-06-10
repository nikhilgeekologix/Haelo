import 'package:haelo_flutter/features/causeslist/data/model/createwatchlist_model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';

class CreateWatchlistDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  CreateWatchlistDataSource(this.networkService, this.networkInfo);

  Future<CreateWatchlistModel> fetchCreateWatchlist(Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.CREATE_WATCHLIST,
        isAuth: true,
        body: body,
        // file: file,
        // fileKey: "uploadFile",
        versionName: "2.0",
      );
      return CreateWatchlistModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }
}
