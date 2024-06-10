import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/drawer_content/data/datasource/commentshistory_data_source.dart';
import 'commentshistory_state.dart';

class CommentsHistoryCubit extends Cubit<CommentsHistoryState> {
  final CommentsHistoryDataSource dataSource;
  CommentsHistoryCubit(this.dataSource) : super(CommentsHistoryInitial());

  void fetchCommentsHistory(Map<String, String> body) {
    emit(CommentsHistoryLoading());
    dataSource.fetchCommentsHistory(body).then((value) => {emit(CommentsHistoryLoaded(value))});
  }
}
