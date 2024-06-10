import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/cases/cubit/cmt_suggestion/cmt_suggestion_state.dart';

import '../../data/datasource/addcomment_data_source.dart';


class CommentSuggestionCubit extends Cubit<CommentSuggestionState> {
  final AddCommentDataSource dataSource;
  CommentSuggestionCubit(this.dataSource) : super(CommentSuggestionInitial());

  void fetchCommentSuggestion(Map<String, String> body) {
    emit(CommentSuggestionLoading());
    dataSource.fetchCmtSuggestion(body).
    then((value) =>
    {emit(CommentSuggestionLoaded(value))});
  }

}
