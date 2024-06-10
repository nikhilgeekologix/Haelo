import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/task/cubit/reassign_mytask_state.dart';
import 'package:haelo_flutter/features/task/data/datasource/reassign_mytask_data_source.dart';

class ReassignMyTaskCubit extends Cubit<ReassignMyTaskState> {
  final ReassignMyTaskDataSource dataSource;
  ReassignMyTaskCubit(this.dataSource) : super(ReassignMyTaskInitial());

  void fetchReassignMyTask(Map<String, String> body) {
    emit(ReassignMyTaskLoading());
    dataSource.fetchReassignMyTask(body).then((value) => {emit(ReassignMyTaskLoaded(value))});
  }
}
