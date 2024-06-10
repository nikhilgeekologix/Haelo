import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/userboard/data/datasource/login_verify_data_source.dart';
import 'login_verify_state.dart';

class LoginVerifyCubit extends Cubit<LoginVerifyState> {
  final LoginVerifyDataSource dataSource;
  LoginVerifyCubit(this.dataSource) : super(LoginVerifyInitial());

  void fetchLoginVerify(Map<String, String> body) {
    emit(LoginVerifyLoading());
    dataSource.fetchLoginVerify(body).then((value) => {emit(LoginVerifyLoaded(value))});
  }
}
