import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/cases/data/model/accountsdelete_model.dart';

@immutable
abstract class AccountsDeleteState {}

class AccountsDeleteInitial extends AccountsDeleteState {}

class AccountsDeleteLoading extends AccountsDeleteState {}

class AccountsDeleteLoaded extends AccountsDeleteState {
  AccountsDeleteModel accountsDeleteModel;
  AccountsDeleteLoaded(this.accountsDeleteModel);
}

class AccountsDeleteError extends AccountsDeleteState {
  final String message;
  AccountsDeleteError(this.message);
}
