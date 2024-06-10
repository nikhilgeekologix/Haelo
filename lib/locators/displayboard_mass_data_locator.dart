import 'package:get_it/get_it.dart';

import '../features/mass_addition_of_case/cubit/displayboard_item_stage_cubit.dart';
import '../features/mass_addition_of_case/data/datasource/displayboard_itemstage_data_source.dart';
import '../features/mass_addition_of_case/data/repository/displayboard_item_stage_repository.dart';

GetIt locator = GetIt.instance;

Future<void> DisplayBoardMassDataLocator() async {
  locator.registerLazySingleton<DisplayBoardItemMassDataSource>(
    () => DisplayBoardItemMassDataSource(
      locator(),
      locator(),
    ),
  );
  locator.registerFactory(
    () => DisplayBoardMassDataCubit(
      locator(),
    ),
  );
  locator.registerLazySingleton<DisplayBoardMassDataRepository>(
    () => DisplayBoardMassDataRepositoryImpl(
      networkInfo: locator(),
      dataSource: locator(),
    ),
  );
}
