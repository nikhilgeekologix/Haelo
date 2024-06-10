import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/cases/data/datasource/casedetails_data_source.dart';
import 'casedetail_state.dart';

class CaseDetailCubit extends Cubit<CaseDetailState> {
  final CaseDetailDataSource dataSource;
  CaseDetailCubit(this.dataSource) : super(CaseDetailInitial());

  void fetchCaseDetail(Map<String, String> body) {
    emit(CaseDetailLoading());
    dataSource.fetchCaseDetail(body).then((value) => {emit(CaseDetailLoaded(value))});
  }
}
