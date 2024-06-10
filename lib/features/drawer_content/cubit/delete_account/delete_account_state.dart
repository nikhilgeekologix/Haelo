import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/drawer_content/data/model/delete_account_model.dart';

@immutable
abstract class DeleteAccountState {}

class DeleteAccountInitial extends DeleteAccountState {}

class DeleteAccountLoading extends DeleteAccountState {}

class DeleteAccountLoaded extends DeleteAccountState {
  final DeleteAccountModel model;

  DeleteAccountLoaded(this.model);
}

class DeleteAccountError extends DeleteAccountState {
  final String message;

  DeleteAccountError(this.message);
}
