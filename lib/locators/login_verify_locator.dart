import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/userboard/cubit/login_verify_cubit.dart';
import 'package:haelo_flutter/features/userboard/data/datasource/login_verify_data_source.dart';
import 'package:haelo_flutter/features/userboard/data/repository/login_verify_repository.dart';
import '../features/splash/cubit/splash_cubit.dart';
import '../features/splash/data/datasource/splash_data_source.dart';
import '../features/splash/data/repository/splash_repository.dart';
import '../features/userboard/cubit/login_cubit.dart';
import '../features/userboard/data/datasource/login_data_source.dart';
import '../features/userboard/data/repository/login_repository.dart';

GetIt locator = GetIt.instance;

Future<void> loginVerifyLocator() async {
  locator.registerLazySingleton<LoginVerifyDataSource>(() => LoginVerifyDataSource(locator(), locator()));
  locator.registerFactory(() => LoginVerifyCubit(locator()));
  locator.registerLazySingleton<LoginVerifyRepository>(
      () => LoginVerifyRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
