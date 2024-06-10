import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/cases/cubit/paperdetail_state.dart';
import 'package:haelo_flutter/features/cases/data/datasource/paperdetail_data_source.dart';

class PaperDetailCubit extends Cubit<PaperDetailState> {
  final PaperDetailDataSource dataSource;
  PaperDetailCubit(this.dataSource) : super(PaperDetailInitial());

  void fetchPaperDetail(Map<String, String> body) {
    emit(PaperDetailLoading());
    dataSource.fetchPaperDetail(body).then((value) => {emit(PaperDetailLoaded(value))});
  }
}
