import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/home_page/data/model/home_mytask_model.dart';

@immutable
abstract class HomeMyTaskState {}

class HomeMyTaskInitial extends HomeMyTaskState {}

class HomeMyTaskLoading extends HomeMyTaskState {}

class HomeMyTaskLoaded extends HomeMyTaskState {
  HomeMyTaskModel homeMyTaskModel;
  HomeMyTaskLoaded(this.homeMyTaskModel);
}

class HomeMyTaskError extends HomeMyTaskState {
  final String message;
  HomeMyTaskError(this.message);
}
