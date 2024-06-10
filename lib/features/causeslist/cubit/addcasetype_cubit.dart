import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/causeslist/data/datasource/addcase_data_source.dart';
import 'package:haelo_flutter/features/causeslist/data/datasource/addcasetype_data_source.dart';
import 'package:haelo_flutter/features/causeslist/data/datasource/main_causelistdata_data_source.dart';
import 'addcase_state.dart';
import 'addcasetype_state.dart';
import 'main_causelistdata_state.dart';

class AddCaseTypeCubit extends Cubit<AddCaseTypeState> {
  final AddCaseTypeDataSource dataSource;
  AddCaseTypeCubit(this.dataSource) : super(AddCaseTypeInitial());

  void fetchAddCaseType() {
    emit(AddCaseTypeLoading());
    dataSource.fetchAddCaseType().then((value) => {emit(AddCaseTypeLoaded(value))});
  }
}
