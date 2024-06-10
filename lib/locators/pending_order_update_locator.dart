import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/drawer_content/cubit/aboutus_cubit.dart';
import 'package:haelo_flutter/features/drawer_content/data/datasource/aboutus_data_source.dart';
import 'package:haelo_flutter/features/drawer_content/data/repository/aboutus_repository.dart';

import '../features/pending_order_report/cubit/pending_order_update_cubit.dart';
import '../features/pending_order_report/data/datasource/pending_order_update_source.dart';
import '../features/pending_order_report/data/repo/pending_order_update_repo.dart';

GetIt locator = GetIt.instance;

Future<void> PendingOrderUpdateLocator() async {
  locator.registerLazySingleton<PendingOrderUpdateSource>(
      () => PendingOrderUpdateSource(locator(), locator()));
  locator.registerFactory(() => PendingOrderUpdateCubit(locator()));
  locator.registerLazySingleton<PendingOrderUpdateRepository>(() =>
      PPendingOrderUpdateRepositoryImpl(
          networkInfo: locator(), dataSource: locator()));
}
