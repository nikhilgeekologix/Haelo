import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/cases/cubit/adddetails_cubit.dart';
import 'package:haelo_flutter/features/cases/data/datasource/adddetails_data_source.dart';
import 'package:haelo_flutter/features/cases/data/repository/adddetails_repository.dart';

GetIt locator = GetIt.instance;

Future<void> AddDetailsLocator() async {
  locator.registerLazySingleton<AddDetailsDataSource>(() => AddDetailsDataSource(locator(), locator()));
  locator.registerFactory(() => AddDetailsCubit(locator()));
  locator.registerLazySingleton<AddDetailsRepository>(
      () => AddDetailsRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
