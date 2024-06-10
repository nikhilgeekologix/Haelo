import 'package:haelo_flutter/features/userboard/data/model/login_verify_model.dart';

import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../services/network_service.dart';
import '../../../../urls.dart';
import 'package:http/http.dart' as http;

import '../model/update_trial_model.dart';

class UpdateTrialDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  UpdateTrialDataSource(this.networkService, this.networkInfo);

  Future<UpdateTrialModel> fetchUpdateTrial() async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.UPDATE_TRIAL,
        isAuth: false,
      );

      return UpdateTrialModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get data');
    }
  }
}
