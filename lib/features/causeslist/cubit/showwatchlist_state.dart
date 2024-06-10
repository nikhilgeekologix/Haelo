import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/causeslist/data/model/showwatchlist_model.dart';

@immutable
abstract class ShowWatchlistState {}

class ShowWatchlistInitial extends ShowWatchlistState {}

class ShowWatchlistLoading extends ShowWatchlistState {}

class ShowWatchlistLoaded extends ShowWatchlistState {
  ShowWatchlistModel showWatchlistModel;
  ShowWatchlistLoaded(this.showWatchlistModel);
}

class ShowWatchlistError extends ShowWatchlistState {
  final String message;
  ShowWatchlistError(this.message);
}
