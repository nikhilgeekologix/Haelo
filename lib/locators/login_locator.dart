import 'package:get_it/get_it.dart';
import '../features/userboard/cubit/login_cubit.dart';
import '../features/userboard/data/datasource/login_data_source.dart';
import '../features/userboard/data/repository/login_repository.dart';

GetIt locator = GetIt.instance;

Future<void> loginLocator() async {
  locator.registerLazySingleton<LoginDataSource>(() => LoginDataSource(locator(), locator()));
  locator.registerFactory(() => LoginCubit(locator()));
  locator
      .registerLazySingleton<LoginRepository>(() => LoginRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
