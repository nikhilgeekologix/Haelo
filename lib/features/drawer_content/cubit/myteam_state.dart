import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/drawer_content/data/model/myteam_model.dart';

@immutable
abstract class MyTeamState {}

class MyTeamInitial extends MyTeamState {}

class MyTeamLoading extends MyTeamState {}

class MyTeamLoaded extends MyTeamState {
  MyTeamModel profileUpdateModel;
  MyTeamLoaded(this.profileUpdateModel);
}

class MyTeamError extends MyTeamState {
  final String message;
  MyTeamError(this.message);
}
