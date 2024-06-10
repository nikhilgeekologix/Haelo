import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/cases/data/model/fees_model.dart';

@immutable
abstract class FeesState {}

class FeesInitial extends FeesState {}

class FeesLoading extends FeesState {}

class FeesLoaded extends FeesState {
  FeesModel feesModel;
  FeesLoaded(this.feesModel);
}

class FeesError extends FeesState {
  final String message;
  FeesError(this.message);
}
