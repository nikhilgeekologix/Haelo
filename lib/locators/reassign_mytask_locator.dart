import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/task/cubit/reassign_mytask_cubit.dart';
import 'package:haelo_flutter/features/task/data/datasource/reassign_mytask_data_source.dart';
import 'package:haelo_flutter/features/task/data/repository/reassign_mytask_repository.dart';

GetIt locator = GetIt.instance;

Future<void> ReassignMyTaskLocator() async {
  locator.registerLazySingleton<ReassignMyTaskDataSource>(() => ReassignMyTaskDataSource(locator(), locator()));
  locator.registerFactory(() => ReassignMyTaskCubit(locator()));
  locator.registerLazySingleton<ReassignMyTaskRepository>(
      () => ReassignMyTaskRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
