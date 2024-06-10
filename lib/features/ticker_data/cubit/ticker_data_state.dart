import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/home_page/data/model/display_board_model.dart';
import 'package:haelo_flutter/features/home_page/data/model/update_display_board_model.dart';

import '../data/model/ticker_data_model.dart';

@immutable
abstract class TickerDataState {}

class TickerDataInitial extends TickerDataState {}

class TickerDataLoading extends TickerDataState {}

class TickerDataLoaded extends TickerDataState {
  TickerDataModel model;
  TickerDataLoaded(this.model);
}

class TickerDataError extends TickerDataState {
  final String message;
  TickerDataError(this.message);
}
