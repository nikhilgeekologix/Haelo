import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/task/cubit/task_selectteam_cubit.dart';
import 'package:haelo_flutter/features/task/data/datasource/task_selectteam_data_source.dart';
import 'package:haelo_flutter/features/task/data/repository/task_selectteam_repository.dart';

GetIt locator = GetIt.instance;

Future<void> TaskSelectTeamLocator() async {
  locator.registerLazySingleton<TaskSelectTeamDataSource>(() => TaskSelectTeamDataSource(locator(), locator()));
  locator.registerFactory(() => TaskSelectTeamCubit(locator()));
  locator.registerLazySingleton<TaskSelectTeamRepository>(
      () => TaskSelectTeamRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
