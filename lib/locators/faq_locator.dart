import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/drawer_content/cubit/faq_cubit.dart';
import 'package:haelo_flutter/features/drawer_content/data/datasource/faq_data_source.dart';
import 'package:haelo_flutter/features/drawer_content/data/repository/faq_repository.dart';

GetIt locator = GetIt.instance;

Future<void> FAQLocator() async {
  locator.registerLazySingleton<FAQDataSource>(() => FAQDataSource(locator(), locator()));
  locator.registerFactory(() => FAQCubit(locator()));
  locator.registerLazySingleton<FAQRepository>(() => FAQRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
