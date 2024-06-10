import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/causeslist/cubit/addcase_cubit.dart';
import 'package:haelo_flutter/features/causeslist/cubit/main_causelistdata_cubit.dart';
import 'package:haelo_flutter/features/causeslist/data/datasource/addcase_data_source.dart';
import 'package:haelo_flutter/features/causeslist/data/datasource/main_causelistdata_data_source.dart';
import 'package:haelo_flutter/features/causeslist/data/repository/addcase_repository.dart';
import 'package:haelo_flutter/features/causeslist/data/repository/main_causelistdata_repository.dart';

GetIt locator = GetIt.instance;

Future<void> AddCaseLocator() async {
  locator.registerLazySingleton<AddCaseDataSource>(() => AddCaseDataSource(locator(), locator()));
  locator.registerFactory(() => AddCaseCubit(locator()));
  locator.registerLazySingleton<AddCaseRepository>(
      () => AddCaseRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
