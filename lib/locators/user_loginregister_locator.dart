import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/userboard/cubit/user_loginregister_cubit.dart';
import 'package:haelo_flutter/features/userboard/data/datasource/user_loginregister_data_source.dart';
import 'package:haelo_flutter/features/userboard/data/repository/user_loginregister_repository.dart';

GetIt locator = GetIt.instance;

Future<void> userLoginRegisterLocator() async {
  locator.registerLazySingleton<UserLoginRegisterDataSource>(() => UserLoginRegisterDataSource(locator(), locator()));
  locator.registerFactory(() => UserLoginRegisterCubit(locator()));
  locator.registerLazySingleton<UserLoginRegisterRepository>(
      () => UserLoginRegisterRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
