import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/task/data/model/reassign_mytask_model.dart';

@immutable
abstract class ReassignMyTaskState {}

class ReassignMyTaskInitial extends ReassignMyTaskState {}

class ReassignMyTaskLoading extends ReassignMyTaskState {}

class ReassignMyTaskLoaded extends ReassignMyTaskState {
  ReassignMyTaskModel reassignMyTaskModel;
  ReassignMyTaskLoaded(this.reassignMyTaskModel);
}

class ReassignMyTaskError extends ReassignMyTaskState {
  final String message;
  ReassignMyTaskError(this.message);
}
