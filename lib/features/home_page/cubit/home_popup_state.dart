import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/userboard/data/model/firm_register_model.dart';

import '../data/model/HomeStatusModel.dart';

@immutable
abstract class HomePopupState {}

class HomePopupInitial extends HomePopupState {}

class HomePopupLoading extends HomePopupState {}

class HomePopupLoaded extends HomePopupState {
  HomeStatusModel model;
  HomePopupLoaded(this.model);
}

class HomePopupError extends HomePopupState {
  final String message;
  HomePopupError(this.message);
}
