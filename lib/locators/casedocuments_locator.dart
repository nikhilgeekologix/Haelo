import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/cases/cubit/casedocuments_cubit.dart';
import 'package:haelo_flutter/features/cases/data/datasource/casedocuments_data_source.dart';
import 'package:haelo_flutter/features/cases/data/repository/casedocuments_repository.dart';

GetIt locator = GetIt.instance;

Future<void> CaseDocumentsLocator() async {
  locator.registerLazySingleton<CaseDocumentsDataSource>(() => CaseDocumentsDataSource(locator(), locator()));
  locator.registerFactory(() => CaseDocumentsCubit(locator()));
  locator.registerLazySingleton<CaseDocumentsRepository>(
      () => CaseDocumentsRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
