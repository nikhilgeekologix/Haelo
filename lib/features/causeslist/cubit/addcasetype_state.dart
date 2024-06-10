import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/causeslist/data/model/addcasetype_model.dart';

@immutable
abstract class AddCaseTypeState {}

class AddCaseTypeInitial extends AddCaseTypeState {}

class AddCaseTypeLoading extends AddCaseTypeState {}

class AddCaseTypeLoaded extends AddCaseTypeState {
  AddCaseTypeModel addCaseTypeModel;
  AddCaseTypeLoaded(this.addCaseTypeModel);
}

class AddCaseTypeError extends AddCaseTypeState {
  final String message;
  AddCaseTypeError(this.message);
}
