import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/home_page/cubit/court_summary_cubit.dart';
import 'package:haelo_flutter/features/home_page/data/datasource/court_summary_data_source.dart';
import 'package:haelo_flutter/features/home_page/data/repository/court_summary_repository.dart';

import '../features/home_page/cubit/court_summary_new_cubit.dart';
import '../features/home_page/data/datasource/court_summary_new_data_source.dart';
import '../features/home_page/data/repository/court_summary_new_repository.dart';

GetIt locator = GetIt.instance;

Future<void> CourtSummaryNewLocator() async {
  locator.registerLazySingleton<CourtSummaryNewDataSource>(
      () => CourtSummaryNewDataSource(locator(), locator()));
  locator.registerFactory(() => CourtSummaryNewCubit(locator()));
  locator.registerLazySingleton<CourtSummaryNewRepository>(() =>
      CourtSummaryNewRepositoryImpl(
          networkInfo: locator(), dataSource: locator()));
}
