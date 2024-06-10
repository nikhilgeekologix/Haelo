import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/cases/data/datasource/casehistory_data_source.dart';
import 'casehistory_state.dart';

class CaseHistoryCubit extends Cubit<CaseHistoryState> {
  final CaseHistoryDataSource dataSource;
  CaseHistoryCubit(this.dataSource) : super(CaseHistoryInitial());

  void fetchCaseHistory(Map<String, String> body) {
    emit(CaseHistoryLoading());
    dataSource.fetchCaseHistory(body).then((value) => {emit(CaseHistoryLoaded(value))});
  }
}
