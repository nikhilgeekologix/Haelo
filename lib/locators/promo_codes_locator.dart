import 'package:get_it/get_it.dart';
import 'package:haelo_flutter/features/causeslist/cubit/viewcauselist_cubit.dart';
import 'package:haelo_flutter/features/causeslist/data/datasource/viewcauselist_data_source.dart';
import 'package:haelo_flutter/features/causeslist/data/repository/viewcauselist_repository.dart';

import '../features/home_page/cubit/home_popup_cubit.dart';
import '../features/home_page/data/datasource/home_popup_data_source.dart';
import '../features/home_page/data/repository/home_popup_repository.dart';
import '../features/in_app_purchase/cubit/promo_code_detail_cubit.dart';
import '../features/in_app_purchase/data/datasource/promo_code_details_data_source.dart';
import '../features/in_app_purchase/data/repository/promo_codes_details_repository.dart';

GetIt locator = GetIt.instance;

Future<void> PromoCodesLocator() async {
  locator.registerLazySingleton<PromoCodesDataSource>(
      () => PromoCodesDataSource(locator(), locator()));
  locator.registerFactory(() => PromoCodesCubit(locator()));
  locator.registerLazySingleton<PromoCodesRepository>(() =>
      PromoCodesRepositoryImpl(networkInfo: locator(), dataSource: locator()));
}
