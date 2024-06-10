import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/cases/data/model/adddetails_model.dart';

@immutable
abstract class AddDetailsState {}

class AddDetailsInitial extends AddDetailsState {}

class AddDetailsLoading extends AddDetailsState {}

class AddDetailsLoaded extends AddDetailsState {
  AddDetailsModel addDetailsModel;
  AddDetailsLoaded(this.addDetailsModel);
}

class AddDetailsError extends AddDetailsState {
  final String message;
  AddDetailsError(this.message);
}
