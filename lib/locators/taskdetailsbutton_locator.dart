import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/task/cubit/taskdetails_cubit.dart';
import 'package:haelo_flutter/features/task/cubit/taskdetailsbutton_cubit.dart';
import 'package:haelo_flutter/features/task/data/datasource/taskdetails_data_source.dart';
import 'package:haelo_flutter/features/task/data/datasource/taskdetailsbutton_data_source.dart';
import 'package:haelo_flutter/features/task/data/repository/taskdetails_repository.dart';
import 'package:haelo_flutter/features/task/data/repository/taskdetailsbutton_repository.dart';

GetIt locator = GetIt.instance;

Future<void> TaskDetailsButtonLocator() async {
  locator.registerLazySingleton<TaskDetailsButtonDataSource>(() => TaskDetailsButtonDataSource(locator(), locator()));
  locator.registerFactory(() => TaskDetailsButtonCubit(locator()));
  locator.registerLazySingleton<TaskDetailsButtonRepository>(
      () => TaskDetailsButtonRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
