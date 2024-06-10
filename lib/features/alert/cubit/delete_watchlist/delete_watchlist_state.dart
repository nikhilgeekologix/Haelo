import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/alert/data/model/add_event_model.dart';

@immutable
abstract class DeleteWatchlistState {}

class DeleteWatchlistInitial extends DeleteWatchlistState {}

class DeleteWatchlistLoading extends DeleteWatchlistState {}

class DeleteWatchlistLoaded extends DeleteWatchlistState {
  DeleteWatchlistModel model;
  DeleteWatchlistLoaded(this.model);
}

class DeleteWatchlistError extends DeleteWatchlistState {
  final String message;
  DeleteWatchlistError(this.message);
}
