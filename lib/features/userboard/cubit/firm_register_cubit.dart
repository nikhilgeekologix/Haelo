import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/userboard/data/datasource/firm_register_data_source.dart';

import '../data/datasource/login_data_source.dart';
import 'firm_register_state.dart';
import 'login_state.dart';

class FirmRegisterCubit extends Cubit<FirmRegisterState> {
  final FirmRegisterDataSource dataSource;
  FirmRegisterCubit(this.dataSource) : super(FirmRegisterInitial());

  void fetchFirmRegister(Map<String, String> body) {
    dataSource.fetchFirmRegister(body).then((value) => {emit(FirmRegisterLoaded(value))});
  }
}
