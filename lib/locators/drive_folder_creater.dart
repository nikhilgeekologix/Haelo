import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/drawer_content/cubit/aboutus_cubit.dart';
import 'package:haelo_flutter/features/drawer_content/data/datasource/aboutus_data_source.dart';
import 'package:haelo_flutter/features/drawer_content/data/repository/aboutus_repository.dart';

import '../features/cases/cubit/drive_folder_creater_cubit.dart';
import '../features/cases/data/datasource/drive_folder_creater_data_source.dart';
import '../features/cases/data/repository/drive_folder_creater_repository.dart';
import '../features/order_comment_history/cubit/order_cmt_history_cubit.dart';
import '../features/order_comment_history/data/datasource/order_cmt_history_data_sourse.dart';
import '../features/order_comment_history/data/repository/order_cmt_history_repo.dart';

GetIt locator = GetIt.instance;

Future<void> DriveFolderCreatorLocator() async {
  locator.registerLazySingleton<DriveFolderCreatorDataSource>(
      () => DriveFolderCreatorDataSource(locator(), locator()));
  locator.registerFactory(() => DriveFolderCreatorCubit(locator()));
  locator.registerLazySingleton<DriveFolderCreatorRepository>(() =>
      DriveFolderCreatorRepositoryImpl(
          networkInfo: locator(), dataSource: locator()));
}
