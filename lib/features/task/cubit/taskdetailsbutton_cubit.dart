import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/task/cubit/taskdetails_state.dart';
import 'package:haelo_flutter/features/task/cubit/taskdetailsbutton_state.dart';
import 'package:haelo_flutter/features/task/data/datasource/taskdetails_data_source.dart';
import 'package:haelo_flutter/features/task/data/datasource/taskdetailsbutton_data_source.dart';

class TaskDetailsButtonCubit extends Cubit<TaskDetailsButtonState> {
  final TaskDetailsButtonDataSource dataSource;
  TaskDetailsButtonCubit(this.dataSource) : super(TaskDetailsButtonInitial());

  void fetchTaskDetailsButton(Map<String, String> body, {file}) {
    dataSource.fetchTaskDetailsButton(body, file: file).then((value) => {emit(TaskDetailsButtonLoaded(value))});
  }
}
