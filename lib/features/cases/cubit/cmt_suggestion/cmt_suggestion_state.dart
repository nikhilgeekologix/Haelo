import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/cases/data/model/cmt_suggestion_model.dart';

@immutable
abstract class CommentSuggestionState {}

class CommentSuggestionInitial extends CommentSuggestionState {}

class CommentSuggestionLoading extends CommentSuggestionState {}

class CommentSuggestionLoaded extends CommentSuggestionState {
  CommentSuggestionModel model;
  CommentSuggestionLoaded(this.model);
}

class CommentSuggestionError extends CommentSuggestionState {
  final String message;
  CommentSuggestionError(this.message);
}
