import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/home_page/data/datasource/displayboard_summary_data_source.dart';
import '../data/datasource/displayboard_itemstage_data_source.dart';
import 'displayboard_item_stage_state.dart';
import 'displayboard_summary_state.dart';

class DisplayBoardItemStageCubit extends Cubit<DisplayBoardItemStageState> {
  final DisplayBoardItemStageDataSource dataSource;
  DisplayBoardItemStageCubit(this.dataSource)
      : super(DisplayBoardStageItemInitial());

  void fetchDisplayBoardItemStage(Map<String, String> body) {
    emit(DisplayBoardStageItemLoading());
    dataSource
        .fetchDisplayBoardItemStage(body)
        .then((value) => {emit(DisplayBoardStageItemLoaded(value))});
  }
}
