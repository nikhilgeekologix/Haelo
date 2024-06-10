import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/home_page/cubit/court_summary_cubit.dart';
import 'package:haelo_flutter/features/home_page/cubit/displayboard_summary_cubit.dart';
import 'package:haelo_flutter/features/home_page/data/datasource/court_summary_data_source.dart';
import 'package:haelo_flutter/features/home_page/data/datasource/displayboard_summary_data_source.dart';
import 'package:haelo_flutter/features/home_page/data/repository/court_summary_repository.dart';
import 'package:haelo_flutter/features/home_page/data/repository/displayboard_summary_repository.dart';

import '../features/home_page/cubit/displayboard_item_stage_cubit.dart';
import '../features/home_page/data/datasource/displayboard_itemstage_data_source.dart';
import '../features/home_page/data/repository/displayboard_item_stage_repository.dart';

GetIt locator = GetIt.instance;

Future<void> DisplayBoardStageItemLocator() async {
  locator.registerLazySingleton<DisplayBoardItemStageDataSource>(
    () => DisplayBoardItemStageDataSource(
      locator(),
      locator(),
    ),
  );
  locator.registerFactory(
    () => DisplayBoardItemStageCubit(
      locator(),
    ),
  );
  locator.registerLazySingleton<DisplayBoardStageItemRepository>(
    () => DisplayBoardStageItemRepositoryImpl(
      networkInfo: locator(),
      dataSource: locator(),
    ),
  );
}
