import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/cases/data/datasource/addcomment_data_source.dart';
import 'addcomment_state.dart';

class AddCommentCubit extends Cubit<AddCommentState> {
  final AddCommentDataSource dataSource;
  AddCommentCubit(this.dataSource) : super(AddCommentInitial());

  void fetchAddComment(Map<String, String> body) {
    emit(AddCommentLoading());
    dataSource.fetchAddComment(body).then((value) => {emit(AddCommentLoaded(value))});
  }
}
