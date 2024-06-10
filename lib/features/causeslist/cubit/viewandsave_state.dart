import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/causeslist/data/model/viewandsave_model.dart';

@immutable
abstract class ViewSaveState {}

class ViewSaveInitial extends ViewSaveState {}

class ViewSaveLoading extends ViewSaveState {}

class ViewSaveLoaded extends ViewSaveState {
  ViewSaveModel viewSaveModel;
  ViewSaveLoaded(this.viewSaveModel);
}

class ViewSaveError extends ViewSaveState {
  final String message;
  ViewSaveError(this.message);
}
