import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/home_page/cubit/update_display_board/update_display_board_state.dart';
import 'package:haelo_flutter/features/home_page/data/datasource/update_display_board_datasource.dart';

class UpdateDisplayBoardCubit extends Cubit<UpdateDisplayBoardState> {
  final UpdateDisplayBoardDataSource dataSource;
  UpdateDisplayBoardCubit(this.dataSource) : super(UpdateDisplayBoardInitial());

  void updateDisplayBoard(Map<String, String> body) {
    emit(UpdateDisplayBoardLoading());
    dataSource.updateDisplayBoard(body).then((value) => {emit(UpdateDisplayBoardLoaded(value))});
  }
}
