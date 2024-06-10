import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/cases/data/datasource/expenses_data_source.dart';
import 'expenses_state.dart';

class ExpensesCubit extends Cubit<ExpensesState> {
  final ExpensesDataSource dataSource;
  ExpensesCubit(this.dataSource) : super(ExpensesInitial());

  void fetchExpenses(Map<String, String> body) {
    emit(ExpensesLoading());
    dataSource.fetchExpenses(body).then((value) => {emit(ExpensesLoaded(value))});
  }
}
