import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/home_page/data/model/displayboard_summary_model.dart';

@immutable
abstract class DisplayBoardSummaryState {}

class DisplayBoardSummaryInitial extends DisplayBoardSummaryState {}

class DisplayBoardSummaryLoading extends DisplayBoardSummaryState {}

class DisplayBoardSummaryLoaded extends DisplayBoardSummaryState {
  DisplayBoardSummaryModel displayBoardSummaryModel;
  DisplayBoardSummaryLoaded(this.displayBoardSummaryModel);
}

class DisplayBoardSummaryError extends DisplayBoardSummaryState {
  final String message;
  DisplayBoardSummaryError(this.message);
}
