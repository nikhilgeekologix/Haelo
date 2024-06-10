import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/causeslist/cubit/viewcauselist_cubit.dart';
import 'package:haelo_flutter/features/causeslist/data/datasource/viewcauselist_data_source.dart';
import 'package:haelo_flutter/features/causeslist/data/repository/viewcauselist_repository.dart';

GetIt locator = GetIt.instance;

Future<void> ViewCauseListLocator() async {
  locator.registerLazySingleton<ViewCauseListDataSource>(() => ViewCauseListDataSource(locator(), locator()));
  locator.registerFactory(() => ViewCauseListCubit(locator()));
  locator.registerLazySingleton<ViewCauseListRepository>(
      () => ViewCauseListRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
