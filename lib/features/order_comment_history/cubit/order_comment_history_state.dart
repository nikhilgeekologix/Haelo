import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/order_comment_history/data/model/order_comment_history_model.dart';

@immutable
abstract class OrderCommentHistoryState {}

class OrderCommentHistoryInitial extends OrderCommentHistoryState {}

class OrderCommentHistoryLoading extends OrderCommentHistoryState {}

class OrderCommentHistoryLoaded extends OrderCommentHistoryState {
  OrderCommentHistoryModel model;

  OrderCommentHistoryLoaded(this.model);
}

class OrderCommentHistoryError extends OrderCommentHistoryState {
  final String message;

  OrderCommentHistoryError(this.message);
}
