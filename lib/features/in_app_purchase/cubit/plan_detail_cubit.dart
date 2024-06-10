import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/in_app_purchase/cubit/plan_detail_state.dart';
import '../data/datasource/plan-details_data_source.dart';

class PlanDetailCubit extends Cubit<PlanDetailState> {
  final PlanDetailsDataSource dataSource;
  PlanDetailCubit(this.dataSource) : super(PlanDetailInitial());

  void fetchPlanDetailsStage() {
    emit(PlanDetailLoading());
    dataSource
        .fetchPlanDetails()
        .then((value) => {emit(PlanDetailLoaded(value))});
  }
}
