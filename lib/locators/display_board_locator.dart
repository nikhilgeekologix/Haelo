import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/home_page/cubit/display_board_cubit.dart';
import 'package:haelo_flutter/features/home_page/data/datasource/display_board_data_source.dart';
import 'package:haelo_flutter/features/home_page/data/repository/display_board_repository.dart';

GetIt locator = GetIt.instance;

Future<void> DisplayBoardLocator() async {
  locator.registerLazySingleton<DisplayBoardDataSource>(() => DisplayBoardDataSource(locator(), locator()));
  locator.registerFactory(() => DisplayBoardCubit(locator()));
  locator.registerLazySingleton<DisplayBoardRepository>(
      () => DisplayBoardRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
