import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/causeslist/cubit/createwatchlist_cubit.dart';
import 'package:haelo_flutter/features/causeslist/data/datasource/createwatchlist_data_source.dart';
import 'package:haelo_flutter/features/causeslist/data/repository/createwatchlist_repository.dart';

GetIt locator = GetIt.instance;

Future<void> CreateWatchlistLocator() async {
  locator.registerLazySingleton<CreateWatchlistDataSource>(() => CreateWatchlistDataSource(locator(), locator()));
  locator.registerFactory(() => CreateWatchlistCubit(locator()));
  locator.registerLazySingleton<CreateWatchlistRepository>(
      () => CreateWatchlistRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
