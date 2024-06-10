import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/cases/data/model/mobileemailupdate_model.dart';

@immutable
abstract class MobileEmailUpdateState {}

class MobileEmailUpdateInitial extends MobileEmailUpdateState {}

class MobileEmailUpdateLoading extends MobileEmailUpdateState {}

class MobileEmailUpdateLoaded extends MobileEmailUpdateState {
  MobileEmailUpdateModel mobileEmailUpdateModel;
  MobileEmailUpdateLoaded(this.mobileEmailUpdateModel);
}

class MobileEmailUpdateError extends MobileEmailUpdateState {
  final String message;
  MobileEmailUpdateError(this.message);
}
