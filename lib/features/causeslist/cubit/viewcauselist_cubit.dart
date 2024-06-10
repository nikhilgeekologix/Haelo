import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/causeslist/cubit/viewcauselist_state.dart';
import 'package:haelo_flutter/features/causeslist/data/datasource/viewcauselist_data_source.dart';

class ViewCauseListCubit extends Cubit<ViewCauseListState> {
  final ViewCauseListDataSource dataSource;
  ViewCauseListCubit(this.dataSource) : super(ViewCauseListInitial());

  void fetchViewCauseList(Map<String, String> body,String versionName,
  {bool isQuickSearch=false}) {
    emit(ViewCauseListLoading());
    if(!isQuickSearch) {
      dataSource.fetchViewCauseList(body,versionName).then((value) => {emit(ViewCauseListLoaded(value))});
    }else{
      dataSource.fetchQuickSearchData(body).then((value) => {emit(ViewCauseListLoaded(value))});
    }
  }
}
