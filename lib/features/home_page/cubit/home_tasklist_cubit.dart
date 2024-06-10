import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/home_page/data/datasource/home_mytask_data_source.dart';
import 'package:haelo_flutter/features/home_page/data/datasource/home_tasklist_data_source.dart';
import 'package:haelo_flutter/features/home_page/data/model/Home_TaskList_Model.dart';
import 'home_mytask_state.dart';
import 'home_tasklist_state.dart';

class HomeTaskListCubit extends Cubit<HomeTaskListState> {
  final HomeTaskListDataSource dataSource;
  HomeTaskListCubit(this.dataSource) : super(HomeTaskListInitial());
  // int page = 1;
  //
  // void getHomeTaskLists(bool isFirstCall, {var body}) {
  //   try {
  //     if (isFirstCall) page = 1;
  //     if (state is HomeTaskListLoading) return;
  //     final currentState = state;
  //
  //     var oldHomeTaskList = <TaskData>[];
  //
  //     if (currentState is HomeTaskListLoaded && page != 1) {
  //       oldHomeTaskList = currentState.homeTaskList;
  //     }
  //
  //     emit(HomeTaskListLoading(oldHomeTaskList, isFirstFetch: page == 1));
  //     dataSource.fetchHomeTaskList(body).then((value) {
  //       if (value.result != null) {
  //         if (value.dData!.bookings != null && value.dData!.bookings!.appointmentdata != null) {
  //           page++;
  //           final hometasklists = (state as HomeTaskListLoading).oldHomeTaskList;
  //           hometasklists.addAll(value.dData!.bookings!.appointmentdata!);
  //           emit(HomeTaskListLoaded(hometasklists));
  //         } else if (page == 1) {
  //           emit(HomeTaskListError("Appointment not found"));
  //         } else {
  //           final hometasklists = (state as HomeTaskListLoading).oldHomeTaskList;
  //           emit(HomeTaskListPageNotFound(hometasklists, page));
  //         }
  //       } else {
  //         if (page == 1) {
  //           emit(HomeTaskListError("Appointment not found"));
  //         } else {
  //           final appointments = (state as HomeTaskListLoading).oldHomeTaskList;
  //           emit(HomeTaskListPageNotFound(appointments, page));
  //         }
  //       }
  //     });
  //   } on Exception {
  //     emit(HomeTaskListError("some error occurred"));
  //   }
  // }

  void fetchHomeTaskList({Map<String, String>? body}) {
    emit(HomeTaskListLoading());
    dataSource.fetchHomeTaskList(body).then((value) => {emit(HomeTaskListLoaded(value))});
  }
}
