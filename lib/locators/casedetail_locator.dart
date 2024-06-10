import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/cases/cubit/casedetail_cubit.dart';
import 'package:haelo_flutter/features/cases/data/datasource/casedetails_data_source.dart';
import 'package:haelo_flutter/features/cases/data/repository/casedetails_repository.dart';

GetIt locator = GetIt.instance;

Future<void> CaseDetailLocator() async {
  locator.registerLazySingleton<CaseDetailDataSource>(() => CaseDetailDataSource(locator(), locator()));
  locator.registerFactory(() => CaseDetailCubit(locator()));
  locator.registerLazySingleton<CaseDetailRepository>(
      () => CaseDetailRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
