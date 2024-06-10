import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/causeslist/cubit/viewcauselist_cubit.dart';
import 'package:haelo_flutter/features/causeslist/data/datasource/viewcauselist_data_source.dart';
import 'package:haelo_flutter/features/causeslist/data/repository/viewcauselist_repository.dart';

import '../features/home_page/cubit/home_popup_cubit.dart';
import '../features/home_page/data/datasource/home_popup_data_source.dart';
import '../features/home_page/data/repository/home_popup_repository.dart';

GetIt locator = GetIt.instance;

Future<void> HomePopupLocator() async {
  locator.registerLazySingleton<HomePopupBoardDataSource>(
      () => HomePopupBoardDataSource(locator(), locator()));
  locator.registerFactory(() => HomePopupCubit(locator()));
  locator.registerLazySingleton<HomePopupBoardRepository>(() =>
      HomePopupBoardRepositoryImpl(
          networkInfo: locator(), dataSource: locator()));
}
