import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/userboard/data/model/user_loginregister_model.dart';

@immutable
abstract class UserLoginRegisterState {}

class UserLoginRegisterInitial extends UserLoginRegisterState {}

class UserLoginRegisterLoading extends UserLoginRegisterState {}

class UserLoginRegisterLoaded extends UserLoginRegisterState {
  UserLoginRegisterModel model;
  UserLoginRegisterLoaded(this.model);
}

class UserLoginRegisterError extends UserLoginRegisterState {
  final String message;
  UserLoginRegisterError(this.message);
}
