import 'package:flutter/material.dart';

import '../data/model/pending_dowload_file_model.dart';
import '../data/model/pending_oder_report_model.dart';

@immutable
abstract class PendingOrderDownloadFileState {}

class PendingOrderDownloadFileInitial extends PendingOrderDownloadFileState {}

class PendingOrderDownloadFileLoading extends PendingOrderDownloadFileState {}

class PendingOrderDownloadFileLoaded extends PendingOrderDownloadFileState {
  PendingDownloadFileModel model;

  PendingOrderDownloadFileLoaded(this.model);
}

class PendingOrderDownloadFileError extends PendingOrderDownloadFileState {
  final String message;

  PendingOrderDownloadFileError(this.message);
}
