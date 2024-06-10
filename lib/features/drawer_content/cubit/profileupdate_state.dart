import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/drawer_content/data/model/profileupdate_model.dart';

@immutable
abstract class ProfileUpdateState {}

class ProfileUpdateInitial extends ProfileUpdateState {}

class ProfileUpdateLoading extends ProfileUpdateState {}

class ProfileUpdateLoaded extends ProfileUpdateState {
  ProfileUpdateModel profileUpdateModel;
  ProfileUpdateLoaded(this.profileUpdateModel);
}

class ProfileUpdateError extends ProfileUpdateState {
  final String message;
  ProfileUpdateError(this.message);
}
