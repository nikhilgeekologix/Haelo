import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/causeslist/cubit/showwatchlist_state.dart';
import 'package:haelo_flutter/features/causeslist/data/datasource/createwatchlist_data_source.dart';
import 'package:haelo_flutter/features/causeslist/data/datasource/showwatchlist_data_source.dart';
import 'createwatchlist_state.dart';

class ShowWatchlistCubit extends Cubit<ShowWatchlistState> {
  final ShowWatchlistDataSource dataSource;
  ShowWatchlistCubit(this.dataSource) : super(ShowWatchlistInitial());

  void fetchShowWatchlist() {
    dataSource.fetchShowWatchlist().then((value) => {emit(ShowWatchlistLoaded(value))});
  }
}
