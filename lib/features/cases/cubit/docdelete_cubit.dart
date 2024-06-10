import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/cases/data/datasource/docdelete_data_source.dart';
import 'docdelete_state.dart';

class DocDeleteCubit extends Cubit<DocDeleteState> {
  final DocDeleteDataSource dataSource;
  DocDeleteCubit(this.dataSource) : super(DocDeleteInitial());

  void fetchDocDelete(Map<String, String> body) {
    emit(DocDeleteLoading());
    dataSource.fetchDocDelete(body).then((value) => {emit(DocDeleteLoaded(value))});
  }
}
