import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/drawer_content/cubit/commentshistory_cubit.dart';
import 'package:haelo_flutter/features/drawer_content/data/datasource/commentshistory_data_source.dart';
import 'package:haelo_flutter/features/drawer_content/data/repository/commentshistory_repository.dart';

GetIt locator = GetIt.instance;

Future<void> CommentsHistoryLocator() async {
  locator.registerLazySingleton<CommentsHistoryDataSource>(() => CommentsHistoryDataSource(locator(), locator()));
  locator.registerFactory(() => CommentsHistoryCubit(locator()));
  locator.registerLazySingleton<CommentsHistoryRepository>(
      () => CommentsHistoryRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
