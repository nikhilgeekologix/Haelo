import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/home_page/data/model/court_summary_model.dart';
import 'package:haelo_flutter/features/task/data/model/task_caseno_model.dart';

@immutable
abstract class TaskCaseNoState {}

class TaskCaseNoInitial extends TaskCaseNoState {}

class TaskCaseNoLoading extends TaskCaseNoState {}

class TaskCaseNoLoaded extends TaskCaseNoState {
  TaskCaseNoModel taskCaseNoModel;
  TaskCaseNoLoaded(this.taskCaseNoModel);
}

class TaskCaseNoError extends TaskCaseNoState {
  final String message;
  TaskCaseNoError(this.message);
}
