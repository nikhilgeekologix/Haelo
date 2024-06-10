import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/in_app_purchase/data/model/pay_request_model.dart';
import 'package:haelo_flutter/features/in_app_purchase/data/model/plans_model.dart';

@immutable
abstract class PayRequestState {}

class PayRequestInitial extends PayRequestState {}

class PayRequestLoading extends PayRequestState {}

class PayRequestLoaded extends PayRequestState {
  PayRequestModel model;
  PayRequestLoaded(this.model);
}

class PayRequestError extends PayRequestState {
  final String message;
  PayRequestError(this.message);
}
