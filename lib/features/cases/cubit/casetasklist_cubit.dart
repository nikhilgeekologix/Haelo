import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/cases/data/datasource/casetasklist_data_source.dart';
import 'casetasklist_state.dart';

class CaseTaskListCubit extends Cubit<CaseTaskListState> {
  final CaseTaskListDataSource dataSource;
  CaseTaskListCubit(this.dataSource) : super(CaseTaskListInitial());

  void fetchCaseTaskList(Map<String, String> body) {
    emit(CaseTaskListLoading());
    dataSource.fetchCaseTaskList(body).then((value) => {emit(CaseTaskListLoaded(value))});
  }
}
