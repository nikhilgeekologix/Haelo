import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/home_page/data/datasource/display_board_data_source.dart';
import 'display_board_state.dart';

class DisplayBoardCubit extends Cubit<DisplayBoardState> {
  final DisplayBoardDataSource dataSource;
  DisplayBoardCubit(this.dataSource) : super(DisplayBoardInitial());

  void fetchDisplayBoard(Map<String, String> body) {
    emit(DisplayBoardLoading());
    dataSource.fetchDisplayBoard(body).then((value) => {emit(DisplayBoardLoaded(value))});
  }
}
