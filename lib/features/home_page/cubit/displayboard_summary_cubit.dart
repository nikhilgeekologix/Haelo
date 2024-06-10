import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/home_page/data/datasource/displayboard_summary_data_source.dart';
import 'displayboard_summary_state.dart';

class DisplayBoardSummaryCubit extends Cubit<DisplayBoardSummaryState> {
  final DisplayBoardSummaryDataSource dataSource;
  DisplayBoardSummaryCubit(this.dataSource) : super(DisplayBoardSummaryInitial());

  void fetchDisplayBoardSummary(Map<String, String> body) {
    emit(DisplayBoardSummaryLoading());
    dataSource.fetchDisplayBoardSummary(body).then((value) => {emit(DisplayBoardSummaryLoaded(value))});
  }
}
