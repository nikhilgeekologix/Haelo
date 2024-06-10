import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/home_page/cubit/court_summary_cubit.dart';
import 'package:haelo_flutter/features/home_page/cubit/displayboard_summary_cubit.dart';
import 'package:haelo_flutter/features/home_page/data/datasource/court_summary_data_source.dart';
import 'package:haelo_flutter/features/home_page/data/datasource/displayboard_summary_data_source.dart';
import 'package:haelo_flutter/features/home_page/data/repository/court_summary_repository.dart';
import 'package:haelo_flutter/features/home_page/data/repository/displayboard_summary_repository.dart';

GetIt locator = GetIt.instance;

Future<void> DisplayBoardSummaryLocator() async {
  locator.registerLazySingleton<DisplayBoardSummaryDataSource>(
    () => DisplayBoardSummaryDataSource(
      locator(),
      locator(),
    ),
  );
  locator.registerFactory(
    () => DisplayBoardSummaryCubit(
      locator(),
    ),
  );
  locator.registerLazySingleton<DisplayBoardSummaryRepository>(
    () => DisplayBoardSummaryRepositoryImpl(
      networkInfo: locator(),
      dataSource: locator(),
    ),
  );
}
