import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/drawer_content/data/datasource/aboutus_data_source.dart';
import 'package:haelo_flutter/features/drawer_content/data/datasource/commentshistory_data_source.dart';
import '../data/datasource/coupons_data_source.dart';
import 'aboutus_state.dart';
import 'commentshistory_state.dart';
import 'coupons_state.dart';

class CouponsCubit extends Cubit<CouponState> {
  final CouponsDataSource dataSource;
  CouponsCubit(this.dataSource) : super(CouponInitial());

  void fetchCouponsList() {
    emit(CouponLoading());
    dataSource.fetchCouponsList().then((value) => {emit(CouponLoaded(value))});
  }
}
