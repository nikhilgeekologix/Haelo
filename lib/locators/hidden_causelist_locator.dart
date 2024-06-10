import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/drawer_content/cubit/hidden_causelist_cubit.dart';
import 'package:haelo_flutter/features/drawer_content/data/datasource/hidden%20_causelist_data_source.dart';
import 'package:haelo_flutter/features/drawer_content/data/repository/hidden_causelist_repository.dart';

GetIt locator = GetIt.instance;

Future<void> HiddenCauseListLocator() async {
  locator.registerLazySingleton<HiddenCauseListDataSource>(() => HiddenCauseListDataSource(locator(), locator()));
  locator.registerFactory(() => HiddenCauseListCubit(locator()));
  locator.registerLazySingleton<HiddenCauseListRepository>(
      () => HiddenCauseListRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
