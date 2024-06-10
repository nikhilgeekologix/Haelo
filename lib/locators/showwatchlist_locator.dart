import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/causeslist/cubit/showwatchlist_cubit.dart';
import 'package:haelo_flutter/features/causeslist/data/datasource/showwatchlist_data_source.dart';
import 'package:haelo_flutter/features/causeslist/data/repository/showwatchlist_repository.dart';

GetIt locator = GetIt.instance;

Future<void> ShowWatchlistLocator() async {
  locator.registerLazySingleton<ShowWatchlistDataSource>(() => ShowWatchlistDataSource(locator(), locator()));
  locator.registerFactory(() => ShowWatchlistCubit(locator()));
  locator.registerLazySingleton<ShowWatchlistRepository>(
      () => ShowWatchlistRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
