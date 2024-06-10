import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/in_app_purchase/data/model/plans_model.dart';

import '../data/model/promo_code_model.dart';

@immutable
abstract class PromoCodesState {}

class PromoCodesInitial extends PromoCodesState {}

class PromoCodesLoading extends PromoCodesState {}

class PromoCodesLoaded extends PromoCodesState {
  PromoCodesModel model;
  PromoCodesLoaded(this.model);
}

class PromoCodesError extends PromoCodesState {
  final String message;
  PromoCodesError(this.message);
}
