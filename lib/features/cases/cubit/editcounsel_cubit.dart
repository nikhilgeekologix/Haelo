import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/cases/data/datasource/editcounsel_data_source.dart';
import 'editcounsel_state.dart';

class EditCounselCubit extends Cubit<EditCounselState> {
  final EditCounselDataSource dataSource;
  EditCounselCubit(this.dataSource) : super(EditCounselInitial());

  void fetchEditCounsel(Map<String, String> body) {
    emit(EditCounselLoading());
    dataSource.fetchEditCounsel(body).then((value) => {emit(EditCounselLoaded(value))});
  }
}
