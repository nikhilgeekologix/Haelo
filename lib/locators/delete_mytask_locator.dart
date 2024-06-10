import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/task/cubit/delete_mytask_cubit.dart';
import 'package:haelo_flutter/features/task/data/datasource/delete_mytask_data_source.dart';
import 'package:haelo_flutter/features/task/data/repository/delete_mytask_repository.dart';

GetIt locator = GetIt.instance;

Future<void> DeleteMyTaskLocator() async {
  locator.registerLazySingleton<DeleteMyTaskDataSource>(() => DeleteMyTaskDataSource(locator(), locator()));
  locator.registerFactory(() => DeleteMyTaskCubit(locator()));
  locator.registerLazySingleton<DeleteMyTaskRepository>(
      () => DeleteMyTaskRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
