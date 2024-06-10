import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/cases/data/datasource/mycases_data_source.dart';
import 'mycases_state.dart';

class MyCasesCubit extends Cubit<MyCasesState> {
  final MyCasesDataSource dataSource;
  MyCasesCubit(this.dataSource) : super(MyCasesInitial());

  void fetchMyCases(Map<String, String> body) {
    emit(MyCasesLoading());
    dataSource.fetchMyCases(body).then((value) => {emit(MyCasesLoaded(value))});
  }
}
