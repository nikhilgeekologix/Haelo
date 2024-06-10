import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/home_page/data/model/court_summary_model.dart';

import '../data/model/CourtSummaryNewModel.dart';

@immutable
abstract class CourtSummaryNewState {}

class CourtSummaryNewInitial extends CourtSummaryNewState {}

class CourtSummaryNewLoading extends CourtSummaryNewState {}

class CourtSummaryNewLoaded extends CourtSummaryNewState {
  CourtSummaryNewModel courtSummaryNewModel;
  CourtSummaryNewLoaded(this.courtSummaryNewModel);
}

class CourtSummaryNewError extends CourtSummaryNewState {
  final String message;
  CourtSummaryNewError(this.message);
}
