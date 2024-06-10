import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/home_page/cubit/home_mytask_cubit.dart';
import 'package:haelo_flutter/features/home_page/data/datasource/home_mytask_data_source.dart';
import 'package:haelo_flutter/features/home_page/data/repository/home_mytask_repository.dart';

GetIt locator = GetIt.instance;

Future<void> HomeMyTaskLocator() async {
  locator.registerLazySingleton<HomeMyTaskDataSource>(() => HomeMyTaskDataSource(locator(), locator()));
  locator.registerFactory(() => HomeMyTaskCubit(locator()));
  locator
      .registerLazySingleton<HomeMyTaskRepository>(() => HomeMyTaskRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
