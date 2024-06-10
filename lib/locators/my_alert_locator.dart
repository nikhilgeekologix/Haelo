import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/alert/cubit/add_event_cubit.dart';
import 'package:haelo_flutter/features/alert/cubit/auto_download/auto_download_cubit.dart';
import 'package:haelo_flutter/features/alert/cubit/delete_alert_cubit.dart';
import 'package:haelo_flutter/features/alert/cubit/delete_watchlist/delete_watchlist_cubit.dart';
import 'package:haelo_flutter/features/alert/cubit/edit_watchlist/edit_watchlist_cubit.dart';
import 'package:haelo_flutter/features/alert/cubit/my_alert_cubit.dart';
import 'package:haelo_flutter/features/alert/data/datasource/my_alert_datasource.dart';
import 'package:haelo_flutter/features/alert/data/repository/my_alert_repository.dart';

GetIt locator = GetIt.instance;

Future<void> MyAlertLocator() async {
  locator.registerLazySingleton<MyAlertDataSource>(() =>
      MyAlertDataSource(locator(), locator()));
  locator.registerFactory(() => MyAlertCubit(locator()));
  locator.registerFactory(() => DeleteAlertCubit(locator()));
  locator.registerFactory(() => AddEventCubit(locator()));
  locator.registerFactory(() => AutoDownloadCubit(locator()));
  locator.registerFactory(() => DeleteWatchlistCubit(locator()));
  locator.registerFactory(() => EditWatchlistCubit(locator()));
  locator.registerLazySingleton<MyAlertRepository>(
          () => MyAlertRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
