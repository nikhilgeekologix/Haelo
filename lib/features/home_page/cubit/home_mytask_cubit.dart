import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/home_page/data/datasource/home_mytask_data_source.dart';
import 'home_mytask_state.dart';

class HomeMyTaskCubit extends Cubit<HomeMyTaskState> {
  final HomeMyTaskDataSource dataSource;
  HomeMyTaskCubit(this.dataSource) : super(HomeMyTaskInitial());

  void fetchHomeMyTask(Map<String, String> body) {
    dataSource.fetchHomeMyTask(body).then((value) => {emit(HomeMyTaskLoaded(value))});
  }
}
