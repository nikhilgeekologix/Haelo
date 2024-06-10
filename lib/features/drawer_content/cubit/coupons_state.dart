import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/drawer_content/data/model/aboutus_model.dart';

import '../data/model/coupons_model.dart';

@immutable
abstract class CouponState {}

class CouponInitial extends CouponState {}

class CouponLoading extends CouponState {}

class CouponLoaded extends CouponState {
  CouponsModel couponsModel;
  CouponLoaded(this.couponsModel);
}

class CouponError extends CouponState {
  final String message;
  CouponError(this.message);
}
