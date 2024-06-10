import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/cases/cubit/comments_cubit.dart';
import 'package:haelo_flutter/features/cases/data/datasource/comments_data_source.dart';
import 'package:haelo_flutter/features/cases/data/repository/comments_repository.dart';

GetIt locator = GetIt.instance;

Future<void> CasesCommentLocator() async {
  locator.registerLazySingleton<CasesCommentDataSource>(() => CasesCommentDataSource(locator(), locator()));
  locator.registerFactory(() => CasesCommentCubit(locator()));
  locator.registerLazySingleton<CasesCommentRepository>(
      () => CasesCommentRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
