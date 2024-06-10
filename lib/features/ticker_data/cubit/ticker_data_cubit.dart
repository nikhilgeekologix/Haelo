import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/ticker_data/cubit/ticker_data_state.dart';
import '../data/datasource/ticker_data_datasource.dart';

class TickerDataCubit extends Cubit<TickerDataState> {
  final TickerDataDataSource dataSource;
  TickerDataCubit(this.dataSource) : super(TickerDataInitial());

  void getTickerData(Map<String, String> body) {
    emit(TickerDataLoading());
    dataSource.TickerData(body).then((value) => {emit(TickerDataLoaded(value))});
  }
}
