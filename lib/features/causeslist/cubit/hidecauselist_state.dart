import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/causeslist/data/model/hidecauselist_model.dart';

@immutable
abstract class HideCauseListState {}

class HideCauseListInitial extends HideCauseListState {}

class HideCauseListLoading extends HideCauseListState {}

class HideCauseListLoaded extends HideCauseListState {
  HideCauseListModel hideCauseListModel;
  HideCauseListLoaded(this.hideCauseListModel);
}

class HideCauseListError extends HideCauseListState {
  final String message;
  HideCauseListError(this.message);
}
