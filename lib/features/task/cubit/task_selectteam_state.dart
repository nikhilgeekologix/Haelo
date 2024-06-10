import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/task/data/model/task_selectteam_model.dart';

@immutable
abstract class TaskSelectTeamState {}

class TaskSelectTeamInitial extends TaskSelectTeamState {}

class TaskSelectTeamLoading extends TaskSelectTeamState {}

class TaskSelectTeamLoaded extends TaskSelectTeamState {
  TaskSelectTeamModel taskSelectTeamModel;
  TaskSelectTeamLoaded(this.taskSelectTeamModel);
}

class TaskSelectTeamError extends TaskSelectTeamState {
  final String message;
  TaskSelectTeamError(this.message);
}
