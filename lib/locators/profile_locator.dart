import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/drawer_content/cubit/profile_cubit.dart';
import 'package:haelo_flutter/features/drawer_content/data/datasource/profile_data_source.dart';
import 'package:haelo_flutter/features/drawer_content/data/repository/profile_repository.dart';

GetIt locator = GetIt.instance;

Future<void> ProfileLocator() async {
  locator.registerLazySingleton<ProfileDataSource>(() => ProfileDataSource(locator(), locator()));
  locator.registerFactory(() => ProfileCubit(locator()));
  locator.registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
