import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/drawer_content/data/datasource/hidden%20_causelist_data_source.dart';
import 'hidden_causelist_state.dart';

class HiddenCauseListCubit extends Cubit<HiddenCauseListState> {
  final HiddenCauseListDataSource dataSource;
  HiddenCauseListCubit(this.dataSource) : super(HiddenCauseListInitial());

  void fetchHiddenCauseList() {
    emit(HiddenCauseListLoading());
    dataSource.fetchHiddenCauseList().then((value) => {emit(HiddenCauseListLoaded(value))});
  }
}
