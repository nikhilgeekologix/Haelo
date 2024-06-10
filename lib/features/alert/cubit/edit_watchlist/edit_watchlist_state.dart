import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/alert/data/model/add_event_model.dart';

@immutable
abstract class EditWatchlistState {}

class EditWatchlistInitial extends EditWatchlistState {}

class EditWatchlistLoading extends EditWatchlistState {}

class EditWatchlistLoaded extends EditWatchlistState {
  EditWatchlistModel model;
  EditWatchlistLoaded(this.model);
}

class EditWatchlistError extends EditWatchlistState {
  final String message;
  EditWatchlistError(this.message);
}
