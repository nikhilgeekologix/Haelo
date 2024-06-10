import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/causeslist/cubit/viewandsave_cubit.dart';
import 'package:haelo_flutter/features/causeslist/data/datasource/viewandsave_data_source.dart';
import 'package:haelo_flutter/features/causeslist/data/repository/viewandsave_repository.dart';

GetIt locator = GetIt.instance;

Future<void> ViewSaveLocator() async {
  locator.registerLazySingleton<ViewSaveDataSource>(() => ViewSaveDataSource(locator(), locator()));
  locator.registerFactory(() => ViewSaveCubit(locator()));
  locator.registerLazySingleton<ViewSaveRepository>(
      () => ViewSaveRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
