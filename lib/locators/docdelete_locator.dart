import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/cases/cubit/docdelete_cubit.dart';
import 'package:haelo_flutter/features/cases/data/datasource/docdelete_data_source.dart';
import 'package:haelo_flutter/features/cases/data/repository/docdelete_repository.dart';

GetIt locator = GetIt.instance;

Future<void> DocDeleteLocator() async {
  locator.registerLazySingleton<DocDeleteDataSource>(() => DocDeleteDataSource(locator(), locator()));
  locator.registerFactory(() => DocDeleteCubit(locator()));
  locator.registerLazySingleton<DocDeleteRepository>(
      () => DocDeleteRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
