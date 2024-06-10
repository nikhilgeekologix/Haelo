import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/causeslist/data/repository/addcase_repository.dart';
import 'package:haelo_flutter/features/drawer_content/cubit/unhide_causelist_cubit.dart';
import 'package:haelo_flutter/features/drawer_content/data/datasource/unhide_causelist_data_source.dart';
import 'package:haelo_flutter/features/drawer_content/data/repository/unhide_causelist_repository.dart';

GetIt locator = GetIt.instance;

Future<void> UnHideCauseListLocator() async {
  locator.registerLazySingleton<UnHideCauseListDataSource>(() => UnHideCauseListDataSource(locator(), locator()));
  locator.registerFactory(() => UnHideCauseListCubit(locator()));
  locator.registerLazySingleton<UnHideCauseListRepository>(
      () => UnHideCauseListRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
