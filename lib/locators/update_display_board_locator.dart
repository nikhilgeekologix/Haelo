import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/home_page/cubit/display_board_cubit.dart';
import 'package:haelo_flutter/features/home_page/cubit/update_display_board/update_display_board_cubit.dart';
import 'package:haelo_flutter/features/home_page/data/datasource/display_board_data_source.dart';
import 'package:haelo_flutter/features/home_page/data/datasource/update_display_board_datasource.dart';
import 'package:haelo_flutter/features/home_page/data/repository/display_board_repository.dart';
import 'package:haelo_flutter/features/home_page/data/repository/update_display_board_repository.dart';

GetIt locator = GetIt.instance;

Future<void> updateDisplayBoardLocator() async {
  locator.registerLazySingleton<UpdateDisplayBoardDataSource>(() => UpdateDisplayBoardDataSource(locator(), locator()));
  locator.registerFactory(() => UpdateDisplayBoardCubit(locator()));
  locator.registerLazySingleton<UpdateDisplayBoardRepository>(
          () => UpdateDisplayBoardRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
