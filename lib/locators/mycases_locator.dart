import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/cases/cubit/mycases_cubit.dart';
import 'package:haelo_flutter/features/cases/data/datasource/mycases_data_source.dart';
import 'package:haelo_flutter/features/cases/data/repository/mycases_repository.dart';

GetIt locator = GetIt.instance;

Future<void> MyCasesLocator() async {
  locator.registerLazySingleton<MyCasesDataSource>(() => MyCasesDataSource(locator(), locator()));
  locator.registerFactory(() => MyCasesCubit(locator()));
  locator.registerLazySingleton<MyCasesRepository>(
      () => MyCasesRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
