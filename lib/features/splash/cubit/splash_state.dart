import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/splash/data/model/splash_model.dart';


@immutable
abstract class SplashState {}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashLoaded extends SplashState {
  final SplashModel splashModel;

  SplashLoaded(this.splashModel);
}

class SplashError extends SplashState {
  final String message;

  SplashError(this.message);
}
