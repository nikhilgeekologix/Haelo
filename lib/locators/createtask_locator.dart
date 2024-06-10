import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/task/cubit/createtask_cubit.dart';
import 'package:haelo_flutter/features/task/data/datasource/cratetask_data_source.dart';
import 'package:haelo_flutter/features/task/data/repository/createtask_repository.dart';

GetIt locator = GetIt.instance;

Future<void> CreateTaskLocator() async {
  locator.registerLazySingleton<CreateTaskDataSource>(() => CreateTaskDataSource(locator(), locator()));
  locator.registerFactory(() => CreateTaskCubit(locator()));
  locator.registerLazySingleton<CreateTaskRepository>(
      () => CreateTaskRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
