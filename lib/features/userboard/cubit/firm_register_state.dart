import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/userboard/data/model/firm_register_model.dart';

@immutable
abstract class FirmRegisterState {}

class FirmRegisterInitial extends FirmRegisterState {}

class FirmRegisterLoading extends FirmRegisterState {}

class FirmRegisterLoaded extends FirmRegisterState {
  FirmRegisterModel model;
  FirmRegisterLoaded(this.model);
}

class FirmRegisterError extends FirmRegisterState {
  final String message;
  FirmRegisterError(this.message);
}
