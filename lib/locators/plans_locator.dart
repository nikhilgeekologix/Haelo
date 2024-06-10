import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/in_app_purchase/cubit/my_subscription_cubit.dart';
import 'package:haelo_flutter/features/in_app_purchase/cubit/pay_request_cubit.dart';
import 'package:haelo_flutter/features/in_app_purchase/cubit/plans_cubit.dart';
import 'package:haelo_flutter/features/in_app_purchase/data/datasource/plans_datasource.dart';
import 'package:haelo_flutter/features/in_app_purchase/data/repository/plans_repository.dart';

GetIt locator = GetIt.instance;

Future<void> plansLocator() async {
  locator.registerLazySingleton<PlansDataSource>(() => PlansDataSource(locator(), locator()));
  locator.registerFactory(() => PlansCubit(locator()));
  locator.registerFactory(() => MySubscriptionCubit(locator()));
  locator.registerFactory(() => PayRequestCubit(locator()));
  locator.registerLazySingleton<PlansRepository>(
          () => PlansRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
