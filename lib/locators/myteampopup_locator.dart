import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/drawer_content/cubit/myteampopup_cubit.dart';
import 'package:haelo_flutter/features/drawer_content/data/datasource/myteampopup_data_source.dart';
import 'package:haelo_flutter/features/drawer_content/data/repository/myteampopup_repository.dart';

GetIt locator = GetIt.instance;

Future<void> MyTeamPopupLocator() async {
  locator.registerLazySingleton<MyTeamPopupDataSource>(() => MyTeamPopupDataSource(locator(), locator()));
  locator.registerFactory(() => MyTeamPopupCubit(locator()));
  locator.registerLazySingleton<MyTeamPopupRepository>(
      () => MyTeamPopupRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
