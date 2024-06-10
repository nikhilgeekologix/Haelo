import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/court_date_report/data/model/court_date_report_model.dart';

@immutable
abstract class CourtDateReportState {}

class CourtDateReportInitial extends CourtDateReportState {}

class CourtDateReportLoading extends CourtDateReportState {}

class CourtDateReportLoaded extends CourtDateReportState {
  CourtDateReportModel model;

  CourtDateReportLoaded(this.model);
}

class CourtDateReportError extends CourtDateReportState {
  final String message;

  CourtDateReportError(this.message);
}
