import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/features/alert/data/datasource/my_alert_datasource.dart';

import 'add_event_state.dart';

class AddEventCubit extends Cubit<AddEventState> {
  final MyAlertDataSource dataSource;
  AddEventCubit(this.dataSource) : super(AddEventInitial());

  void addEventToCalendar(Map<String, String> body) {
    emit(AddEventLoading());
    dataSource.addEventToCalendar(body).then((value) => {emit(AddEventLoaded(value))});
  }
}
