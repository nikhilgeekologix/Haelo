import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/causeslist/cubit/viewandsave_state.dart';
import 'package:haelo_flutter/features/causeslist/data/datasource/createcase_data_source.dart';
import 'package:haelo_flutter/features/causeslist/data/datasource/viewandsave_data_source.dart';
import 'createcase_state.dart';

class ViewSaveCubit extends Cubit<ViewSaveState> {
  final ViewSaveDataSource dataSource;
  ViewSaveCubit(this.dataSource) : super(ViewSaveInitial());

  void fetchViewSave(Map<String, String> body) {
      emit(ViewSaveLoading());
    dataSource.fetchViewSave(body).then((value) => {emit(ViewSaveLoaded(value))});
  }
}
