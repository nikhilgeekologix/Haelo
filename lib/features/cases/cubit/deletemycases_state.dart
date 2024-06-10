import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/cases/data/model/deletemycases_model.dart';

@immutable
abstract class DeleteMyCaseState {}

class DeleteMyCaseInitial extends DeleteMyCaseState {}

class DeleteMyCaseLoading extends DeleteMyCaseState {}

class DeleteMyCaseLoaded extends DeleteMyCaseState {
  DeleteMyCaseModel deleteMyCaseModel;
  DeleteMyCaseLoaded(this.deleteMyCaseModel);
}

class DeleteMyCaseError extends DeleteMyCaseState {
  final String message;
  DeleteMyCaseError(this.message);
}
