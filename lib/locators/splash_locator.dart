import 'package:get_it/get_it.dart';
import '../features/splash/cubit/splash_cubit.dart';
import '../features/splash/data/datasource/splash_data_source.dart';
import '../features/splash/data/repository/splash_repository.dart';

GetIt locator = GetIt.instance;

Future<void> splashLocator() async {

  locator.registerLazySingleton<SplashRemoteDataSource>(
      () => SplashRemoteDataSource(locator(),locator()));
  locator.registerFactory(() => SplashCubit(locator()));
  locator.registerLazySingleton<SplashRepository>(
          () => SplashRepositoryImpl(networkInfo: locator(), splashRemoteDataSource: locator()));
}

