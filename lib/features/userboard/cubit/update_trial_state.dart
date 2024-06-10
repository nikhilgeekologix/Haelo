import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/userboard/data/model/firm_register_model.dart';

import '../data/model/update_trial_model.dart';

@immutable
abstract class UpdateTrialState {}

class UpdateTrialInitial extends UpdateTrialState {}

class UpdateTrialLoading extends UpdateTrialState {}

class UpdateTrialLoaded extends UpdateTrialState {
  UpdateTrialModel model;
  UpdateTrialLoaded(this.model);
}

class UpdateTrialError extends UpdateTrialState {
  final String message;
  UpdateTrialError(this.message);
}
