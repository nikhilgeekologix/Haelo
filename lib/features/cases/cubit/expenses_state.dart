import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/cases/data/model/expenses_model.dart';

@immutable
abstract class ExpensesState {}

class ExpensesInitial extends ExpensesState {}

class ExpensesLoading extends ExpensesState {}

class ExpensesLoaded extends ExpensesState {
  ExpensesModel expensesModel;
  ExpensesLoaded(this.expensesModel);
}

class ExpensesError extends ExpensesState {
  final String message;
  ExpensesError(this.message);
}
