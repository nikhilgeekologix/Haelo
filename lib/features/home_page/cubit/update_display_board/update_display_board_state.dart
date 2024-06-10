import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/home_page/data/model/display_board_model.dart';
import 'package:haelo_flutter/features/home_page/data/model/update_display_board_model.dart';

@immutable
abstract class UpdateDisplayBoardState {}

class UpdateDisplayBoardInitial extends UpdateDisplayBoardState {}

class UpdateDisplayBoardLoading extends UpdateDisplayBoardState {}

class UpdateDisplayBoardLoaded extends UpdateDisplayBoardState {
  UpdateDisplayBoardModel model;
  UpdateDisplayBoardLoaded(this.model);
}

class UpdateDisplayBoardError extends UpdateDisplayBoardState {
  final String message;
  UpdateDisplayBoardError(this.message);
}
