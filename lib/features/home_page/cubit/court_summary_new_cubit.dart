import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/home_page/data/datasource/court_summary_data_source.dart';
import '../data/datasource/court_summary_new_data_source.dart';
import 'court_summary_new_state.dart';
import 'court_summary_state.dart';

class CourtSummaryNewCubit extends Cubit<CourtSummaryNewState> {
  final CourtSummaryNewDataSource dataSource;
  CourtSummaryNewCubit(this.dataSource) : super(CourtSummaryNewInitial());

  void fetchCourtNewSummary() {
    dataSource
        .fetchCourtSummaryNew()
        .then((value) => {emit(CourtSummaryNewLoaded(value))});
  }
}
