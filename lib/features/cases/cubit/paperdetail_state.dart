import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/cases/data/model/paperdetail_model.dart';

@immutable
abstract class PaperDetailState {}

class PaperDetailInitial extends PaperDetailState {}

class PaperDetailLoading extends PaperDetailState {}

class PaperDetailLoaded extends PaperDetailState {
  PaperDetailModel paperDetailModel;
  PaperDetailLoaded(this.paperDetailModel);
}

class PaperDetailError extends PaperDetailState {
  final String message;
  PaperDetailError(this.message);
}
