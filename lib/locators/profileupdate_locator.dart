import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/drawer_content/cubit/profileupdate_cubit.dart';
import 'package:haelo_flutter/features/drawer_content/data/datasource/profileupdate_data_source.dart';
import 'package:haelo_flutter/features/drawer_content/data/repository/profileupdate_repository.dart';

GetIt locator = GetIt.instance;

Future<void> ProfileUpdateLocator() async {
  locator.registerLazySingleton<ProfileUpdateDataSource>(() => ProfileUpdateDataSource(locator(), locator()));
  locator.registerFactory(() => ProfileUpdateCubit(locator()));
  locator.registerLazySingleton<ProfileUpdateRepository>(
      () => ProfileUpdateRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
