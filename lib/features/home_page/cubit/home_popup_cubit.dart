import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/userboard/cubit/update_trial_state.dart';

import '../data/datasource/home_popup_data_source.dart';
import 'home_popup_state.dart';

class HomePopupCubit extends Cubit<HomePopupState> {
  final HomePopupBoardDataSource dataSource;
  HomePopupCubit(this.dataSource) : super(HomePopupInitial());

  void fetchHomePopup(Map<String, String> body) {
    dataSource
        .fetchHomePopupBoard(body)
        .then((value) => {emit(HomePopupLoaded(value))});
  }
}
