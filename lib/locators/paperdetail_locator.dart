import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/cases/cubit/paperdetail_cubit.dart';
import 'package:haelo_flutter/features/cases/data/datasource/paperdetail_data_source.dart';
import 'package:haelo_flutter/features/cases/data/repository/paperdetail_repository.dart';

GetIt locator = GetIt.instance;

Future<void> PaperDetailLocator() async {
  locator.registerLazySingleton<PaperDetailDataSource>(() => PaperDetailDataSource(locator(), locator()));
  locator.registerFactory(() => PaperDetailCubit(locator()));
  locator.registerLazySingleton<PaperDetailRepository>(
      () => PaperDetailRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
