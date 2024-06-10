import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/cases/data/model/updatecomment_model.dart';

@immutable
abstract class UpdateCommentState {}

class UpdateCommentInitial extends UpdateCommentState {}

class UpdateCommentLoading extends UpdateCommentState {}

class UpdateCommentLoaded extends UpdateCommentState {
  UpdateCommentModel updateCommentModel;
  UpdateCommentLoaded(this.updateCommentModel);
}

class UpdateCommentError extends UpdateCommentState {
  final String message;
  UpdateCommentError(this.message);
}
