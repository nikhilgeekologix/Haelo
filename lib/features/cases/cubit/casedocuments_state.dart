import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/cases/data/model/casedocuments_model.dart';

@immutable
abstract class CaseDocumentsState {}

class CaseDocumentsInitial extends CaseDocumentsState {}

class CaseDocumentsLoading extends CaseDocumentsState {}

class CaseDocumentsLoaded extends CaseDocumentsState {
  CaseDocumentsModel caseDocumentsModel;
  CaseDocumentsLoaded(this.caseDocumentsModel);
}

class CaseDocumentsError extends CaseDocumentsState {
  final String message;
  CaseDocumentsError(this.message);
}
