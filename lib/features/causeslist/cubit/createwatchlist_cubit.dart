import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/causeslist/data/datasource/createwatchlist_data_source.dart';
import 'createwatchlist_state.dart';

class CreateWatchlistCubit extends Cubit<CreateWatchlistState> {
  final CreateWatchlistDataSource dataSource;
  CreateWatchlistCubit(this.dataSource) : super(CreateWatchlistInitial());

  void fetchCreateWatchlist(Map<String, String> body) {
    emit(CreateWatchlistLoading());
    dataSource.fetchCreateWatchlist(body).then((value) => {emit(CreateWatchlistLoaded(value))});
  }
}
