import 'package:flutter/material.dart';

import '../data/model/pending_oder_report_model.dart';

@immutable
abstract class PendingOrderReportState {}

class PendingOrderReportInitial extends PendingOrderReportState {}

class PendingOrderReportLoading extends PendingOrderReportState {}

class PendingOrderReportLoaded extends PendingOrderReportState {
  PendingOrderReportModel model;

  PendingOrderReportLoaded(this.model);
}

class PendingOrderReportError extends PendingOrderReportState {
  final String message;

  PendingOrderReportError(this.message);
}
