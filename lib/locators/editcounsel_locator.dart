import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/cases/cubit/editcounsel_cubit.dart';
import 'package:haelo_flutter/features/cases/data/datasource/editcounsel_data_source.dart';
import 'package:haelo_flutter/features/cases/data/repository/editcounsel_repository.dart';

GetIt locator = GetIt.instance;

Future<void> EditCounselLocator() async {
  locator.registerLazySingleton<EditCounselDataSource>(() => EditCounselDataSource(locator(), locator()));
  locator.registerFactory(() => EditCounselCubit(locator()));
  locator.registerLazySingleton<EditCounselRepository>(
      () => EditCounselRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
