import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/features/pending_order_report/cubit/pending_order_download_file_state.dart';
import 'package:haelo_flutter/features/pending_order_report/cubit/pending_order_report_state.dart';

import '../data/datasource/pending_order_download_file_source.dart';
import '../data/datasource/pending_order_report_source.dart';

class PendingOrderDownloadFileCubit
    extends Cubit<PendingOrderDownloadFileState> {
  final PendingOrderDownloadFileSource dataSource;
  PendingOrderDownloadFileCubit(this.dataSource)
      : super(PendingOrderDownloadFileInitial());

  void fetchPendingOrderDownloadFile(Map<String, String> body) {
    emit(PendingOrderDownloadFileLoading());
    dataSource
        .fetchPendingOrderDownloadFile(body)
        .then((value) => {emit(PendingOrderDownloadFileLoaded(value))});
  }
}
