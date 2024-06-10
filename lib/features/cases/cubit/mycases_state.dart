import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/cases/data/model/mycases_model.dart';

@immutable
abstract class MyCasesState {}

class MyCasesInitial extends MyCasesState {}

class MyCasesLoading extends MyCasesState {}

class MyCasesLoaded extends MyCasesState {
  MyCasesModel myCasesModel;
  MyCasesLoaded(this.myCasesModel);
}

class MyCasesError extends MyCasesState {
  final String message;
  MyCasesError(this.message);
}
