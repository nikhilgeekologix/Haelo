
import 'package:haelo_flutter/core/utils/exceptions.dart';
import 'package:haelo_flutter/core/utils/network_info.dart';
import 'package:haelo_flutter/features/drawer_content/data/model/delete_account_model.dart';
import 'package:haelo_flutter/services/network_service.dart';
import 'package:haelo_flutter/urls.dart';

class DeleteAccountDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  DeleteAccountDataSource(this.networkService, this.networkInfo);

  Future<DeleteAccountModel> deleteAccount() async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.USER_DELETE,
        isAuth: true,
        versionName: "1.0",
      );
      return DeleteAccountModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }
}
