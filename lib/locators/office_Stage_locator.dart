import 'package:get_it/get_it.dart';

import '../features/cases/cubit/office_stage_cubit.dart';
import '../features/cases/data/datasource/office_stage_source.dart';
import '../features/cases/data/repository/office_stage_repository.dart';

GetIt locator = GetIt.instance;

Future<void> OfficeStageLocator() async {
  locator.registerLazySingleton<OfficeStageSource>(
    () => OfficeStageSource(
      locator(),
      locator(),
    ),
  );
  locator.registerFactory(
    () => OfficeStageCubit(
      locator(),
    ),
  );
  locator.registerLazySingleton<OfficeStageRepository>(
    () => OfficeStageRepositoryImpl(
      networkInfo: locator(),
      dataSource: locator(),
    ),
  );
}
