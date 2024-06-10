import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/cases/data/model/docdelete_model.dart';

@immutable
abstract class DocDeleteState {}

class DocDeleteInitial extends DocDeleteState {}

class DocDeleteLoading extends DocDeleteState {}

class DocDeleteLoaded extends DocDeleteState {
  DocDeleteModel docDeleteModel;
  DocDeleteLoaded(this.docDeleteModel);
}

class DocDeleteError extends DocDeleteState {
  final String message;
  DocDeleteError(this.message);
}
