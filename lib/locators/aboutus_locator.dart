import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/drawer_content/cubit/aboutus_cubit.dart';
import 'package:haelo_flutter/features/drawer_content/data/datasource/aboutus_data_source.dart';
import 'package:haelo_flutter/features/drawer_content/data/repository/aboutus_repository.dart';

GetIt locator = GetIt.instance;

Future<void> AboutUsDeleteLocator() async {
  locator.registerLazySingleton<AboutUsDataSource>(() => AboutUsDataSource(locator(), locator()));
  locator.registerFactory(() => AboutUsCubit(locator()));
  locator.registerLazySingleton<AboutUsRepository>(
      () => AboutUsRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
