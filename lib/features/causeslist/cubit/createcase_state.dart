import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/causeslist/data/model/createcase_model.dart';

@immutable
abstract class CauseListCreateCaseState {}

class CauseListCreateCaseInitial extends CauseListCreateCaseState {}

class CauseListCreateCaseLoading extends CauseListCreateCaseState {}

class CauseListCreateCaseLoaded extends CauseListCreateCaseState {
  CauseListCreateCaseModel causeListCreateCaseModel;
  CauseListCreateCaseLoaded(this.causeListCreateCaseModel);
}

class CauseListCreateCaseError extends CauseListCreateCaseState {
  final String message;
  CauseListCreateCaseError(this.message);
}
