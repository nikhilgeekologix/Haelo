import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/task/cubit/task_selectteam_state.dart';
import 'package:haelo_flutter/features/task/data/datasource/task_selectteam_data_source.dart';

class TaskSelectTeamCubit extends Cubit<TaskSelectTeamState> {
  final TaskSelectTeamDataSource dataSource;
  TaskSelectTeamCubit(this.dataSource) : super(TaskSelectTeamInitial());

  void fetchTaskSelectTeam() {
    dataSource.fetchTaskSelectTeam().then((value) => {emit(TaskSelectTeamLoaded(value))});
  }
}
