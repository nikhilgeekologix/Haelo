import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/features/drawer_content/data/datasource/delete_account_datasource.dart';
import 'delete_account_state.dart';

class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  final DeleteAccountDataSource dataSource;

  DeleteAccountCubit(this.dataSource) : super(DeleteAccountInitial());

  void deleteAccount() {
    try {
      emit(DeleteAccountLoading());
      dataSource
          .deleteAccount()
          .then((value) => emit(DeleteAccountLoaded(value)));
    } on Exception {
      emit(DeleteAccountError("some error occurred"));
    }
  }
}
