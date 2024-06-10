import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/home_page/data/model/display_board_model.dart';

@immutable
abstract class DisplayBoardState {}

class DisplayBoardInitial extends DisplayBoardState {}

class DisplayBoardLoading extends DisplayBoardState {}

class DisplayBoardLoaded extends DisplayBoardState {
  DisplayBoardModel displayBoardModel;
  DisplayBoardLoaded(this.displayBoardModel);
}

class DisplayBoardError extends DisplayBoardState {
  final String message;
  DisplayBoardError(this.message);
}
