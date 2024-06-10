import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/task/cubit/taskdetails_cubit.dart';
import 'package:haelo_flutter/features/task/data/datasource/taskdetails_data_source.dart';
import 'package:haelo_flutter/features/task/data/repository/taskdetails_repository.dart';

GetIt locator = GetIt.instance;

Future<void> TaskDetailLocator() async {
  locator.registerLazySingleton<TaskDetailDataSource>(() => TaskDetailDataSource(locator(), locator()));
  locator.registerFactory(() => TaskDetailCubit(locator()));
  locator.registerLazySingleton<TaskDetailRepository>(
      () => TaskDetailRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
