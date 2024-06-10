import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/court_date_report/cubit/court_date_report_cubit.dart';
import 'package:haelo_flutter/features/court_date_report/data/datasource/court_date_report_datasource.dart';
import 'package:haelo_flutter/features/court_date_report/data/repository/court_date_report_repository.dart';

GetIt locator = GetIt.instance;

Future<void> courtDateReportLocator() async {
  locator.registerLazySingleton<CourtDateReportDataSource>(() => CourtDateReportDataSource(locator(), locator()));
  locator.registerFactory(() => CourtDateReportCubit(locator()));
  locator.registerLazySingleton<CourtDateReportRepository>(
          () => CourtDateReportRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
