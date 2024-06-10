import 'package:haelo_flutter/features/cases/data/model/expenses_model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';

class ExpensesDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  ExpensesDataSource(this.networkService, this.networkInfo);

  Future<ExpensesModel> fetchExpenses(Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.EXPENSES,
        isAuth: true,
        body: body,
        // file: file,
        // fileKey: "uploadFile",
        // versionName: "2.0",
      );
      return ExpensesModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }
}
