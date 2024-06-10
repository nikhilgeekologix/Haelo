import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/cases/cubit/deletecomment_cubit.dart';
import 'package:haelo_flutter/features/cases/data/datasource/deletecomment_data_source.dart';
import 'package:haelo_flutter/features/cases/data/repository/deletecomment_repository.dart';

GetIt locator = GetIt.instance;

Future<void> DeleteCommentLocator() async {
  locator.registerLazySingleton<DeleteCommentDataSource>(() => DeleteCommentDataSource(locator(), locator()));
  locator.registerFactory(() => DeleteCommentCubit(locator()));
  locator.registerLazySingleton<DeleteCommentRepository>(
      () => DeleteCommentRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
