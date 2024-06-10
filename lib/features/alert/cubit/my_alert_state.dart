import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/alert/data/model/my_alert_model.dart';

@immutable
abstract class MyAlertState {}

class MyAlertInitial extends MyAlertState {}

class MyAlertLoading extends MyAlertState {}

class MyAlertLoaded extends MyAlertState {
  MyAlertModel myAlertModel;
  MyAlertLoaded(this.myAlertModel);
}

class MyAlertError extends MyAlertState {
  final String message;
  MyAlertError(this.message);
}
