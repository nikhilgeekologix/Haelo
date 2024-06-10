import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/causeslist/cubit/createcase_cubit.dart';
import 'package:haelo_flutter/features/causeslist/data/datasource/createcase_data_source.dart';
import 'package:haelo_flutter/features/causeslist/data/repository/createcase_repository.dart';

GetIt locator = GetIt.instance;

Future<void> CauseListCreateCaseLocator() async {
  locator
      .registerLazySingleton<CauseListCreateCaseDataSource>(() => CauseListCreateCaseDataSource(locator(), locator()));
  locator.registerFactory(() => CauseListCreateCaseCubit(locator()));
  locator.registerLazySingleton<CauseListCreateCaseRepository>(
      () => CauseListCreateCaseRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
