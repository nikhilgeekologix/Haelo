import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/task/data/datasource/delete_mytask_data_source.dart';
import 'delete_mytask_state.dart';

class DeleteMyTaskCubit extends Cubit<DeleteMyTaskState> {
  final DeleteMyTaskDataSource dataSource;
  DeleteMyTaskCubit(this.dataSource) : super(DeleteMyTaskInitial());

  void fetchDeleteMyTask(Map<String, String> body) {
    emit(DeleteMyTaskLoading());
    dataSource.fetchDeleteMyTask(body).then((value) => {emit(DeleteMyTaskLoaded(value))});
  }
}
