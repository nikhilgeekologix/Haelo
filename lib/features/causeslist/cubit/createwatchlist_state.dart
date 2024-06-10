import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/causeslist/data/model/createwatchlist_model.dart';

@immutable
abstract class CreateWatchlistState {}

class CreateWatchlistInitial extends CreateWatchlistState {}

class CreateWatchlistLoading extends CreateWatchlistState {}

class CreateWatchlistLoaded extends CreateWatchlistState {
  CreateWatchlistModel createWatchlistModel;
  CreateWatchlistLoaded(this.createWatchlistModel);
}

class CreateWatchlistError extends CreateWatchlistState {
  final String message;
  CreateWatchlistError(this.message);
}
