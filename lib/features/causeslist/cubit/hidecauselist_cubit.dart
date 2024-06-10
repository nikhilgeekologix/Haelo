import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/causeslist/data/datasource/addcase_data_source.dart';
import 'package:haelo_flutter/features/causeslist/data/datasource/hidecauselist_data_source.dart';
import 'package:haelo_flutter/features/causeslist/data/datasource/main_causelistdata_data_source.dart';
import 'addcase_state.dart';
import 'hidecauselist_state.dart';
import 'main_causelistdata_state.dart';

class HideCauseListCubit extends Cubit<HideCauseListState> {
  final HideCauseListDataSource dataSource;
  HideCauseListCubit(this.dataSource) : super(HideCauseListInitial());

  void fetchHideCauseList(Map<String, String> body) {
    dataSource.fetchHideCauseList(body).then((value) => {emit(HideCauseListLoaded(value))});
  }
}
