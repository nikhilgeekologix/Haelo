import 'package:get_it/get_it.dart';

import '../features/cases/cubit/office_stage_cubit.dart';
import '../features/cases/data/datasource/office_stage_source.dart';
import '../features/cases/data/repository/office_stage_repository.dart';
import '../features/userboard/cubit/update_trial_cubit.dart';
import '../features/userboard/data/datasource/update_trial_data_source.dart';
import '../features/userboard/data/repository/update_trial_repository.dart';

GetIt locator = GetIt.instance;

Future<void> UpdateTrialLocator() async {
  locator.registerLazySingleton<UpdateTrialDataSource>(
    () => UpdateTrialDataSource(
      locator(),
      locator(),
    ),
  );
  locator.registerFactory(
    () => UpdateTrialCubit(
      locator(),
    ),
  );
  locator.registerLazySingleton<UpdateTrialRepositoryImpl>(
    () => UpdateTrialRepositoryImpl(
      networkInfo: locator(),
      dataSource: locator(),
    ),
  );
}
