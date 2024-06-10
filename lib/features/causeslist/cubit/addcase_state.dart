import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/causeslist/data/model/addcase_model.dart';

@immutable
abstract class AddCaseState {}

class AddCaseInitial extends AddCaseState {}

class AddCaseLoading extends AddCaseState {}

class AddCaseLoaded extends AddCaseState {
  AddCaseModel addCaseModel;
  AddCaseLoaded(this.addCaseModel);
}

class AddCaseError extends AddCaseState {
  final String message;
  AddCaseError(this.message);
}
