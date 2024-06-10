import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/task/cubit/task_caseno_cubit.dart';
import 'package:haelo_flutter/features/task/data/datasource/task_caseno_data_source.dart';
import 'package:haelo_flutter/features/task/data/repository/task_caseno_repository.dart';

GetIt locator = GetIt.instance;

Future<void> TaskCaseNoLocator() async {
  locator.registerLazySingleton<TaskCaseNoDataSource>(() => TaskCaseNoDataSource(locator(), locator()));
  locator.registerFactory(() => TaskCaseNoCubit(locator()));
  locator.registerLazySingleton<TaskCaseNoRepository>(
      () => TaskCaseNoRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
