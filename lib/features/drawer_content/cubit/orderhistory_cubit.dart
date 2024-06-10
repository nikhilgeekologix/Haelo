import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/drawer_content/data/datasource/orderhistory_data_source.dart';
import 'orderhistory_state.dart';

class OrderHistoryCubit extends Cubit<OrderHistoryState> {
  final OrderHistoryDataSource dataSource;
  OrderHistoryCubit(this.dataSource) : super(OrderHistoryInitial());

  void fetchOrderHistory(Map<String, String> body) {
    emit(OrderHistoryLoading());
    dataSource.fetchOrderHistory(body).then((value) => {emit(OrderHistoryLoaded(value))});
  }
}
