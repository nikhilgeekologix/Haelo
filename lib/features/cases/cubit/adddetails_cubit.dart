import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/cases/data/datasource/adddetails_data_source.dart';
import 'addetails_state.dart';
import 'expenses_state.dart';

class AddDetailsCubit extends Cubit<AddDetailsState> {
  final AddDetailsDataSource dataSource;
  AddDetailsCubit(this.dataSource) : super(AddDetailsInitial());

  void fetchAddDetails(Map<String, String> body) {
    emit(AddDetailsLoading());
    dataSource.fetchAddDetails(body).then((value) => {emit(AddDetailsLoaded(value))});
  }
}
