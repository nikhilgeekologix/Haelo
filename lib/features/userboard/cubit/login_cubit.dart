import 'package:bloc/bloc.dart';

import '../data/datasource/login_data_source.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginDataSource dataSource;
  LoginCubit(this.dataSource) : super(AdminUserInitial());


  void fetchAdminUser({Map<String, String>? map})
  {
    dataSource.fetchAdminUser().then((value) => {
      emit(AdminUserLoaded(value))
    });
  }
}
