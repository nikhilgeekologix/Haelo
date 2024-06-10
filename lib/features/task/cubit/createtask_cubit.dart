import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/task/data/datasource/cratetask_data_source.dart';
import 'createtask_state.dart';

class CreateTaskCubit extends Cubit<CreateTaskState> {
  final CreateTaskDataSource dataSource;
  CreateTaskCubit(this.dataSource) : super(CreateTaskInitial());

  void fetchCreateTask(Map<String, String> body, file) {
    emit(CreateTaskLoading());
    dataSource.fetchCreateTask(body, file).then((value) => {emit(CreateTaskLoaded(value))});
  }
}
