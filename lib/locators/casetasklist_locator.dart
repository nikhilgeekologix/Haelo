import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/cases/cubit/casetasklist_cubit.dart';
import 'package:haelo_flutter/features/cases/data/datasource/casetasklist_data_source.dart';
import 'package:haelo_flutter/features/cases/data/repository/casetasklist_repository.dart';

GetIt locator = GetIt.instance;

Future<void> CaseTaskListLocator() async {
  locator.registerLazySingleton<CaseTaskListDataSource>(() => CaseTaskListDataSource(locator(), locator()));
  locator.registerFactory(() => CaseTaskListCubit(locator()));
  locator.registerLazySingleton<CaseTaskListRepository>(
      () => CaseTaskListRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
