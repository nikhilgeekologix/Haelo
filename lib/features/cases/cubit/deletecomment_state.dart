import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/cases/data/model/deletecomment_model.dart';

@immutable
abstract class DeleteCommentState {}

class DeleteCommentInitial extends DeleteCommentState {}

class DeleteCommentLoading extends DeleteCommentState {}

class DeleteCommentLoaded extends DeleteCommentState {
  DeleteCommentModel deleteCommentModel;
  DeleteCommentLoaded(this.deleteCommentModel);
}

class DeleteCommentError extends DeleteCommentState {
  final String message;
  DeleteCommentError(this.message);
}
