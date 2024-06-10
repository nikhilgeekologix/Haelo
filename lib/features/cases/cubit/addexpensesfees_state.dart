import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/cases/data/model/addexpensesfees_model.dart';

@immutable
abstract class AddExpensesFeesState {}

class AddExpensesFeesInitial extends AddExpensesFeesState {}

class AddExpensesFeesLoading extends AddExpensesFeesState {}

class AddExpensesFeesLoaded extends AddExpensesFeesState {
  AddExpensesFeesModel addExpensesFeesModel;
  AddExpensesFeesLoaded(this.addExpensesFeesModel);
}

class AddExpensesFeesError extends AddExpensesFeesState {
  final String message;
  AddExpensesFeesError(this.message);
}
