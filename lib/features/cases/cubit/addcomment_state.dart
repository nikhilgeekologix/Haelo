import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/cases/data/model/addcomment_model.dart';

@immutable
abstract class AddCommentState {}

class AddCommentInitial extends AddCommentState {}

class AddCommentLoading extends AddCommentState {}

class AddCommentLoaded extends AddCommentState {
  AddCommentModel addCommentModel;
  AddCommentLoaded(this.addCommentModel);
}

class AddCommentError extends AddCommentState {
  final String message;
  AddCommentError(this.message);
}
