import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/cases/cubit/addexpensesfees_cubit.dart';
import 'package:haelo_flutter/features/cases/data/datasource/addexpensesfees_data_source.dart';
import 'package:haelo_flutter/features/cases/data/repository/addexpensesfees_repository.dart';

GetIt locator = GetIt.instance;

Future<void> AddExpensesFeesLocator() async {
  locator.registerLazySingleton<AddExpensesFeesDataSource>(() => AddExpensesFeesDataSource(locator(), locator()));
  locator.registerFactory(() => AddExpensesFeesCubit(locator()));
  locator.registerLazySingleton<AddExpensesFeesRepository>(
      () => AddExpensesFeesRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
