import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/causeslist/data/datasource/createcase_data_source.dart';
import 'createcase_state.dart';

class CauseListCreateCaseCubit extends Cubit<CauseListCreateCaseState> {
  final CauseListCreateCaseDataSource dataSource;
  CauseListCreateCaseCubit(this.dataSource) : super(CauseListCreateCaseInitial());

  void fetchCauseListCreateCase(Map<String, String> body) {
    emit(CauseListCreateCaseLoading());
    dataSource.fetchCauseListCreateCase(body).then((value) => {emit(CauseListCreateCaseLoaded(value))});
  }
}
