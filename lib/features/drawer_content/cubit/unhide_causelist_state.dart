import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/drawer_content/data/model/unhide_causelist_model.dart';

@immutable
abstract class UnHideCauseListState {}

class UnHideCauseListInitial extends UnHideCauseListState {}

class UnHideCauseListLoading extends UnHideCauseListState {}

class UnHideCauseListLoaded extends UnHideCauseListState {
  UnHideCauseListModel unHideCauseListModel;
  UnHideCauseListLoaded(this.unHideCauseListModel);
}

class UnHideCauseListError extends UnHideCauseListState {
  final String message;
  UnHideCauseListError(this.message);
}
