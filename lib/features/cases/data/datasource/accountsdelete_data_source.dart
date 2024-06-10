import 'package:haelo_flutter/features/cases/data/model/accountsdelete_model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';

class AccountsDeleteDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  AccountsDeleteDataSource(this.networkService, this.networkInfo);

  Future<AccountsDeleteModel> fetchAccountsDelete(Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.DELETEFEES_EXPENSES,
        isAuth: true,
        body: body,
        // file: file,
        // fileKey: "uploadFile",
        // versionName: "2.0",
      );
      return AccountsDeleteModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }
}
