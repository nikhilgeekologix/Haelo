import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/alert/data/model/add_event_model.dart';

@immutable
abstract class AddEventState {}

class AddEventInitial extends AddEventState {}

class AddEventLoading extends AddEventState {}

class AddEventLoaded extends AddEventState {
  AddEventModel model;
  AddEventLoaded(this.model);
}

class AddEventError extends AddEventState {
  final String message;
  AddEventError(this.message);
}
