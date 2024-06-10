import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/cases/data/datasource/addexpensesfees_data_source.dart';
import 'addexpensesfees_state.dart';

class AddExpensesFeesCubit extends Cubit<AddExpensesFeesState> {
  final AddExpensesFeesDataSource dataSource;
  AddExpensesFeesCubit(this.dataSource) : super(AddExpensesFeesInitial());

  void fetchAddExpensesFees(Map<String, String> body) {
    emit(AddExpensesFeesLoading());
    dataSource.fetchAddExpensesFees(body).then((value) => {emit(AddExpensesFeesLoaded(value))});
  }
}
