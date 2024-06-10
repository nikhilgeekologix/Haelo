import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/drawer_content/data/model/hidden_causelist_model.dart';
import 'package:haelo_flutter/features/drawer_content/data/model/profile_model.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  ProfileModel profileModel;
  ProfileLoaded(this.profileModel);
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
