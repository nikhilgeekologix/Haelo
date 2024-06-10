import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/cases/data/model/office_stage_model.dart';

@immutable
abstract class OfficeStageState {}

class OfficeStageInitial extends OfficeStageState {}

class OfficeStageLoading extends OfficeStageState {}

class OfficeStageLoaded extends OfficeStageState {
  OfficeStageModel model;

  OfficeStageLoaded(this.model);
}

class OfficeStageError extends OfficeStageState {
  final String message;

  OfficeStageError(this.message);
}
