import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/cases/cubit/updatecomment_cubit.dart';
import 'package:haelo_flutter/features/cases/data/datasource/updatecomment_data_source.dart';
import 'package:haelo_flutter/features/cases/data/repository/updatecomment_repository.dart';

GetIt locator = GetIt.instance;

Future<void> UpdateCommentLocator() async {
  locator.registerLazySingleton<UpdateCommentDataSource>(() => UpdateCommentDataSource(locator(), locator()));
  locator.registerFactory(() => UpdateCommentCubit(locator()));
  locator.registerLazySingleton<UpdateCommentRepository>(
      () => UpdateCommentRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
