import 'package:get_it/get_it.dart';

import '../features/home_page/data/repository/displayboard_item_stage_repository.dart';
import '../features/in_app_purchase/cubit/plan_detail_cubit.dart';
import '../features/in_app_purchase/data/datasource/plan-details_data_source.dart';
import '../features/in_app_purchase/data/repository/plan_details_repository.dart';

GetIt locator = GetIt.instance;

Future<void> PlanDetailsLocator() async {
  locator.registerLazySingleton<PlanDetailsDataSource>(
    () => PlanDetailsDataSource(
      locator(),
      locator(),
    ),
  );
  locator.registerFactory(
    () => PlanDetailCubit(
      locator(),
    ),
  );
  locator.registerLazySingleton<PlanDetailsRepository>(
    () => PlanDetailsRepositoryImpl(
      networkInfo: locator(),
      dataSource: locator(),
    ),
  );
}
