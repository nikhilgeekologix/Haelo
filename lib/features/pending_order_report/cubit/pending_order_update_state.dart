import 'package:flutter/material.dart';

import '../data/model/pending_dowload_file_model.dart';
import '../data/model/pending_oder_report_model.dart';

@immutable
abstract class PendingOrderUpdateState {}

class PendingOrderUpdateInitial extends PendingOrderUpdateState {}

class PendingOrderUpdateLoading extends PendingOrderUpdateState {}

class PendingOrderUpdateLoaded extends PendingOrderUpdateState {
  PendingDownloadFileModel model;

  PendingOrderUpdateLoaded(this.model);
}

class PendingOrderUpdateError extends PendingOrderUpdateState {
  final String message;

  PendingOrderUpdateError(this.message);
}
