import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/alert/data/model/delete_alert_model.dart';

@immutable
abstract class DeleteAlertState {}

class DeleteAlertInitial extends DeleteAlertState {}

class DeleteAlertLoading extends DeleteAlertState {}

class DeleteAlertLoaded extends DeleteAlertState {
  DeleteAlertModel model;
  DeleteAlertLoaded(this.model);
}

class DeleteAlertError extends DeleteAlertState {
  final String message;
  DeleteAlertError(this.message);
}
