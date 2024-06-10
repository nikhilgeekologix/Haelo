import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/cases/data/datasource/deletecomment_data_source.dart';
import 'deletecomment_state.dart';

class DeleteCommentCubit extends Cubit<DeleteCommentState> {
  final DeleteCommentDataSource dataSource;
  DeleteCommentCubit(this.dataSource) : super(DeleteCommentInitial());

  void fetchDeleteComment(Map<String, String> body) {
    emit(DeleteCommentLoading());
    dataSource.fetchDeleteComment(body).then((value) => {emit(DeleteCommentLoaded(value))});
  }
}
