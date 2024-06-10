import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/task/data/model/taskdetails_model.dart';
import 'package:haelo_flutter/features/task/data/model/taskdetailsbuttons_model.dart';

@immutable
abstract class TaskDetailsButtonState {}

class TaskDetailsButtonInitial extends TaskDetailsButtonState {}

class TaskDetailsButtonLoading extends TaskDetailsButtonState {}

class TaskDetailsButtonLoaded extends TaskDetailsButtonState {
  TaskDetailsButtonModel taskDetailButtonModel;
  TaskDetailsButtonLoaded(this.taskDetailButtonModel);
}

class taskDetailButtonModelError extends TaskDetailsButtonState {
  final String message;
  taskDetailButtonModelError(this.message);
}
