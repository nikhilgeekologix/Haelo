import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/features/alert/cubit/auto_download/auto_download_state.dart';
import 'package:haelo_flutter/features/alert/data/datasource/my_alert_datasource.dart';

class AutoDownloadCubit extends Cubit<AutoDownloadState> {
  final MyAlertDataSource dataSource;
  AutoDownloadCubit(this.dataSource) : super(AutoDownloadInitial());

  void autoDownload(Map<String, String> body) {
    emit(AutoDownloadLoading());
    dataSource.autoDownload(body).then((value) => {emit(AutoDownloadLoaded(value))});
  }
}