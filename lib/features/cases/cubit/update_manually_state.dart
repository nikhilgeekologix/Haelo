import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/cases/data/model/addcomment_model.dart';

import '../data/model/adddetails_model.dart';

@immutable
abstract class UpdateManuallyState {}

class UpdateManuallyInitial extends UpdateManuallyState {}

class UpdateManuallyLoading extends UpdateManuallyState {}

class UpdateManuallyLoaded extends UpdateManuallyState {
  AddDetailsModel addCommentModel;
  UpdateManuallyLoaded(this.addCommentModel);
}

class UpdateManuallyError extends UpdateManuallyState {
  final String message;
  UpdateManuallyError(this.message);
}
