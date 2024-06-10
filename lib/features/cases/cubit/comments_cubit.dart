import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/cases/data/datasource/comments_data_source.dart';

import 'comments_state.dart';

class CasesCommentCubit extends Cubit<CasesCommentState> {
  final CasesCommentDataSource dataSource;
  CasesCommentCubit(this.dataSource) : super(CasesCommentInitial());

  void fetchCasesComment(Map<String, String> body) {
    emit(CasesCommentLoading());
    dataSource.fetchCasesComment(body).then((value) => {emit(CasesCommentLoaded(value))});
  }
}
