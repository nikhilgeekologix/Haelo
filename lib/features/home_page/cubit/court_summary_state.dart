import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/home_page/data/model/court_summary_model.dart';

@immutable
abstract class CourtSummaryState {}

class CourtSummaryInitial extends CourtSummaryState {}

class CourtSummaryLoading extends CourtSummaryState {}

class CourtSummaryLoaded extends CourtSummaryState {
  CourtSummaryModel courtSummaryModel;
  CourtSummaryLoaded(this.courtSummaryModel);
}

class CourtSummaryError extends CourtSummaryState {
  final String message;
  CourtSummaryError(this.message);
}
