import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/cases/data/model/casehistory.model.dart';

@immutable
abstract class CaseHistoryState {}

class CaseHistoryInitial extends CaseHistoryState {}

class CaseHistoryLoading extends CaseHistoryState {}

class CaseHistoryLoaded extends CaseHistoryState {
  CaseHistoryModel caseHistoryModel;
  CaseHistoryLoaded(this.caseHistoryModel);
}

class CaseHistoryError extends CaseHistoryState {
  final String message;
  CaseHistoryError(this.message);
}
