import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/causeslist/cubit/hidecauselist_cubit.dart';
import 'package:haelo_flutter/features/causeslist/data/datasource/hidecauselist_data_source.dart';
import 'package:haelo_flutter/features/causeslist/data/repository/hidecauselist_repository.dart';

GetIt locator = GetIt.instance;

Future<void> HideCauseListLocator() async {
  locator.registerLazySingleton<HideCauseListDataSource>(() => HideCauseListDataSource(locator(), locator()));
  locator.registerFactory(() => HideCauseListCubit(locator()));
  locator.registerLazySingleton<HideCauseListRepository>(
      () => HideCauseListRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
