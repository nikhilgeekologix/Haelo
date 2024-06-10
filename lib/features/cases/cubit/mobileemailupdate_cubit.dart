import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/cases/data/datasource/mobileemailupdate_data_source.dart';
import 'mobileemailupdate_state.dart';

class MobileEmailUpdateCubit extends Cubit<MobileEmailUpdateState> {
  final MobileEmailUpdateDataSource dataSource;
  MobileEmailUpdateCubit(this.dataSource) : super(MobileEmailUpdateInitial());

  void fetchMobileEmailUpdate(Map<String, String> body) {
    emit(MobileEmailUpdateLoading());
    dataSource.fetchMobileEmailUpdate(body).then((value) => {emit(MobileEmailUpdateLoaded(value))});
  }
}
