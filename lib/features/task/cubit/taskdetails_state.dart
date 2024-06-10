import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/task/data/model/taskdetails_model.dart';

@immutable
abstract class TaskDetailState {}

class TaskDetailInitial extends TaskDetailState {}

class TaskDetailLoading extends TaskDetailState {}

class TaskDetailLoaded extends TaskDetailState {
  TaskDetailModel taskDetailModel;
  TaskDetailLoaded(this.taskDetailModel);
}

class TaskDetailError extends TaskDetailState {
  final String message;
  TaskDetailError(this.message);
}
