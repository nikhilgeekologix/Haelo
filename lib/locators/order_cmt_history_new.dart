import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/drawer_content/cubit/aboutus_cubit.dart';
import 'package:haelo_flutter/features/drawer_content/data/datasource/aboutus_data_source.dart';
import 'package:haelo_flutter/features/drawer_content/data/repository/aboutus_repository.dart';

import '../features/order_comment_history/cubit/order_cmt_history_cubit.dart';
import '../features/order_comment_history/data/datasource/order_cmt_history_data_sourse.dart';
import '../features/order_comment_history/data/repository/order_cmt_history_repo.dart';

GetIt locator = GetIt.instance;

Future<void> OrderCmtHistoryNewLocator() async {
  locator.registerLazySingleton<OrderCmtHistoryDataSource>(
      () => OrderCmtHistoryDataSource(locator(), locator()));
  locator.registerFactory(() => OrderCmtHistoryCubit(locator()));
  locator.registerLazySingleton<OrderCmtHistoryRepository>(() =>
      OrderCmtHistoryRepositoryImpl(
          networkInfo: locator(), dataSource: locator()));
}
