import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/task/cubit/task_caseno_state.dart';
import 'package:haelo_flutter/features/task/data/datasource/task_caseno_data_source.dart';

class TaskCaseNoCubit extends Cubit<TaskCaseNoState> {
  final TaskCaseNoDataSource dataSource;
  TaskCaseNoCubit(this.dataSource) : super(TaskCaseNoInitial());

  void fetchTaskCaseNo() {
    dataSource.fetchTaskCaseNo().then((value) => {emit(TaskCaseNoLoaded(value))});
  }
}
