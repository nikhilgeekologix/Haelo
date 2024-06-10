import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/drawer_content/cubit/aboutus_cubit.dart';
import 'package:haelo_flutter/features/drawer_content/data/datasource/aboutus_data_source.dart';
import 'package:haelo_flutter/features/drawer_content/data/repository/aboutus_repository.dart';

import '../features/drawer_content/cubit/coupons_cubit.dart';
import '../features/drawer_content/data/datasource/coupons_data_source.dart';
import '../features/drawer_content/data/repository/coupons_repository.dart';

GetIt locator = GetIt.instance;

Future<void> CouponsLocator() async {
  locator.registerLazySingleton<CouponsDataSource>(
      () => CouponsDataSource(locator(), locator()));
  locator.registerFactory(() => CouponsCubit(locator()));
  locator.registerLazySingleton<CouponsRepository>(() =>
      CouponsRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
