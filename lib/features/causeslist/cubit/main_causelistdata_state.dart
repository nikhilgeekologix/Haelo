import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/causeslist/data/model/main_causelistdata_model.dart';

@immutable
abstract class MainCauseListDataState {}

class MainCauseListDataInitial extends MainCauseListDataState {}

class MainCauseListDataLoading extends MainCauseListDataState {}

class MainCauseListDataLoaded extends MainCauseListDataState {
  MainCauseListDataModel mainCauseListDataModel;
  MainCauseListDataLoaded(this.mainCauseListDataModel);
}

class MainCauseListDataError extends MainCauseListDataState {
  final String message;
  MainCauseListDataError(this.message);
}
