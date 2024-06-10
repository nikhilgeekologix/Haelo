import 'package:haelo_flutter/features/cases/data/model/addexpensesfees_model.dart';
import 'package:haelo_flutter/features/cases/data/model/expenses_model.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';

class AddExpensesFeesDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  AddExpensesFeesDataSource(this.networkService, this.networkInfo);

  Future<AddExpensesFeesModel> fetchAddExpensesFees(Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.ADDFEES_EXPENSES,
        isAuth: true,
        body: body,
        // file: file,
        // fileKey: "uploadFile",
        // versionName: "2.0",
      );
      return AddExpensesFeesModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }
}
