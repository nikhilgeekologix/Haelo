import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/cases/data/datasource/casedocuments_data_source.dart';
import 'casedocuments_state.dart';
import 'expenses_state.dart';

class CaseDocumentsCubit extends Cubit<CaseDocumentsState> {
  final CaseDocumentsDataSource dataSource;
  CaseDocumentsCubit(this.dataSource) : super(CaseDocumentsInitial());

  void fetchCaseDocuments(Map<String, String> body) {
    emit(CaseDocumentsLoading());
    dataSource.fetchCaseDocuments(body).then((value) => {emit(CaseDocumentsLoaded(value))});
  }
}
