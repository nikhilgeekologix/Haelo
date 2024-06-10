import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/task/cubit/taskdetails_state.dart';
import 'package:haelo_flutter/features/task/data/datasource/taskdetails_data_source.dart';

class TaskDetailCubit extends Cubit<TaskDetailState> {
  final TaskDetailDataSource dataSource;
  TaskDetailCubit(this.dataSource) : super(TaskDetailInitial());

  void fetchTaskDetail(Map<String, String> body) {
    emit(TaskDetailLoading());
    dataSource.fetchTaskDetail(body).then((value) => {emit(TaskDetailLoaded(value))});
  }
}
