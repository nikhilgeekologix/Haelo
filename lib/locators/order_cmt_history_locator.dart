import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/order_comment_history/cubit/order_comment_history_cubit.dart';
import 'package:haelo_flutter/features/order_comment_history/data/datasource/order_comment_history_datasource.dart';

import '../features/order_comment_history/data/repository/order_comment_history_repository.dart';

GetIt locator = GetIt.instance;

Future<void> orderCommentHistoryLocator() async {
  locator.registerLazySingleton<OrderCommentHistoryDataSource>(
      () => OrderCommentHistoryDataSource(locator(), locator()));
  locator.registerFactory(() => OrderCommentHistoryCubit(locator()));
  locator.registerLazySingleton<OrderCommentHistoryRepository>(() =>
      OrderCommentHistoryRepositoryImpl(
          networkInfo: locator(), dataSource: locator()));
}
