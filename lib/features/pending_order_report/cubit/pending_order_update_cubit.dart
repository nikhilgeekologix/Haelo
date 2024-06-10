import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/features/pending_order_report/cubit/pending_order_download_file_state.dart';
import 'package:haelo_flutter/features/pending_order_report/cubit/pending_order_report_state.dart';
import 'package:haelo_flutter/features/pending_order_report/cubit/pending_order_update_state.dart';
import 'package:haelo_flutter/features/pending_order_report/data/datasource/pending_order_update_source.dart';

import '../data/datasource/pending_order_download_file_source.dart';
import '../data/datasource/pending_order_report_source.dart';

class PendingOrderUpdateCubit extends Cubit<PendingOrderUpdateState> {
  final PendingOrderUpdateSource dataSource;
  PendingOrderUpdateCubit(this.dataSource) : super(PendingOrderUpdateInitial());

  void fetchPendingOrderUpdate(Map<String, String> body) {
    emit(PendingOrderUpdateLoading());
    dataSource
        .fetchPendingOrderUpdate(body)
        .then((value) => {emit(PendingOrderUpdateLoaded(value))});
  }
}
