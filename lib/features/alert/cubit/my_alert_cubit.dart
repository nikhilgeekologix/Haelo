import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/features/alert/cubit/my_alert_state.dart';
import 'package:haelo_flutter/features/alert/data/datasource/my_alert_datasource.dart';

class MyAlertCubit extends Cubit<MyAlertState> {
  final MyAlertDataSource dataSource;
  MyAlertCubit(this.dataSource) : super(MyAlertInitial());

  void fetchMyAlert() {
    emit(MyAlertLoading());
    dataSource.fetchMyAlert().then((value) => {emit(MyAlertLoaded(value))});
  }
}
