import 'package:flutter/material.dart';

import '../../home_page/data/model/home_mytask_model.dart';
import '../data/model/plan_details.dart';

@immutable
abstract class PlanDetailState {}

class PlanDetailInitial extends PlanDetailState {}

class PlanDetailLoading extends PlanDetailState {}

class PlanDetailLoaded extends PlanDetailState {
  PlanDetailsData planDetailsDataModel;
  PlanDetailLoaded(this.planDetailsDataModel);
}

class PlanDetailError extends PlanDetailState {
  final String message;
  PlanDetailError(this.message);
}
