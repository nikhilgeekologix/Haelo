import 'package:flutter/material.dart';

import '../data/model/mass_data.dart';

@immutable
abstract class DisplayBoardMassDataState {}

class DisplayBoardMassDataInitial extends DisplayBoardMassDataState {}

class DisplayBoardStageItemLoading extends DisplayBoardMassDataState {}

class DisplayBoardMassDataLoaded extends DisplayBoardMassDataState {
  MassDataModel displayBoardMassDataModel;
  DisplayBoardMassDataLoaded(this.displayBoardMassDataModel);
}

class DisplayBoardMassDataError extends DisplayBoardMassDataState {
  final String message;
  DisplayBoardMassDataError(this.message);
}
