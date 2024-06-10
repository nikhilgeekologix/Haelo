import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/in_app_purchase/data/model/my_subscription_model.dart';

@immutable
abstract class MySubscriptionState {}

class MySubscriptionInitial extends MySubscriptionState {}

class MySubscriptionLoading extends MySubscriptionState {}

class MySubscriptionLoaded extends MySubscriptionState {
  MySubscriptionModel model;
  MySubscriptionLoaded(this.model);
}

class MySubscriptionError extends MySubscriptionState {
  final String message;
  MySubscriptionError(this.message);
}
