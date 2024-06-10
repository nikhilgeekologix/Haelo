import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/features/alert/cubit/edit_watchlist/edit_watchlist_state.dart';
import 'package:haelo_flutter/features/alert/data/datasource/my_alert_datasource.dart';

class EditWatchlistCubit extends Cubit<EditWatchlistState> {
  final MyAlertDataSource dataSource;
  EditWatchlistCubit(this.dataSource) : super(EditWatchlistInitial());

  void editWatchlist(Map<String, String> body) {
    emit(EditWatchlistLoading());
    dataSource.editWatchlist(body).then((value) => {emit(EditWatchlistLoaded(value))});
  }
}
