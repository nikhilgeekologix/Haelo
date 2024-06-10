import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/drawer_content/data/datasource/myteam_data_source.dart';
import 'myteam_state.dart';

class MyTeamCubit extends Cubit<MyTeamState> {
  final MyTeamDataSource dataSource;
  MyTeamCubit(this.dataSource) : super(MyTeamInitial());

  void fetchMyTeam(Map<String, String> body) {
    emit(MyTeamLoading());
    dataSource.fetchMyTeam(body).then((value) => {emit(MyTeamLoaded(value))});
  }
}
