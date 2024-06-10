import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/home_page/data/model/Home_TaskList_Model.dart';

@immutable
abstract class HomeTaskListState {
  const HomeTaskListState();
}

class HomeTaskListInitial extends HomeTaskListState {}

class HomeTaskListLoading extends HomeTaskListState {
  // final List<TaskData> oldHomeTaskList;
  // final bool isFirstFetch;
  //
  HomeTaskListLoading();
}

class HomeTaskListLoaded extends HomeTaskListState {
  // final List<TaskData> homeTaskList;
  HomeTaskListModel homeTaskListModel;
  HomeTaskListLoaded(this.homeTaskListModel); //, this.homeTaskList
}

class HomeTaskListPageNotFound extends HomeTaskListState {
  // final List<TaskData> oldHomeTaskList;
  // int page;

  // HomeTaskListPageNotFound(this.oldHomeTaskList, this.page);
}

class HomeTaskListError extends HomeTaskListState {
  // String message = "";
  // HomeTaskListError(this.message);
}
