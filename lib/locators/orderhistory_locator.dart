import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/drawer_content/cubit/orderhistory_cubit.dart';
import 'package:haelo_flutter/features/drawer_content/data/datasource/orderhistory_data_source.dart';
import 'package:haelo_flutter/features/drawer_content/data/repository/orderhistory_repository.dart';

GetIt locator = GetIt.instance;

Future<void> OrderHistoryLocator() async {
  locator.registerLazySingleton<OrderHistoryDataSource>(() => OrderHistoryDataSource(locator(), locator()));
  locator.registerFactory(() => OrderHistoryCubit(locator()));
  locator.registerLazySingleton<OrderHistoryRepository>(
      () => OrderHistoryRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
