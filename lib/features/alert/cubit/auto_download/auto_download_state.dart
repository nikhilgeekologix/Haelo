import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/alert/data/model/auto_download_model.dart';

@immutable
abstract class AutoDownloadState {}

class AutoDownloadInitial extends AutoDownloadState {}

class AutoDownloadLoading extends AutoDownloadState {}

class AutoDownloadLoaded extends AutoDownloadState {
  AutoDownloadModel model;
  AutoDownloadLoaded(this.model);
}

class AutoDownloadError extends AutoDownloadState {
  final String message;
  AutoDownloadError(this.message);
}
