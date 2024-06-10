import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/cases/cubit/fees_cubit.dart';
import 'package:haelo_flutter/features/cases/data/datasource/fees_data_source.dart';
import 'package:haelo_flutter/features/cases/data/repository/fees_repository.dart';

import '../features/cases/cubit/update_manually_cubit.dart';
import '../features/cases/data/datasource/update_manually_data_source.dart';
import '../features/cases/data/repository/update_manually_repository.dart';

GetIt locator = GetIt.instance;

Future<void> UpdateManuallyLocator() async {
  locator.registerLazySingleton<UpdateManuallyDataSource>(
      () => UpdateManuallyDataSource(locator(), locator()));
  locator.registerFactory(() => UpdateManuallyCubit(locator()));
  locator.registerLazySingleton<UpdateManuallyRepositoryImpl>(() =>
      UpdateManuallyRepositoryImpl(
          networkInfo: locator(), dataSource: locator()));
}
