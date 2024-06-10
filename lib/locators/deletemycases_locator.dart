import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/cases/cubit/deletemycases_cubit.dart';
import 'package:haelo_flutter/features/cases/data/datasource/deletemycases_data_source.dart';
import 'package:haelo_flutter/features/cases/data/repository/deletemycases_repository.dart';

GetIt locator = GetIt.instance;

Future<void> DeleteMyCaseLocator() async {
  locator.registerLazySingleton<DeleteMyCaseDataSource>(() => DeleteMyCaseDataSource(locator(), locator()));
  locator.registerFactory(() => DeleteMyCaseCubit(locator()));
  locator.registerLazySingleton<DeleteMyCaseRepository>(
      () => DeleteMyCaseRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
