import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/drawer_content/cubit/unhide_causelist_state.dart';
import 'package:haelo_flutter/features/drawer_content/data/datasource/unhide_causelist_data_source.dart';

class UnHideCauseListCubit extends Cubit<UnHideCauseListState> {
  final UnHideCauseListDataSource dataSource;
  UnHideCauseListCubit(this.dataSource) : super(UnHideCauseListInitial());

  void fetchUnHideCauseList(Map<String, String> body) {
    emit(UnHideCauseListLoading());
    dataSource.fetchUnHideCauseList(body).then((value) => {emit(UnHideCauseListLoaded(value))});
  }
}
