import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/home_page/cubit/court_summary_cubit.dart';
import 'package:haelo_flutter/features/home_page/data/datasource/court_summary_data_source.dart';
import 'package:haelo_flutter/features/home_page/data/repository/court_summary_repository.dart';

GetIt locator = GetIt.instance;

Future<void> CourtSummaryLocator() async {
  locator.registerLazySingleton<CourtSummaryDataSource>(() => CourtSummaryDataSource(locator(), locator()));
  locator.registerFactory(() => CourtSummaryCubit(locator()));
  locator.registerLazySingleton<CourtSummaryRepository>(
      () => CourtSummaryRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
