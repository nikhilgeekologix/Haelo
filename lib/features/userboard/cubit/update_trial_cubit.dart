import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/userboard/cubit/update_trial_state.dart';

import '../data/datasource/login_data_source.dart';
import '../data/datasource/update_trial_data_source.dart';
import 'login_state.dart';

class UpdateTrialCubit extends Cubit<UpdateTrialState> {
  final UpdateTrialDataSource dataSource;
  UpdateTrialCubit(this.dataSource) : super(UpdateTrialInitial());

  void fetchUpdateTrialUser({Map<String, String>? map}) {
    dataSource
        .fetchUpdateTrial()
        .then((value) => {emit(UpdateTrialLoaded(value))});
  }
}
