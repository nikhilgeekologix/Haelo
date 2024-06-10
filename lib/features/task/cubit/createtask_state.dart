import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/task/data/model/createtask_model.dart';

@immutable
abstract class CreateTaskState {}

class CreateTaskInitial extends CreateTaskState {}

class CreateTaskLoading extends CreateTaskState {}

class CreateTaskLoaded extends CreateTaskState {
  CreateTaskModel createTaskModel;
  CreateTaskLoaded(this.createTaskModel);
}

class CreateTaskError extends CreateTaskState {
  final String message;
  CreateTaskError(this.message);
}
