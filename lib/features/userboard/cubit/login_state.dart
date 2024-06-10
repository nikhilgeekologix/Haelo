import 'package:flutter/material.dart';
import '../data/model/admin_user_model.dart';


@immutable
abstract class LoginState {}

class AdminUserInitial extends LoginState {}

class AdminUserLoading extends LoginState {}

class AdminUserLoaded extends LoginState {
  AdminUserModel model;
  AdminUserLoaded(this.model);
}

class AdminUserError extends LoginState {
  final String message;
  AdminUserError(this.message);
}
