import 'package:flutter/material.dart';

import '../data/model/order_cmt_history_data_model.dart';

@immutable
abstract class OrderCmtHistoryState {}

class OrderCmtHistoryInitial extends OrderCmtHistoryState {}

class OrderCmtHistoryLoading extends OrderCmtHistoryState {}

class OrderCmtHistoryLoaded extends OrderCmtHistoryState {
  OrderCommentHistoryModel model;

  OrderCmtHistoryLoaded(this.model);
}

class OrderCmtHistoryError extends OrderCmtHistoryState {
  final String message;

  OrderCmtHistoryError(this.message);
}
