import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/home_page/cubit/home_tasklist_cubit.dart';
import 'package:haelo_flutter/features/home_page/data/datasource/home_tasklist_data_source.dart';
import 'package:haelo_flutter/features/home_page/data/repository/home_tasklist_repository.dart';

GetIt locator = GetIt.instance;

Future<void> HomeTaskListLocator() async {
  locator.registerLazySingleton<HomeTaskListDataSource>(() => HomeTaskListDataSource(locator(), locator()));
  locator.registerFactory(() => HomeTaskListCubit(locator()));
  locator.registerLazySingleton<HomeTaskListRepository>(
      () => HomeTaskListRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
