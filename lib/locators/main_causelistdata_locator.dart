import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/causeslist/cubit/main_causelistdata_cubit.dart';
import 'package:haelo_flutter/features/causeslist/data/datasource/main_causelistdata_data_source.dart';
import 'package:haelo_flutter/features/causeslist/data/repository/main_causelistdata_repository.dart';

GetIt locator = GetIt.instance;

Future<void> MainCauseListDataLocator() async {
  locator.registerLazySingleton<MainCauseListDataDataSource>(() => MainCauseListDataDataSource(locator(), locator()));
  locator.registerFactory(() => MainCauseListDataCubit(locator()));
  locator.registerLazySingleton<MainCauseListDataRepository>(
      () => MainCauseListDataRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
