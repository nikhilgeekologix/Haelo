import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/home_page/data/datasource/court_summary_data_source.dart';
import 'court_summary_state.dart';

class CourtSummaryCubit extends Cubit<CourtSummaryState> {
  final CourtSummaryDataSource dataSource;
  CourtSummaryCubit(this.dataSource) : super(CourtSummaryInitial());

  void fetchCourtSummary(Map<String, String> body) {
    dataSource.fetchCourtSummary(body).then((value) => {emit(CourtSummaryLoaded(value))});
  }
}
