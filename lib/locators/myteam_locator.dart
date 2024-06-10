import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/drawer_content/cubit/myteam_cubit.dart';
import 'package:haelo_flutter/features/drawer_content/data/datasource/myteam_data_source.dart';
import 'package:haelo_flutter/features/drawer_content/data/repository/myteam_repository.dart';

GetIt locator = GetIt.instance;

Future<void> MyTeamLocator() async {
  locator.registerLazySingleton<MyTeamDataSource>(() => MyTeamDataSource(locator(), locator()));
  locator.registerFactory(() => MyTeamCubit(locator()));
  locator.registerLazySingleton<MyTeamRepository>(
      () => MyTeamRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
