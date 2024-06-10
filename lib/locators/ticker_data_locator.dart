import 'package:get_it/get_it.dart';
import '../features/ticker_data/cubit/ticker_data_cubit.dart';
import '../features/ticker_data/data/datasource/ticker_data_datasource.dart';
import '../features/ticker_data/data/repository/ticker_data_repository.dart';

GetIt locator = GetIt.instance;

Future<void> TickerDataLocator() async {
  locator.registerLazySingleton<TickerDataDataSource>(() => TickerDataDataSource(locator(), locator()));
  locator.registerFactory(() => TickerDataCubit(locator()));
  locator.registerLazySingleton<TickerDataRepository>(
          () => TickerDataRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
