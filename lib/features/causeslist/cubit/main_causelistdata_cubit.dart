import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/causeslist/data/datasource/main_causelistdata_data_source.dart';
import 'main_causelistdata_state.dart';

class MainCauseListDataCubit extends Cubit<MainCauseListDataState> {
  final MainCauseListDataDataSource dataSource;
  MainCauseListDataCubit(this.dataSource) : super(MainCauseListDataInitial());

  void fetchMainCauseListData(Map<String, String> body) {
    emit(MainCauseListDataLoading());
    dataSource.fetchMainCauseListData(body).then((value) => {emit(MainCauseListDataLoaded(value))});
  }
}
