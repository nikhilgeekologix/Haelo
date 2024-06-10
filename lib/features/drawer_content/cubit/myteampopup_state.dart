import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/drawer_content/data/model/myteampopup_model.dart';

@immutable
abstract class MyTeamPopupState {}

class MyTeamPopupInitial extends MyTeamPopupState {}

class MyTeamPopupLoading extends MyTeamPopupState {}

class MyTeamPopupLoaded extends MyTeamPopupState {
  MyTeamPopupModel myTeamPopupModel;
  MyTeamPopupLoaded(this.myTeamPopupModel);
}

class MyTeamPopupError extends MyTeamPopupState {
  final String message;
  MyTeamPopupError(this.message);
}
