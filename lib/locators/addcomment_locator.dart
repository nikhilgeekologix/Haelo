import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/cases/cubit/addcomment_cubit.dart';
import 'package:haelo_flutter/features/cases/cubit/cmt_suggestion/cmt_suggestion_cubit.dart';
import 'package:haelo_flutter/features/cases/data/datasource/addcomment_data_source.dart';
import 'package:haelo_flutter/features/cases/data/repository/addcomment_repository.dart';

GetIt locator = GetIt.instance;

Future<void> AddCommentLocator() async {
  locator.registerLazySingleton<AddCommentDataSource>(() =>
      AddCommentDataSource(locator(), locator()));
  locator.registerFactory(() => AddCommentCubit(locator()));
  locator.registerFactory(() => CommentSuggestionCubit(locator()));
  locator.registerLazySingleton<AddCommentRepository>(
      () => AddCommentRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
