import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/cases/cubit/updatecomment_state.dart';
import 'package:haelo_flutter/features/cases/data/datasource/updatecomment_data_source.dart';

class UpdateCommentCubit extends Cubit<UpdateCommentState> {
  final UpdateCommentDataSource dataSource;
  UpdateCommentCubit(this.dataSource) : super(UpdateCommentInitial());

  void fetchUpdateComment(Map<String, String> body) {
    emit(UpdateCommentLoading());
    dataSource.fetchUpdateComment(body).then((value) => {emit(UpdateCommentLoaded(value))});
  }
}
