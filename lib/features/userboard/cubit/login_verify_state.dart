import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/userboard/data/model/login_verify_model.dart';

@immutable
abstract class LoginVerifyState {}

class LoginVerifyInitial extends LoginVerifyState {}

class LoginVerifyLoading extends LoginVerifyState {}

class LoginVerifyLoaded extends LoginVerifyState {
  LoginVerificationModel model;
  LoginVerifyLoaded(this.model);
}

class LoginVerifyError extends LoginVerifyState {
  final String message;
  LoginVerifyError(this.message);
}
