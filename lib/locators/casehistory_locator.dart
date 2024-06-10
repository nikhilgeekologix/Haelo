import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/cases/cubit/casehistory_cubit.dart';
import 'package:haelo_flutter/features/cases/data/datasource/casehistory_data_source.dart';
import 'package:haelo_flutter/features/cases/data/repository/casehistory_repository.dart';

GetIt locator = GetIt.instance;

Future<void> CaseHistoryLocator() async {
  locator.registerLazySingleton<CaseHistoryDataSource>(() => CaseHistoryDataSource(locator(), locator()));
  locator.registerFactory(() => CaseHistoryCubit(locator()));
  locator.registerLazySingleton<CaseHistoryRepository>(
      () => CaseHistoryRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
