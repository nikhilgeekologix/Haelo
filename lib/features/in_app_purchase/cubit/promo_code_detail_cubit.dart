import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/in_app_purchase/cubit/promo_codes_state.dart';

import '../data/datasource/promo_code_details_data_source.dart';

class PromoCodesCubit extends Cubit<PromoCodesState> {
  final PromoCodesDataSource dataSource;
  PromoCodesCubit(this.dataSource) : super(PromoCodesInitial());

  void fetchPromoCodesDetailsStage() {
    emit(PromoCodesLoading());
    dataSource
        .fetchPromoCodesDetails()
        .then((value) => {emit(PromoCodesLoaded(value))});
  }
}
