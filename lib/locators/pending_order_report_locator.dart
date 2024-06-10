import 'package:get_it/get_it.dart';

import '../features/pending_order_report/cubit/pending_order_report_cubit.dart';
import '../features/pending_order_report/data/datasource/pending_order_report_source.dart';
import '../features/pending_order_report/data/repo/pending_order_report_repo.dart';

GetIt locator = GetIt.instance;

Future<void> PendingOrderReportLocator() async {
  locator.registerLazySingleton<PendingOrderReportSource>(
    () => PendingOrderReportSource(
      locator(),
      locator(),
    ),
  );
  locator.registerFactory(
    () => PendingOrderReportCubit(
      locator(),
    ),
  );
  locator.registerLazySingleton<PendingOrderReportRepository>(
    () => PendingOrderReportRepositoryImpl(
      networkInfo: locator(),
      dataSource: locator(),
    ),
  );
}
