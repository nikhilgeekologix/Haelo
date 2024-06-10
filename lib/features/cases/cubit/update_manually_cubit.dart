import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/cases/cubit/update_manually_state.dart';
import 'package:haelo_flutter/features/cases/data/datasource/addcomment_data_source.dart';
import '../data/datasource/update_manually_data_source.dart';
import 'addcomment_state.dart';

class UpdateManuallyCubit extends Cubit<UpdateManuallyState> {
  final UpdateManuallyDataSource dataSource;
  UpdateManuallyCubit(this.dataSource) : super(UpdateManuallyInitial());

  void fetchUpdateManually(Map<String, String> body) {
    emit(UpdateManuallyLoading());
    dataSource
        .fetchUpdateManually(body)
        .then((value) => {emit(UpdateManuallyLoaded(value))});
  }
}
