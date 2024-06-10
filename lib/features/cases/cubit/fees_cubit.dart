import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/cases/data/datasource/fees_data_source.dart';
import 'fees_state.dart';

class FeesCubit extends Cubit<FeesState> {
  final FeesDataSource dataSource;
  FeesCubit(this.dataSource) : super(FeesInitial());

  void fetchFees(Map<String, String> body) {
    emit(FeesLoading());
    dataSource.fetchFees(body).then((value) => {emit(FeesLoaded(value))});
  }
}
