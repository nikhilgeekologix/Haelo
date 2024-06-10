import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/drawer_content/cubit/delete_account/delete_account_cubit.dart';
import 'package:haelo_flutter/features/drawer_content/data/datasource/delete_account_datasource.dart';
import 'package:haelo_flutter/features/drawer_content/data/repository/delete_account_repository.dart';

GetIt locator = GetIt.instance;

Future<void> deleteAccountLocator() async {
  locator.registerLazySingleton<DeleteAccountDataSource>(() => DeleteAccountDataSource(locator(), locator()));
  locator.registerFactory(() => DeleteAccountCubit(locator()));
  locator.registerLazySingleton<DeleteAccountRepository>(
          () => DeleteAccountRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
