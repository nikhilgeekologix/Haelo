import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/drawer_content/data/model/aboutus_model.dart';

@immutable
abstract class AboutUsState {}

class AboutUsInitial extends AboutUsState {}

class AboutUsLoading extends AboutUsState {}

class AboutUsLoaded extends AboutUsState {
  AboutUsModel aboutUsModel;
  AboutUsLoaded(this.aboutUsModel);
}

class AboutUsError extends AboutUsState {
  final String message;
  AboutUsError(this.message);
}
