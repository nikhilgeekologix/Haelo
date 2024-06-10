import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/drawer_content/data/model/orderhistory_model.dart';

@immutable
abstract class OrderHistoryState {}

class OrderHistoryInitial extends OrderHistoryState {}

class OrderHistoryLoading extends OrderHistoryState {}

class OrderHistoryLoaded extends OrderHistoryState {
  OrderHistoryModel orderHistoryModel;
  OrderHistoryLoaded(this.orderHistoryModel);
}

class OrderHistoryError extends OrderHistoryState {
  final String message;
  OrderHistoryError(this.message);
}
