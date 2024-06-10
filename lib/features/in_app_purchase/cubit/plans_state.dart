import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/in_app_purchase/data/model/plans_model.dart';

@immutable
abstract class PlansState {}

class PlansInitial extends PlansState {}

class PlansLoading extends PlansState {}

class PlansLoaded extends PlansState {
  PlansModel model;
  PlansLoaded(this.model);
}

class PlansError extends PlansState {
  final String message;
  PlansError(this.message);
}
