import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/cases/cubit/comments_cubit.dart';
import 'package:haelo_flutter/features/cases/data/datasource/comments_data_source.dart';
import 'package:haelo_flutter/features/cases/data/repository/comments_repository.dart';

import '../features/pending_order_report/cubit/pending_order_download_file_cubit.dart';
import '../features/pending_order_report/data/datasource/pending_order_download_file_source.dart';
import '../features/pending_order_report/data/repo/pending_order_download_file_repo.dart';

GetIt locator = GetIt.instance;

Future<void> PendingOrderDownloadFileLocator() async {
  locator.registerLazySingleton<PendingOrderDownloadFileSource>(
      () => PendingOrderDownloadFileSource(locator(), locator()));
  locator.registerFactory(() => PendingOrderDownloadFileCubit(locator()));
  locator.registerLazySingleton<PendingOrderDownloadFileRepository>(() =>
      PendingOrderDownloadFileRepositoryImpl(
          networkInfo: locator(), dataSource: locator()));
}
