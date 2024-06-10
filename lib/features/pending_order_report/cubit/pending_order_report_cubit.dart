import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/features/pending_order_report/cubit/pending_order_report_state.dart';

import '../data/datasource/pending_order_report_source.dart';

class PendingOrderReportCubit extends Cubit<PendingOrderReportState> {
  final PendingOrderReportSource dataSource;
  PendingOrderReportCubit(this.dataSource) : super(PendingOrderReportInitial());

  void fetchPendingOrderReport() {
    emit(PendingOrderReportLoading());
    dataSource
        .fetchPendingOrderReport()
        .then((value) => {emit(PendingOrderReportLoaded(value))});
  }
}
