import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/cases/data/model/editcounsel_model.dart';

@immutable
abstract class EditCounselState {}

class EditCounselInitial extends EditCounselState {}

class EditCounselLoading extends EditCounselState {}

class EditCounselLoaded extends EditCounselState {
  EditCounselModel editCounselModel;
  EditCounselLoaded(this.editCounselModel);
}

class EditCounselError extends EditCounselState {
  final String message;
  EditCounselError(this.message);
}
