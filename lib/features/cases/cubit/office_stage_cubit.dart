import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/features/pending_order_report/cubit/pending_order_report_state.dart';

import '../data/datasource/office_stage_source.dart';
import 'office_stage_state.dart';

class OfficeStageCubit extends Cubit<OfficeStageState> {
  final OfficeStageSource dataSource;
  OfficeStageCubit(this.dataSource) : super(OfficeStageInitial());

  void fetchOfficeStageData() {
    emit(OfficeStageLoading());
    dataSource
        .fetchOfficeStage()
        .then((value) => {emit(OfficeStageLoaded(value))});
  }
}
