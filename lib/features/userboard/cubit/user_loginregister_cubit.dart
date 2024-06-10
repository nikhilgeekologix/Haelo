import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/userboard/cubit/user_loginregister_state.dart';
import 'package:haelo_flutter/features/userboard/data/datasource/user_loginregister_data_source.dart';

class UserLoginRegisterCubit extends Cubit<UserLoginRegisterState> {
  final UserLoginRegisterDataSource dataSource;
  UserLoginRegisterCubit(this.dataSource) : super(UserLoginRegisterInitial());

  void fetchUserLoginRegister(Map<String, String> body) {
    dataSource.fetchUserLoginRegister(body).then((value) => {emit(UserLoginRegisterLoaded(value))});
  }
}
