import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/task/data/model/delete_mytask_model.dart';

@immutable
abstract class DeleteMyTaskState {}

class DeleteMyTaskInitial extends DeleteMyTaskState {}

class DeleteMyTaskLoading extends DeleteMyTaskState {}

class DeleteMyTaskLoaded extends DeleteMyTaskState {
  DeleteMyTaskModel deleteMyTaskModel;
  DeleteMyTaskLoaded(this.deleteMyTaskModel);
}

class DeleteMyTaskError extends DeleteMyTaskState {
  final String message;
  DeleteMyTaskError(this.message);
}
