import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/causeslist/data/model/viewcauselist_model.dart';

@immutable
abstract class ViewCauseListState {}

class ViewCauseListInitial extends ViewCauseListState {}

class ViewCauseListLoading extends ViewCauseListState {}

class ViewCauseListLoaded extends ViewCauseListState {
  ViewCauseListModel viewCauseListModel;
  ViewCauseListLoaded(this.viewCauseListModel);
}

class ViewCauseListError extends ViewCauseListState {
  final String message;
  ViewCauseListError(this.message);
}
