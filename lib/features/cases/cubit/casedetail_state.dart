import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/cases/data/model/casedetails_model.dart';

@immutable
abstract class CaseDetailState {}

class CaseDetailInitial extends CaseDetailState {}

class CaseDetailLoading extends CaseDetailState {}

class CaseDetailLoaded extends CaseDetailState {
  CaseDetailModel caseDetailModel;
  CaseDetailLoaded(this.caseDetailModel);
}

class CaseDetailError extends CaseDetailState {
  final String message;
  CaseDetailError(this.message);
}
