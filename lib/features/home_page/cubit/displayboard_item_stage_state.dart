import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/home_page/cubit/displayboard_item_stage_cubit.dart';
import 'package:haelo_flutter/features/home_page/data/model/displayboard_summary_model.dart';

import '../data/model/displayboard_item_stage_model.dart';

@immutable
abstract class DisplayBoardItemStageState {}

class DisplayBoardStageItemInitial extends DisplayBoardItemStageState {}

class DisplayBoardStageItemLoading extends DisplayBoardItemStageState {}

class DisplayBoardStageItemLoaded extends DisplayBoardItemStageState {
  DisplayBoardItemStageModel displayBoardItemStageModel;
  DisplayBoardStageItemLoaded(this.displayBoardItemStageModel);
}

class DisplayBoardStageItemError extends DisplayBoardItemStageState {
  final String message;
  DisplayBoardStageItemError(this.message);
}
