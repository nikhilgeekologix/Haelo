import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/cases/data/model/addcomment_model.dart';

@immutable
abstract class DriveFolderCreatorState {}

class DriveFolderCreatorInitial extends DriveFolderCreatorState {}

class DriveFolderCreatorLoading extends DriveFolderCreatorState {}

class DriveFolderCreatorLoaded extends DriveFolderCreatorState {
  AddCommentModel addCommentModel;
  DriveFolderCreatorLoaded(this.addCommentModel);
}

class DriveFolderCreatorError extends DriveFolderCreatorState {
  final String message;
  DriveFolderCreatorError(this.message);
}
