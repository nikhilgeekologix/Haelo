import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/cases/cubit/expenses_cubit.dart';
import 'package:haelo_flutter/features/cases/data/datasource/expenses_data_source.dart';
import 'package:haelo_flutter/features/cases/data/repository/expenses_repository.dart';

GetIt locator = GetIt.instance;

Future<void> ExpensesLocator() async {
  locator.registerLazySingleton<ExpensesDataSource>(() => ExpensesDataSource(locator(), locator()));
  locator.registerFactory(() => ExpensesCubit(locator()));
  locator.registerLazySingleton<ExpensesRepository>(
      () => ExpensesRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
