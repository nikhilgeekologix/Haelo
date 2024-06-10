import 'package:bloc/bloc.dart';

import '../data/datasource/displayboard_itemstage_data_source.dart';
import 'displayboard_item_stage_state.dart';

class DisplayBoardMassDataCubit extends Cubit<DisplayBoardMassDataState> {
  final DisplayBoardItemMassDataSource dataSource;
  DisplayBoardMassDataCubit(this.dataSource)
      : super(DisplayBoardMassDataInitial());

  void fetchDisplayBoardItemStage(Map<String, String> body) {
    emit(DisplayBoardStageItemLoading());
    dataSource
        .fetchMassData(body)
        .then((value) => {emit(DisplayBoardMassDataLoaded(value))});
  }
}
