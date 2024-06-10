import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/drawer_content/data/datasource/myteampopup_data_source.dart';
import 'myteampopup_state.dart';

class MyTeamPopupCubit extends Cubit<MyTeamPopupState> {
  final MyTeamPopupDataSource dataSource;
  MyTeamPopupCubit(this.dataSource) : super(MyTeamPopupInitial());

  void fetchMyTeamPopup(Map<String, String> body) {
    emit(MyTeamPopupLoading());
    dataSource.fetchMyTeamPopup(body).then((value) => {emit(MyTeamPopupLoaded(value))});
  }
}
