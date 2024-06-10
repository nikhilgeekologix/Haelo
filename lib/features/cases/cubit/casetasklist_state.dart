import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/cases/data/model/casetasklist_model.dart';

@immutable
abstract class CaseTaskListState {}

class CaseTaskListInitial extends CaseTaskListState {}

class CaseTaskListLoading extends CaseTaskListState {}

class CaseTaskListLoaded extends CaseTaskListState {
  CaseTaskListModel caseTaskListModel;
  CaseTaskListLoaded(this.caseTaskListModel);
}

class CaseTaskListError extends CaseTaskListState {
  final String message;
  CaseTaskListError(this.message);
}
