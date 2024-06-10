import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/cases/data/model/comments_model.dart';

@immutable
abstract class CasesCommentState {}

class CasesCommentInitial extends CasesCommentState {}

class CasesCommentLoading extends CasesCommentState {}

class CasesCommentLoaded extends CasesCommentState {
  CasesCommentModel casesCommentModel;
  CasesCommentLoaded(this.casesCommentModel);
}

class CasesCommentError extends CasesCommentState {
  final String message;
  CasesCommentError(this.message);
}
