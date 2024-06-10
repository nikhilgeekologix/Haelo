import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/cases/cubit/accountsdelete_cubit.dart';
import 'package:haelo_flutter/features/cases/data/datasource/accountsdelete_data_source.dart';
import 'package:haelo_flutter/features/cases/data/repository/accountsdelete_repository.dart';

GetIt locator = GetIt.instance;

Future<void> AccountsDeleteLocator() async {
  locator.registerLazySingleton<AccountsDeleteDataSource>(() => AccountsDeleteDataSource(locator(), locator()));
  locator.registerFactory(() => AccountsDeleteCubit(locator()));
  locator.registerLazySingleton<AccountsDeleteRepository>(
      () => AccountsDeleteRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
