import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/userboard/cubit/firm_register_cubit.dart';
import 'package:haelo_flutter/features/userboard/data/datasource/firm_register_data_source.dart';
import 'package:haelo_flutter/features/userboard/data/repository/firm_register_repository.dart';

GetIt locator = GetIt.instance;

Future<void> firmRegisterLocator() async {
  locator.registerLazySingleton<FirmRegisterDataSource>(() => FirmRegisterDataSource(locator(), locator()));
  locator.registerFactory(() => FirmRegisterCubit(locator()));
  locator.registerLazySingleton<FirmRegisterRepository>(
      () => FirmRegisterRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
