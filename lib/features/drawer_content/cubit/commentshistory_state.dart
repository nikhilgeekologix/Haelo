import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/drawer_content/data/model/commentshistory_model.dart';

@immutable
abstract class CommentsHistoryState {}

class CommentsHistoryInitial extends CommentsHistoryState {}

class CommentsHistoryLoading extends CommentsHistoryState {}

class CommentsHistoryLoaded extends CommentsHistoryState {
  CommentsHistoryModel commentsHistoryModel;
  CommentsHistoryLoaded(this.commentsHistoryModel);
}

class CommentsHistoryError extends CommentsHistoryState {
  final String message;
  CommentsHistoryError(this.message);
}
