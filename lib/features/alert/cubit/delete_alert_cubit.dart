import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/features/alert/cubit/delete_alert_state.dart';
import 'package:haelo_flutter/features/alert/data/datasource/my_alert_datasource.dart';

class DeleteAlertCubit extends Cubit<DeleteAlertState> {
  final MyAlertDataSource dataSource;
  DeleteAlertCubit(this.dataSource) : super(DeleteAlertInitial());

  void fetchMyAlert(Map<String, String> body) {
    emit(DeleteAlertLoading());
    dataSource.deleteAlert(body).then((value) => {emit(DeleteAlertLoaded(value))});
  }
}
