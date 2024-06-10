import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/drawer_content/data/model/hidden_causelist_model.dart';

@immutable
abstract class HiddenCauseListState {}

class HiddenCauseListInitial extends HiddenCauseListState {}

class HiddenCauseListLoading extends HiddenCauseListState {}

class HiddenCauseListLoaded extends HiddenCauseListState {
  HiddenCauseListModel hiddenCauseListModel;
  HiddenCauseListLoaded(this.hiddenCauseListModel);
}

class HiddenCauseListError extends HiddenCauseListState {
  final String message;
  HiddenCauseListError(this.message);
}
