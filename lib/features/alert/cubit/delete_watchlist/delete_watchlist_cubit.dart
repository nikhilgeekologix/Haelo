import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/features/alert/cubit/delete_watchlist/delete_watchlist_state.dart';
import 'package:haelo_flutter/features/alert/data/datasource/my_alert_datasource.dart';


class DeleteWatchlistCubit extends Cubit<DeleteWatchlistState> {
  final MyAlertDataSource dataSource;
  DeleteWatchlistCubit(this.dataSource) : super(DeleteWatchlistInitial());

  void deleteWatchlist(Map<String, String> body) {
    emit(DeleteWatchlistLoading());
    dataSource.deleteWatchlist(body).then((value) => {emit(DeleteWatchlistLoaded(value))});
  }
}
