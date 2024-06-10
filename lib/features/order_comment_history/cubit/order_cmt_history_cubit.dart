import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/datasource/order_cmt_history_data_sourse.dart';
import 'order_cmt_history_state.dart';

class OrderCmtHistoryCubit extends Cubit<OrderCmtHistoryState> {
  final OrderCmtHistoryDataSource dataSource;
  OrderCmtHistoryCubit(this.dataSource) : super(OrderCmtHistoryInitial());

  void fetchOrderCmtHistory(Map<String, String> body) {
    emit(OrderCmtHistoryLoading());
    dataSource
        .fetchOrderCmtHistoryData(body)
        .then((value) => {emit(OrderCmtHistoryLoaded(value))});
  }
}
