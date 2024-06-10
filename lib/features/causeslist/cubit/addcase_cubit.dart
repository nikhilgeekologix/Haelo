import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/causeslist/data/datasource/addcase_data_source.dart';
import 'package:haelo_flutter/features/causeslist/data/datasource/main_causelistdata_data_source.dart';
import 'addcase_state.dart';
import 'main_causelistdata_state.dart';

class AddCaseCubit extends Cubit<AddCaseState> {
  final AddCaseDataSource dataSource;
  AddCaseCubit(this.dataSource) : super(AddCaseInitial());

  void fetchAddCase(Map<String, String> body, file) {
    emit(AddCaseLoading());
    dataSource.fetchAddCase(body, file).then((value) => {emit(AddCaseLoaded(value))});
  }
}
