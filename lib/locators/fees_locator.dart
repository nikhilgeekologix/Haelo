import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/cases/cubit/fees_cubit.dart';
import 'package:haelo_flutter/features/cases/data/datasource/fees_data_source.dart';
import 'package:haelo_flutter/features/cases/data/repository/fees_repository.dart';

GetIt locator = GetIt.instance;

Future<void> FeesLocator() async {
  locator.registerLazySingleton<FeesDataSource>(() => FeesDataSource(locator(), locator()));
  locator.registerFactory(() => FeesCubit(locator()));
  locator
      .registerLazySingleton<FeesRepository>(() => FeesRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
