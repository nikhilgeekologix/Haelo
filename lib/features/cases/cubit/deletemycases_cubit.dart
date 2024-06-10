import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/cases/data/datasource/deletemycases_data_source.dart';
import 'deletemycases_state.dart';

class DeleteMyCaseCubit extends Cubit<DeleteMyCaseState> {
  final DeleteMyCaseDataSource dataSource;
  DeleteMyCaseCubit(this.dataSource) : super(DeleteMyCaseInitial());

  void fetchDeleteMyCase(Map<String, String> body) {
    emit(DeleteMyCaseLoading());
    dataSource.fetchDeleteMyCase(body).then((value) => {emit(DeleteMyCaseLoaded(value))});
  }
}
