import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/cases/cubit/mobileemailupdate_cubit.dart';
import 'package:haelo_flutter/features/cases/data/datasource/mobileemailupdate_data_source.dart';
import 'package:haelo_flutter/features/cases/data/repository/mobileemailupdate_repository.dart';

GetIt locator = GetIt.instance;

Future<void> MobileEmailUpdateLocator() async {
  locator.registerLazySingleton<MobileEmailUpdateDataSource>(() => MobileEmailUpdateDataSource(locator(), locator()));
  locator.registerFactory(() => MobileEmailUpdateCubit(locator()));
  locator.registerLazySingleton<MobileEmailUpdateRepository>(
      () => MobileEmailUpdateRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
