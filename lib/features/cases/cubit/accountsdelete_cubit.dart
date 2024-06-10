import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/cases/data/datasource/accountsdelete_data_source.dart';
import 'accountsdelete_state.dart';

class AccountsDeleteCubit extends Cubit<AccountsDeleteState> {
  final AccountsDeleteDataSource dataSource;
  AccountsDeleteCubit(this.dataSource) : super(AccountsDeleteInitial());

  void fetchAccountsDelete(Map<String, String> body) {
    emit(AccountsDeleteLoading());
    dataSource.fetchAccountsDelete(body).then((value) => {emit(AccountsDeleteLoaded(value))});
  }
}
